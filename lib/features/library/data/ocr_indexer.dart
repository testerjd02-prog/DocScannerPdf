import '../../scan/data/ocr_service.dart';
import '../../scan/domain/ocr_result.dart';
import '../domain/library_models.dart';
import '../domain/smart_naming.dart';
import 'library_repository.dart';

/// Runs OCR over saved pages and keeps the searchable text up to date.
class OcrIndexer {
  OcrIndexer(this._repo, this._engine);

  final LibraryRepository _repo;
  final OcrEngine _engine;

  /// Recognises one page image and stores the result. A failure is not fatal:
  /// a page without OCR is still a perfectly good scan.
  Future<void> indexPage(PageInfo page, OcrScript script) async {
    try {
      final result = await _engine.recognize(page.displayPath, script);
      await _repo.savePageOcr(page.id, result);
    } on Object {
      // Record "no text" so the UI stops showing progress; the page is
      // re-read whenever it is edited.
      await _repo.savePageOcr(page.id, OcrResult.empty);
    }
  }

  /// OCRs every page lacking text, then, if the title is still the automatic
  /// placeholder ([autoTitle]), replaces it with a smart suggestion.
  Future<void> indexDocument(
    String documentId,
    OcrScript script, {
    String? autoTitle,
    SmartNamer? namer,
  }) async {
    final pages = await _repo.getPages(documentId);
    for (final page in pages) {
      if (page.ocrJson == null) await indexPage(page, script);
    }
    if (autoTitle == null || namer == null) return;
    final text = await _repo.getOcrText(documentId);
    if (text.trim().isEmpty) return;
    final sample = text.length > 4000 ? text.substring(0, 4000) : text;
    final suggestion = namer.suggest(sample, DateTime.now());
    if (suggestion != autoTitle) {
      await _repo.renameIfUnchanged(documentId, autoTitle, suggestion);
    }
  }
}
