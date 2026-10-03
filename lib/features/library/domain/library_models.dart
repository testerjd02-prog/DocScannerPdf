import '../../scan/domain/edit_recipe.dart';

enum DocSort { newest, oldest, nameAsc, nameDesc }

class FolderInfo {
  const FolderInfo({required this.id, required this.name});
  final String id;
  final String name;
}

class PageInfo {
  const PageInfo({
    required this.id,
    required this.documentId,
    required this.position,
    required this.originalPath,
    required this.editedPath,
    required this.recipe,
    required this.ocrJson,
  });

  final String id;
  final String documentId;
  final int position;
  final String originalPath;
  final String? editedPath;
  final EditRecipe recipe;
  final String? ocrJson;

  /// What the user should see: the edited render when it exists.
  String get displayPath => editedPath ?? originalPath;
}

class DocumentSummary {
  const DocumentSummary({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.folderId,
    required this.tags,
    required this.pageCount,
    required this.coverPath,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? folderId;
  final List<String> tags;
  final int pageCount;
  final String? coverPath;
}

/// A page about to be inserted; files are already in place.
class NewPage {
  const NewPage({
    required this.id,
    required this.originalPath,
    required this.editedPath,
    required this.recipe,
  });
  final String id;
  final String originalPath;
  final String? editedPath;
  final EditRecipe recipe;
}
