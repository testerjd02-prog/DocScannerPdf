import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/file_store.dart';
import 'app_database.dart';

/// Overridden in `main()` once the database is open.
final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('appDatabaseProvider must be overridden'),
);

/// Overridden in `main()` once directories exist.
final fileStoreProvider = Provider<FileStore>(
  (ref) => throw UnimplementedError('fileStoreProvider must be overridden'),
);
