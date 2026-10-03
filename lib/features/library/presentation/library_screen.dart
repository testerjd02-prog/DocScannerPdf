import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n_x.dart';
import '../../../core/widgets/empty_state.dart';
import '../data/library_providers.dart';
import '../domain/library_models.dart';
import 'delete_with_undo.dart';
import 'document_tile.dart';
import 'folder_dialogs.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  bool _searching = false;
  final _search = TextEditingController();
  final Set<String> _selected = {};

  bool get _selecting => _selected.isNotEmpty;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _toggle(String id) => setState(() {
    if (!_selected.remove(id)) _selected.add(id);
  });

  void _stopSearch() {
    _search.clear();
    ref.read(libraryFilterProvider.notifier).setQuery('');
    setState(() => _searching = false);
  }

  Future<void> _moveSelected() async {
    final target = await pickFolder(context, ref);
    if (target == null || !mounted) return;
    await ref
        .read(libraryRepositoryProvider)
        .moveToFolder(_selected, target.isEmpty ? null : target);
    if (mounted) setState(_selected.clear);
  }

  Future<void> _deleteSelected() async {
    final ids = _selected.toList();
    setState(_selected.clear);
    await deleteWithUndo(context, ref, ids);
  }

  PreferredSizeWidget _appBar() {
    final l10n = context.l10n;
    if (_selecting) {
      return AppBar(
        leading: IconButton(
          tooltip: l10n.selectionClear,
          icon: const Icon(Icons.close),
          onPressed: () => setState(_selected.clear),
        ),
        title: Text(l10n.selectedCount(_selected.length)),
        actions: [
          IconButton(
            tooltip: l10n.folderMoveTitle,
            icon: const Icon(Icons.drive_file_move_outline),
            onPressed: _moveSelected,
          ),
          IconButton(
            tooltip: l10n.commonDelete,
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteSelected,
          ),
        ],
      );
    }
    if (_searching) {
      return AppBar(
        leading: IconButton(
          tooltip: l10n.commonBack,
          icon: const Icon(Icons.arrow_back),
          onPressed: _stopSearch,
        ),
        title: TextField(
          controller: _search,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.searchHint,
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          onChanged: ref.read(libraryFilterProvider.notifier).setQuery,
        ),
        actions: [
          IconButton(
            tooltip: l10n.searchClear,
            icon: const Icon(Icons.clear),
            onPressed: () {
              _search.clear();
              ref.read(libraryFilterProvider.notifier).setQuery('');
            },
          ),
        ],
      );
    }
    final mode = ref.watch(libraryViewModeProvider);
    final sort = ref.watch(libraryFilterProvider).sort;
    final sortNames = {
      DocSort.newest: l10n.sortNewest,
      DocSort.oldest: l10n.sortOldest,
      DocSort.nameAsc: l10n.sortNameAsc,
      DocSort.nameDesc: l10n.sortNameDesc,
    };
    return AppBar(
      title: Text(l10n.libraryTitle),
      actions: [
        IconButton(
          tooltip: l10n.searchHint,
          icon: const Icon(Icons.search),
          onPressed: () => setState(() => _searching = true),
        ),
        PopupMenuButton<DocSort>(
          tooltip: l10n.sortMenuLabel,
          icon: const Icon(Icons.sort),
          initialValue: sort,
          onSelected: ref.read(libraryFilterProvider.notifier).setSort,
          itemBuilder: (context) => [
            for (final s in DocSort.values)
              CheckedPopupMenuItem(
                value: s,
                checked: s == sort,
                child: Text(sortNames[s]!),
              ),
          ],
        ),
        IconButton(
          tooltip: mode == LibraryViewMode.grid ? l10n.viewList : l10n.viewGrid,
          icon: Icon(
            mode == LibraryViewMode.grid ? Icons.view_list : Icons.grid_view,
          ),
          onPressed: ref.read(libraryViewModeProvider.notifier).toggle,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final filter = ref.watch(libraryFilterProvider);
    final docs = ref.watch(documentsProvider);
    final mode = ref.watch(libraryViewModeProvider);

    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          const _FolderBar(),
          Expanded(
            child: docs.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(l10n.commonGenericError)),
              data: (items) {
                if (items.isEmpty) {
                  final searching = filter.query.trim().isNotEmpty;
                  return EmptyState(
                    icon: searching
                        ? Icons.search_off
                        : Icons.folder_open_outlined,
                    title: searching
                        ? l10n.libraryNoResultsTitle
                        : l10n.libraryEmptyTitle,
                    body: searching
                        ? l10n.libraryNoResultsBody(filter.query.trim())
                        : l10n.libraryEmptyBody,
                  );
                }
                Widget tile(DocumentSummary d, bool grid) => DocumentTile(
                  document: d,
                  grid: grid,
                  selected: _selected.contains(d.id),
                  selecting: _selecting,
                  onTap: () => _selecting
                      ? _toggle(d.id)
                      : context.push('/document/${d.id}'),
                  onLongPress: () => _toggle(d.id),
                );
                if (mode == LibraryViewMode.list) {
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 100),
                    itemCount: items.length,
                    itemBuilder: (context, i) => tile(items[i], false),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 100),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 0.72,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, i) => tile(items[i], true),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FolderBar extends ConsumerWidget {
  const _FolderBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final folders = ref.watch(foldersProvider).value ?? const <FolderInfo>[];
    final selectedId = ref.watch(libraryFilterProvider).folderId;
    final controller = ref.read(libraryFilterProvider.notifier);

    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(l10n.foldersAll),
              selected: selectedId == null,
              onSelected: (_) => controller.setFolder(null),
            ),
          ),
          for (final f in folders)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onLongPress: () => showFolderMenu(context, ref, f),
                child: ChoiceChip(
                  label: Text(f.name),
                  selected: selectedId == f.id,
                  onSelected: (_) => controller.setFolder(f.id),
                ),
              ),
            ),
          ActionChip(
            avatar: const Icon(Icons.add, size: 18),
            label: Text(l10n.folderNew),
            onPressed: () => createFolderDialog(context, ref),
          ),
        ],
      ),
    );
  }
}
