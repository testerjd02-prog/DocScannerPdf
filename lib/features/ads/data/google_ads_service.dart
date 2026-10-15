import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../domain/ad_format.dart';
import '../domain/ad_policy.dart';
import 'ad_unit_ids.dart';
import 'ads_facade.dart';
import 'consent_service.dart';
import 'full_screen_slot.dart';
import 'native_ad_pool.dart';

/// AdMob implementation. See docs/ADS.md for the full behaviour table.
class GoogleAdsService implements AdsFacade {
  GoogleAdsService({
    FrequencyPolicy? policy,
    this.consent = const ConsentService(),
  }) : _policy = policy ?? FrequencyPolicy() {
    _interstitial = FullScreenAdSlot<InterstitialAd>(
      adUnitId: AdUnitIds.forFormat(AdFormat.interstitial),
      maxAge: const Duration(minutes: 55),
      canLoad: _canLoad,
      disposeAd: (ad) => ad.dispose(),
      loader: (id, onLoaded, onFailed) => InterstitialAd.load(
        adUnitId: id,
        request: adRequest,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: onLoaded,
          onAdFailedToLoad: (e) => onFailed(e.code),
        ),
      ),
    );
    _rewarded = FullScreenAdSlot<RewardedAd>(
      adUnitId: AdUnitIds.forFormat(AdFormat.rewarded),
      maxAge: const Duration(minutes: 55),
      canLoad: _canLoad,
      disposeAd: (ad) => ad.dispose(),
      loader: (id, onLoaded, onFailed) => RewardedAd.load(
        adUnitId: id,
        request: adRequest,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: onLoaded,
          onAdFailedToLoad: (e) => onFailed(e.code),
        ),
      ),
    );
    _appOpen = FullScreenAdSlot<AppOpenAd>(
      adUnitId: AdUnitIds.forFormat(AdFormat.appOpen),
      // App-open ads stay valid for 4 hours.
      maxAge: const Duration(hours: 3, minutes: 50),
      canLoad: _canLoad,
      disposeAd: (ad) => ad.dispose(),
      loader: (id, onLoaded, onFailed) => AppOpenAd.load(
        adUnitId: id,
        request: adRequest,
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: onLoaded,
          onAdFailedToLoad: (e) => onFailed(e.code),
        ),
      ),
    );
    _native = NativeAdPool(
      adUnitId: AdUnitIds.forFormat(AdFormat.native),
      canLoad: _canLoad,
      request: adRequest,
    );
  }

  static const _testDeviceIds = String.fromEnvironment('ADMOB_TEST_DEVICE_IDS');

  final FrequencyPolicy _policy;
  final ConsentService consent;
  late final FullScreenAdSlot<InterstitialAd> _interstitial;
  late final FullScreenAdSlot<RewardedAd> _rewarded;
  late final FullScreenAdSlot<AppOpenAd> _appOpen;
  late final NativeAdPool _native;

  @override
  final ValueNotifier<bool> canServe = ValueNotifier(false);

  bool _started = false;
  bool _consentKnown = false;
  bool _consentOk = false;
  bool _enabled = true;
  bool _sdkReady = false;
  bool _foreground = true;
  bool _fullScreenOpen = false;
  int _externalFlows = 0;
  DateTime _ignoreResumeUntil = DateTime.fromMillisecondsSinceEpoch(0);
  Future<void>? _initializing;

  /// Single source of truth for "may we send an ad request right now".
  bool _canLoad() => canServe.value && _foreground;

  void _recompute() {
    canServe.value = _sdkReady && _consentOk && _enabled;
  }

  @override
  AdRequest get adRequest => const AdRequest();

  @override
  String? get bannerAdUnitId => AdUnitIds.forFormat(AdFormat.banner);

  // ------------------------------------------------------------- start-up

  @override
  Future<void> start() async {
    if (_started) return;
    _started = true;

    final ids = _testDeviceIds
        .split(',')
        .where((e) => e.trim().isNotEmpty)
        .toList();
    try {
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          testDeviceIds: ids.isEmpty ? null : ids,
          maxAdContentRating: MaxAdContentRating.pg,
        ),
      );
    } on Object catch (e) {
      debugPrint('Ads: request configuration failed: $e');
    }

    // Consent from an earlier session lets us start the SDK straight away;
    // the refresh below then confirms or revokes it.
    if (await consent.canRequestAdsNow()) {
      _consentOk = true;
      unawaited(_maybeInitialize());
    }
    // The UMP form is full-screen UI: returning from it is not a "resume".
    _consentOk = await runExternalFlow(consent.gather);
    _consentKnown = true;
    if (!_consentOk) _disposeCaches();
    await _maybeInitialize();
    _recompute();
  }

  Future<void> _maybeInitialize() {
    return _initializing ??= () async {
      try {
        if (!_consentOk || !_enabled) return;
        if (!_sdkReady) {
          await MobileAds.instance.initialize();
          _sdkReady = true;
        }
        _recompute();
        // One app-open ad ready for the first real resume.
        _appOpen.warmUp();
      } on Object catch (e) {
        debugPrint('Ads: initialisation failed: $e');
      } finally {
        _initializing = null;
      }
    }();
  }

  @override
  void setEnabled(bool enabled) {
    if (_enabled == enabled) return;
    _enabled = enabled;
    if (!enabled) {
      _disposeCaches();
      _recompute();
    } else if (_started && (_consentKnown || _consentOk)) {
      unawaited(_maybeInitialize());
    }
  }

  void _disposeCaches() {
    _interstitial.clear();
    _rewarded.clear();
    _appOpen.clear();
    _native.clearUnused();
  }

  // ------------------------------------------------------------ lifecycle

  @override
  void onAppBackgrounded() {
    _foreground = false;
  }

  @override
  void onAppForegrounded({
    required Duration backgroundedFor,
    required bool safeToInterrupt,
  }) {
    _foreground = true;
    if (!canServe.value) return;

    // A new session of use: give failed loads a fresh budget.
    _interstitial.resetRetries();
    _rewarded.resetRetries();
    _appOpen.resetRetries();
    _native.resetFailures();

    final now = DateTime.now();
    final external = _externalFlows > 0 || now.isBefore(_ignoreResumeUntil);
    final blocked = external || _fullScreenOpen || !safeToInterrupt;

    if (!blocked &&
        _appOpen.isReady &&
        _policy.canShowAppOpen(backgroundedFor: backgroundedFor)) {
      unawaited(_showAppOpen());
      return;
    }
    // Make sure the next qualifying resume has an ad waiting. Loads only if
    // none is cached, so this is at most one request per shown ad.
    _appOpen.warmUp();
  }

  @override
  Future<T> runExternalFlow<T>(Future<T> Function() body) async {
    _externalFlows++;
    try {
      return await body();
    } finally {
      _externalFlows--;
      // Coming back from a system screen fires a lifecycle "resumed" a moment
      // later; ignore it.
      _ignoreResumeUntil = DateTime.now().add(const Duration(seconds: 3));
    }
  }

  // -------------------------------------------------------- full-screen ads

  void _fullScreenClosed() {
    _fullScreenOpen = false;
    _ignoreResumeUntil = DateTime.now().add(const Duration(seconds: 3));
  }

  Future<void> _showAppOpen() async {
    final ad = _appOpen.take();
    if (ad == null) return;
    _fullScreenOpen = true;
    ad.fullScreenContentCallback = FullScreenContentCallback<AppOpenAd>(
      onAdShowedFullScreenContent: (_) => _policy.recordShown(AdFormat.appOpen),
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _fullScreenClosed();
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        _fullScreenClosed();
      },
    );
    try {
      await ad.show();
    } on Object {
      unawaited(ad.dispose());
      _fullScreenClosed();
    }
  }

  @override
  void noteEvent(AdEvent event) {
    if (!canServe.value) return;
    _policy.recordEvent();
    if (_fullScreenOpen || !_policy.canShowInterstitial()) return;
    // No ad ready means the opportunity is skipped, never delayed: a late
    // interstitial would land in the middle of the user's next task.
    if (_interstitial.isReady) unawaited(_showInterstitial());
  }

  Future<void> _showInterstitial() async {
    final ad = _interstitial.take();
    if (ad == null) return;
    _fullScreenOpen = true;
    ad.fullScreenContentCallback = FullScreenContentCallback<InterstitialAd>(
      onAdShowedFullScreenContent: (_) =>
          _policy.recordShown(AdFormat.interstitial),
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _fullScreenClosed();
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        _fullScreenClosed();
      },
    );
    try {
      await ad.show();
    } on Object {
      unawaited(ad.dispose());
      _fullScreenClosed();
    }
  }

  @override
  void warmUp(AdFormat format) {
    if (!canServe.value) return;
    switch (format) {
      case AdFormat.interstitial:
        _interstitial.resetRetries();
        _interstitial.warmUp();
      case AdFormat.rewarded:
        _rewarded.resetRetries();
        _rewarded.warmUp();
      case AdFormat.appOpen:
        _appOpen.warmUp();
      case AdFormat.banner:
      case AdFormat.native:
        break;
    }
  }

  @override
  Future<RewardOutcome> showRewarded() async {
    if (!canServe.value || _fullScreenOpen) return RewardOutcome.unavailable;
    _rewarded.resetRetries();
    _rewarded.warmUp();
    if (!_rewarded.isReady &&
        !await _rewarded.whenReady(const Duration(seconds: 8))) {
      return RewardOutcome.unavailable;
    }
    final ad = _rewarded.take();
    if (ad == null) return RewardOutcome.unavailable;

    final done = Completer<RewardOutcome>();
    var earned = false;
    _fullScreenOpen = true;
    ad.fullScreenContentCallback = FullScreenContentCallback<RewardedAd>(
      onAdShowedFullScreenContent: (_) =>
          _policy.recordShown(AdFormat.rewarded),
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _fullScreenClosed();
        if (!done.isCompleted) {
          done.complete(
            earned ? RewardOutcome.earned : RewardOutcome.dismissed,
          );
        }
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        _fullScreenClosed();
        if (!done.isCompleted) done.complete(RewardOutcome.unavailable);
      },
    );
    try {
      await ad.show(onUserEarnedReward: (_, _) => earned = true);
    } on Object {
      unawaited(ad.dispose());
      _fullScreenClosed();
      if (!done.isCompleted) done.complete(RewardOutcome.unavailable);
    }
    return done.future;
  }

  // ------------------------------------------------------------- privacy

  @override
  Future<bool> privacyOptionsRequired() => consent.privacyOptionsRequired();

  @override
  Future<void> showPrivacyOptions() async {
    await runExternalFlow(consent.showPrivacyOptions);
    // The user may have changed their choice.
    final ok = await consent.canRequestAdsNow();
    if (ok != _consentOk) {
      _consentOk = ok;
      if (!ok) _disposeCaches();
      unawaited(_maybeInitialize());
      _recompute();
    }
  }

  // --------------------------------------------------------------- native

  @override
  NativeAdLease? acquireNative(int slot, NativeTemplateStyle style) =>
      _native.acquire(slot, style);

  @override
  void dispose() {
    _interstitial.clear();
    _rewarded.clear();
    _appOpen.clear();
    _native.dispose();
    canServe.dispose();
  }
}
