import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/data/settings_providers.dart';
import '../../settings/data/settings_repository.dart';
import 'ads_facade.dart';

/// Length of the ad-free break earned by watching one rewarded video.
const Duration kAdFreeBreak = Duration(minutes: 60);

/// Overridden in `main()` with the AdMob service on Android and iOS.
final adsFacadeProvider = Provider<AdsFacade>((ref) => NoopAdsService());

/// True for paying users. Phase 3 (RevenueCat entitlements) replaces this
/// with the real value; Pro means no ads anywhere.
final proEntitlementProvider = Provider<bool>((ref) => false);

/// When the current ad-free break ends, or null if none is active.
class AdFreeController extends Notifier<DateTime?> {
  Timer? _timer;

  @override
  DateTime? build() {
    ref.onDispose(() => _timer?.cancel());
    final raw = ref.read(
      initialSettingsProvider,
    )[SettingsRepository.keyAdFreeUntil];
    final until = (raw == null || raw.isEmpty) ? null : DateTime.tryParse(raw);
    if (until != null && until.isAfter(DateTime.now())) {
      _schedule(until);
      return until;
    }
    return null;
  }

  void _schedule(DateTime until) {
    _timer?.cancel();
    _timer = Timer(until.difference(DateTime.now()), _expire);
  }

  void _expire() {
    state = null;
    unawaited(_persist(null));
  }

  /// Starts (or extends) an ad-free break.
  Future<void> grant(Duration duration) async {
    final now = DateTime.now();
    final current = state;
    final base = (current != null && current.isAfter(now)) ? current : now;
    final until = base.add(duration);
    state = until;
    _schedule(until);
    await _persist(until);
  }

  Future<void> _persist(DateTime? until) => ref
      .read(settingsRepositoryProvider)
      .set(SettingsRepository.keyAdFreeUntil, until?.toIso8601String() ?? '');
}

final adFreeUntilProvider = NotifierProvider<AdFreeController, DateTime?>(
  AdFreeController.new,
);

/// Ads are shown only when the user is neither Pro nor on an ad-free break.
final adsEnabledProvider = Provider<bool>((ref) {
  final pro = ref.watch(proEntitlementProvider);
  final breakEnd = ref.watch(adFreeUntilProvider);
  return !pro && breakEnd == null;
});

/// Keeps the ads service in sync with [adsEnabledProvider]. Watch it once
/// from a long-lived widget.
final adsWiringProvider = Provider<void>((ref) {
  final ads = ref.watch(adsFacadeProvider);
  ref.listen<bool>(
    adsEnabledProvider,
    (_, enabled) => ads.setEnabled(enabled),
    fireImmediately: true,
  );
});
