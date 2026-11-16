import 'dart:convert';

import 'package:parla_shared/parla_shared.dart';
import 'package:test/test.dart';

Map<String, String> _l(String s) => {
  'az': '$s az',
  'ru': '$s ru',
  'en': '$s en',
};

List<String> _p(ContentKind kind, Object json, {bool complete = true}) =>
    ContentRules.problems(kind, jsonEncode(json), complete: complete);

void main() {
  final article = {
    'title': _l('Qış'),
    'summary': _l('Qısa'),
    'body': _l('Mətn'),
    'minutes': 4,
    'tips': [_l('Ilıq su')],
  };
  final recipe = {
    'title': _l('Yulaf'),
    'minutes': 10,
    'servings': 1,
    'groups': ['whole_grain', 'fruit'],
    'ingredients': [
      {'name': _l('Yulaf'), 'amount': _l('4 qaşıq')},
    ],
    'steps': [_l('Qarışdır')],
    'allergens': ['gluten', 'milk'],
  };
  final expert = {
    'name': 'Dr. Test',
    'workplace': _l('Klinika'),
    'city': _l('Bakı'),
    'years': 8,
    'whatsapp': '+994501234567',
  };

  test('complete content of every kind is valid', () {
    expect(_p(ContentKind.article, article), isEmpty);
    expect(_p(ContentKind.recipe, recipe), isEmpty);
    expect(_p(ContentKind.expert, expert), isEmpty);
  });

  test('drafts may miss texts, but review needs all three languages', () {
    final draft = {
      'title': {'az': 'Yalnız az'},
    };
    expect(_p(ContentKind.article, draft, complete: false), isEmpty);
    expect(
      _p(ContentKind.article, draft),
      containsAll(['title.ru.missing', 'title.en.missing', 'body.missing']),
    );
  });

  test('unknown fields, groups and bad contacts are refused', () {
    expect(
      _p(ContentKind.article, {...article, 'score': 48}),
      contains('score.unknown'),
    );
    expect(
      _p(ContentKind.recipe, {
        ...recipe,
        'groups': ['calories'],
      }),
      contains('groups.invalid'),
    );
    expect(
      _p(ContentKind.expert, {...expert, 'phone': '050 123'}),
      contains('phone.invalid'),
    );
    final noContact = Map.of(expert)..remove('whatsapp');
    expect(_p(ContentKind.expert, noContact), contains('contact.missing'));
  });

  test('recipes must name their allergens, or none explicitly', () {
    expect(
      _p(ContentKind.recipe, {...recipe}..remove('allergens')),
      contains('allergens.missing'),
    );
    expect(
      _p(ContentKind.recipe, {...recipe}..remove('allergens'), complete: false),
      isEmpty,
    );
    expect(_p(ContentKind.recipe, {...recipe, 'allergens': []}), isEmpty);
    expect(
      _p(ContentKind.recipe, {
        ...recipe,
        'allergens': ['milk', 'milk'],
      }),
      contains('allergens.invalid'),
    );
    expect(
      _p(ContentKind.recipe, {
        ...recipe,
        'allergens': ['chocolate'],
      }),
      contains('allergens.invalid'),
    );
    expect(ContentRules.recipeAllergens, hasLength(14));
  });

  test('articles: body category, https sources and no plan left over', () {
    expect(ContentRules.categoriesFor(ContentKind.article), contains('body'));
    expect(
      _p(ContentKind.article, {
        ...article,
        'sources': ['https://www.aad.org/public/everyday-care'],
      }),
      isEmpty,
    );
    for (final bad in [
      ['http://example.com/page'],
      ['https://has space.org'],
      'https://not-a-list.org',
      List.filled(11, 'https://example.org/a'),
    ]) {
      expect(
        _p(ContentKind.article, {...article, 'sources': bad}),
        contains('sources.invalid'),
        reason: '$bad',
      );
    }
    final planned = {
      ...article,
      'body': {
        ...?(article['body'] as Map<String, String>?),
        'az': '${ContentRules.planMarker}: sil]\n## Başlıq',
      },
    };
    expect(_p(ContentKind.article, planned, complete: false), isEmpty);
    expect(_p(ContentKind.article, planned), contains('body.plan_left'));
  });

  test('content may point to an image by id', () {
    for (final (kind, json) in [
      (ContentKind.article, article),
      (ContentKind.recipe, recipe),
      (ContentKind.expert, expert),
    ]) {
      expect(_p(kind, {...json, 'image': 7}), isEmpty);
      expect(_p(kind, {...json, 'image': 0}), contains('image.invalid'));
      expect(_p(kind, {...json, 'image': '7'}), contains('image.invalid'));
    }
  });

  test('images need a licence; publishing needs alt text in 3 languages', () {
    final alt = jsonEncode(_l('Yulaf qabı'));
    expect(MediaRules.problems(license: 'Own photo', altJson: alt), isEmpty);
    expect(
      MediaRules.problems(license: ' ', altJson: alt),
      contains('license.invalid'),
    );
    final partial = jsonEncode({'az': 'Yulaf'});
    expect(MediaRules.problems(license: 'x', altJson: partial), isEmpty);
    expect(
      MediaRules.problems(license: 'x', altJson: partial, complete: true),
      containsAll(['alt.ru.missing', 'alt.en.missing']),
    );
    expect(
      MediaRules.problems(license: 'x', altJson: '[1]'),
      contains('alt.invalid'),
    );
    expect(MediaRules.imageOf({'image': 3}), 3);
    expect(MediaRules.imageOf({}), isNull);
  });

  test('catalogue texts: known ids only, defaults are valid drafts', () {
    for (final kind in [
      ContentKind.preference,
      ContentKind.exercise,
      ContentKind.step,
    ]) {
      expect(kind.isCatalogue, isTrue);
      final ids = ContentRules.catalogueIds(kind);
      expect(ids, isNotEmpty);
      expect(ContentRules.isValidSlug(kind, ids.first), isTrue);
      expect(ContentRules.isValidSlug(kind, 'made-up-id'), isFalse);
      expect(ContentRules.categoriesFor(kind), ['catalogue']);
      for (final id in ids) {
        final defaults = ContentRules.catalogueDefaults(kind, id);
        expect(defaults, isNotEmpty, reason: '$kind $id has no text');
        expect(
          _p(kind, defaults, complete: false),
          isEmpty,
          reason: '$kind $id',
        );
      }
    }
    expect(ContentKind.article.isCatalogue, isFalse);
    expect(
      ContentRules.isValidSlug(ContentKind.article, 'fragrance_free'),
      isFalse,
    );
    // Only exercises take an image; logic fields are refused.
    expect(
      _p(ContentKind.step, {'title': _l('x'), 'image': 3}),
      contains('image.unknown'),
    );
    expect(
      _p(ContentKind.preference, {
        'name': _l('x'),
        'contains': ['parfum'],
      }),
      contains('contains.unknown'),
    );
    expect(
      _p(ContentKind.exercise, {'name': _l('x'), 'how': _l('y'), 'image': 3}),
      isEmpty,
    );
  });

  test('slugs and picking a language', () {
    expect(ContentRules.isSlug('qis-ayl-ari-deri'), isTrue);
    expect(ContentRules.isSlug('Bad Slug'), isFalse);
    expect(ContentRules.pick(_l('X'), 'ru'), 'X ru');
    expect(ContentRules.pick({'az': 'only'}, 'en'), 'only');
  });

  test('the daily plate holds known groups only', () {
    String doc(Object plates) => jsonEncode({'format': 1, 'plates': plates});
    expect(
      NutritionRules.isValid(
        doc({
          '2026-11-16': ['vegetables', 'protein'],
        }),
      ),
      isTrue,
    );
    expect(
      NutritionRules.isValid(
        doc({
          '2026-11-16': ['kcal'],
        }),
      ),
      isFalse,
    );
    expect(
      NutritionRules.isValid(jsonEncode({'format': 1, 'weight': 60})),
      isFalse,
    );
  });
}
