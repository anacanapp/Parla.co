import 'dart:convert';

import 'package:parla_server/src/content/content_seed_import.dart';
import 'package:parla_server/src/content/wording_fixes.dart';
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

  test('the full blog articles are complete in three languages', () {
    expect(blogSeed, hasLength(32));
    final slugs = blogSeed.map((b) => b.slug).toSet();
    expect(slugs, hasLength(blogSeed.length));
    // Every article of the first sheet has its full version.
    for (final a in contentSeed.where((s) => s.kind == 'article')) {
      expect(slugs, contains(a.slug));
    }
    for (final b in blogSeed) {
      expect(b.problems, isEmpty, reason: b.slug);
      final json = jsonDecode(b.json) as Map<String, Object?>;
      final body = json['body']! as Map<String, Object?>;
      expect(body.keys.toSet(), {'az', 'ru', 'en'}, reason: b.slug);
      for (final text in body.values) {
        expect(text, isNot(contains(ContentRules.planMarker)));
        expect((text! as String).length, greaterThan(3000), reason: b.slug);
      }
      expect(json['sources'], isNotEmpty, reason: b.slug);
      // Only the cover and its review are missing before publishing.
      expect(
        ContentRules.problems(
          ContentKind.article,
          b.json,
          complete: true,
        ).where((p) => !p.startsWith('image')),
        isEmpty,
        reason: b.slug,
      );
    }
  });

  test('the import offers each article once, in its full version', () {
    final articles = importSeed.where((s) => s.kind == 'article').toList();
    expect(articles, hasLength(32));
    expect(articles.every(blogSeed.contains), isTrue);
    expect(importSeed.where((s) => s.kind == 'recipe'), hasLength(76));
  });

  test('the recipe sheet keeps the first 20 recipes unchanged', () {
    expect(recipeSeed, hasLength(76));
    final keys = recipeSeed.map((s) => s.slug).toSet();
    expect(keys, hasLength(recipeSeed.length));
    final first = {
      for (final s in contentSeed.where((s) => s.kind == 'recipe')) s.slug: s,
    };
    for (final r in recipeSeed) {
      expect(r.problems, isEmpty, reason: r.slug);
      expect(
        ContentRules.problems(ContentKind.recipe, r.json, complete: true),
        isEmpty,
        reason: r.slug,
      );
      final old = first[r.slug];
      if (old != null) {
        expect(jsonDecode(r.json), jsonDecode(old.json), reason: r.slug);
        expect(r.category, old.category, reason: r.slug);
      }
    }
    expect(first.keys.every(keys.contains), isTrue);
  });

  test('no blog article calls anything harmful or toxic, in any language '
      '(owner 2026-11-26)', () {
    final banned = RegExp(
      r'zərərli|zəhərli|(?<!без)вредн|токсич|harmful|toxic',
      caseSensitive: false,
    );
    for (final s in blogSeed) {
      expect(banned.hasMatch(s.json), isFalse, reason: s.slug);
    }
  });

  test('every wording fix is already in the blog seed, and applying the '
      'fixes again changes nothing', () {
    final seed = {for (final s in blogSeed) s.slug: s};
    for (final (slug, lang, _, to) in wordingFixes) {
      final data = jsonDecode(seed[slug]!.json) as Map<String, Object?>;
      expect(jsonEncode(data), contains(to), reason: '$slug $lang');
      expect(applyWordingFixes(slug, data), same(data), reason: slug);
    }
    final old = {
      'title': {'az': 'Ucuz eynək zərərlidirmi?', 'en': 'x'},
      'tips': [
        {'az': 'Ucuz eynək zərərlidirmi?'},
      ],
    };
    final fixed = applyWordingFixes('sunglasses-hats-uv', old);
    expect((fixed['title']! as Map)['az'], 'Ucuz eynək gözü qoruyurmu?');
    expect(
      ((fixed['tips']! as List).single as Map)['az'],
      'Ucuz eynək gözü qoruyurmu?',
    );
  });
}
