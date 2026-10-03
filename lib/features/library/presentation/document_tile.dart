import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n_x.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/page_image.dart';
import '../domain/library_models.dart';

/// A document as a grid card or a list row, with selection support.
class DocumentTile extends StatelessWidget {
  const DocumentTile({
    super.key,
    required this.document,
    required this.grid,
    required this.selected,
    required this.selecting,
    required this.onTap,
    required this.onLongPress,
  });

  final DocumentSummary document;
  final bool grid;
  final bool selected;
  final bool selecting;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final date = DateFormat.yMMMd(l10n.localeName).format(document.createdAt);
    final subtitle = '${l10n.reviewPagesCount(document.pageCount)} · $date';
    final semantics = l10n.documentSemantics(
      document.title,
      document.pageCount,
    );

    final thumb = Stack(
      fit: StackFit.expand,
      children: [
        PageImage(path: document.coverPath),
        if (selecting)
          Positioned(
            top: 6,
            left: 6,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: selected
                  ? context.scheme.primary
                  : context.scheme.surface.withValues(alpha: 0.85),
              child: Icon(
                selected ? Icons.check : Icons.circle_outlined,
                size: 18,
                color: selected
                    ? context.scheme.onPrimary
                    : context.scheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );

    final child = grid
        ? Card(
            clipBehavior: Clip.antiAlias,
            color: selected ? context.scheme.secondaryContainer : null,
            child: InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: thumb),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.titleSmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.bodySmall?.copyWith(
                            color: context.scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Card(
            clipBehavior: Clip.antiAlias,
            color: selected ? context.scheme.secondaryContainer : null,
            child: InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(width: 56, height: 72, child: thumb),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            document.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.titleSmall,
                          ),
                          Text(
                            subtitle,
                            style: context.text.bodySmall?.copyWith(
                              color: context.scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

    return Semantics(
      label: semantics,
      selected: selected,
      button: true,
      excludeSemantics: true,
      onTap: onTap,
      onLongPress: onLongPress,
      child: child,
    );
  }
}
