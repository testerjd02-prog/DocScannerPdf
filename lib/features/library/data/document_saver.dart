import 'dart:io';

import '../../../core/storage/file_store.dart';
import '../../scan/data/image_processor.dart';
import '../../scan/domain/draft_page.dart';
import '../domain/library_models.dart';
import 'library_repository.dart';

/// Turns scan-session drafts into a saved document.
///
/// Saving is deliberately quick: originals are copied, edits are rendered in
/// parallel isolates, and OCR is left to run afterwards.
class DocumentSaver {
  DocumentSaver(this._repo, this._files, this._processor);

  final LibraryRepository _repo;
  final FileStore _files;
  final ImageProcessor _processor;

  Future<NewPage> _persistPage(String documentId, DraftPage draft) async {
    final pageId = _repo.newId();
    final original = _files.originalPath(documentId, pageId);
    await File(draft.originalPath).copy(original);

    String? edited;
    if (!draft.recipe.isIdentity) {
      edited = _files.editedPath(documentId, pageId);
      await _processor.render(
        originalPath: original,
        outputPath: edited,
        recipe: draft.recipe,
      );
    }
    return NewPage(
      id: pageId,
      originalPath: original,
      editedPath: edited,
      recipe: draft.recipe,
    );
  }

  Future<List<NewPage>> _persistAll(
    String documentId,
    List<DraftPage> drafts,
  ) async {
    await _files.documentDir(documentId).create(recursive: true);
    final out = <NewPage>[];
    // Small batches keep several cores busy without holding many decoded
    // images in memory at once.
    const batch = 3;
    for (var i = 0; i < drafts.length; i += batch) {
      final slice = drafts.skip(i).take(batch);
      out.addAll(
        await Future.wait([for (final d in slice) _persistPage(documentId, d)]),
      );
    }
    return out;
  }

  /// Creates a new document. Returns its id.
  Future<String> saveNew({
    required List<DraftPage> drafts,
    required String title,
    String? folderId,
  }) async {
    final id = _repo.newId();
    try {
      final pages = await _persistAll(id, drafts);
      await _repo.insertDocument(
        id: id,
        title: title,
        pages: pages,
        folderId: folderId,
      );
    } on Object {
      await _files.deleteDocumentFiles(id);
      rethrow;
    }
    return id;
  }

  /// Appends pages to an existing document.
  Future<void> appendTo(String documentId, List<DraftPage> drafts) async {
    final pages = await _persistAll(documentId, drafts);
    await _repo.addPages(documentId, pages);
  }
}
