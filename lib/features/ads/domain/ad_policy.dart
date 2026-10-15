import 'ad_format.dart';

/// Tunable limits that keep ads from becoming a nuisance. These are
/// deliberately conservative: a privacy-first document app lives on trust.
class AdPolicyConfig {
  const AdPolicyConfig({
    this.interstitialEveryNthEvent = 2,
    this.interstitialMinGap = const Duration(minutes: 3),
    this.startupQuiet = const Duration(seconds: 45),
    this.crossFormatGap = const Duration(seconds: 60),
    this.appOpenMinBackground = const Duration(seconds: 45),
    this.appOpenMinGap = const Duration(minutes: 4),
  });

  /// An interstitial is allowed after this many qualifying events.
  final int interstitialEveryNthEvent;

  /// Minimum time between two interstitials.
  final Duration interstitialMinGap;

  /// No full-screen ad this soon after the app process started.
  final Duration startupQuiet;

  /// Minimum time between any two full-screen ads of different formats.
  final Duration crossFormatGap;

  /// The app must have been in the background at least this long before an
  /// app-open ad is considered ("resume", not a quick app switch).
  final Duration appOpenMinBackground;

  /// Minimum time between two app-open ads.
  final Duration appOpenMinGap;
}

/// Decides *whether* a full-screen ad may be shown. It never loads anything,
/// so asking costs no ad request.
class FrequencyPolicy {
  FrequencyPolicy({
    this.config = const AdPolicyConfig(),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now,
       _launchedAt = (now ?? DateTime.now)();

  final AdPolicyConfig config;
  final DateTime Function() _now;
  final DateTime _launchedAt;

  int _eventsSinceInterstitial = 0;
  DateTime? _lastInterstitial;
  DateTime? _lastAppOpen;
  DateTime? _lastAnyFullScreen;

  /// Counts one qualifying event. Call before [canShowInterstitial].
  void recordEvent() => _eventsSinceInterstitial++;

  /// Call when a full-screen ad actually appeared on screen.
  void recordShown(AdFormat format) {
    final t = _now();
    _lastAnyFullScreen = t;
    switch (format) {
      case AdFormat.interstitial:
        _lastInterstitial = t;
        _eventsSinceInterstitial = 0;
      case AdFormat.appOpen:
        _lastAppOpen = t;
      case AdFormat.rewarded:
      case AdFormat.banner:
      case AdFormat.native:
        break;
    }
  }

  bool _quietPeriodOver() =>
      _now().difference(_launchedAt) >= config.startupQuiet;

  bool _crossGapOver() {
    final last = _lastAnyFullScreen;
    return last == null || _now().difference(last) >= config.crossFormatGap;
  }

  bool canShowInterstitial() {
    if (_eventsSinceInterstitial < config.interstitialEveryNthEvent) {
      return false;
    }
    if (!_quietPeriodOver() || !_crossGapOver()) return false;
    final last = _lastInterstitial;
    return last == null || _now().difference(last) >= config.interstitialMinGap;
  }

  bool canShowAppOpen({required Duration backgroundedFor}) {
    if (backgroundedFor < config.appOpenMinBackground) return false;
    if (!_quietPeriodOver() || !_crossGapOver()) return false;
    final last = _lastAppOpen;
    return last == null || _now().difference(last) >= config.appOpenMinGap;
  }
}
