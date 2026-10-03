import 'dart:convert';
import 'dart:ui';

/// One recognised line of text and where it sits in the image (pixels).
class OcrLine {
  const OcrLine({required this.text, required this.box});
  final String text;
  final Rect box;

  Map<String, Object> toMap() => {
    't': text,
    'l': box.left.round(),
    'tp': box.top.round(),
    'w': box.width.round(),
    'h': box.height.round(),
  };

  factory OcrLine.fromMap(Map<String, dynamic> m) => OcrLine(
    text: m['t'] as String,
    box: Rect.fromLTWH(
      (m['l'] as num).toDouble(),
      (m['tp'] as num).toDouble(),
      (m['w'] as num).toDouble(),
      (m['h'] as num).toDouble(),
    ),
  );
}

/// OCR output for one page image. Kept as plain data so it can cross isolates
/// and be stored as JSON next to the page.
class OcrResult {
  const OcrResult({
    required this.imageWidth,
    required this.imageHeight,
    required this.lines,
  });

  static const OcrResult empty = OcrResult(
    imageWidth: 0,
    imageHeight: 0,
    lines: [],
  );

  final int imageWidth;
  final int imageHeight;
  final List<OcrLine> lines;

  bool get isEmpty => lines.isEmpty;
  String get text => lines.map((l) => l.text).join('\n');

  String toJson() => jsonEncode({
    'w': imageWidth,
    'h': imageHeight,
    'lines': [for (final l in lines) l.toMap()],
  });

  static OcrResult fromJson(String? source) {
    if (source == null || source.isEmpty) return empty;
    final m = jsonDecode(source) as Map<String, dynamic>;
    return OcrResult(
      imageWidth: (m['w'] as num).toInt(),
      imageHeight: (m['h'] as num).toInt(),
      lines: [
        for (final l in (m['lines'] as List<dynamic>))
          OcrLine.fromMap(l as Map<String, dynamic>),
      ],
    );
  }
}

/// Scripts the on-device recogniser can be switched to.
enum OcrScript { latin, devanagari, chinese, japanese, korean }
