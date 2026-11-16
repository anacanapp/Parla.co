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
