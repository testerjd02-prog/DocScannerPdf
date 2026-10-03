import 'dart:convert';
import 'dart:ui';

/// Non-destructive filters applied on top of the untouched original capture.
enum ScanFilter {
  original,
  enhanced,
  grayscale,
  blackWhite;

  static ScanFilter parse(String? name) => ScanFilter.values.firstWhere(
    (f) => f.name == name,
    orElse: () => ScanFilter.original,
  );
}

/// Four crop corners in normalised image coordinates (0..1), ordered
/// top-left, top-right, bottom-right, bottom-left.
///
/// Corners are free so a skewed page can be straightened (perspective crop).
class CropQuad {
  const CropQuad(this.corners);

  static const CropQuad full = CropQuad([
    Offset.zero,
    Offset(1, 0),
    Offset(1, 1),
    Offset(0, 1),
  ]);

  final List<Offset> corners;

  Offset get topLeft => corners[0];
  Offset get topRight => corners[1];
  Offset get bottomRight => corners[2];
  Offset get bottomLeft => corners[3];

  bool get isFull {
    for (var i = 0; i < 4; i++) {
      if ((corners[i] - full.corners[i]).distance > 0.002) return false;
    }
    return true;
  }

  CropQuad withCorner(int index, Offset value) {
    final next = List<Offset>.of(corners);
    next[index] = Offset(value.dx.clamp(0.0, 1.0), value.dy.clamp(0.0, 1.0));
    return CropQuad(List.unmodifiable(next));
  }

  String toJson() => jsonEncode([
    for (final c in corners) [c.dx, c.dy],
  ]);

  static CropQuad? fromJson(String? source) {
    if (source == null || source.isEmpty) return null;
    final decoded = jsonDecode(source) as List<dynamic>;
    if (decoded.length != 4) return null;
    return CropQuad([
      for (final c in decoded)
        Offset(
          ((c as List<dynamic>)[0] as num).toDouble(),
          (c[1] as num).toDouble(),
        ),
    ]);
  }

  @override
  bool operator ==(Object other) =>
      other is CropQuad &&
      [for (var i = 0; i < 4; i++) corners[i] == other.corners[i]]
          .every((e) => e);

  @override
  int get hashCode => Object.hashAll(corners);
}

/// Everything needed to rebuild the edited image from the original.
class EditRecipe {
  const EditRecipe({
    this.crop = CropQuad.full,
    this.filter = ScanFilter.original,
    this.rotation = 0,
  }) : assert(rotation % 90 == 0);

  static const EditRecipe none = EditRecipe();

  final CropQuad crop;
  final ScanFilter filter;

  /// Clockwise degrees: 0, 90, 180 or 270.
  final int rotation;

  EditRecipe copyWith({CropQuad? crop, ScanFilter? filter, int? rotation}) =>
      EditRecipe(
        crop: crop ?? this.crop,
        filter: filter ?? this.filter,
        rotation: ((rotation ?? this.rotation) % 360 + 360) % 360,
      );

  EditRecipe rotatedClockwise() => copyWith(rotation: rotation + 90);

  /// True when rendering would reproduce the original unchanged.
  bool get isIdentity =>
      crop.isFull && filter == ScanFilter.original && rotation == 0;

  @override
  bool operator ==(Object other) =>
      other is EditRecipe &&
      other.crop == crop &&
      other.filter == filter &&
      other.rotation == rotation;

  @override
  int get hashCode => Object.hash(crop, filter, rotation);
}
