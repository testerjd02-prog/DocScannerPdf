import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/theme/app_theme.dart';
import '../data/ads_facade.dart';
import '../data/ads_providers.dart';
import '../domain/retry_backoff.dart';

/// One adaptive banner for the whole tab area.
///
/// * Lives in the app shell, so it is requested once and survives tab
///   switches (no reload per screen). AdMob refreshes it on its own schedule.
/// * Collapses to nothing until an ad is actually loaded and whenever ads
///   cannot serve, so there is never an empty "ad" strip.
/// * Reloads only when the available width really changes (rotation).
/// * Failures retry with bounded backoff, then stop until the next rebuild
///   trigger (consent change, rotation).
class BannerAdSlot extends ConsumerStatefulWidget {
  const BannerAdSlot({super.key, this.onVisibilityChanged});

  /// Called when a banner appears or disappears, so the shell can adjust the
  /// safe-area handling of the content below.
  final ValueChanged<bool>? onVisibilityChanged;

  @override
  ConsumerState<BannerAdSlot> createState() => _BannerAdSlotState();
}

class _BannerAdSlotState extends ConsumerState<BannerAdSlot> {
  late final AdsFacade _ads = ref.read(adsFacadeProvider);
  final RetryBackoff _backoff = RetryBackoff();

  BannerAd? _ad;
  int? _loadedWidth;
  bool _loading = false;
  Timer? _retry;
  bool _reportedVisible = false;

  @override
  void initState() {
    super.initState();
    _ads.canServe.addListener(_onServeChanged);
  }

  @override
  void dispose() {
    _ads.canServe.removeListener(_onServeChanged);
    _retry?.cancel();
    unawaited(_ad?.dispose());
    super.dispose();
  }

  void _onServeChanged() {
    if (!_ads.canServe.value) {
      _retry?.cancel();
      final old = _ad;
      _ad = null;
      _loadedWidth = null;
      unawaited(old?.dispose());
      _backoff.reset();
    }
    if (mounted) setState(() {});
  }

  void _report(bool visible) {
    if (_reportedVisible == visible) return;
    _reportedVisible = visible;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onVisibilityChanged?.call(visible);
    });
  }

  Future<void> _ensureLoaded(int width, Orientation orientation) async {
    final id = _ads.bannerAdUnitId;
    if (!mounted || id == null || !_ads.canServe.value || _loading) return;
    if (_retry != null) return;
    final loadedWidth = _loadedWidth;
    if (_ad != null &&
        loadedWidth != null &&
        (loadedWidth - width).abs() < 48) {
      return;
    }
    _loading = true;
    // ignore: deprecated_member_use
    final size = await AdSize.getAnchoredAdaptiveBannerAdSize(
      orientation,
      width,
    );
    if (!mounted || !_ads.canServe.value) {
      _loading = false;
      return;
    }
    unawaited(
      BannerAd(
        adUnitId: id,
        size: size ?? AdSize.banner,
        request: _ads.adRequest,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            _loading = false;
            if (!mounted || !_ads.canServe.value) {
              unawaited(ad.dispose());
              return;
            }
            _backoff.reset();
            final old = _ad;
            setState(() {
              _ad = ad as BannerAd;
              _loadedWidth = width;
            });
            unawaited(old?.dispose());
          },
          onAdFailedToLoad: (ad, error) {
            unawaited(ad.dispose());
            _loading = false;
            final delay = _backoff.onFailure();
            if (delay != null && mounted) {
              _retry = Timer(delay, () {
                _retry = null;
                if (mounted) setState(() {});
              });
            }
          },
        ),
      ).load(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final serving = _ads.canServe.value;
    if (!serving) {
      _report(false);
      return const SizedBox.shrink();
    }
    final orientation = MediaQuery.orientationOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.truncate();
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _ensureLoaded(width, orientation),
        );
        final ad = _ad;
        _report(ad != null);
        if (ad == null) return const SizedBox.shrink();
        return ColoredBox(
          color: context.scheme.surfaceContainerLow,
          child: SafeArea(
            bottom: false,
            child: Semantics(
              container: true,
              child: Center(
                child: SizedBox(
                  width: ad.size.width.toDouble(),
                  height: ad.size.height.toDouble(),
                  child: AdWidget(ad: ad),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
