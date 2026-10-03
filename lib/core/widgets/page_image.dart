import 'dart:io';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Shows a page file scaled down to roughly [cacheWidth] pixels, so grids of
/// large scans never decode full-resolution bitmaps.
class PageImage extends StatelessWidget {
  const PageImage({
    super.key,
    required this.path,
    this.cacheWidth = 400,
    this.fit = BoxFit.cover,
    this.semanticLabel,
  });

  final String? path;
  final int cacheWidth;
  final BoxFit fit;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final p = path;
    if (p == null) return _placeholder(context);
    return Image(
      image: ResizeImage(
        FileImage(File(p)),
        width: cacheWidth,
        policy: ResizeImagePolicy.fit,
      ),
      fit: fit,
      gaplessPlayback: true,
      semanticLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
      errorBuilder: (context, error, stack) => _placeholder(context),
    );
  }

  Widget _placeholder(BuildContext context) => ColoredBox(
    color: context.scheme.surfaceContainerHighest,
    child: Center(
      child: Icon(
        Icons.description_outlined,
        color: context.scheme.onSurfaceVariant,
      ),
    ),
  );
}
