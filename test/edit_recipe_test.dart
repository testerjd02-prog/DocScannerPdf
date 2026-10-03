import 'package:flutter_test/flutter_test.dart';
import 'package:packet_pal/features/scan/domain/edit_recipe.dart';

void main() {
  test('full crop is detected and round-trips as JSON', () {
    expect(CropQuad.full.isFull, isTrue);
    final moved = CropQuad.full.withCorner(0, const Offset(0.1, 0.2));
    expect(moved.isFull, isFalse);
    expect(CropQuad.fromJson(moved.toJson()), moved);
    expect(CropQuad.fromJson(null), isNull);
  });

  test('corners are clamped to the image', () {
    final q = CropQuad.full.withCorner(2, const Offset(1.5, -0.3));
    expect(q.bottomRight, const Offset(1, 0));
  });

  test('rotation wraps to 0..270', () {
    var r = EditRecipe.none;
    for (var i = 0; i < 5; i++) {
      r = r.rotatedClockwise();
    }
    expect(r.rotation, 90);
    expect(r.copyWith(rotation: -90).rotation, 270);
  });

  test('identity recipe renders nothing new', () {
    expect(EditRecipe.none.isIdentity, isTrue);
    expect(const EditRecipe(filter: ScanFilter.grayscale).isIdentity, isFalse);
  });
}
