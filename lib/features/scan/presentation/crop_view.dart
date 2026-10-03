import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/l10n_x.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/edit_recipe.dart';

/// Image with four draggable corner handles for a perspective crop.
class CropView extends StatelessWidget {
  const CropView({
    super.key,
    required this.imagePath,
    required this.aspectRatio,
    required this.quad,
    required this.onChanged,
  });

  final String imagePath;

  /// Width / height of the image.
  final double aspectRatio;
  final CropQuad quad;
  final ValueChanged<CropQuad> onChanged;

  static const double _hit = 48;
  static const double _dot = 22;

  @override
  Widget build(BuildContext context) {
    final labels = [
      context.l10n.cropTopLeft,
      context.l10n.cropTopRight,
      context.l10n.cropBottomRight,
      context.l10n.cropBottomLeft,
    ];
    return Center(
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: LayoutBuilder(
          builder: (context, box) {
            final size = box.biggest;
            Offset toPx(Offset n) =>
                Offset(n.dx * size.width, n.dy * size.height);
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: ExcludeSemantics(
                    child: Image(
                      image: ResizeImage(
                        FileImage(File(imagePath)),
                        width: 1600,
                        policy: ResizeImagePolicy.fit,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: _QuadPainter(
                      quad: quad,
                      shade: context.scheme.scrim.withValues(alpha: 0.55),
                      line: context.scheme.primary,
                    ),
                  ),
                ),
                for (var i = 0; i < 4; i++)
                  Positioned(
                    left: toPx(quad.corners[i]).dx - _hit / 2,
                    top: toPx(quad.corners[i]).dy - _hit / 2,
                    width: _hit,
                    height: _hit,
                    child: Semantics(
                      label: context.l10n.cropHandleLabel(labels[i]),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanUpdate: (d) {
                          final next =
                              quad.corners[i] +
                              Offset(
                                d.delta.dx / size.width,
                                d.delta.dy / size.height,
                              );
                          onChanged(quad.withCorner(i, next));
                        },
                        child: Center(
                          child: Container(
                            width: _dot,
                            height: _dot,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.scheme.primary,
                              border: Border.all(
                                color: context.scheme.onPrimary,
                                width: 2.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _QuadPainter extends CustomPainter {
  _QuadPainter({required this.quad, required this.shade, required this.line});

  final CropQuad quad;
  final Color shade;
  final Color line;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addPolygon([
        for (final c in quad.corners)
          Offset(c.dx * size.width, c.dy * size.height),
      ], true);
    final outside = Path.combine(
      PathOperation.difference,
      Path()..addRect(Offset.zero & size),
      path,
    );
    canvas.drawPath(outside, Paint()..color = shade);
    canvas.drawPath(
      path,
      Paint()
        ..color = line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_QuadPainter old) =>
      old.quad != quad || old.shade != shade || old.line != line;
}
