import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/l10n_x.dart';
import '../../../core/widgets/blocking_progress.dart';
import '../data/export_providers.dart';

enum _Format { pdf, images }

/// Bottom sheet that exports a document and hands it to the share sheet.
Future<void> showExportSheet(
  BuildContext context,
  WidgetRef ref, {
  required String documentId,
  required String title,
}) async {
  final l10n = context.l10n;
  final format = await showModalBottomSheet<_Format>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              l10n.exportTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ListTile(
            minTileHeight: 56,
            leading: const Icon(Icons.picture_as_pdf_outlined),
            title: Text(l10n.exportPdf),
            subtitle: Text(l10n.exportPdfSubtitle),
            onTap: () => Navigator.pop(context, _Format.pdf),
          ),
          ListTile(
            minTileHeight: 56,
            leading: const Icon(Icons.image_outlined),
            title: Text(l10n.exportImages),
            subtitle: Text(l10n.exportImagesSubtitle),
            onTap: () => Navigator.pop(context, _Format.images),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
  if (format == null || !context.mounted) return;

  final messenger = ScaffoldMessenger.of(context);
  final box = context.findRenderObject() as RenderBox?;
  final origin = box == null ? null : box.localToGlobal(Offset.zero) & box.size;
  final progress = BlockingProgress.show(context, l10n.exportBuilding);
  final exporter = ref.read(documentExporterProvider);
  try {
    final paths = switch (format) {
      _Format.pdf => [await exporter.exportPdf(documentId, title)],
      _Format.images => await exporter.exportImages(documentId, title),
    };
    progress.close();
    await SharePlus.instance.share(
      ShareParams(
        files: [for (final path in paths) XFile(path)],
        subject: l10n.exportShareSubject(title),
        sharePositionOrigin: origin,
      ),
    );
  } on Object {
    progress.close();
    messenger.showSnackBar(SnackBar(content: Text(l10n.exportFailed)));
  }
}
