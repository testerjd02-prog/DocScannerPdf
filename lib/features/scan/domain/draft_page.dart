import 'edit_recipe.dart';

/// A page captured in the current scan session but not yet saved.
class DraftPage {
  const DraftPage({
    required this.id,
    required this.originalPath,
    this.recipe = EditRecipe.none,
  });

  final String id;

  /// Untouched capture inside the session's temp directory.
  final String originalPath;
  final EditRecipe recipe;

  DraftPage copyWith({EditRecipe? recipe}) => DraftPage(
    id: id,
    originalPath: originalPath,
    recipe: recipe ?? this.recipe,
  );
}
