import 'package:flutter/painting.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../domain/ocr_result.dart';
import '../data/image_processor.dart';

/// On-device text recognition. Nothing leaves the phone.
abstract interface class OcrEngine {
  Future<OcrResult> recognize(String imagePath, OcrScript script);
}

class MlKitOcrEngine implements OcrEngine {
  MlKitOcrEngine([this._processor = const ImageProcessor()]);

  final ImageProcessor _processor;

  static TextRecognitionScript _map(OcrScript s) => switch (s) {
    OcrScript.latin => TextRecognitionScript.latin,
    OcrScript.devanagari => TextRecognitionScript.devanagiri,
    OcrScript.chinese => TextRecognitionScript.chinese,
    OcrScript.japanese => TextRecognitionScript.japanese,
    OcrScript.korean => TextRecognitionScript.korean,
  };

  @override
  Future<OcrResult> recognize(String imagePath, OcrScript script) async {
    final size = await _processor.sizeOf(imagePath);
    final recognizer = TextRecognizer(script: _map(script));
    try {
      final recognised = await recognizer.processImage(
        InputImage.fromFilePath(imagePath),
      );
      final lines = <OcrLine>[];
      for (final block in recognised.blocks) {
        for (final line in block.lines) {
          final text = line.text.trim();
          if (text.isEmpty) continue;
          final Rect box = line.boundingBox;
          lines.add(OcrLine(text: text, box: box));
        }
      }
      return OcrResult(
        imageWidth: size.width,
        imageHeight: size.height,
        lines: lines,
      );
    } finally {
      await recognizer.close();
    }
  }
}
