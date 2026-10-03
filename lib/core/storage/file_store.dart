import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Owns every file location the app writes to.
///
/// Documents live in the app-private support directory (never in a shared
/// gallery or cloud folder). Scratch files live in the temp directory and are
/// swept on launch.
class FileStore {
  FileStore({required this.docsRoot, required this.tempRoot});

  final Directory docsRoot;
  final Directory tempRoot;

  static Future<FileStore> create() async {
    final support = await getApplicationSupportDirectory();
    final temp = await getTemporaryDirectory();
    final store = FileStore(
      docsRoot: Directory(p.join(support.path, 'documents')),
      tempRoot: Directory(p.join(temp.path, 'packetpal')),
    );
    await store.docsRoot.create(recursive: true);
    await store.tempRoot.create(recursive: true);
    await store._excludeFromBackup(store.docsRoot);
    return store;
  }

  static const _storageChannel = MethodChannel('app.packetpal/storage');

  /// iOS backs up Application Support to iCloud by default. Documents must
  /// stay on the device unless the user opts in, so opt this folder out.
  /// (Android backup is disabled in the manifest.)
  Future<void> _excludeFromBackup(Directory dir) async {
    if (!Platform.isIOS) return;
    try {
      await _storageChannel.invokeMethod<bool>('excludeFromBackup', dir.path);
    } on PlatformException {
      // Leave as is; the flag is a privacy hardening, not a requirement.
    } on MissingPluginException {
      // Channel not registered (tests, other platforms).
    }
  }

  Directory documentDir(String documentId) =>
      Directory(p.join(docsRoot.path, documentId));

  String originalPath(String documentId, String pageId) =>
      p.join(documentDir(documentId).path, '${pageId}_original.jpg');

  /// Edited renders get a fresh name per render so Flutter's image cache never
  /// serves a stale picture.
  String editedPath(String documentId, String pageId) => p.join(
    documentDir(documentId).path,
    '${pageId}_edit_${DateTime.now().microsecondsSinceEpoch}.jpg',
  );

  Directory sessionDir(String sessionId) =>
      Directory(p.join(tempRoot.path, 'session_$sessionId'));

  String tempFile(String name) => p.join(tempRoot.path, name);

  Future<void> deleteDocumentFiles(String documentId) async {
    final dir = documentDir(documentId);
    if (await dir.exists()) await dir.delete(recursive: true);
  }

  Future<void> deleteFileQuietly(String? path) async {
    if (path == null) return;
    try {
      final f = File(path);
      if (await f.exists()) await f.delete();
    } on FileSystemException {
      // Best effort: a leftover scratch file is swept on next launch.
    }
  }

  /// Removes everything in the temp area (scan sessions, export scratch).
  Future<void> clearTemp() async {
    if (!await tempRoot.exists()) return;
    await for (final entity in tempRoot.list()) {
      try {
        await entity.delete(recursive: true);
      } on FileSystemException {
        // Ignore files still in use.
      }
    }
  }
}
