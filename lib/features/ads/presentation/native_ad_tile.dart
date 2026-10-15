import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/theme/app_theme.dart';
import '../data/ads_facade.dart';
import '../data/ads_providers.dart';

/// A native ad row between document rows.
///
/// Requests its ad only when the row is first built (i.e. near the viewport),
/// keeps the loaded ad when scrolled away, and takes no space until an ad has
/// actually loaded.
class NativeAdTile extends ConsumerStatefulWidget {
  const NativeAdTile({super.key, required this.slot});

  /// Stable ordinal of this ad position within the list.
  final int slot;

  @override
  ConsumerState<NativeAdTile> createState() => _NativeAdTileState();
}

class _NativeAdTileState extends ConsumerState<NativeAdTile> {
  NativeAdLease? _lease;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Needs the theme to style the ad, so it cannot happen in initState.
    _lease ??= ref
        .read(adsFacadeProvider)
        .acquireNative(widget.slot, _style(context));
  }

  @override
  void dispose() {
    _lease?.release();
    super.dispose();
  }

  NativeTemplateStyle _style(BuildContext context) {
    final s = context.scheme;
    return NativeTemplateStyle(
      templateType: TemplateType.small,
      mainBackgroundColor: s.surfaceContainerLow,
      cornerRadius: 12,
      callToActionTextStyle: NativeTemplateTextStyle(
        textColor: s.onPrimary,
        backgroundColor: s.primary,
        style: NativeTemplateFontStyle.bold,
        size: 14,
      ),
      primaryTextStyle: NativeTemplateTextStyle(
        textColor: s.onSurface,
        style: NativeTemplateFontStyle.bold,
        size: 15,
      ),
      secondaryTextStyle: NativeTemplateTextStyle(
        textColor: s.onSurfaceVariant,
        size: 13,
      ),
      tertiaryTextStyle: NativeTemplateTextStyle(
        textColor: s.onSurfaceVariant,
        size: 12,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lease = _lease;
    if (lease == null) return const SizedBox.shrink();
    return ValueListenableBuilder<NativeAd?>(
      valueListenable: lease.ad,
      builder: (context, ad, _) {
        if (ad == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 90, maxHeight: 120),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AdWidget(ad: ad),
            ),
          ),
        );
      },
    );
  }
}
