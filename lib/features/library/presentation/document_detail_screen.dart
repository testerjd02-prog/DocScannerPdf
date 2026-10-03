import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/database/providers.dart';
import '../../../core/l10n_x.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/blocking_progress.dart';
import '../../../core/widgets/page_image.dart';
import '../../../core/widgets/page_tile.dart';
import '../../export/presentation/export_sheet.dart';
import '../../scan/domain/edit_recipe.dart';
import '../../scan/presentation/page_editor_screen.dart';
import '../../scan/presentation/scan_actions.dart';
import '../../settings/data/settings_providers.dart';
import '../data/library_providers.dart';
import '../domain/library_models.dart';
import 'delete_with_undo.dart';
import 'folder_dialogs.dart';

enum _Menu { rename, duplicate, copyText, delete }

class DocumentDetailScreen extends ConsumerWidget {
  const DocumentDetailScreen({super.key, required this.documentId});
  final String documentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final doc = ref.watch(documentProvider(documentId));
    final pages = ref.watch(pagesProvider(documentId));

    return doc.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.commonGenericError)),
      ),
      data: (d) {
        if (d == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(l10n.detailNotFound)),
          );
        }
        return _DetailBody(document: d, pages: pages.value ?? const []);
      },
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.document, required this.pages});
  final DocumentSummary document;
  final List<PageInfo> pages;

  Future<void> _rename(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final name = await askForName(
      context,
      title: l10n.detailRenameTitle,
      label: l10n.reviewNameLabel,
      initial: document.title,
    );
    if (name != null) {
      await ref.read(libraryRepositoryProvider).rename(document.id, name);
    }
  }

  Future<void> _duplicate(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final router = GoRouter.of(context);
    final progress = BlockingProgress.show(context, l10n.exportBuilding);
    try {
      final id = await ref
          .read(libraryRepositoryProvider)
          .duplicate(
            document.id,
            copyTitle: l10n.documentCopyTitle(document.title),
          );
      progress.close();
      unawaited(router.pushReplacement('/document/$id'));
    } on Object {
      progress.close();
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.commonGenericError)));
      }
    }
  }

  Future<void> _copyText(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final text = await ref
        .read(libraryRepositoryProvider)
        .getOcrText(document.id);
    if (text.trim().isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.detailNoText)));
      return;
    }
    await Clipboard.setData(ClipboardData(text: text));
    messenger.showSnackBar(SnackBar(content: Text(l10n.detailTextCopied)));
  }

  Future<void> _editPage(
    BuildContext context,
    WidgetRef ref,
    PageInfo page,
  ) async {
    final recipe = await context.push<EditRecipe>(
      '/editor',
      extra: PageEditorArgs(
        originalPath: page.originalPath,
        recipe: page.recipe,
      ),
    );
    if (recipe == null || recipe == page.recipe || !context.mounted) return;

    final l10n = context.l10n;
    final progress = BlockingProgress.show(context, l10n.editorSavingPage);
    final repo = ref.read(libraryRepositoryProvider);
    try {
      final out = ref.read(fileStoreProvider).editedPath(document.id, page.id);
      await ref
          .read(imageProcessorProvider)
          .render(
            originalPath: page.originalPath,
            outputPath: out,
            recipe: recipe,
          );
      await repo.updatePageEdit(
        pageId: page.id,
        recipe: recipe,
        editedPath: out,
      );
      progress.close();
      // The picture changed, so its text boxes must be re-read.
      final fresh = (await repo.getPages(document.id))
          .firstWhere((p) => p.id == page.id);
      unawaited(
        ref
            .read(ocrIndexerProvider)
            .indexPage(fresh, ref.read(ocrScriptProvider)),
      );
    } on Object {
      progress.close();
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.commonGenericError)));
      }
    }
  }

  Future<void> _deletePage(
    BuildContext context,
    WidgetRef ref,
    PageInfo page,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await ref.read(libraryRepositoryProvider).deletePage(page.id);
    messenger.showSnackBar(
      SnackBar(
        content: Text(ok ? l10n.detailPageDeleted : l10n.detailLastPage),
      ),
    );
  }

  Future<void> _addTag(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final tag = await askForName(
      context,
      title: l10n.detailAddTag,
      label: l10n.detailTagHint,
    );
    if (tag == null || document.tags.contains(tag)) return;
    await ref.read(libraryRepositoryProvider).setTags(document.id, [
      ...document.tags,
      tag,
    ]);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final indexing = pages.any((p) => p.ocrJson == null);
    final created = DateFormat.yMMMd(l10n.localeName)
        .format(document.createdAt);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          document.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: l10n.detailExport,
            icon: const Icon(Icons.ios_share),
            onPressed: pages.isEmpty
                ? null
                : () => showExportSheet(
                    context,
                    ref,
                    documentId: document.id,
                    title: document.title,
                  ),
          ),
          PopupMenuButton<_Menu>(
            onSelected: (m) async {
              switch (m) {
                case _Menu.rename:
                  await _rename(context, ref);
                case _Menu.duplicate:
                  await _duplicate(context, ref);
                case _Menu.copyText:
                  await _copyText(context, ref);
                case _Menu.delete:
                  final router = GoRouter.of(context);
                  final id = document.id;
                  router.pop();
                  await deleteWithUndo(context, ref, [id]);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _Menu.rename,
                child: Text(l10n.commonRename),
              ),
              PopupMenuItem(
                value: _Menu.duplicate,
                child: Text(l10n.detailDuplicate),
              ),
              PopupMenuItem(
                value: _Menu.copyText,
                child: Text(l10n.detailCopyText),
              ),
              PopupMenuItem(
                value: _Menu.delete,
                child: Text(l10n.commonDelete),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (indexing) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                indexing
                    ? '${l10n.detailCreated(created)} · ${l10n.detailIndexing}'
                    : l10n.detailCreated(created),
                style: context.text.bodySmall?.copyWith(
                  color: context.scheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Wrap(
                spacing: 8,
                children: [
                  for (final tag in document.tags)
                    InputChip(
                      label: Text(tag),
                      onDeleted: () => ref
                          .read(libraryRepositoryProvider)
                          .setTags(
                            document.id,
                            document.tags.where((t) => t != tag).toList(),
                          ),
                    ),
                  ActionChip(
                    avatar: const Icon(Icons.sell_outlined, size: 18),
                    label: Text(l10n.detailAddTag),
                    onPressed: () => _addTag(context, ref),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              padding: const EdgeInsets.only(top: 8, bottom: 96),
              itemCount: pages.length,
              onReorderItem: (oldIndex, newIndex) {
                final ids = pages.map((p) => p.id).toList();
                ids.insert(newIndex, ids.removeAt(oldIndex));
                ref
                    .read(libraryRepositoryProvider)
                    .reorderPages(document.id, ids);
              },
              itemBuilder: (context, i) {
                final page = pages[i];
                return PageTile(
                  key: ValueKey(page.id),
                  index: i,
                  thumbnail: PageImage(path: page.displayPath, cacheWidth: 300),
                  onEdit: () => _editPage(context, ref, page),
                  onDelete: pages.length > 1
                      ? () => _deletePage(context, ref, page)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          unawaited(
            ScanActions.showSourceSheet(
              context,
              ref,
              targetDocumentId: document.id,
            ),
          );
        },
        icon: const Icon(Icons.add_a_photo_outlined),
        label: Text(l10n.detailAddPages),
      ),
    );
  }
}
