import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n_x.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/blocking_progress.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/page_tile.dart';
import '../../library/data/library_providers.dart';
import '../../library/presentation/naming_labels.dart';
import '../../settings/data/settings_providers.dart';
import '../domain/edit_recipe.dart';
import 'draft_thumb.dart';
import 'page_editor_screen.dart';
import 'scan_actions.dart';
import 'scan_session_controller.dart';

/// Last step before saving: name, reorder, delete, edit, add more pages.
class ScanReviewScreen extends ConsumerStatefulWidget {
  const ScanReviewScreen({super.key});

  @override
  ConsumerState<ScanReviewScreen> createState() => _ScanReviewScreenState();
}

class _ScanReviewScreenState extends ConsumerState<ScanReviewScreen> {
  final _title = TextEditingController();
  String? _provisionalTitle;
  bool _saving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // A readable placeholder (e.g. "Document - Oct 3, 2026"). It is replaced by
    // an OCR-based suggestion after saving unless the user types their own.
    _provisionalTitle ??= smartNamerFor(context.l10n)
        .suggest('', DateTime.now());
    if (_title.text.isEmpty) _title.text = _provisionalTitle!;
  }

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<bool> _confirmDiscard() async {
    final l10n = context.l10n;
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.reviewDiscardTitle),
        content: Text(l10n.reviewDiscardBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.reviewKeep),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.reviewDiscard),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  Future<void> _editPage(int index) async {
    final session = ref.read(scanSessionProvider);
    final page = session.pages[index];
    final recipe = await context.push<EditRecipe>(
      '/editor',
      extra: PageEditorArgs(
        originalPath: page.originalPath,
        recipe: page.recipe,
        onApplyFilterToAll: ref
            .read(scanSessionProvider.notifier)
            .applyFilterToAll,
      ),
    );
    if (recipe != null) {
      ref.read(scanSessionProvider.notifier).updateRecipe(page.id, recipe);
    }
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final session = ref.read(scanSessionProvider);
    if (session.isEmpty || _saving) return;

    setState(() => _saving = true);
    final progress = BlockingProgress.show(context, l10n.reviewSaving);
    try {
      final saver = ref.read(documentSaverProvider);
      final indexer = ref.read(ocrIndexerProvider);
      final script = ref.read(ocrScriptProvider);
      final namer = smartNamerFor(l10n);
      final target = session.targetDocumentId;
      final String documentId;
      String? autoTitle;

      if (target != null) {
        await saver.appendTo(target, session.pages);
        documentId = target;
      } else {
        final typed = _title.text.trim();
        final title = typed.isEmpty ? _provisionalTitle! : typed;
        documentId = await saver.saveNew(drafts: session.pages, title: title);
        if (title == _provisionalTitle) autoTitle = title;
      }

      // OCR (and the smart title) continue in the background.
      unawaited(
        indexer.indexDocument(
          documentId,
          script,
          autoTitle: autoTitle,
          namer: namer,
        ),
      );
      await ref.read(scanSessionProvider.notifier).discard();
      progress.close();
      // Land on the library with the document on top, so Back works naturally.
      router.go('/library');
      unawaited(router.push('/document/$documentId'));
    } on Object {
      progress.close();
      messenger.showSnackBar(SnackBar(content: Text(l10n.reviewSaveFailed)));
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final session = ref.watch(scanSessionProvider);
    final isAppend = session.targetDocumentId != null;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final router = GoRouter.of(context);
        if (session.isEmpty || await _confirmDiscard()) {
          await ref.read(scanSessionProvider.notifier).discard();
          if (router.canPop()) {
            router.pop();
          } else {
            router.go('/');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.reviewTitle),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  l10n.reviewPagesCount(session.pages.length),
                  style: context.text.labelLarge,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            if (!isAppend)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  controller: _title,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(labelText: l10n.reviewNameLabel),
                ),
              ),
            Expanded(
              child: session.isEmpty
                  ? EmptyState(
                      icon: Icons.note_add_outlined,
                      title: l10n.reviewEmpty,
                      body: '',
                    )
                  : ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      itemCount: session.pages.length,
                      onReorderItem: ref
                          .read(scanSessionProvider.notifier)
                          .reorder,
                      itemBuilder: (context, i) {
                        final page = session.pages[i];
                        return PageTile(
                          key: ValueKey(page.id),
                          index: i,
                          thumbnail: DraftThumb(page: page),
                          onEdit: () => _editPage(i),
                          onDelete: () => ref
                              .read(scanSessionProvider.notifier)
                              .remove(page.id),
                        );
                      },
                    ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _saving
                            ? null
                            : () => ScanActions.showSourceSheet(
                                context,
                                ref,
                                continuing: true,
                              ),
                        icon: const Icon(Icons.add_a_photo_outlined),
                        label: Text(l10n.reviewAddPages),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _saving || session.isEmpty ? null : _save,
                        icon: const Icon(Icons.check),
                        label: Text(l10n.reviewSave),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
