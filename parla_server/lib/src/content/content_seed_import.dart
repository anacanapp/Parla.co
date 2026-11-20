import 'dart:convert';

import 'package:parla_shared/parla_shared.dart';

part 'blog_seed.dart';
part 'content_seed.dart';
part 'recipe_seed.dart';

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

/// Everything the sheet import offers: the full blog articles and the
/// recipes, then the first sheet's items that have no newer version.
List<SeedContent> get importSeed {
  final newer = {
    for (final s in [...blogSeed, ...recipeSeed]) '${s.kind}/${s.slug}',
  };
  return [
    ...blogSeed,
    ...recipeSeed,
    for (final s in contentSeed)
      if (!newer.contains('${s.kind}/${s.slug}')) s,
  ];
}

/// Whether [draftJson] of the article [slug] is still exactly the writing
/// plan the first sheet import gave it: only then may the full article
/// replace it. Any edit, even of the title, keeps the draft as it is.
bool isUntouchedPlan(String slug, String draftJson) {
  for (final s in contentSeed) {
    if (s.kind != 'article' || s.slug != slug) continue;
    try {
      return jsonEncode(jsonDecode(draftJson)) ==
          jsonEncode(jsonDecode(s.json));
    } on FormatException {
      return false;
    }
  }
  return false;
}

/// [seedJson] with the fields of [current] the seed does not set (an
/// uploaded cover, hashtags) kept.
String mergeSeed(String current, String seedJson) {
  final old = jsonDecode(current) as Map<String, Object?>;
  final next = jsonDecode(seedJson) as Map<String, Object?>;
  return jsonEncode({
    for (final e in old.entries)
      if (!next.containsKey(e.key)) e.key: e.value,
    ...next,
  });
}
