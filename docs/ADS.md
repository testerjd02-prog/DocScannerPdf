# Ads (AdMob) and consent (UMP)

All ad code lives in `lib/features/ads/`. Screens only talk to the `AdsFacade`
interface (`adsFacadeProvider`); tests, desktop and ad-free users get a no-op.

## What is shown, and where

| Format | Where | Rules |
|--------|-------|-------|
| Banner (adaptive) | Top of the tab area (shell), one instance | Loaded once, collapses until loaded, reloads only on a real width change |
| Native (small template) | Library list/grid, first after 4 items then every 8, max 6 | Not while searching or selecting, not in lists under 5 items, never last |
| Interstitial | After a document is saved or an export completes | Every 2nd event, ≥ 3 min apart, not in the first 45 s, not within 60 s of another full-screen ad. Skipped (not delayed) if not ready |
| Rewarded | Settings → "Take an ad-free break" | User-initiated. Reward: 60 minutes with no ads of any kind |
| App open | On resume | Backgrounded ≥ 45 s, ≥ 4 min since the last one, not after camera/picker/share/consent/other ads, never over an unsaved scan |

There are **no ads** on scan, crop, edit, review or document screens.

## Request optimisation ("no ad loaded loss")

* Nothing is requested before consent allows it, and the SDK is not even
  initialised for ad-free users (Pro, or during a rewarded break).
* One request in flight per format, none while a fresh ad is cached
  (`FullScreenAdSlot`). Expired ads (55 min; 3 h 50 min for app open) are
  discarded, not shown.
* Load on intent, not on launch: interstitial when the review/export screen
  opens, rewarded only when the user taps, app-open after a resume.
* Failed loads retry 4 s → 8 s → 16 s and then stop until the user does
  something that justifies another try.
* Native ads are pooled per slot (`NativeAdPool`): scrolling away and back
  reuses the loaded ad; on-screen ads are never evicted.
* Ads that finish loading after ads were switched off are disposed.
* Frequency limits live in `AdPolicyConfig` (unit tested).

## Consent (UMP)

`ConsentService` runs on every launch once the first tab is visible:
`requestConsentInfoUpdate` → `loadAndShowConsentFormIfRequired` →
`canRequestAds`. If consent from an earlier session already allows ads the SDK
starts immediately. Settings shows **Privacy & ad choices** whenever Google
requires that entry point.

Set up the messages in AdMob → *Privacy & messaging* (GDPR message, US state
regulations, and on iOS the IDFA/ATT explainer).

Debug helpers (dart-defines):

```
--dart-define=UMP_DEBUG_GEOGRAPHY=eea          # or us_state
--dart-define=UMP_TEST_DEVICE_IDS=<hash>       # hash is printed in logcat
--dart-define=ADMOB_TEST_DEVICE_IDS=<id>       # test device for ad requests
```

## Where the ids live

* **Test ids (app + all five units, Android and iOS):**
  `lib/features/ads/data/admob_config.dart` is the only Dart place. The native
  projects must also hold the *app* id (the SDK reads it before Dart runs); they
  are marked with a comment and `test/admob_config_test.dart` fails if they
  drift from the Dart values.
* **Production ids:** never committed; passed at build time (below).

## Going to production

Debug/profile builds always use Google's test ad units. For release:

1. Create the app and five ad units per platform in AdMob.
2. Android app id: `-PadmobAppId=ca-app-pub-XXXX~YYYY` (Gradle property, e.g.
   in `~/.gradle/gradle.properties` or CI). iOS: set `GADApplicationIdentifier`
   in `ios/Runner/Info.plist`.
3. Ad unit ids, per platform and format:

```
flutter build appbundle --release \
  --dart-define=ADMOB_ANDROID_BANNER=ca-app-pub-XXXX/1111 \
  --dart-define=ADMOB_ANDROID_NATIVE=... \
  --dart-define=ADMOB_ANDROID_INTERSTITIAL=... \
  --dart-define=ADMOB_ANDROID_REWARDED=... \
  --dart-define=ADMOB_ANDROID_APP_OPEN=...
```
(`ADMOB_IOS_*` for iOS). A release build missing an id simply shows no ad of
that format. `--dart-define=ADMOB_USE_TEST_ADS=true` forces test ads in a
release binary for QA.

4. iOS: replace the single `SKAdNetworkItems` entry in `Info.plist` with
   Google's full list: <https://developers.google.com/admob/ios/choose-networks#skadnetwork>
5. Never click your own live ads; use test devices.

## Store disclosures (must be updated before release)

* **Google Play Data safety:** declare advertising/analytics data collected
  and shared via AdMob (device or other IDs, app interactions, diagnostics),
  and the advertising-ID declaration. Documents and OCR text are still never
  collected.
* **App Store privacy labels:** "Data used to track you" / "Identifiers" and
  "Usage data" for advertising; ATT prompt text is in `Info.plist`.
* **Privacy policy:** mention AdMob, consent management and how to change
  choices (Settings → Privacy & ad choices).
* Listing copy must not claim "no ads".

## Pro (Phase 3)

`proEntitlementProvider` currently returns `false`. RevenueCat entitlements
will drive it; when true, `adsEnabledProvider` turns every ad format off and
the SDK is never started.
