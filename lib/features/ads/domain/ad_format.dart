/// Ad formats the app can show.
enum AdFormat { banner, native, interstitial, rewarded, appOpen }

/// Natural breaks in the user's flow that may (subject to frequency caps)
/// be followed by an interstitial. Never fired mid-task.
enum AdEvent { documentSaved, exportCompleted }

/// Result of offering a rewarded video.
enum RewardOutcome { earned, dismissed, unavailable }
