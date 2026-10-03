import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:packet_pal/features/library/domain/library_models.dart';
import 'package:packet_pal/features/library/presentation/library_screen.dart';
import 'package:packet_pal/features/scan/domain/edit_recipe.dart';

import 'support/pump_app.dart';
import 'support/test_env.dart';

void main() {
  late TestEnv env;

  setUp(() async => env = await TestEnv.create());
  tearDown(() => env.dispose());

  Future<void> addDoc(WidgetTester tester, String title) =>
      tester.runAsync(() async {
        final id = env.repo.newId();
        final pageId = env.repo.newId();
        await env.files.documentDir(id).create(recursive: true);
        final path = env.files.originalPath(id, pageId);
        File(env.writeJpeg('$pageId.jpg')).copySync(path);
        await env.repo.insertDocument(
          id: id,
          title: title,
          pages: [
            NewPage(
              id: pageId,
              originalPath: path,
              editedPath: null,
              recipe: EditRecipe.none,
            ),
          ],
        );
      });

  testWidgets('shows a friendly empty state', (tester) async {
    await pumpApp(tester, const LibraryScreen(), env: env);
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('No documents yet'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('lists documents and filters them by search', (tester) async {
    await addDoc(tester, 'Bank Statement - Mar 2026');
    await addDoc(tester, 'Passport');
    await pumpApp(tester, const LibraryScreen(), env: env);
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pump();

    expect(find.text('Bank Statement - Mar 2026'), findsOneWidget);
    expect(find.text('Passport'), findsOneWidget);

    await tester.tap(find.byTooltip('Search names and text inside scans'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'passp');
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pump();

    expect(find.text('Passport'), findsOneWidget);
    expect(find.text('Bank Statement - Mar 2026'), findsNothing);

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pump();
    expect(find.text('No matches'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('long press selects and shows the selection toolbar', (
    tester,
  ) async {
    await addDoc(tester, 'Lease');
    await pumpApp(tester, const LibraryScreen(), env: env);
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pump();

    await tester.longPress(find.text('Lease'));
    await tester.pump();

    expect(find.text('1 selected'), findsOneWidget);
    expect(find.byTooltip('Delete'), findsOneWidget);
    await disposeApp(tester);
  });
}
