import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/database/app_database.dart';
import 'core/database/providers.dart';
import 'core/storage/file_store.dart';
import 'features/library/data/library_repository.dart';
import 'features/settings/data/settings_providers.dart';
import 'features/settings/data/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final files = await FileStore.create();
  final db = AppDatabase.open();
  final settings = await SettingsRepository(db).loadAll();

  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        fileStoreProvider.overrideWithValue(files),
        initialSettingsProvider.overrideWithValue(settings),
      ],
      child: const PacketPalApp(),
    ),
  );

  // Housekeeping after the first frame so it never delays launch: sweep
  // scratch files and permanently remove documents left in the trash.
  unawaited(_housekeeping(db, files));
}

Future<void> _housekeeping(AppDatabase db, FileStore files) async {
  await files.clearTemp();
  await LibraryRepository(db, files).purgeTrashed(olderThan: DateTime.now());
}
