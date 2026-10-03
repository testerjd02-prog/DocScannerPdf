import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:isolate';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import '../domain/edit_recipe.dart';

/// Longest side, in pixels, of a rendered page. Keeps 50+ page documents
/// small enough to hold and export without exhausting memory.
const int kMaxPageSide = 2400;

class RenderResult {
  const RenderResult({required this.width, required this.height});
  final int width;
  final int height;
}

/// Pure image maths. Everything here is synchronous and isolate-safe; use
/// [ImageProcessor] to run it off the UI thread.
abstract final class ImageOps {
  /// Decodes [bytes], applies EXIF orientation and flattens transparency
  /// onto white so every later step can assume an opaque RGB image.
  static img.Image decodeUpright(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw const FormatException('Unsupported or corrupt image');
    }
    var image = img.bakeOrientation(decoded);
    // Drop EXIF (GPS, device, timestamps): nothing in a scan needs it.
    image.exif = img.ExifData();
    if (image.hasAlpha || image.numChannels != 3 || image.hasPalette) {
      final flat = img.Image(width: image.width, height: image.height);
      img.fill(flat, color: img.ColorRgb8(255, 255, 255));
      img.compositeImage(flat, image);
      image = flat;
    }
    return image;
  }

  static img.Image capSize(img.Image image, int maxSide) {
    final longest = math.max(image.width, image.height);
    if (longest <= maxSide) return image;
    final scale = maxSide / longest;
    return img.copyResize(
      image,
      width: (image.width * scale).round(),
      height: (image.height * scale).round(),
      interpolation: img.Interpolation.average,
    );
  }

  /// Applies crop, filter and rotation (in that order) to [source].
  static img.Image applyRecipe(
    img.Image source,
    EditRecipe recipe, {
    int maxSide = kMaxPageSide,
  }) {
    var image = capSize(source, maxSide);
    if (!recipe.crop.isFull) image = _perspectiveCrop(image, recipe.crop);
    image = applyFilter(image, recipe.filter);
    if (recipe.rotation != 0) {
      image = img.copyRotate(image, angle: recipe.rotation);
    }
    return image;
  }

  static img.Image _perspectiveCrop(img.Image src, CropQuad quad) {
    img.Point pt(int i) => img.Point(
      quad.corners[i].dx * (src.width - 1),
      quad.corners[i].dy * (src.height - 1),
    );
    final tl = pt(0), tr = pt(1), br = pt(2), bl = pt(3);
    double dist(img.Point a, img.Point b) =>
        math.sqrt(math.pow(a.x - b.x, 2) + math.pow(a.y - b.y, 2));
    final width = math.max(2, ((dist(tl, tr) + dist(bl, br)) / 2).round());
    final height = math.max(2, ((dist(tl, bl) + dist(tr, br)) / 2).round());
    return img.copyRectify(
      src,
      topLeft: tl,
      topRight: tr,
      bottomLeft: bl,
      bottomRight: br,
      interpolation: img.Interpolation.linear,
      toImage: img.Image(width: width, height: height),
    );
  }

  static img.Image applyFilter(img.Image image, ScanFilter filter) {
    switch (filter) {
      case ScanFilter.original:
        return image;
      case ScanFilter.enhanced:
        final stretched = img.normalize(image, min: 0, max: 255);
        return img.adjustColor(stretched, contrast: 1.15, brightness: 1.04);
      case ScanFilter.grayscale:
        return img.grayscale(image);
      case ScanFilter.blackWhite:
        return _adaptiveThreshold(image);
    }
  }

  /// Local-mean threshold: copes with uneven lighting and shadows that make a
  /// single global threshold turn half the page black.
  static img.Image _adaptiveThreshold(img.Image image) {
    final w = image.width, h = image.height;
    final gray = Uint8List(w * h);
    var i = 0;
    for (final p in image) {
      gray[i++] = (0.299 * p.r + 0.587 * p.g + 0.114 * p.b).round();
    }
    final stride = w + 1;
    final integral = Float64List(stride * (h + 1));
    for (var y = 0; y < h; y++) {
      var rowSum = 0.0;
      for (var x = 0; x < w; x++) {
        rowSum += gray[y * w + x];
        integral[(y + 1) * stride + x + 1] =
            integral[y * stride + x + 1] + rowSum;
      }
    }
    final radius = math.max(8, math.min(w, h) ~/ 16);
    const sensitivity = 0.12;
    final out = img.Image(width: w, height: h);
    for (var y = 0; y < h; y++) {
      final y0 = math.max(0, y - radius), y1 = math.min(h, y + radius + 1);
      for (var x = 0; x < w; x++) {
        final x0 = math.max(0, x - radius), x1 = math.min(w, x + radius + 1);
        final sum =
            integral[y1 * stride + x1] -
            integral[y0 * stride + x1] -
            integral[y1 * stride + x0] +
            integral[y0 * stride + x0];
        final mean = sum / ((x1 - x0) * (y1 - y0));
        final v = gray[y * w + x] > mean * (1 - sensitivity) ? 255 : 0;
        out.setPixelRgb(x, y, v, v, v);
      }
    }
    return out;
  }
}

/// Limits how many image jobs run at once. A 50-page document would otherwise
/// start 50 isolates, each decoding a full-size photo, and exhaust memory.
class _Gate {
  _Gate(this._limit);

  final int _limit;
  int _running = 0;
  final Queue<Completer<void>> _waiting = Queue();

  Future<T> run<T>(Future<T> Function() task) async {
    if (_running >= _limit) {
      final turn = Completer<void>();
      _waiting.add(turn);
      await turn.future; // the finishing job hands its slot to us
    } else {
      _running++;
    }
    try {
      return await task();
    } finally {
      if (_waiting.isNotEmpty) {
        _waiting.removeFirst().complete();
      } else {
        _running--;
      }
    }
  }
}

/// Runs [ImageOps] in background isolates and writes JPEG files.
class ImageProcessor {
  const ImageProcessor();

  static final _Gate _gate = _Gate(3);

  static Future<T> _isolated<T>(T Function() job) =>
      _gate.run(() => Isolate.run(job));

  /// Copies an imported image into [outputPath], upright and size-capped.
  Future<RenderResult> normalizeImport({
    required String inputPath,
    required String outputPath,
    int maxSide = 3200,
  }) => Isolate.run(() {
    final image = ImageOps.capSize(
      ImageOps.decodeUpright(File(inputPath).readAsBytesSync()),
      maxSide,
    );
    File(outputPath).writeAsBytesSync(img.encodeJpg(image, quality: 92));
    return RenderResult(width: image.width, height: image.height);
  });

  /// Renders the edited version of [originalPath] to [outputPath].
  /// The original is only read, never modified.
  Future<RenderResult> render({
    required String originalPath,
    required String outputPath,
    required EditRecipe recipe,
    int maxSide = kMaxPageSide,
    int quality = 88,
  }) => Isolate.run(() {
    final source = ImageOps.decodeUpright(File(originalPath).readAsBytesSync());
    final result = ImageOps.applyRecipe(source, recipe, maxSide: maxSide);
    File(outputPath).writeAsBytesSync(img.encodeJpg(result, quality: quality));
    return RenderResult(width: result.width, height: result.height);
  });

  /// Small in-memory render for the live editor preview.
  Future<Uint8List> preview({
    required String originalPath,
    required EditRecipe recipe,
    int maxSide = 1100,
  }) => Isolate.run(() {
    final source = ImageOps.decodeUpright(File(originalPath).readAsBytesSync());
    final result = ImageOps.applyRecipe(source, recipe, maxSide: maxSide);
    return Uint8List.fromList(img.encodeJpg(result, quality: 80));
  });

  /// Pixel size of an image file, read from its header without decoding.
  Future<({int width, int height})> sizeOf(String path) => _isolated(() {
    final bytes = File(path).readAsBytesSync();
    final info = img.findDecoderForData(bytes)?.startDecode(bytes);
    if (info != null && info.width > 0 && info.height > 0) {
      return (width: info.width, height: info.height);
    }
    final decoded = img.decodeImage(bytes);
    if (decoded == null) throw const FormatException('Unreadable image');
    return (width: decoded.width, height: decoded.height);
  });
}
