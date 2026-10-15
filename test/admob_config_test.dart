import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:packet_pal/features/ads/data/admob_config.dart';
import 'package:packet_pal/features/ads/domain/ad_format.dart';

void main() {
  test('Android test app id matches build.gradle.kts', () {
    final gradle = File('android/app/build.gradle.kts').readAsStringSync();
    expect(gradle, contains(AdMobConfig.testAndroid.appId));
  });

  test('iOS test app id matches Info.plist', () {
    final plist = File('ios/Runner/Info.plist').readAsStringSync();
    expect(plist, contains(AdMobConfig.testIos.appId));
  });

  test('app ids look like app ids and unit ids like ad units', () {
    for (final p in [AdMobConfig.testAndroid, AdMobConfig.testIos]) {
      expect(p.appId, matches(RegExp(r'^ca-app-pub-\d{16}~\d+$')));
      for (final f in AdFormat.values) {
        expect(p.unit(f), matches(RegExp(r'^ca-app-pub-\d{16}/\d+$')));
      }
    }
  });

  test('every ad unit is distinct within a platform', () {
    for (final p in [AdMobConfig.testAndroid, AdMobConfig.testIos]) {
      expect(p.units.values.toSet().length, AdFormat.values.length);
    }
  });
}
