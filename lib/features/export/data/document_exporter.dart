import 'dart:io';

import 'package:path/path.dart' as p;

import '../../../core/storage/file_store.dart';
import '../../library/data/library_repository.dart';
import 'pdf_export_service.dart';

/// Produces shareable files for a document inside the temp area. The files
/// are removed by the next launch's temp sweep.
class DocumentExporter {
  DocumentExporter(this._repo, this._files, this._pdf);

  final LibraryRepository _repo;
  final FileStore _files;
  final PdfExportService _pdf;

  /// Turns a title into a safe file name stem.
  static String fileStem(String title) {
    final cleaned = title
        .replaceAll(RegExp(r'[\\/:*?"<>|\x00-\x1F]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (cleaned.isEmpty) return 'document';
    return cleaned.length > 80 ? cleaned.substring(0, 80).trim() : cleaned;
  }

  Future<String> exportPdf(String documentId, String title) async {
    final pages = await _repo.getPages(documentId);
    final out = _files.tempFile('${fileStem(title)}.pdf');
    return _pdf.buildPdf(
      pages: [
        for (final page in pages)
          ExportPage(imagePath: page.displayPath, ocrJson: page.ocrJson),
      ],
      outputPath: out,
    );
  }

  Future<List<String>> exportImages(String documentId, String title) async {
    final pages = await _repo.getPages(documentId);
    final stem = fileStem(title);
    final out = <String>[];
    for (final page in pages) {
      final suffix = pages.length == 1 ? '' : '_${page.position + 1}';
      final dest = p.join(_files.tempRoot.path, '$stem$suffix.jpg');
      await File(page.displayPath).copy(dest);
      out.add(dest);
    }
    return out;
  }
}
