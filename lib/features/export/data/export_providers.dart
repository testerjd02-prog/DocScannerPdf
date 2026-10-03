import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/providers.dart';
import '../../library/data/library_providers.dart';
import 'document_exporter.dart';
import 'pdf_export_service.dart';

final pdfExportServiceProvider = Provider<PdfExportService>(
  (ref) => const PdfExportService(),
);

final documentExporterProvider = Provider<DocumentExporter>(
  (ref) => DocumentExporter(
    ref.watch(libraryRepositoryProvider),
    ref.watch(fileStoreProvider),
    ref.watch(pdfExportServiceProvider),
  ),
);
