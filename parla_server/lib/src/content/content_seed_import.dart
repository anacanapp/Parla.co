import 'package:parla_shared/parla_shared.dart';

part 'content_seed.dart';

/// One article or recipe from the content sheet.
class SeedContent {
  const SeedContent(this.kind, this.slug, this.category, this.json);

  final String kind;
  final String slug;
  final String category;

  /// Draft JSON in the [ContentRules] format.
  final String json;

  /// Problems that would stop it from being saved as a draft.
  List<String> get problems => [
    if (!ContentRules.isSlug(slug)) 'slug',
    if (!ContentRules.categoriesFor(
      ContentKind.values.byName(kind),
    ).contains(category))
      'category',
    ...ContentRules.problems(ContentKind.values.byName(kind), json),
  ];
}
