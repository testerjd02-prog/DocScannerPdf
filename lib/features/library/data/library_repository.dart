import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/storage/file_store.dart';
import '../../scan/domain/edit_recipe.dart';
import '../../scan/domain/ocr_result.dart';
import '../domain/library_models.dart';

/// Single access point for documents, pages and folders.
///
/// Every page mutation also touches the owning document's `updatedAt`, which
/// is what makes the reactive document streams refresh.
class LibraryRepository {
  LibraryRepository(this._db, this._files);

  final AppDatabase _db;
  final FileStore _files;
  static const _uuid = Uuid();

  String newId() => _uuid.v4();

  // ---------------------------------------------------------------- reading

  /// Live list of non-trashed documents.
  ///
  /// [query] matches the title, tags and OCR text; every word must match.
  Stream<List<DocumentSummary>> watchDocuments({
    String? folderId,
    String query = '',
    DocSort sort = DocSort.newest,
    int? limit,
  }) {
    final select = _db.select(_db.documents)
      ..where((d) => d.trashedAt.isNull());
    if (folderId != null) {
      select.where((d) => d.folderId.equals(folderId));
    }
    for (final word in query.trim().split(RegExp(r'\s+'))) {
      if (word.isEmpty) continue;
      select.where(
        (d) =>
            d.title.contains(word) |
            d.ocrText.contains(word) |
            d.tags.contains(word),
      );
    }
    select.orderBy([
      (d) => switch (sort) {
        DocSort.newest => OrderingTerm.desc(d.createdAt),
        DocSort.oldest => OrderingTerm.asc(d.createdAt),
        DocSort.nameAsc => OrderingTerm.asc(d.title.lower()),
        DocSort.nameDesc => OrderingTerm.desc(d.title.lower()),
      },
    ]);
    if (limit != null) select.limit(limit);
    return select.watch().asyncMap(_summaries);
  }

  Stream<DocumentSummary?> watchDocument(String id) {
    final select = _db.select(_db.documents)..where((d) => d.id.equals(id));
    return select.watch().asyncMap((rows) async {
      if (rows.isEmpty || rows.first.trashedAt != null) return null;
      return (await _summaries(rows)).first;
    });
  }

  Stream<List<PageInfo>> watchPages(String documentId) {
    final select = _db.select(_db.pages)
      ..where((t) => t.documentId.equals(documentId))
      ..orderBy([(t) => OrderingTerm.asc(t.position)]);
    return select.watch().map((rows) => rows.map(_toPage).toList());
  }

  Future<List<PageInfo>> getPages(String documentId) async {
    final select = _db.select(_db.pages)
      ..where((t) => t.documentId.equals(documentId))
      ..orderBy([(t) => OrderingTerm.asc(t.position)]);
    return (await select.get()).map(_toPage).toList();
  }

  Future<DocumentSummary?> getDocument(String id) async {
    final row = await (_db.select(
      _db.documents,
    )..where((d) => d.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return (await _summaries([row])).first;
  }

  Future<String> getOcrText(String documentId) async {
    final row = await (_db.select(
      _db.documents,
    )..where((d) => d.id.equals(documentId))).getSingleOrNull();
    return row?.ocrText ?? '';
  }

  Future<List<DocumentSummary>> _summaries(List<DocumentRow> rows) async {
    if (rows.isEmpty) return const [];
    final ids = rows.map((r) => r.id).toList();
    final pages =
        await (_db.select(_db.pages)
              ..where((t) => t.documentId.isIn(ids))
              ..orderBy([(t) => OrderingTerm.asc(t.position)]))
            .get();
    final counts = <String, int>{};
    final covers = <String, String>{};
    for (final page in pages) {
      counts[page.documentId] = (counts[page.documentId] ?? 0) + 1;
      covers.putIfAbsent(
        page.documentId,
        () => page.editedPath ?? page.originalPath,
      );
    }
    return [
      for (final r in rows)
        DocumentSummary(
          id: r.id,
          title: r.title,
          createdAt: r.createdAt,
          updatedAt: r.updatedAt,
          folderId: r.folderId,
          tags: r.tags,
          pageCount: counts[r.id] ?? 0,
          coverPath: covers[r.id],
        ),
    ];
  }

  PageInfo _toPage(PageRow r) => PageInfo(
    id: r.id,
    documentId: r.documentId,
    position: r.position,
    originalPath: r.originalPath,
    editedPath: r.editedPath,
    recipe: EditRecipe(
      crop: CropQuad.fromJson(r.cropJson) ?? CropQuad.full,
      filter: ScanFilter.parse(r.filter),
      rotation: r.rotation,
    ),
    ocrJson: r.ocrBlocksJson,
  );

  // ---------------------------------------------------------------- writing

  /// Inserts a document and its pages. Files must already be in place.
  Future<void> insertDocument({
    required String id,
    required String title,
    required List<NewPage> pages,
    String? folderId,
    DateTime? now,
  }) async {
    final stamp = now ?? DateTime.now();
    await _db.transaction(() async {
      await _db
          .into(_db.documents)
          .insert(
            DocumentsCompanion.insert(
              id: id,
              title: title,
              createdAt: stamp,
              updatedAt: stamp,
              folderId: Value(folderId),
            ),
          );
      for (var i = 0; i < pages.length; i++) {
        await _insertPage(id, pages[i], i);
      }
    });
  }

  Future<void> _insertPage(String documentId, NewPage page, int position) => _db
      .into(_db.pages)
      .insert(
        PagesCompanion.insert(
          id: page.id,
          documentId: documentId,
          position: position,
          originalPath: page.originalPath,
          editedPath: Value(page.editedPath),
          filter: Value(page.recipe.filter.name),
          rotation: Value(page.recipe.rotation),
          cropJson: Value(
            page.recipe.crop.isFull ? null : page.recipe.crop.toJson(),
          ),
        ),
      );

  Future<void> _touch(String documentId) =>
      (_db.update(_db.documents)..where((d) => d.id.equals(documentId))).write(
        DocumentsCompanion(updatedAt: Value(DateTime.now())),
      );

  Future<void> rename(String id, String title) async {
    final clean = title.trim();
    if (clean.isEmpty) return;
    await (_db.update(_db.documents)..where((d) => d.id.equals(id))).write(
      DocumentsCompanion(title: Value(clean), updatedAt: Value(DateTime.now())),
    );
  }

  /// Renames only if the title is still [expected]; used so a late OCR-based
  /// suggestion never overwrites a name the user typed in the meantime.
  Future<bool> renameIfUnchanged(
    String id,
    String expected,
    String title,
  ) async {
    final updated =
        await (_db.update(_db.documents)
              ..where((d) => d.id.equals(id) & d.title.equals(expected)))
            .write(DocumentsCompanion(title: Value(title)));
    return updated > 0;
  }

  Future<void> setTags(String id, List<String> tags) async {
    await (_db.update(_db.documents)..where((d) => d.id.equals(id))).write(
      DocumentsCompanion(tags: Value(tags), updatedAt: Value(DateTime.now())),
    );
  }

  Future<void> moveToFolder(Iterable<String> ids, String? folderId) async {
    await (_db.update(_db.documents)..where((d) => d.id.isIn(ids.toList())))
        .write(DocumentsCompanion(folderId: Value(folderId)));
  }

  Future<void> updatePageEdit({
    required String pageId,
    required EditRecipe recipe,
    required String editedPath,
  }) async {
    final old = await (_db.select(
      _db.pages,
    )..where((t) => t.id.equals(pageId))).getSingle();
    await _db.transaction(() async {
      await (_db.update(_db.pages)..where((t) => t.id.equals(pageId))).write(
        PagesCompanion(
          editedPath: Value(editedPath),
          filter: Value(recipe.filter.name),
          rotation: Value(recipe.rotation),
          cropJson: Value(recipe.crop.isFull ? null : recipe.crop.toJson()),
          // The text boxes belong to the old picture; clear until re-indexed.
          ocrBlocksJson: const Value(null),
        ),
      );
      await _touch(old.documentId);
    });
    await _files.deleteFileQuietly(old.editedPath);
  }

  /// Stores OCR for a page and rebuilds the document's searchable text.
  Future<void> savePageOcr(String pageId, OcrResult result) async {
    final page = await (_db.select(
      _db.pages,
    )..where((t) => t.id.equals(pageId))).getSingleOrNull();
    if (page == null) return;
    await _db.transaction(() async {
      await (_db.update(_db.pages)..where((t) => t.id.equals(pageId))).write(
        PagesCompanion(ocrBlocksJson: Value(result.toJson())),
      );
      final all = await getPages(page.documentId);
      final text = all
          .map((pg) => OcrResult.fromJson(pg.ocrJson).text)
          .where((t) => t.isNotEmpty)
          .join('\n\n');
      await (_db.update(_db.documents)
            ..where((d) => d.id.equals(page.documentId)))
          .write(DocumentsCompanion(ocrText: Value(text)));
    });
  }

  Future<void> reorderPages(String documentId, List<String> orderedIds) async {
    await _db.transaction(() async {
      for (var i = 0; i < orderedIds.length; i++) {
        await (_db.update(_db.pages)..where((t) => t.id.equals(orderedIds[i])))
            .write(PagesCompanion(position: Value(i)));
      }
      await _touch(documentId);
    });
  }

  Future<void> addPages(String documentId, List<NewPage> pages) async {
    await _db.transaction(() async {
      final start = (await getPages(documentId)).length;
      for (var i = 0; i < pages.length; i++) {
        await _insertPage(documentId, pages[i], start + i);
      }
      await _touch(documentId);
    });
  }

  /// Removes one page and its files. A document keeps at least one page.
  Future<bool> deletePage(String pageId) async {
    final page = await (_db.select(
      _db.pages,
    )..where((t) => t.id.equals(pageId))).getSingleOrNull();
    if (page == null) return false;
    final siblings = await getPages(page.documentId);
    if (siblings.length <= 1) return false;
    await _db.transaction(() async {
      await (_db.delete(_db.pages)..where((t) => t.id.equals(pageId))).go();
      final remaining = siblings.where((s) => s.id != pageId).toList();
      for (var i = 0; i < remaining.length; i++) {
        await (_db.update(_db.pages)
              ..where((t) => t.id.equals(remaining[i].id)))
            .write(PagesCompanion(position: Value(i)));
      }
      await _touch(page.documentId);
    });
    await _files.deleteFileQuietly(page.originalPath);
    await _files.deleteFileQuietly(page.editedPath);
    return true;
  }

  // ------------------------------------------------------- trash and undo

  Future<void> trash(Iterable<String> ids) async {
    await (_db.update(_db.documents)..where((d) => d.id.isIn(ids.toList())))
        .write(DocumentsCompanion(trashedAt: Value(DateTime.now())));
  }

  /// Undo for [trash].
  Future<void> restore(Iterable<String> ids) async {
    await (_db.update(_db.documents)..where((d) => d.id.isIn(ids.toList())))
        .write(const DocumentsCompanion(trashedAt: Value(null)));
  }

  /// Permanently removes documents trashed before [olderThan], files included.
  Future<int> purgeTrashed({required DateTime olderThan}) async {
    final stale =
        await (_db.select(_db.documents)..where(
              (d) =>
                  d.trashedAt.isNotNull() &
                  d.trashedAt.isSmallerThanValue(olderThan),
            ))
            .get();
    await _purgeRows(stale);
    return stale.length;
  }

  /// Permanently removes these documents, but only if they are still trashed
  /// (so a document restored through Undo is never lost).
  Future<void> purge(Iterable<String> ids) async {
    final rows = await (_db.select(
      _db.documents,
    )..where((d) => d.id.isIn(ids.toList()) & d.trashedAt.isNotNull())).get();
    await _purgeRows(rows);
  }

  Future<void> _purgeRows(List<DocumentRow> rows) async {
    for (final doc in rows) {
      await (_db.delete(_db.documents)..where((d) => d.id.equals(doc.id))).go();
      await _files.deleteDocumentFiles(doc.id);
    }
  }

  // ------------------------------------------------------------ duplicate

  /// Copies a document, its pages and files. Returns the new document id.
  Future<String> duplicate(String id, {required String copyTitle}) async {
    final source = await (_db.select(
      _db.documents,
    )..where((d) => d.id.equals(id))).getSingle();
    final pages =
        await (_db.select(_db.pages)
              ..where((t) => t.documentId.equals(id))
              ..orderBy([(t) => OrderingTerm.asc(t.position)]))
            .get();
    final copyId = newId();
    await _files.documentDir(copyId).create(recursive: true);

    final copies = <PagesCompanion>[];
    for (final page in pages) {
      final pageId = newId();
      final original = _files.originalPath(copyId, pageId);
      await File(page.originalPath).copy(original);
      String? edited;
      if (page.editedPath != null) {
        edited = p.join(
          _files.documentDir(copyId).path,
          '${pageId}_edit_copy.jpg',
        );
        await File(page.editedPath!).copy(edited);
      }
      copies.add(
        PagesCompanion.insert(
          id: pageId,
          documentId: copyId,
          position: page.position,
          originalPath: original,
          editedPath: Value(edited),
          filter: Value(page.filter),
          rotation: Value(page.rotation),
          cropJson: Value(page.cropJson),
          ocrBlocksJson: Value(page.ocrBlocksJson),
        ),
      );
    }
    final now = DateTime.now();
    await _db.transaction(() async {
      await _db
          .into(_db.documents)
          .insert(
            DocumentsCompanion.insert(
              id: copyId,
              title: copyTitle,
              createdAt: now,
              updatedAt: now,
              folderId: Value(source.folderId),
              ocrText: Value(source.ocrText),
              tags: Value(source.tags),
            ),
          );
      for (final c in copies) {
        await _db.into(_db.pages).insert(c);
      }
    });
    return copyId;
  }

  // -------------------------------------------------------------- folders

  Stream<List<FolderInfo>> watchFolders() {
    final select = _db.select(_db.folders)
      ..orderBy([(f) => OrderingTerm.asc(f.name.lower())]);
    return select.watch().map(
      (rows) => [for (final r in rows) FolderInfo(id: r.id, name: r.name)],
    );
  }

  Future<String> createFolder(String name) async {
    final id = _uuid.v4();
    await _db
        .into(_db.folders)
        .insert(FoldersCompanion.insert(id: id, name: name.trim()));
    return id;
  }

  Future<void> renameFolder(String id, String name) =>
      (_db.update(_db.folders)..where((f) => f.id.equals(id))).write(
        FoldersCompanion(name: Value(name.trim())),
      );

  /// Deletes the folder; its documents become unfiled.
  Future<void> deleteFolder(String id) =>
      (_db.delete(_db.folders)..where((f) => f.id.equals(id))).go();
}
