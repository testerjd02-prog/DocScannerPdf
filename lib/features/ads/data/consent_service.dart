import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Google User Messaging Platform (UMP) wrapper: GDPR / US-state consent and
/// the "privacy options" entry point. Configure the actual messages in the
/// AdMob console (Privacy & messaging).
///
/// Debug aids (never needed in production):
///   --dart-define=UMP_TEST_DEVICE_IDS=HASH1,HASH2   (hash is printed in logcat)
///   --dart-define=UMP_DEBUG_GEOGRAPHY=eea|us_state
class ConsentService {
  const ConsentService();

  static const _testDevices = String.fromEnvironment('UMP_TEST_DEVICE_IDS');
  static const _geography = String.fromEnvironment('UMP_DEBUG_GEOGRAPHY');

  ConsentRequestParameters _params() {
    final ids = _testDevices
        .split(',')
        .where((e) => e.trim().isNotEmpty)
        .toList();
    DebugGeography? geo;
    switch (_geography) {
      case 'eea':
        geo = DebugGeography.debugGeographyEea;
      case 'us_state':
        geo = DebugGeography.debugGeographyRegulatedUsState;
    }
    return ConsentRequestParameters(
      // The app is for a general audience, not directed at children.
      tagForUnderAgeOfConsent: false,
      consentDebugSettings: (ids.isEmpty && geo == null)
          ? null
          : ConsentDebugSettings(debugGeography: geo, testIdentifiers: ids),
    );
  }

  /// True if consent from an earlier session already allows ad requests.
  /// Lets the SDK initialise immediately instead of waiting for the network.
  Future<bool> canRequestAdsNow() async {
    try {
      return await ConsentInformation.instance.canRequestAds();
    } on Object {
      return false;
    }
  }

  /// Refreshes consent state and shows the consent form if one is required.
  /// Returns whether ads may be requested afterwards. Never throws.
  Future<bool> gather() async {
    final updated = Completer<void>();
    try {
      ConsentInformation.instance.requestConsentInfoUpdate(
        _params(),
        () => updated.complete(),
        (FormError error) {
          debugPrint('UMP update failed: ${error.errorCode} ${error.message}');
          updated.complete();
        },
      );
      // Do not hang app start-up on a bad network.
      await updated.future.timeout(const Duration(seconds: 15));

      final shown = Completer<void>();
      // The form itself is user-paced, so it has no timeout.
      await ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
        if (error != null) {
          debugPrint('UMP form error: ${error.errorCode} ${error.message}');
        }
        shown.complete();
      });
      await shown.future;
    } on Object catch (e) {
      debugPrint('UMP gather failed: $e');
    }
    return canRequestAdsNow();
  }

  /// Whether the app must offer a "Privacy & ad choices" entry point.
  Future<bool> privacyOptionsRequired() async {
    try {
      return await ConsentInformation.instance
              .getPrivacyOptionsRequirementStatus() ==
          PrivacyOptionsRequirementStatus.required;
    } on Object {
      return false;
    }
  }

  /// Opens the form where users can review or withdraw consent.
  Future<void> showPrivacyOptions() async {
    final done = Completer<void>();
    try {
      await ConsentForm.showPrivacyOptionsForm((FormError? error) {
        if (error != null) debugPrint('UMP options error: ${error.message}');
        done.complete();
      });
      await done.future;
    } on Object catch (e) {
      debugPrint('UMP options failed: $e');
    }
  }
}
