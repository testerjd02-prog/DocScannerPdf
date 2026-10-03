import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../scan/domain/ocr_result.dart';

/// One page to place in the PDF.
class ExportPage {
  const ExportPage({required this.imagePath, this.ocrJson});
  final String imagePath;
  final String? ocrJson;
}

/// Builds PDFs from page images.
///
/// Pages are full-bleed images with an invisible text layer on top, so the
/// result is searchable and its text can be copied, with no visible change.
class PdfExportService {
  const PdfExportService();

  /// Width of every page in PDF points (A4 portrait width).
  static const double pageWidth = 595.28;

  /// Writes the PDF and returns [outputPath]. Runs in a background isolate.
  Future<String> buildPdf({
    required List<ExportPage> pages,
    required String outputPath,
    bool includeTextLayer = true,
  }) => Isolate.run(() async {
    final bytes = await buildPdfBytes(
      pages,
      includeTextLayer: includeTextLayer,
    );
    File(outputPath).writeAsBytesSync(bytes);
    return outputPath;
  });

  /// Core builder, exposed for tests.
  static Future<Uint8List> buildPdfBytes(
    List<ExportPage> pages, {
    bool includeTextLayer = true,
    bool compress = true,
  }) {
    final doc = pw.Document(
      compress: compress,
      // Object streams (1.5) hide structure from simple inspection; only
      // used when compressing.
      version: compress ? PdfVersion.pdf_1_5 : PdfVersion.pdf_1_4,
      creator: 'PacketPal',
    );
    final font = pw.Font.helvetica();

    for (final page in pages) {
      final image = pw.MemoryImage(File(page.imagePath).readAsBytesSync());
      final aspect = image.height! / image.width!;
      final format = PdfPageFormat(pageWidth, pageWidth * aspect, marginAll: 0);
      final ocr = includeTextLayer
          ? OcrResult.fromJson(page.ocrJson)
          : OcrResult.empty;
      final scale = ocr.imageWidth > 0 ? pageWidth / ocr.imageWidth : 1.0;

      doc.addPage(
        pw.Page(
          pageFormat: format,
          margin: pw.EdgeInsets.zero,
          build: (context) => pw.Stack(
            children: [
              pw.Positioned.fill(child: pw.Image(image, fit: pw.BoxFit.fill)),
              for (final line in ocr.lines)
                if (_printable(line.text).trim().isNotEmpty)
                  pw.Positioned(
                    left: line.box.left * scale,
                    top: line.box.top * scale,
                    child: pw.Text(
                      _printable(line.text),
                      style: pw.TextStyle(
                        font: font,
                        fontSize: (line.box.height * scale * 0.85).clamp(2, 72),
                        renderingMode: PdfTextRenderingMode.invisible,
                      ),
                    ),
                  ),
            ],
          ),
        ),
      );
    }
    return doc.save();
  }

  /// The built-in PDF font covers Latin-1 only. Other characters are dropped
  /// from the invisible layer (they remain in the image and in app search).
  static String _printable(String text) => String.fromCharCodes(
    text.runes.map((r) => (r >= 32 && r <= 255) ? r : 32),
  );
}
