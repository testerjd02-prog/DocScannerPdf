import 'dart:async';

import '../domain/retry_backoff.dart';

/// Starts one ad request. Exactly one of [onLoaded] / [onFailed] must be
/// called. [onFailed] receives the AdMob error code.
typedef SlotLoader<T> = void Function(
  String adUnitId,
  void Function(T ad) onLoaded,
  void Function(int errorCode) onFailed,
);

typedef RetryScheduler = Timer Function(Duration delay, void Function() run);

/// Holds at most one preloaded full-screen ad of one format and makes sure
/// requests are never wasted:
///
/// * at most one request in flight, and none while an unexpired ad is cached;
/// * an ad that outlived [maxAge] is discarded instead of shown (AdMob will not
///   pay for stale impressions);
/// * failures retry with bounded exponential backoff and then stop until the
///   owner asks again ([resetRetries] + [warmUp]);
/// * nothing is requested while [canLoad] is false (no consent, ad-free,
///   offline-ish background, ...), and an ad that arrives after that turned
///   false is thrown away.
class FullScreenAdSlot<T> {
  FullScreenAdSlot({
    required this.adUnitId,
    required this.maxAge,
    required this.loader,
    required this.disposeAd,
    required this.canLoad,
    DateTime Function()? now,
    RetryBackoff? backoff,
    RetryScheduler? scheduler,
  }) : _now = now ?? DateTime.now,
       _backoff = backoff ?? RetryBackoff(),
       _schedule = scheduler ?? Timer.new;

  /// Null disables the slot entirely (format not configured).
  final String? adUnitId;
  final Duration maxAge;
  final SlotLoader<T> loader;
  final void Function(T ad) disposeAd;
  final bool Function() canLoad;

  final DateTime Function() _now;
  final RetryBackoff _backoff;
  final RetryScheduler _schedule;

  T? _ad;
  DateTime? _loadedAt;
  bool _loading = false;
  Timer? _retryTimer;
  final List<Completer<bool>> _waiters = [];

  /// Number of ad requests actually sent (useful for tests and diagnostics).
  int requestCount = 0;

  bool get isLoading => _loading;

  bool get isReady {
    _discardIfStale();
    return _ad != null;
  }

  void _discardIfStale() {
    final ad = _ad;
    final at = _loadedAt;
    if (ad != null && at != null && _now().difference(at) >= maxAge) {
      _ad = null;
      _loadedAt = null;
      disposeAd(ad);
    }
  }

  /// Makes sure an ad is (being) loaded, without ever duplicating a request.
  void warmUp() {
    final id = adUnitId;
    if (id == null || !canLoad()) return;
    _discardIfStale();
    if (_ad != null || _loading) return;
    _retryTimer?.cancel();
    _retryTimer = null;
    _start(id);
  }

  void _start(String id) {
    _loading = true;
    requestCount++;
    try {
      loader(id, _onLoaded, _onFailed);
    } on Object {
      _onFailed(-1);
    }
  }

  void _onLoaded(T ad) {
    _loading = false;
    if (!canLoad()) {
      disposeAd(ad);
      _resolveWaiters(false);
      return;
    }
    _ad = ad;
    _loadedAt = _now();
    _backoff.reset();
    _resolveWaiters(true);
  }

  void _onFailed(int code) {
    _loading = false;
    _resolveWaiters(false);
    // 1 = invalid request, 8 = app id missing: retrying cannot help.
    if (code == 1 || code == 8) return;
    final delay = _backoff.onFailure();
    if (delay == null) return;
    _retryTimer = _schedule(delay, () {
      _retryTimer = null;
      final id = adUnitId;
      if (id != null && canLoad() && _ad == null && !_loading) _start(id);
    });
  }

  /// Completes true as soon as an ad is ready, false on failure or timeout.
  Future<bool> whenReady(Duration timeout) {
    if (isReady) return Future.value(true);
    final waiter = Completer<bool>();
    _waiters.add(waiter);
    return waiter.future.timeout(
      timeout,
      onTimeout: () {
        _waiters.remove(waiter);
        return false;
      },
    );
  }

  void _resolveWaiters(bool ok) {
    for (final w in _waiters) {
      if (!w.isCompleted) w.complete(ok);
    }
    _waiters.clear();
  }

  /// Hands the cached ad (if fresh) to the caller, who now owns it and must
  /// dispose it. The slot is empty afterwards.
  T? take() {
    _discardIfStale();
    final ad = _ad;
    _ad = null;
    _loadedAt = null;
    return ad;
  }

  /// Allows another round of retries (after a user-driven trigger).
  void resetRetries() {
    _backoff.reset();
  }

  /// Drops the cached ad and cancels pending work, e.g. when ads get disabled.
  void clear() {
    _retryTimer?.cancel();
    _retryTimer = null;
    final ad = _ad;
    _ad = null;
    _loadedAt = null;
    if (ad != null) disposeAd(ad);
    _resolveWaiters(false);
  }
}
