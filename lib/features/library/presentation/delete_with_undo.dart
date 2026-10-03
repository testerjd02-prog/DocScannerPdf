import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n_x.dart';
import '../data/library_providers.dart';

/// Moves documents to the trash and offers Undo. When the snackbar goes away
/// without Undo, the files are permanently removed from the device.
Future<void> deleteWithUndo(
  BuildContext context,
  WidgetRef ref,
  List<String> ids,
) async {
  if (ids.isEmpty) return;
  final repo = ref.read(libraryRepositoryProvider);
  final messenger = ScaffoldMessenger.of(context);
  final l10n = context.l10n;
  await repo.trash(ids);
  messenger.clearSnackBars();
  final controller = messenger.showSnackBar(
    SnackBar(
      content: Text(l10n.documentsDeleted(ids.length)),
      duration: const Duration(seconds: 6),
      action: SnackBarAction(
        label: l10n.commonUndo,
        onPressed: () => repo.restore(ids),
      ),
    ),
  );
  final reason = await controller.closed;
  if (reason != SnackBarClosedReason.action) {
    await repo.purge(ids);
  }
}
