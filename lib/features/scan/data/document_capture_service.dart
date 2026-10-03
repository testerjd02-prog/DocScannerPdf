import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart'
    as mlkit;
import 'package:path/path.dart' as p;
import 'package:pdfx/pdfx.dart';
import 'package:uuid/uuid.dart';

import '../../../core/storage/file_store.dart';
import 'image_processor.dart';

/// Thrown for failures worth showing to the user (as opposed to cancellation,
/// which is reported as an empty result).
class CaptureException implements Exception {
  const CaptureException(this.message);
  final String message;
  @override
  String toString() => 'CaptureException: $message';
}

/// Source of page images for a scan session.
///
/// Every returned path is an upright JPEG inside the session directory, so the
/// caller owns the file and the plugins' caches can be cleared freely.
abstract interface class DocumentCaptureService {
  /// Opens the native scanner (edge detection, multi-page).
  Future<List<String>> scan({required String sessionId});

  /// Imports from the photo library.
  Future<List<String>> importPhotos({required String sessionId});

  /// Imports images and PDFs from the file system.
  Future<List<String>> importFiles({required String sessionId});
}

class PlatformCaptureService implements DocumentCaptureService {
  PlatformCaptureService(
    this._files, [
    this._processor = const ImageProcessor(),
  ]);

  final FileStore _files;
  final ImageProcessor _processor;
  static const _uuid = Uuid();

  static const _imageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'webp',
    'heic',
    'heif',
  ];

  Future<Directory> _session(String sessionId) async {
    final dir = _files.sessionDir(sessionId);
    await dir.create(recursive: true);
    return dir;
  }

  @override
  Future<List<String>> scan({required String sessionId}) async {
    final dir = await _session(sessionId);
    final List<String> raw;
    try {
      raw = Platform.isAndroid ? await _scanAndroid() : await _scanIos();
    } on CunningDocumentScannerException catch (e) {
      throw CaptureException(e.message);
    }
    // The plugin cache is outside our control; take our own copies at once.
    final out = <String>[];
    for (final path in raw) {
      final dest = p.join(dir.path, '${_uuid.v4()}.jpg');
      await File(_stripScheme(path)).copy(dest);
      out.add(dest);
    }
    if (!Platform.isAndroid) {
      try {
        await CunningDocumentScanner.cleanCache();
      } on Object {
        // Cache cleaning is best effort.
      }
    }
    return out;
  }

  Future<List<String>> _scanAndroid() async {
    final scanner = mlkit.DocumentScanner(
      options: mlkit.DocumentScannerOptions(
        documentFormats: {mlkit.DocumentFormat.jpeg},
        // `base` = capture, auto edge detection, crop and rotate. Filters are
        // applied later by the app so the original is always preserved.
        mode: mlkit.ScannerMode.base,
        pageLimit: 100,
        isGalleryImport: true,
      ),
    );
    try {
      final result = await scanner.scanDocument();
      return result.images ?? const [];
    } on Object catch (e) {
      // ML Kit reports a dismissed scanner as an exception.
      final text = e.toString().toLowerCase();
      if (text.contains('cancel') || text.contains('canceled')) return const [];
      throw CaptureException(e.toString());
    } finally {
      await scanner.close();
    }
  }

  Future<List<String>> _scanIos() async {
    final pictures = await CunningDocumentScanner.getPictures(
      noOfPages: 100,
      scannerSource: ScannerSource.camera,
    );
    return pictures ?? const [];
  }

  static String _stripScheme(String path) =>
      path.startsWith('file://') ? Uri.parse(path).toFilePath() : path;

  @override
  Future<List<String>> importPhotos({required String sessionId}) async {
    final picked = await FilePicker.pickFiles(type: FileType.image);
    return _ingest(picked, sessionId);
  }

  @override
  Future<List<String>> importFiles({required String sessionId}) async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: [..._imageExtensions, 'pdf'],
    );
    return _ingest(picked, sessionId);
  }

  Future<List<String>> _ingest(
    List<PlatformFile> picked,
    String sessionId,
  ) async {
    if (picked.isEmpty) return const [];
    final dir = await _session(sessionId);
    final out = <String>[];
    for (final file in picked) {
      final source = await _materialize(file, dir);
      if (p.extension(source).toLowerCase() == '.pdf') {
        out.addAll(await _renderPdf(source, dir));
      } else {
        final dest = p.join(dir.path, '${_uuid.v4()}.jpg');
        await _processor.normalizeImport(inputPath: source, outputPath: dest);
        out.add(dest);
      }
      if (source.startsWith(dir.path)) await _files.deleteFileQuietly(source);
    }
    return out;
  }

  /// Returns a readable local path, copying a content URI when necessary.
  Future<String> _materialize(PlatformFile file, Directory dir) async {
    final path = file.path;
    if (path != null) return path;
    final ext = file.extension ?? 'bin';
    final dest = p.join(dir.path, '${_uuid.v4()}.$ext');
    final sink = File(dest).openWrite();
    try {
      await sink.addStream(file.readAsByteStream());
    } finally {
      await sink.close();
    }
    return dest;
  }

  /// Rasterises each PDF page to a JPEG, one at a time to bound memory.
  Future<List<String>> _renderPdf(String pdfPath, Directory dir) async {
    final doc = await PdfDocument.openFile(pdfPath);
    final out = <String>[];
    try {
      for (var i = 1; i <= doc.pagesCount; i++) {
        final page = await doc.getPage(i);
        try {
          // 2x the PDF's point size is about 144 dpi: sharp but small.
          final scale = 2.0;
          final image = await page.render(
            width: page.width * scale,
            height: page.height * scale,
            format: PdfPageImageFormat.jpeg,
            quality: 90,
            backgroundColor: '#FFFFFF',
          );
          if (image == null) {
            throw const CaptureException('Could not render PDF page');
          }
          final dest = p.join(dir.path, '${_uuid.v4()}.jpg');
          await File(dest).writeAsBytes(image.bytes);
          out.add(dest);
        } finally {
          await page.close();
        }
      }
    } finally {
      await doc.close();
    }
    return out;
  }
}
