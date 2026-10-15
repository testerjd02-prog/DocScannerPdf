import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../domain/ad_format.dart';

/// A claim on a pooled native ad. Release it when the widget goes away; the
/// loaded ad stays cached so scrolling back reuses it instead of re-requesting.
abstract interface class NativeAdLease {
  ValueListenable<NativeAd?> get ad;
  void release();
}

/// Everything the UI needs from the ads layer. A no-op implementation is used
/// in tests, on unsupported platforms and for ad-free users, so screens never
/// branch on "is the SDK there".
abstract interface class AdsFacade {
  /// True when ads may be requested and shown right now: consent obtained,
  /// SDK initialised, and the user is not ad-free.
  ValueListenable<bool> get canServe;

  /// Gathers consent (UMP) and initialises the SDK. Idempotent.
  Future<void> start();

  /// Turns all ads on or off (Pro entitlement, ad-free break).
  void setEnabled(bool enabled);

  void onAppBackgrounded();

  /// [safeToInterrupt] is false while the user is mid-task (e.g. unsaved
  /// scan session), which suppresses the app-open ad.
  void onAppForegrounded({
    required Duration backgroundedFor,
    required bool safeToInterrupt,
  });

  /// Runs [body] (camera, file picker, share sheet, ...) and makes sure the
  /// app returning from it is not mistaken for a "resume" worth an ad.
  Future<T> runExternalFlow<T>(Future<T> Function() body);

  /// Reports a natural break; may show an interstitial if caps allow.
  void noteEvent(AdEvent event);

  /// Preloads a format because the user is about to need it.
  void warmUp(AdFormat format);

  /// Shows a rewarded video the user chose to watch.
  Future<RewardOutcome> showRewarded();

  Future<bool> privacyOptionsRequired();
  Future<void> showPrivacyOptions();

  String? get bannerAdUnitId;
  AdRequest get adRequest;

  /// Pooled native ad for list slot [slot], or null when ads cannot serve.
  NativeAdLease? acquireNative(int slot, NativeTemplateStyle style);

  void dispose();
}

/// Used when ads are unavailable. Does nothing, safely.
class NoopAdsService implements AdsFacade {
  @override
  final ValueNotifier<bool> canServe = ValueNotifier(false);

  @override
  Future<void> start() async {}
  @override
  void setEnabled(bool enabled) {}
  @override
  void onAppBackgrounded() {}
  @override
  void onAppForegrounded({
    required Duration backgroundedFor,
    required bool safeToInterrupt,
  }) {}
  @override
  Future<T> runExternalFlow<T>(Future<T> Function() body) => body();
  @override
  void noteEvent(AdEvent event) {}
  @override
  void warmUp(AdFormat format) {}
  @override
  Future<RewardOutcome> showRewarded() async => RewardOutcome.unavailable;
  @override
  Future<bool> privacyOptionsRequired() async => false;
  @override
  Future<void> showPrivacyOptions() async {}
  @override
  String? get bannerAdUnitId => null;
  @override
  AdRequest get adRequest => const AdRequest();
  @override
  NativeAdLease? acquireNative(int slot, NativeTemplateStyle style) => null;
  @override
  void dispose() => canServe.dispose();
}
