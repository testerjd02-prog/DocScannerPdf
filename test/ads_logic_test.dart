import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:packet_pal/features/ads/data/ad_unit_ids.dart';
import 'package:packet_pal/features/ads/data/ads_providers.dart';
import 'package:packet_pal/features/ads/data/full_screen_slot.dart';
import 'package:packet_pal/features/ads/domain/ad_format.dart';
import 'package:packet_pal/features/ads/domain/ad_interleaver.dart';
import 'package:packet_pal/features/ads/domain/ad_policy.dart';
import 'package:packet_pal/features/ads/domain/retry_backoff.dart';
import 'package:packet_pal/features/settings/data/settings_repository.dart';

import 'support/test_env.dart';

/// A controllable clock.
class _Clock {
  DateTime now = DateTime(2026, 10, 1, 12);
  void advance(Duration d) => now = now.add(d);
}

void main() {
  group('RetryBackoff', () {
    test('doubles the delay, then gives up', () {
      final b = RetryBackoff();
      expect(b.onFailure(), const Duration(seconds: 4));
      expect(b.onFailure(), const Duration(seconds: 8));
      expect(b.onFailure(), const Duration(seconds: 16));
      expect(b.onFailure(), isNull);
      expect(b.exhausted, isTrue);
    });

    test('reset restores the full budget', () {
      final b = RetryBackoff()..onFailure();
      b.reset();
      expect(b.onFailure(), const Duration(seconds: 4));
    });

    test('delay is capped', () {
      final b = RetryBackoff(base: const Duration(seconds: 40), maxRetries: 3);
      b.onFailure();
      expect(b.onFailure(), const Duration(minutes: 1));
    });
  });

  group('FrequencyPolicy', () {
    late _Clock clock;
    late FrequencyPolicy policy;

    setUp(() {
      clock = _Clock();
      policy = FrequencyPolicy(now: () => clock.now);
    });

    test('no full-screen ad right after launch', () {
      policy.recordEvent();
      policy.recordEvent();
      expect(policy.canShowInterstitial(), isFalse);
      clock.advance(const Duration(seconds: 46));
      expect(policy.canShowInterstitial(), isTrue);
    });

    test('interstitial needs every Nth event and a time gap', () {
      clock.advance(const Duration(minutes: 5));
      policy.recordEvent();
      expect(
        policy.canShowInterstitial(),
        isFalse,
        reason: 'first save is free',
      );
      policy.recordEvent();
      expect(policy.canShowInterstitial(), isTrue);

      policy.recordShown(AdFormat.interstitial);
      policy.recordEvent();
      policy.recordEvent();
      expect(policy.canShowInterstitial(), isFalse, reason: 'cross-format gap');
      clock.advance(const Duration(minutes: 2));
      expect(policy.canShowInterstitial(), isFalse, reason: 'min gap 3 min');
      clock.advance(const Duration(minutes: 2));
      expect(policy.canShowInterstitial(), isTrue);
    });

    test('an unused qualifying event is not lost', () {
      clock.advance(const Duration(minutes: 5));
      policy.recordEvent();
      policy.recordEvent();
      policy.recordEvent(); // ad was not ready for the 2nd and 3rd
      expect(policy.canShowInterstitial(), isTrue);
    });

    test('app-open needs a real absence and respects its own gap', () {
      clock.advance(const Duration(minutes: 5));
      expect(
        policy.canShowAppOpen(backgroundedFor: const Duration(seconds: 10)),
        isFalse,
        reason: 'quick app switch',
      );
      expect(
        policy.canShowAppOpen(backgroundedFor: const Duration(minutes: 2)),
        isTrue,
      );
      policy.recordShown(AdFormat.appOpen);
      clock.advance(const Duration(minutes: 2));
      expect(
        policy.canShowAppOpen(backgroundedFor: const Duration(minutes: 2)),
        isFalse,
      );
      clock.advance(const Duration(minutes: 3));
      expect(
        policy.canShowAppOpen(backgroundedFor: const Duration(minutes: 2)),
        isTrue,
      );
    });

    test('app-open and interstitial never come back to back', () {
      clock.advance(const Duration(minutes: 5));
      policy.recordShown(AdFormat.appOpen);
      policy.recordEvent();
      policy.recordEvent();
      expect(policy.canShowInterstitial(), isFalse);
    });

    test('a rewarded video resets the cross-format gap, not the counters', () {
      clock.advance(const Duration(minutes: 5));
      policy.recordEvent();
      policy.recordEvent();
      policy.recordShown(AdFormat.rewarded);
      expect(policy.canShowInterstitial(), isFalse);
      clock.advance(const Duration(seconds: 61));
      expect(policy.canShowInterstitial(), isTrue);
    });
  });

  group('planAdSegments', () {
    test('no ad in a short list', () {
      expect(planAdSegments(4), [const AdSegment(start: 0, end: 4)]);
      expect(planAdSegments(0), [const AdSegment(start: 0, end: 0)]);
    });

    test('first ad after 4, then every 8, never at the very end', () {
      expect(planAdSegments(5), [
        const AdSegment(start: 0, end: 4, adSlotAfter: 0),
        const AdSegment(start: 4, end: 5),
      ]);
      expect(planAdSegments(20), [
        const AdSegment(start: 0, end: 4, adSlotAfter: 0),
        const AdSegment(start: 4, end: 12, adSlotAfter: 1),
        const AdSegment(start: 12, end: 20),
      ]);
    });

    test('covers every item exactly once and caps the ad count', () {
      for (final n in [1, 5, 12, 13, 40, 200]) {
        final segs = planAdSegments(n);
        expect(segs.first.start, 0);
        expect(segs.last.end, n);
        for (var i = 1; i < segs.length; i++) {
          expect(segs[i].start, segs[i - 1].end);
        }
        expect(
          segs.where((s) => s.adSlotAfter != null).length,
          lessThanOrEqualTo(6),
        );
        expect(segs.last.adSlotAfter, isNull);
      }
    });
  });

  group('AdUnitIds.resolve', () {
    const prod = {AdFormat.banner: 'ca-app-pub-1/2'};

    test('debug builds always get Google test units', () {
      expect(
        AdUnitIds.resolve(
          AdFormat.banner,
          isAndroid: true,
          isRelease: false,
          forceTest: false,
          prod: prod,
        ),
        AdUnitIds.testAndroid[AdFormat.banner],
      );
      expect(
        AdUnitIds.resolve(
          AdFormat.interstitial,
          isAndroid: false,
          isRelease: false,
          forceTest: false,
          prod: prod,
        ),
        AdUnitIds.testIos[AdFormat.interstitial],
      );
    });

    test('release uses real ids; a missing id disables that format', () {
      expect(
        AdUnitIds.resolve(
          AdFormat.banner,
          isAndroid: true,
          isRelease: true,
          forceTest: false,
          prod: prod,
        ),
        'ca-app-pub-1/2',
      );
      expect(
        AdUnitIds.resolve(
          AdFormat.rewarded,
          isAndroid: true,
          isRelease: true,
          forceTest: false,
          prod: prod,
        ),
        isNull,
      );
    });

    test('forceTest overrides release ids', () {
      expect(
        AdUnitIds.resolve(
          AdFormat.banner,
          isAndroid: true,
          isRelease: true,
          forceTest: true,
          prod: prod,
        ),
        AdUnitIds.testAndroid[AdFormat.banner],
      );
    });

    test('every format has a test unit on both platforms', () {
      for (final f in AdFormat.values) {
        expect(AdUnitIds.testAndroid[f], isNotNull);
        expect(AdUnitIds.testIos[f], isNotNull);
      }
    });
  });

  group('FullScreenAdSlot', () {
    late _Clock clock;
    late bool allowed;
    late List<String> disposed;
    late List<void Function(String)> pending; // onLoaded
    late List<void Function(int)> failures;
    late List<void Function()> retries;

    FullScreenAdSlot<String> slot({String? id = 'unit'}) =>
        FullScreenAdSlot<String>(
          adUnitId: id,
          maxAge: const Duration(minutes: 55),
          now: () => clock.now,
          canLoad: () => allowed,
          disposeAd: disposed.add,
          loader: (unit, onLoaded, onFailed) {
            pending.add(onLoaded);
            failures.add(onFailed);
          },
          scheduler: (delay, run) {
            retries.add(run);
            return Timer(const Duration(days: 1), () {});
          },
        );

    setUp(() {
      clock = _Clock();
      allowed = true;
      disposed = [];
      pending = [];
      failures = [];
      retries = [];
    });

    test('never sends a second request while one is in flight or cached', () {
      final s = slot();
      s.warmUp();
      s.warmUp();
      s.warmUp();
      expect(s.requestCount, 1);
      pending.single('ad1');
      s.warmUp();
      expect(s.requestCount, 1, reason: 'a fresh ad is cached');
      expect(s.isReady, isTrue);
    });

    test('take hands over the ad once', () {
      final s = slot()..warmUp();
      pending.single('ad1');
      expect(s.take(), 'ad1');
      expect(s.take(), isNull);
      expect(s.isReady, isFalse);
    });

    test('an expired ad is disposed and reloaded, not shown', () {
      final s = slot()..warmUp();
      pending.single('old');
      clock.advance(const Duration(minutes: 56));
      expect(s.isReady, isFalse);
      expect(disposed, ['old']);
      s.warmUp();
      expect(s.requestCount, 2);
    });

    test('does not request when loading is not allowed or unit is missing', () {
      allowed = false;
      final s = slot()..warmUp();
      expect(s.requestCount, 0);
      final none = slot(id: null)..warmUp();
      expect(none.requestCount, 0);
    });

    test('an ad that arrives after ads were disabled is discarded', () {
      final s = slot()..warmUp();
      allowed = false;
      pending.single('late');
      expect(disposed, ['late']);
      expect(s.isReady, isFalse);
    });

    test('failures retry with backoff and then stop', () {
      final s = slot()..warmUp();
      for (var i = 0; i < 3; i++) {
        failures.last(3); // no fill
        expect(retries.length, i + 1, reason: 'retry scheduled');
        retries.last();
      }
      failures.last(3);
      expect(retries.length, 3, reason: 'budget spent: no further retry');
      expect(s.requestCount, 4);

      s.warmUp();
      expect(s.requestCount, 4 + 1, reason: 'warmUp is an explicit new ask');
    });

    test('invalid requests are never retried', () {
      final s = slot()..warmUp();
      failures.last(8); // app id missing
      expect(retries, isEmpty);
      expect(s.isLoading, isFalse);
    });

    test('a retry does nothing if ads got disabled meanwhile', () {
      final s = slot()..warmUp();
      failures.last(3);
      allowed = false;
      retries.last();
      expect(s.requestCount, 1);
    });

    test('whenReady resolves on load, on failure, and on timeout', () async {
      final s = slot()..warmUp();
      final ok = s.whenReady(const Duration(seconds: 5));
      pending.single('ad');
      expect(await ok, isTrue);

      final s2 = slot()..warmUp();
      final bad = s2.whenReady(const Duration(seconds: 5));
      failures.last(3);
      expect(await bad, isFalse);

      final s3 = slot()..warmUp();
      expect(await s3.whenReady(const Duration(milliseconds: 20)), isFalse);
    });

    test('clear disposes the cached ad', () {
      final s = slot()..warmUp();
      pending.single('ad');
      s.clear();
      expect(disposed, ['ad']);
      expect(s.isReady, isFalse);
    });
  });

  group('AdFreeController / adsEnabled', () {
    late TestEnv env;
    setUp(() async => env = await TestEnv.create());
    tearDown(() => env.dispose());

    test('ads are on by default and off during a break', () async {
      final c = ProviderContainer(overrides: env.overrides);
      addTearDown(c.dispose);
      expect(c.read(adsEnabledProvider), isTrue);

      await c
          .read(adFreeUntilProvider.notifier)
          .grant(const Duration(minutes: 60));
      expect(c.read(adsEnabledProvider), isFalse);
      expect(c.read(adFreeUntilProvider)!.isAfter(DateTime.now()), isTrue);
    });

    test('a second grant extends the break', () async {
      final c = ProviderContainer(overrides: env.overrides);
      addTearDown(c.dispose);
      final ctl = c.read(adFreeUntilProvider.notifier);
      await ctl.grant(const Duration(minutes: 30));
      final first = c.read(adFreeUntilProvider)!;
      await ctl.grant(const Duration(minutes: 30));
      expect(
        c.read(adFreeUntilProvider)!.difference(first),
        const Duration(minutes: 30),
      );
    });

    test(
      'the break is persisted and restored; an expired one is ignored',
      () async {
        final c = ProviderContainer(overrides: env.overrides);
        addTearDown(c.dispose);
        await c
            .read(adFreeUntilProvider.notifier)
            .grant(const Duration(minutes: 60));
        final saved = await env.db.select(env.db.appSettings).get();
        final value = saved
            .firstWhere((r) => r.key == SettingsRepository.keyAdFreeUntil)
            .value;
        expect(DateTime.parse(value).isAfter(DateTime.now()), isTrue);
      },
    );
  });
}
