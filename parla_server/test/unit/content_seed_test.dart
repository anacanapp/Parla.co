import 'dart:convert';

import 'package:parla_server/src/content/content_seed_import.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:test/test.dart';

void main() {
  test('every sheet item is a valid draft with a unique slug', () {
    expect(contentSeed, isNotEmpty);
    for (final s in contentSeed) {
      expect(s.problems, isEmpty, reason: s.slug);
    }
    final keys = contentSeed.map((s) => '${s.kind}/${s.slug}').toSet();
    expect(keys, hasLength(contentSeed.length));
  });

  test('recipes are complete apart from expert review', () {
    final recipes = contentSeed.where((s) => s.kind == 'recipe').toList();
    expect(recipes, hasLength(20));
    for (final r in recipes) {
      expect(
        ContentRules.problems(ContentKind.recipe, r.json, complete: true),
        isEmpty,
        reason: r.slug,
      );
      expect(jsonDecode(r.json), contains('allergens'));
    }
  });

  test('articles carry the writing plan, sources and no published text', () {
    final articles = contentSeed.where((s) => s.kind == 'article').toList();
    expect(articles, hasLength(12));
    expect(articles.map((a) => a.category).toSet(), contains('body'));
    for (final a in articles) {
      final json = jsonDecode(a.json) as Map<String, Object?>;
      final body = json['body']! as Map<String, Object?>;
      expect(body['az'], startsWith(ContentRules.planMarker), reason: a.slug);
      expect(body.keys, ['az']);
      expect(json['sources'], isNotEmpty, reason: a.slug);
      expect(
        ContentRules.problems(ContentKind.article, a.json, complete: true),
        contains('body.plan_left'),
      );
    }
  });
}
