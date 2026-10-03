import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/providers.dart';
import '../../scan/data/document_capture_service.dart';
import '../../scan/data/image_processor.dart';
import '../../scan/data/ocr_service.dart';
import '../domain/library_models.dart';
import 'document_saver.dart';
import 'library_repository.dart';
import 'ocr_indexer.dart';

final imageProcessorProvider = Provider<ImageProcessor>(
  (ref) => const ImageProcessor(),
);

final ocrEngineProvider = Provider<OcrEngine>(
  (ref) => MlKitOcrEngine(ref.watch(imageProcessorProvider)),
);

final captureServiceProvider = Provider<DocumentCaptureService>(
  (ref) => PlatformCaptureService(
    ref.watch(fileStoreProvider),
    ref.watch(imageProcessorProvider),
  ),
);

final libraryRepositoryProvider = Provider<LibraryRepository>(
  (ref) => LibraryRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(fileStoreProvider),
  ),
);

final ocrIndexerProvider = Provider<OcrIndexer>(
  (ref) => OcrIndexer(
    ref.watch(libraryRepositoryProvider),
    ref.watch(ocrEngineProvider),
  ),
);

final documentSaverProvider = Provider<DocumentSaver>(
  (ref) => DocumentSaver(
    ref.watch(libraryRepositoryProvider),
    ref.watch(fileStoreProvider),
    ref.watch(imageProcessorProvider),
  ),
);

// ----------------------------------------------------------- UI-facing state

enum LibraryViewMode { grid, list }

class LibraryFilter {
  const LibraryFilter({
    this.query = '',
    this.sort = DocSort.newest,
    this.folderId,
  });

  final String query;
  final DocSort sort;
  final String? folderId;

  LibraryFilter copyWith({
    String? query,
    DocSort? sort,
    String? folderId,
    bool clearFolder = false,
  }) => LibraryFilter(
    query: query ?? this.query,
    sort: sort ?? this.sort,
    folderId: clearFolder ? null : (folderId ?? this.folderId),
  );

  @override
  bool operator ==(Object other) =>
      other is LibraryFilter &&
      other.query == query &&
      other.sort == sort &&
      other.folderId == folderId;

  @override
  int get hashCode => Object.hash(query, sort, folderId);
}

class LibraryFilterController extends Notifier<LibraryFilter> {
  @override
  LibraryFilter build() => const LibraryFilter();

  void setQuery(String q) => state = state.copyWith(query: q);
  void setSort(DocSort s) => state = state.copyWith(sort: s);
  void setFolder(String? id) => state = id == null
      ? state.copyWith(clearFolder: true)
      : state.copyWith(folderId: id);
}

final libraryFilterProvider =
    NotifierProvider<LibraryFilterController, LibraryFilter>(
      LibraryFilterController.new,
    );

class LibraryViewModeController extends Notifier<LibraryViewMode> {
  @override
  LibraryViewMode build() => LibraryViewMode.grid;
  void toggle() => state = state == LibraryViewMode.grid
      ? LibraryViewMode.list
      : LibraryViewMode.grid;
}

final libraryViewModeProvider =
    NotifierProvider<LibraryViewModeController, LibraryViewMode>(
      LibraryViewModeController.new,
    );

final documentsProvider = StreamProvider<List<DocumentSummary>>((ref) {
  final filter = ref.watch(libraryFilterProvider);
  return ref
      .watch(libraryRepositoryProvider)
      .watchDocuments(
        folderId: filter.folderId,
        query: filter.query,
        sort: filter.sort,
      );
});

final recentDocumentsProvider = StreamProvider<List<DocumentSummary>>(
  (ref) => ref.watch(libraryRepositoryProvider).watchDocuments(limit: 10),
);

final foldersProvider = StreamProvider<List<FolderInfo>>(
  (ref) => ref.watch(libraryRepositoryProvider).watchFolders(),
);

final documentProvider = StreamProvider.family<DocumentSummary?, String>(
  (ref, id) => ref.watch(libraryRepositoryProvider).watchDocument(id),
);

final pagesProvider = StreamProvider.family<List<PageInfo>, String>(
  (ref, id) => ref.watch(libraryRepositoryProvider).watchPages(id),
);
