import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n_x.dart';
import '../data/library_providers.dart';
import '../domain/library_models.dart';

Future<String?> _askName(
  BuildContext context, {
  required String title,
  required String label,
  String initial = '',
}) {
  final l10n = context.l10n;
  final controller = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(labelText: label),
        textInputAction: TextInputAction.done,
        onSubmitted: (v) => Navigator.pop(context, v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: Text(l10n.commonSave),
        ),
      ],
    ),
  );
}

/// Asks for a name and returns it trimmed, or null if cancelled or empty.
Future<String?> askForName(
  BuildContext context, {
  required String title,
  required String label,
  String initial = '',
}) async {
  final name = await _askName(
    context,
    title: title,
    label: label,
    initial: initial,
  );
  final trimmed = name?.trim();
  return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
}

Future<void> createFolderDialog(BuildContext context, WidgetRef ref) async {
  final l10n = context.l10n;
  final name = await askForName(
    context,
    title: l10n.folderNew,
    label: l10n.folderNameLabel,
  );
  if (name == null) return;
  await ref.read(libraryRepositoryProvider).createFolder(name);
}

Future<void> showFolderMenu(
  BuildContext context,
  WidgetRef ref,
  FolderInfo folder,
) async {
  final l10n = context.l10n;
  final action = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(l10n.commonRename),
            onTap: () => Navigator.pop(context, 'rename'),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: Text(l10n.commonDelete),
            onTap: () => Navigator.pop(context, 'delete'),
          ),
        ],
      ),
    ),
  );
  if (action == null || !context.mounted) return;
  final repo = ref.read(libraryRepositoryProvider);
  if (action == 'rename') {
    final name = await askForName(
      context,
      title: l10n.folderRenameTitle,
      label: l10n.folderNameLabel,
      initial: folder.name,
    );
    if (name != null) await repo.renameFolder(folder.id, name);
  } else {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.folderDeleteTitle),
        content: Text(l10n.folderDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (ok == true) {
      if (ref.read(libraryFilterProvider).folderId == folder.id) {
        ref.read(libraryFilterProvider.notifier).setFolder(null);
      }
      await repo.deleteFolder(folder.id);
    }
  }
}

/// Lets the user pick a destination folder. Returns the folder id, an empty
/// string for "no folder", or null if cancelled.
Future<String?> pickFolder(BuildContext context, WidgetRef ref) {
  final l10n = context.l10n;
  final folders = ref.read(foldersProvider).value ?? const <FolderInfo>[];
  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            title: Text(
              l10n.folderMoveTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.folder_off_outlined),
            title: Text(l10n.folderNone),
            onTap: () => Navigator.pop(context, ''),
          ),
          for (final f in folders)
            ListTile(
              leading: const Icon(Icons.folder_outlined),
              title: Text(f.name),
              onTap: () => Navigator.pop(context, f.id),
            ),
        ],
      ),
    ),
  );
}
