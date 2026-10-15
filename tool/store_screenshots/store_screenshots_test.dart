// Renders the real app screens to PNG for the store listing.
//
//   SHOTS_SRC=<dir with documents> SHOTS_OUT=<dir> \
//     flutter test tool/store_screenshots/store_screenshots_test.dart
//
// Not part of the normal test suite (it lives outside test/).
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:packet_pal/app.dart';
import 'package:packet_pal/core/database/providers.dart';
import 'package:packet_pal/core/router/app_router.dart';
import 'package:packet_pal/features/scan/domain/edit_recipe.dart';
import 'package:packet_pal/features/scan/domain/ocr_result.dart';
import 'package:packet_pal/features/scan/presentation/page_editor_screen.dart';
import 'package:packet_pal/features/library/domain/library_models.dart';
import 'package:packet_pal/features/settings/data/settings_providers.dart';

import '../../test/support/test_env.dart';

final _src = Platform.environment['SHOTS_SRC']!;
final _out = Platform.environment['SHOTS_OUT']!;

class _Profile {
  const _Profile(this.name, this.width, this.height, this.ratio);
  final String name;
  final double width, height, ratio;
}

const _profiles = [
  _Profile('phone', 360, 800, 3.0), // 1080 x 2400
  _Profile('tablet', 800, 1280, 2.0), // 1600 x 2560
];

Future<void> _loadFonts() async {
  const dir = '/opt/flutter/bin/cache/artifacts/material_fonts';
  Future<ByteData> bytes(String f) async =>
      ByteData.view((await File('$dir/$f').readAsBytes()).buffer);
  final roboto = FontLoader('Roboto');
  for (final f in ['Roboto-Light.ttf', 'Roboto-Regular.ttf', 'Roboto-Medium.ttf', 'Roboto-Bold.ttf']) {
    roboto.addFont(bytes(f));
  }
  await roboto.load();
  final icons = FontLoader('MaterialIcons')..addFont(bytes('MaterialIcons-Regular.otf'));
  await icons.load();
}

OcrResult _ocr(List<String> lines) => OcrResult(
      imageWidth: 850,
      imageHeight: 1100,
      lines: [
        for (var i = 0; i < lines.length; i++)
          OcrLine(text: lines[i], box: Rect.fromLTWH(56, 100.0 + i * 40, 600, 30)),
      ],
    );

class _Seeded {
  _Seeded(this.rentalId);
  final String rentalId;
}

Future<_Seeded> _seed(TestEnv env) async {
  final repo = env.repo;
  Future<String> add(
    String title,
    List<String> files, {
    required int daysAgo,
    String? folder,
    List<String> ocr = const [],
    List<String> tags = const [],
  }) async {
    final id = repo.newId();
    await env.files.documentDir(id).create(recursive: true);
    final pages = <NewPage>[];
    for (final f in files) {
      final pageId = repo.newId();
      final path = env.files.originalPath(id, pageId);
      File('$_src/$f.jpg').copySync(path);
      pages.add(NewPage(id: pageId, originalPath: path, editedPath: null, recipe: EditRecipe.none));
    }
    await repo.insertDocument(
      id: id,
      title: title,
      pages: pages,
      now: DateTime(2026, 10, 14, 9).subtract(Duration(days: daysAgo)),
    );
    if (folder != null) await repo.moveToFolder([id], folder);
    if (tags.isNotEmpty) await repo.setTags(id, tags);
    for (final p in pages) {
      await repo.savePageOcr(p.id, _ocr(ocr));
    }
    return id;
  }

  final rental = await repo.createFolder('Rental');
  final loans = await repo.createFolder('Loans');
  final travel = await repo.createFolder('Travel');
  final work = await repo.createFolder('Work');

  final rentalId = await add('Apartment Papers', ['passport', 'license', 'paystub'],
      daysAgo: 0,
      folder: rental,
      tags: ['landlord'],
      ocr: ['Rental application', 'Alex Morgan', '42 Maple Street Springfield']);
  await add('Bank Statement - Mar 2026', ['bank'],
      daysAgo: 1,
      folder: rental,
      ocr: ['FIRST NATIONAL BANK', 'Account holder Alex Morgan', '14 Oak Avenue Springfield']);
  await add('Lease Agreement', ['lease'],
      daysAgo: 3, folder: rental, ocr: ['Residential lease agreement', '42 Maple Street Springfield']);
  await add('Pay Stub - Feb 2026', ['paystub'], daysAgo: 5, folder: loans, ocr: ['Earnings statement', 'Brightline Studio']);
  await add('Passport', ['passport'], daysAgo: 8, folder: travel, ocr: ['Passport', 'Morgan Alex Jordan']);
  await add('Utility Bill - Mar 2026', ['bill'],
      daysAgo: 9, folder: rental, ocr: ['Electric service bill', '42 Maple Street Springfield']);
  await add('Offer Letter', ['offer'],
      daysAgo: 12, folder: work, ocr: ['Brightline Studio', '14 Oak Avenue Springfield', 'Offer of employment']);
  await add("Driver's License", ['license'], daysAgo: 20, folder: travel, ocr: ["Driver's license", 'Morgan Alex']);
  await add('Tax Document - 2025', ['tax'], daysAgo: 30, folder: loans, ocr: ['Form W-2', 'Wage and tax statement']);
  return _Seeded(rentalId);
}

/// Lets real async work (file reads, image decode, isolates) finish, then
/// waits until no spinner is left on screen.
Future<void> _wait(WidgetTester tester, {int ms = 400, int loops = 6}) async {
  for (var i = 0; i < loops; i++) {
    await tester.runAsync(() => Future<void>.delayed(Duration(milliseconds: ms)));
    await tester.pump(const Duration(milliseconds: 150));
  }
  for (var i = 0; i < 20 && find.byType(CircularProgressIndicator).evaluate().isNotEmpty; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 500)));
    await tester.pump(const Duration(milliseconds: 150));
  }
  // Wait until the image cache stops growing, i.e. every visible picture has
  // been read and decoded.
  var last = -1;
  var stable = 0;
  for (var i = 0; i < 30 && stable < 3; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 400)));
    await tester.pump(const Duration(milliseconds: 150));
    final size = PaintingBinding.instance.imageCache.currentSizeBytes;
    stable = size == last ? stable + 1 : 0;
    last = size;
  }
}

Future<void> _snap(WidgetTester tester, GlobalKey key, _Profile p, String name) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(key));
  final bytes = await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: p.ratio);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  });
  File('$_out/${p.name}_$name.png')
    ..createSync(recursive: true)
    ..writeAsBytesSync(bytes!);
}

void main() {
  setUpAll(() async {
    WidgetsApp.debugAllowBannerOverride = false;
    await _loadFonts();
    await initializeDateFormatting('en');
  });

  for (final p in _profiles) {
    for (final dark in [false, true]) {
      testWidgets('${p.name} ${dark ? 'dark' : 'light'} screens', (tester) async {
        // The test binding draws shadows as solid black by default.
        debugDisableShadows = false;
        tester.view
          ..devicePixelRatio = p.ratio
          ..physicalSize = Size(p.width * p.ratio, p.height * p.ratio)
          ..padding = FakeViewPadding(top: 28 * p.ratio, bottom: 16 * p.ratio)
          ..viewPadding = FakeViewPadding(top: 28 * p.ratio, bottom: 16 * p.ratio);
        addTearDown(tester.view.reset);

        final env = (await tester.runAsync(TestEnv.create))!;
        final seeded = (await tester.runAsync(() => _seed(env)))!;
        final quad = jsonDecode(File('$_src/desk_quad.json').readAsStringSync()) as Map<String, dynamic>;
        final deskQuad = CropQuad([
          for (final c in quad['quad'] as List<dynamic>)
            Offset((c[0] as num).toDouble(), (c[1] as num).toDouble()),
        ]);

        final key = GlobalKey();
        await tester.pumpWidget(
          RepaintBoundary(
            key: key,
            child: ProviderScope(
              overrides: [
                appDatabaseProvider.overrideWithValue(env.db),
                fileStoreProvider.overrideWithValue(env.files),
                initialSettingsProvider.overrideWithValue({
                  'onboarding_done': '1',
                  'theme_mode': dark ? 'dark' : 'light',
                }),
              ],
              child: const PacketPalApp(),
            ),
          ),
        );
        await _wait(tester);
        final router = ProviderScope.containerOf(tester.element(find.byType(MaterialApp)))
            .read(routerProvider);
        Future<void> go(String path) async {
          router.go(path);
          await _wait(tester);
        }

        if (dark) {
          // Dark-mode set: library list inside a folder.
          await go('/library');
          await tester.tap(find.byTooltip('List view'));
          await _wait(tester, ms: 250);
          await tester.tap(find.text('Rental'));
          await _wait(tester);
          await _snap(tester, key, p, 'library_list_dark');
          await go('/settings');
          await _snap(tester, key, p, 'settings_dark');
        } else {
          await go('/library');
          await _snap(tester, key, p, 'library_grid');

          // Search inside scans (matches OCR text, not titles).
          await tester.tap(find.byTooltip('Search names and text inside scans'));
          await tester.pump();
          await tester.enterText(find.byType(TextField), 'springfield');
          await _wait(tester, ms: 400);
          await _snap(tester, key, p, 'search');
          await go('/library');

          // Manual crop on a photo of a page.
          unawaited_(router.push<EditRecipe>(
            '/editor',
            extra: PageEditorArgs(
              originalPath: '$_src/desk_small.jpg',
              recipe: EditRecipe(crop: deskQuad),
              startInCrop: true,
              title: 'Crop page 1 of 2',
            ),
          ));
          await _wait(tester, ms: 600, loops: 4);
          await _wait(tester, ms: 600, loops: 3);
          await _snap(tester, key, p, 'crop');
          router.pop();
          await _wait(tester, ms: 250);

          // Filters (black & white), rendered by the real isolate pipeline.
          unawaited_(router.push<EditRecipe>(
            '/editor',
            extra: PageEditorArgs(
              originalPath: '$_src/desk.jpg',
              recipe: EditRecipe(crop: deskQuad, filter: ScanFilter.blackWhite),
            ),
          ));
          await _wait(tester, ms: 800, loops: 8);
          await _snap(tester, key, p, 'filters');
          router.pop();
          await _wait(tester, ms: 250);

          // Document detail, then the export sheet.
          unawaited_(router.push('/document/${seeded.rentalId}'));
          await _wait(tester);
          await _snap(tester, key, p, 'detail');
          // The share sheet sits at the bottom, so capture this one on a
          // shorter phone to keep the whole sheet inside the store frame.
          if (p.name == 'phone') {
            tester.view.physicalSize = Size(p.width * p.ratio, 600 * p.ratio);
            await tester.pump();
          }
          await tester.tap(find.byTooltip('Export'));
          await _wait(tester, ms: 300);
          await _snap(tester, key, p, 'export');
          await tester.tapAt(const Offset(10, 10));
          await _wait(tester, ms: 250);
          tester.view.physicalSize = Size(p.width * p.ratio, p.height * p.ratio);
          await tester.pump();

          await go('/settings');
          await _snap(tester, key, p, 'settings');
        }

        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(milliseconds: 100));
        await tester.runAsync(env.dispose);
        debugDisableShadows = true;
      });
    }
  }
}

void unawaited_(Future<Object?> f) {}
