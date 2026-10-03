import 'dart:convert';
import 'dart:io';

import 'package:flutter/painting.dart' show Rect;
import 'package:flutter_test/flutter_test.dart';
import 'package:packet_pal/features/export/data/pdf_export_service.dart';
import 'package:packet_pal/features/scan/domain/ocr_result.dart';

import 'support/test_env.dart';

void main() {
  late TestEnv env;
  setUp(() async => env = await TestEnv.create());
  tearDown(() => env.dispose());

  test('builds one PDF page per image, in order', () async {
    final a = env.writeJpeg('a.jpg');
    final b = env.writeJpeg('b.jpg', width: 300, height: 200);

    final bytes = await PdfExportService.buildPdfBytes([
      ExportPage(imagePath: a),
      ExportPage(imagePath: b),
    ], compress: false);
    final text = latin1.decode(bytes);
    expect(text, startsWith('%PDF-'));
    expect(RegExp(r'/Type/Page\b').allMatches(text).length, 2);
  });

  test('writes the file from a background isolate', () async {
    final out = env.files.tempFile('out.pdf');
    await const PdfExportService().buildPdf(
      pages: [ExportPage(imagePath: env.writeJpeg('a.jpg'))],
      outputPath: out,
    );
    expect(latin1.decode(File(out).readAsBytesSync()), startsWith('%PDF-'));
  });

  test('adds an invisible, searchable text layer', () async {
    final image = env.writeJpeg('a.jpg');
    final ocr = const OcrResult(
      imageWidth: 200,
      imageHeight: 300,
      lines: [
        OcrLine(text: 'Hello Landlord', box: Rect.fromLTWH(10, 20, 120, 20)),
      ],
    ).toJson();

    final bytes = await PdfExportService.buildPdfBytes([
      ExportPage(imagePath: image, ocrJson: ocr),
    ], compress: false);
    final text = latin1.decode(bytes);
    // The PDF writer places each word separately.
    expect(text, contains('(Hello)'));
    expect(text, contains('(Landlord)'));
    expect(text, contains('3 Tr'), reason: 'text render mode 3 = invisible');
  });

  test('text layer can be left out', () async {
    final image = env.writeJpeg('a.jpg');
    final ocr = const OcrResult(
      imageWidth: 200,
      imageHeight: 300,
      lines: [OcrLine(text: 'Secret', box: Rect.fromLTWH(0, 0, 50, 10))],
    ).toJson();
    final withLayer = await PdfExportService.buildPdfBytes([
      ExportPage(imagePath: image, ocrJson: ocr),
    ], compress: false);
    expect(latin1.decode(withLayer), contains('(Secret)'));

    final bytes = await PdfExportService.buildPdfBytes(
      [ExportPage(imagePath: image, ocrJson: ocr)],
      includeTextLayer: false,
      compress: false,
    );
    final text = latin1.decode(bytes);
    expect(text, isNot(contains('(Secret)')));
    expect(text, isNot(contains('3 Tr')));
  });
}
