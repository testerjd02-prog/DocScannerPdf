import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:packet_pal/features/scan/data/image_processor.dart';
import 'package:packet_pal/features/scan/domain/edit_recipe.dart';

img.Image _page({int w = 400, int h = 600}) {
  final image = img.Image(width: w, height: h);
  img.fill(image, color: img.ColorRgb8(235, 230, 215));
  // A dark "text" bar.
  img.fillRect(
    image,
    x1: 50,
    y1: 100,
    x2: 350,
    y2: 130,
    color: img.ColorRgb8(30, 30, 30),
  );
  return image;
}

void main() {
  test('rotation swaps dimensions', () {
    final out = ImageOps.applyRecipe(_page(), const EditRecipe(rotation: 90));
    expect((out.width, out.height), (600, 400));
  });

  test('perspective crop outputs the quad size', () {
    final quad = CropQuad.full
        .withCorner(0, const Offset(0.25, 0.25))
        .withCorner(1, const Offset(0.75, 0.25))
        .withCorner(2, const Offset(0.75, 0.75))
        .withCorner(3, const Offset(0.25, 0.75));
    final out = ImageOps.applyRecipe(_page(), EditRecipe(crop: quad));
    expect((out.width - 200).abs() <= 2, isTrue, reason: '${out.width}');
    expect((out.height - 300).abs() <= 2, isTrue, reason: '${out.height}');
  });

  test('black and white yields only black and white pixels', () {
    final out = ImageOps.applyFilter(_page(), ScanFilter.blackWhite);
    var other = 0;
    var black = 0;
    for (final p in out) {
      if (p.r != 0 && p.r != 255) other++;
      if (p.r == 0) black++;
    }
    expect(other, 0);
    expect(black, greaterThan(0), reason: 'text bar should be black');
    expect(
      black,
      lessThan(out.width * out.height ~/ 4),
      reason: 'paper should stay white',
    );
  });

  test('grayscale removes colour', () {
    final out = ImageOps.applyFilter(_page(), ScanFilter.grayscale);
    final p = out.getPixel(10, 10);
    expect(p.r, p.g);
    expect(p.g, p.b);
  });

  test('large images are capped to the maximum side', () {
    final out = ImageOps.applyRecipe(
      _page(w: 1000, h: 2000),
      EditRecipe.none,
      maxSide: 500,
    );
    expect(out.height, 500);
    expect(out.width, 250);
  });

  test('render never modifies the original file', () async {
    final dir = await Directory.systemTemp.createTemp('imgops_');
    addTearDown(() => dir.delete(recursive: true));
    final original = File('${dir.path}/o.jpg')
      ..writeAsBytesSync(img.encodeJpg(_page()));
    final before = original.readAsBytesSync();

    final result = await const ImageProcessor().render(
      originalPath: original.path,
      outputPath: '${dir.path}/e.jpg',
      recipe: const EditRecipe(filter: ScanFilter.blackWhite, rotation: 180),
    );

    expect(result.width, 400);
    expect(File('${dir.path}/e.jpg').existsSync(), isTrue);
    expect(original.readAsBytesSync(), before);
  });

  test('imports are re-encoded without EXIF', () async {
    final dir = await Directory.systemTemp.createTemp('imgops_');
    addTearDown(() => dir.delete(recursive: true));
    final source = _page();
    source.exif.imageIfd['Make'] = 'SecretPhone';
    File('${dir.path}/in.jpg').writeAsBytesSync(img.encodeJpg(source));

    await const ImageProcessor().normalizeImport(
      inputPath: '${dir.path}/in.jpg',
      outputPath: '${dir.path}/out.jpg',
    );
    final out = img.decodeJpg(File('${dir.path}/out.jpg').readAsBytesSync())!;
    expect(out.exif.isEmpty, isTrue);
  });

  test('many concurrent jobs all complete (bounded isolate use)', () async {
    final dir = await Directory.systemTemp.createTemp('imgops_');
    addTearDown(() => dir.delete(recursive: true));
    final file = File('${dir.path}/o.jpg')
      ..writeAsBytesSync(img.encodeJpg(_page()));

    final sizes = await Future.wait([
      for (var i = 0; i < 12; i++) const ImageProcessor().sizeOf(file.path),
    ]);
    expect(sizes, everyElement((width: 400, height: 600)));
  });
}
