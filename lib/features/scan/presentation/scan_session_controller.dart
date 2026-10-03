import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/providers.dart';
import '../domain/draft_page.dart';
import '../domain/edit_recipe.dart';

class ScanSessionState {
  const ScanSessionState({
    this.sessionId = '',
    this.pages = const [],
    this.targetDocumentId,
  });

  final String sessionId;
  final List<DraftPage> pages;

  /// Set when the session appends pages to an existing document instead of
  /// creating a new one.
  final String? targetDocumentId;

  bool get isEmpty => pages.isEmpty;

  ScanSessionState copyWith({
    List<DraftPage>? pages,
    String? targetDocumentId,
  }) => ScanSessionState(
    sessionId: sessionId,
    pages: pages ?? this.pages,
    targetDocumentId: targetDocumentId ?? this.targetDocumentId,
  );
}

/// Holds the pages of the scan in progress. Files live in a temp session
/// directory that is deleted on [discard] and after saving.
class ScanSessionController extends Notifier<ScanSessionState> {
  static const _uuid = Uuid();

  @override
  ScanSessionState build() => ScanSessionState(sessionId: _uuid.v4());

  String get sessionId => state.sessionId;

  /// Starts a fresh session. [targetDocumentId] appends to that document.
  void begin({String? targetDocumentId}) {
    state = ScanSessionState(
      sessionId: _uuid.v4(),
      targetDocumentId: targetDocumentId,
    );
  }

  /// Adds captured files and returns the index of the first new page.
  int addPaths(List<String> paths) {
    final first = state.pages.length;
    state = state.copyWith(
      pages: [
        ...state.pages,
        for (final path in paths) DraftPage(id: _uuid.v4(), originalPath: path),
      ],
    );
    return first;
  }

  void updateRecipe(String pageId, EditRecipe recipe) {
    state = state.copyWith(
      pages: [
        for (final p in state.pages)
          if (p.id == pageId) p.copyWith(recipe: recipe) else p,
      ],
    );
  }

  /// Applies one filter to every page (the common "make them all B&W" case).
  void applyFilterToAll(ScanFilter filter) {
    state = state.copyWith(
      pages: [
        for (final p in state.pages)
          p.copyWith(recipe: p.recipe.copyWith(filter: filter)),
      ],
    );
  }

  void remove(String pageId) {
    final removed = state.pages.where((p) => p.id == pageId).toList();
    state = state.copyWith(
      pages: state.pages.where((p) => p.id != pageId).toList(),
    );
    for (final p in removed) {
      ref.read(fileStoreProvider).deleteFileQuietly(p.originalPath);
    }
  }

  void reorder(int oldIndex, int newIndex) {
    final list = [...state.pages];
    list.insert(newIndex, list.removeAt(oldIndex));
    state = state.copyWith(pages: list);
  }

  /// Drops the session and deletes its temp files.
  Future<void> discard() async {
    final id = state.sessionId;
    state = ScanSessionState(sessionId: _uuid.v4());
    final dir = ref.read(fileStoreProvider).sessionDir(id);
    if (await dir.exists()) await dir.delete(recursive: true);
  }
}

final scanSessionProvider =
    NotifierProvider<ScanSessionController, ScanSessionState>(
      ScanSessionController.new,
    );
