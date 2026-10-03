import 'dart:io';

import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:image/image.dart' as img;
import 'package:packet_pal/core/database/app_database.dart';
import 'package:packet_pal/core/database/providers.dart';
import 'package:packet_pal/core/storage/file_store.dart';
import 'package:packet_pal/features/library/data/library_repository.dart';
import 'package:packet_pal/features/settings/data/settings_providers.dart';
import 'package:path/path.dart' as p;

/// In-memory database plus a throw-away file area for tests.
class TestEnv {
  TestEnv._(this.db, this.files, this.root);

  final AppDatabase db;
  final FileStore files;
  final Directory root;

  late final LibraryRepository repo = LibraryRepository(db, files);

  static Future<TestEnv> create() async {
    final root = await Directory.systemTemp.createTemp('packetpal_test_');
    final files = FileStore(
      docsRoot: Directory(p.join(root.path, 'docs'))..createSync(),
      tempRoot: Directory(p.join(root.path, 'tmp'))..createSync(),
    );
    return TestEnv._(AppDatabase.memory(), files, root);
  }

  List<Override> get overrides => [
    appDatabaseProvider.overrideWithValue(db),
    fileStoreProvider.overrideWithValue(files),
    initialSettingsProvider.overrideWithValue(const {}),
  ];

  /// Writes a plain JPEG and returns its path.
  String writeJpeg(String name, {int width = 200, int height = 300}) {
    final image = img.Image(width: width, height: height);
    img.fill(image, color: img.ColorRgb8(250, 250, 250));
    final path = p.join(root.path, name);
    File(path).writeAsBytesSync(img.encodeJpg(image));
    return path;
  }

  Future<void> dispose() async {
    await db.close();
    if (root.existsSync()) await root.delete(recursive: true);
  }
}
