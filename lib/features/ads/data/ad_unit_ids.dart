import 'package:flutter/foundation.dart';

import '../domain/ad_format.dart';
import 'admob_config.dart';

/// Resolves AdMob ad unit ids.
///
/// * Debug and profile builds always use Google's public test units, so
///   developers never click live ads (an account-suspension risk).
/// * Release builds use the real ids passed with `--dart-define`, e.g.
///   `--dart-define=ADMOB_ANDROID_BANNER=ca-app-pub-xxx/yyy`. A release build
///   missing an id gets `null` for that format: it simply shows no such ad.
/// * `--dart-define=ADMOB_USE_TEST_ADS=true` forces test ads in a release
///   build (handy for QA of the production binary).
abstract final class AdUnitIds {
  static const bool _forceTest = bool.fromEnvironment('ADMOB_USE_TEST_ADS');

  static const _prodAndroid = <AdFormat, String>{
    AdFormat.banner: String.fromEnvironment('ADMOB_ANDROID_BANNER'),
    AdFormat.native: String.fromEnvironment('ADMOB_ANDROID_NATIVE'),
    AdFormat.interstitial: String.fromEnvironment('ADMOB_ANDROID_INTERSTITIAL'),
    AdFormat.rewarded: String.fromEnvironment('ADMOB_ANDROID_REWARDED'),
    AdFormat.appOpen: String.fromEnvironment('ADMOB_ANDROID_APP_OPEN'),
  };

  static const _prodIos = <AdFormat, String>{
    AdFormat.banner: String.fromEnvironment('ADMOB_IOS_BANNER'),
    AdFormat.native: String.fromEnvironment('ADMOB_IOS_NATIVE'),
    AdFormat.interstitial: String.fromEnvironment('ADMOB_IOS_INTERSTITIAL'),
    AdFormat.rewarded: String.fromEnvironment('ADMOB_IOS_REWARDED'),
    AdFormat.appOpen: String.fromEnvironment('ADMOB_IOS_APP_OPEN'),
  };

  /// Google's sample ad units, from the central [AdMobConfig].
  static Map<AdFormat, String> get testAndroid => AdMobConfig.testAndroid.units;
  static Map<AdFormat, String> get testIos => AdMobConfig.testIos.units;

  /// The id for [format] on the current platform, or null if the format is
  /// disabled (release build without a configured id, or unsupported OS).
  static String? forFormat(AdFormat format) {
    final android = defaultTargetPlatform == TargetPlatform.android;
    final ios = defaultTargetPlatform == TargetPlatform.iOS;
    if (!android && !ios) return null;
    return resolve(
      format,
      isAndroid: android,
      isRelease: kReleaseMode,
      forceTest: _forceTest,
      prod: android ? _prodAndroid : _prodIos,
    );
  }

  /// Pure resolution logic, separated so it can be unit tested.
  static String? resolve(
    AdFormat format, {
    required bool isAndroid,
    required bool isRelease,
    required bool forceTest,
    required Map<AdFormat, String> prod,
  }) {
    if (!isRelease || forceTest) {
      return (isAndroid ? testAndroid : testIos)[format];
    }
    final id = prod[format];
    return (id == null || id.isEmpty) ? null : id;
  }
}
