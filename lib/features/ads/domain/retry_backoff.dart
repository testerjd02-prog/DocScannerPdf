import 'dart:math' as math;

/// Bounded exponential backoff for failed ad loads.
///
/// After [maxRetries] retries it gives up (returns null) so a persistent
/// "no fill" or offline state never turns into a request storm. The owner
/// calls [reset] when a load succeeds or when the user does something that
/// justifies trying again (opening a screen, resuming the app).
class RetryBackoff {
  RetryBackoff({
    this.base = const Duration(seconds: 4),
    this.factor = 2,
    this.maxRetries = 3,
    this.maxDelay = const Duration(minutes: 1),
  });

  final Duration base;
  final num factor;
  final int maxRetries;
  final Duration maxDelay;

  int _failures = 0;

  int get failures => _failures;
  bool get exhausted => _failures > maxRetries;

  /// Records a failure and returns how long to wait before retrying, or null
  /// when the retry budget is spent.
  Duration? onFailure() {
    final retryIndex = _failures;
    _failures++;
    if (retryIndex >= maxRetries) return null;
    final ms = base.inMilliseconds * math.pow(factor, retryIndex);
    return Duration(
      milliseconds: math.min(ms, maxDelay.inMilliseconds).round(),
    );
  }

  void reset() => _failures = 0;
}
