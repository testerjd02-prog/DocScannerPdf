import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n_x.dart';
import '../../../core/widgets/blocking_progress.dart';
import '../../library/data/library_providers.dart';
import '../../settings/data/settings_providers.dart';
import '../../settings/data/settings_repository.dart';
import '../data/document_capture_service.dart';
import '../domain/edit_recipe.dart';
import 'page_editor_screen.dart';
import 'scan_session_controller.dart';

enum ScanSource { camera, photos, files }

/// Orchestrates "get pages → crop each → review", shared by every entry point
/// (center button, quick scan, add pages to a document).
abstract final class ScanActions {
  /// Shows the source picker used by the center scan button.
  static Future<void> showSourceSheet(
    BuildContext context,
    WidgetRef ref, {
    String? targetDocumentId,
    bool continuing = false,
  }) async {
    final l10n = context.l10n;
    final source = await showModalBottomSheet<ScanSource>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(
                l10n.scanAddTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            _tile(
              context,
              Icons.photo_camera_outlined,
              l10n.scanFromCamera,
              l10n.scanFromCameraSubtitle,
              ScanSource.camera,
            ),
            _tile(
              context,
              Icons.photo_library_outlined,
              l10n.scanFromPhotos,
              l10n.scanFromPhotosSubtitle,
              ScanSource.photos,
            ),
            _tile(
              context,
              Icons.folder_open_outlined,
              l10n.scanFromFiles,
              l10n.scanFromFilesSubtitle,
              ScanSource.files,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (source == null || !context.mounted) return;
    await start(
      context,
      ref,
      source,
      targetDocumentId: targetDocumentId,
      continuing: continuing,
    );
  }

  static Widget _tile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    ScanSource value,
  ) => ListTile(
    minTileHeight: 56,
    leading: Icon(icon),
    title: Text(title),
    subtitle: Text(subtitle),
    onTap: () => Navigator.of(context).pop(value),
  );

  /// Captures pages from [source], walks the user through a manual crop for
  /// every new page, then opens the review screen.
  ///
  /// [continuing] means a session is already open (we came from the review
  /// screen), so new pages are appended and no new screen is pushed.
  static Future<void> start(
    BuildContext context,
    WidgetRef ref,
    ScanSource source, {
    String? targetDocumentId,
    bool continuing = false,
  }) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final session = ref.read(scanSessionProvider.notifier);

    if (source == ScanSource.camera &&
        !await _confirmCameraRationale(context, ref)) {
      return;
    }
    if (!context.mounted) return;

    if (!continuing) session.begin(targetDocumentId: targetDocumentId);
    final sessionId = session.sessionId;
    final capture = ref.read(captureServiceProvider);

    final progress = BlockingProgress.show(context, l10n.scanImporting);
    List<String> paths;
    try {
      paths = switch (source) {
        ScanSource.camera => await capture.scan(sessionId: sessionId),
        ScanSource.photos => await capture.importPhotos(sessionId: sessionId),
        ScanSource.files => await capture.importFiles(sessionId: sessionId),
      };
    } on CaptureException catch (e) {
      progress.close();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.scanFailed(e.message))),
      );
      if (!continuing) await session.discard();
      return;
    } on Object catch (e) {
      progress.close();
      messenger.showSnackBar(SnackBar(content: Text(l10n.scanFailed('$e'))));
      if (!continuing) await session.discard();
      return;
    }
    progress.close();

    if (paths.isEmpty) {
      if (!continuing && ref.read(scanSessionProvider).isEmpty) {
        await session.discard();
      }
      return;
    }

    final first = session.addPaths(paths);
    final total = ref.read(scanSessionProvider).pages.length;

    // Manual crop after every capture. Backing out of one page's crop stops
    // the sequence but keeps all pages.
    for (var i = first; i < total; i++) {
      if (!context.mounted) return;
      final page = ref.read(scanSessionProvider).pages[i];
      final recipe = await context.push<EditRecipe>(
        '/editor',
        extra: PageEditorArgs(
          originalPath: page.originalPath,
          recipe: page.recipe,
          startInCrop: true,
          title: l10n.cropPageOf(i - first + 1, total - first),
        ),
      );
      if (recipe == null) break;
      session.updateRecipe(page.id, recipe);
    }

    if (!continuing) unawaited(router.push('/scan/review'));
  }

  static Future<bool> _confirmCameraRationale(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final settings = ref.read(settingsRepositoryProvider);
    if (await settings.get(SettingsRepository.keyCameraRationaleSeen) != null) {
      return true;
    }
    if (!context.mounted) return false;
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.photo_camera_outlined),
        title: Text(l10n.scanRationaleTitle),
        content: Text(l10n.scanRationaleBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.scanRationaleContinue),
          ),
        ],
      ),
    );
    if (ok != true) return false;
    await settings.set(SettingsRepository.keyCameraRationaleSeen, '1');
    return true;
  }
}
