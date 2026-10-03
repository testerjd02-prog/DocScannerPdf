import 'package:flutter/material.dart';

import '../l10n_x.dart';
import '../theme/app_theme.dart';

/// One row of a reorderable page list: thumbnail, label, edit, delete and a
/// drag handle. Used by the scan review and the document detail screens.
class PageTile extends StatelessWidget {
  const PageTile({
    super.key,
    required this.index,
    required this.thumbnail,
    required this.onEdit,
    required this.onDelete,
  });

  /// Zero-based position in the list.
  final int index;
  final Widget thumbnail;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final number = index + 1;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(width: 64, height: 88, child: thumbnail),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.reviewPageLabel(number),
                  style: context.text.titleMedium,
                ),
              ),
              IconButton(
                tooltip: l10n.reviewEditPage(number),
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: l10n.reviewDeletePage(number),
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
              ReorderableDragStartListener(
                index: index,
                child: Semantics(
                  label: l10n.reviewReorderHandle(number),
                  child: const SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(Icons.drag_handle),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
