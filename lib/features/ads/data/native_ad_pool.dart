import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads_facade.dart';

class _Entry {
  final ValueNotifier<NativeAd?> ad = ValueNotifier(null);
  DateTime? loadedAt;
  DateTime? failedAt;
  bool loading = false;
  int failures = 0;
  int leases = 0;
}

class _Lease implements NativeAdLease {
  _Lease(this._entry, this._onRelease);

  final _Entry _entry;
  final void Function(_Entry) _onRelease;
  bool _released = false;

  @override
  ValueListenable<NativeAd?> get ad => _entry.ad;

  @override
  void release() {
    if (_released) return;
    _released = true;
    _onRelease(_entry);
  }
}

/// Small cache of native ads keyed by list slot.
///
/// * A slot is requested only when a list row for it is actually built.
/// * A loaded ad is kept (up to [maxCached]) after its row scrolls away, so
///   scrolling back costs no new request.
/// * Ads shown right now are never evicted or disposed.
/// * After a failure a slot waits (30 s, doubling, capped at 5 min) and gives
///   up after 3 failures until [resetFailures] is called (app resume).
/// * Ads older than [maxAge] are replaced the next time their row appears.
class NativeAdPool {
  NativeAdPool({
    required this.adUnitId,
    required this.canLoad,
    required this.request,
    this.maxCached = 4,
    this.maxAge = const Duration(minutes: 50),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final String? adUnitId;
  final bool Function() canLoad;
  final AdRequest request;
  final int maxCached;
  final Duration maxAge;
  final DateTime Function() _now;

  // Insertion order doubles as least-recently-used order.
  final LinkedHashMap<int, _Entry> _entries = LinkedHashMap();

  int requestCount = 0;

  NativeAdLease? acquire(int slot, NativeTemplateStyle style) {
    final id = adUnitId;
    if (id == null || !canLoad()) return null;

    final entry = _entries.remove(slot) ?? _Entry();
    _entries[slot] = entry; // mark most recently used
    entry.leases++;

    _dropIfStale(entry);
    if (entry.ad.value == null && !entry.loading && _mayRetry(entry)) {
      _load(entry, id, style);
    }
    _evict();
    return _Lease(entry, (e) => e.leases--);
  }

  void _dropIfStale(_Entry entry) {
    final ad = entry.ad.value;
    final at = entry.loadedAt;
    // Only replace when nobody is looking at it.
    if (ad != null &&
        at != null &&
        entry.leases <= 1 &&
        _now().difference(at) >= maxAge) {
      entry.ad.value = null;
      entry.loadedAt = null;
      ad.dispose();
    }
  }

  bool _mayRetry(_Entry e) {
    if (e.failures == 0) return true;
    if (e.failures >= 3) return false;
    final wait = Duration(
      seconds: (30 * (1 << (e.failures - 1))).clamp(30, 300),
    );
    final at = e.failedAt;
    return at == null || _now().difference(at) >= wait;
  }

  void _load(_Entry entry, String id, NativeTemplateStyle style) {
    entry.loading = true;
    requestCount++;
    NativeAd(
      adUnitId: id,
      request: request,
      nativeTemplateStyle: style,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          entry.loading = false;
          if (!canLoad()) {
            ad.dispose();
            return;
          }
          entry.failures = 0;
          entry.loadedAt = _now();
          entry.ad.value = ad as NativeAd;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          entry.loading = false;
          entry.failures++;
          entry.failedAt = _now();
        },
      ),
    ).load();
  }

  void _evict() {
    var loaded = _entries.values.where((e) => e.ad.value != null).length;
    if (loaded <= maxCached) return;
    for (final key in _entries.keys.toList()) {
      if (loaded <= maxCached) break;
      final e = _entries[key]!;
      if (e.leases > 0 || e.ad.value == null) continue;
      e.ad.value?.dispose();
      e.ad.value = null;
      _entries.remove(key);
      loaded--;
    }
  }

  /// Gives failed slots another chance (call on app resume).
  void resetFailures() {
    for (final e in _entries.values) {
      e.failures = 0;
    }
  }

  /// Disposes cached ads that are not on screen.
  void clearUnused() {
    for (final key in _entries.keys.toList()) {
      final e = _entries[key]!;
      if (e.leases > 0) continue;
      e.ad.value?.dispose();
      _entries.remove(key);
    }
  }

  void dispose() {
    for (final e in _entries.values) {
      e.ad.value?.dispose();
      e.ad.value = null;
    }
    _entries.clear();
  }
}
