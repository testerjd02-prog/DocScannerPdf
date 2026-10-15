import '../domain/ad_format.dart';

/// App id plus one ad unit per format for a single platform.
class AdMobPlatformIds {
  const AdMobPlatformIds({
    required this.appId,
    required this.banner,
    required this.native,
    required this.interstitial,
    required this.rewarded,
    required this.appOpen,
  });

  /// AdMob *app* id (`ca-app-pub-…~…`).
  final String appId;
  final String banner;
  final String native;
  final String interstitial;
  final String rewarded;
  final String appOpen;

  String unit(AdFormat format) => switch (format) {
    AdFormat.banner => banner,
    AdFormat.native => native,
    AdFormat.interstitial => interstitial,
    AdFormat.rewarded => rewarded,
    AdFormat.appOpen => appOpen,
  };

  Map<AdFormat, String> get units => {
    for (final f in AdFormat.values) f: unit(f),
  };
}

/// The single place that holds every AdMob test identifier.
///
/// These are Google's public sample ids: they always serve test creatives and
/// are safe to commit. Real (production) ids are never stored in the repo;
/// they are passed with `--dart-define` / `-PadmobAppId` (see docs/ADS.md and
/// `AdUnitIds`).
///
/// The native projects must carry the *app* id too, because the AdMob SDK
/// reads it from the manifest / Info.plist before Dart runs:
///   * Android: `manifestPlaceholders["admobAppId"]` in
///     `android/app/build.gradle.kts`
///   * iOS: `GADApplicationIdentifier` in `ios/Runner/Info.plist`
/// `test/admob_config_test.dart` fails if those drift from the values below.
abstract final class AdMobConfig {
  static const AdMobPlatformIds testAndroid = AdMobPlatformIds(
    appId: 'ca-app-pub-3940256099942544~3347511713',
    banner: 'ca-app-pub-3940256099942544/9214589741', // adaptive banner
    native: 'ca-app-pub-3940256099942544/2247696110',
    interstitial: 'ca-app-pub-3940256099942544/1033173712',
    rewarded: 'ca-app-pub-3940256099942544/5224354917',
    appOpen: 'ca-app-pub-3940256099942544/9257395921',
  );

  static const AdMobPlatformIds testIos = AdMobPlatformIds(
    appId: 'ca-app-pub-3940256099942544~1458002511',
    banner: 'ca-app-pub-3940256099942544/2934735716', // adaptive banner
    native: 'ca-app-pub-3940256099942544/3986624511',
    interstitial: 'ca-app-pub-3940256099942544/4411468910',
    rewarded: 'ca-app-pub-3940256099942544/1712485313',
    appOpen: 'ca-app-pub-3940256099942544/5575463023',
  );
}
