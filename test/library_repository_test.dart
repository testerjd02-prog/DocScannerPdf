import 'dart:io';

import 'package:flutter/painting.dart' show Rect;
import 'package:flutter_test/flutter_test.dart';
import 'package:packet_pal/features/library/domain/library_models.dart';
import 'package:packet_pal/features/scan/domain/edit_recipe.dart';
import 'package:packet_pal/features/scan/domain/ocr_result.dart';

import 'support/test_env.dart';

void main() {
  late TestEnv env;
  setUp(() async => env = await TestEnv.create());
  tearDown(() => env.dispose());

  Future<String> addDoc(String title, {int pages = 1, String? folderId}) async {
    final id = env.repo.newId();
    await env.files.documentDir(id).create(recursive: true);
    final list = <NewPage>[];
    for (var i = 0; i < pages; i++) {
      final pageId = env.repo.newId();
      final path = env.files.originalPath(id, pageId);
      File(env.writeJpeg('src_$pageId.jpg')).copySync(path);
      list.add(
        NewPage(
          id: pageId,
          originalPath: path,
          editedPath: null,
          recipe: EditRecipe.none,
        ),
      );
    }
    await env.repo.insertDocument(
      id: id,
      title: title,
      pages: list,
      folderId: folderId,
    );
    return id;
  }

  OcrResult ocr(String text) => OcrResult(
    imageWidth: 10,
    imageHeight: 10,
    lines: [OcrLine(text: text, box: const Rect.fromLTWH(0, 0, 1, 1))],
  );

  test('lists documents with page count and cover', () async {
    final id = await addDoc('Lease', pages: 3);
    final docs = await env.repo.watchDocuments().first;
    expect(docs.single.id, id);
    expect(docs.single.pageCount, 3);
    expect(docs.single.coverPath, isNotNull);
  });

  test('searches title, tags and OCR text; every word must match', () async {
    final a = await addDoc('Bank Statement - Mar 2026');
    final b = await addDoc('Passport');
    final pageA = (await env.repo.getPages(a)).single;
    await env.repo.savePageOcr(
      pageA.id,
      ocr('Account number 12345 Springfield'),
    );
    await env.repo.setTags(b, ['travel']);

    Future<List<String>> search(String q) async =>
        (await env.repo.watchDocuments(query: q).first)
            .map((d) => d.id)
            .toList();

    expect(await search('springfield'), [a]);
    expect(await search('bank mar'), [a]);
    expect(await search('bank passport'), isEmpty);
    expect(await search('TRAVEL'), [b]);
    expect(await search('100%'), isEmpty, reason: 'wildcards are literal');
  });

  test('sorts by name and by date', () async {
    await addDoc('b');
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await addDoc('A');
    final byName = await env.repo.watchDocuments(sort: DocSort.nameAsc).first;
    expect(byName.map((d) => d.title), ['A', 'b']);
    final newest = await env.repo.watchDocuments(sort: DocSort.newest).first;
    expect(newest.first.title, 'A');
  });

  test('trash hides, restore brings back, purge deletes files', () async {
    final id = await addDoc('Temp');
    final dir = env.files.documentDir(id);
    expect(dir.existsSync(), isTrue);

    await env.repo.trash([id]);
    expect(await env.repo.watchDocuments().first, isEmpty);
    await env.repo.restore([id]);
    expect(await env.repo.watchDocuments().first, hasLength(1));

    await env.repo.trash([id]);
    await env.repo.purge([id]);
    expect(dir.existsSync(), isFalse);
    expect(await env.repo.getDocument(id), isNull);
  });

  test('purge leaves a restored document alone', () async {
    final id = await addDoc('Keep me');
    await env.repo.trash([id]);
    await env.repo.restore([id]);
    await env.repo.purge([id]);
    expect(await env.repo.getDocument(id), isNotNull);
  });

  test('reorders pages and keeps positions contiguous after delete', () async {
    final id = await addDoc('Doc', pages: 3);
    final pages = await env.repo.getPages(id);
    await env.repo.reorderPages(id, [pages[2].id, pages[0].id, pages[1].id]);
    var now = await env.repo.getPages(id);
    expect(now.map((p) => p.id), [pages[2].id, pages[0].id, pages[1].id]);

    expect(await env.repo.deletePage(pages[0].id), isTrue);
    now = await env.repo.getPages(id);
    expect(now.map((p) => p.position), [0, 1]);
    expect(File(pages[0].originalPath).existsSync(), isFalse);
  });

  test('the last page cannot be deleted', () async {
    final id = await addDoc('One', pages: 1);
    final page = (await env.repo.getPages(id)).single;
    expect(await env.repo.deletePage(page.id), isFalse);
  });

  test('editing a page keeps the original and clears stale OCR', () async {
    final id = await addDoc('Doc');
    final page = (await env.repo.getPages(id)).single;
    await env.repo.savePageOcr(page.id, ocr('old'));
    final edited = env.files.editedPath(id, page.id);
    File(env.writeJpeg('e.jpg')).copySync(edited);

    const recipe = EditRecipe(filter: ScanFilter.blackWhite, rotation: 90);
    await env.repo.updatePageEdit(
      pageId: page.id,
      recipe: recipe,
      editedPath: edited,
    );

    final updated = (await env.repo.getPages(id)).single;
    expect(updated.editedPath, edited);
    expect(updated.recipe, recipe);
    expect(updated.ocrJson, isNull);
    expect(File(page.originalPath).existsSync(), isTrue);
    expect(updated.displayPath, edited);
  });

  test('duplicate copies pages and files independently', () async {
    final id = await addDoc('Original', pages: 2);
    final copyId = await env.repo.duplicate(id, copyTitle: 'Original (copy)');
    final copy = await env.repo.getPages(copyId);
    final source = await env.repo.getPages(id);
    expect(copy, hasLength(2));
    expect(copy.first.originalPath, isNot(source.first.originalPath));
    expect(File(copy.first.originalPath).existsSync(), isTrue);

    await env.repo.trash([id]);
    await env.repo.purge([id]);
    expect(File(copy.first.originalPath).existsSync(), isTrue);
  });

  test(
    'rename ignores blanks; renameIfUnchanged respects user edits',
    () async {
      final id = await addDoc('Placeholder');
      await env.repo.rename(id, '   ');
      expect((await env.repo.getDocument(id))!.title, 'Placeholder');

      expect(
        await env.repo.renameIfUnchanged(id, 'Placeholder', 'Auto'),
        isTrue,
      );
      expect(
        await env.repo.renameIfUnchanged(id, 'Placeholder', 'Late'),
        isFalse,
      );
      expect((await env.repo.getDocument(id))!.title, 'Auto');
    },
  );

  test('deleting a folder unfiles its documents', () async {
    final folder = await env.repo.createFolder('Taxes');
    final id = await addDoc('Form', folderId: folder);
    await env.repo.deleteFolder(folder);
    expect((await env.repo.getDocument(id))!.folderId, isNull);
  });

  test('document OCR text joins all pages', () async {
    final id = await addDoc('Doc', pages: 2);
    final pages = await env.repo.getPages(id);
    await env.repo.savePageOcr(pages[0].id, ocr('first'));
    await env.repo.savePageOcr(pages[1].id, ocr('second'));
    expect(await env.repo.getOcrText(id), 'first\n\nsecond');
  });
}
