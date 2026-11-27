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

  test('a sweet recipe may fill no plate group', () {
    final sweet = {...recipe, 'groups': <String>[]};
    expect(
      ContentRules.problems(
        ContentKind.recipe,
        jsonEncode(sweet),
        complete: true,
      ),
      isNot(contains('groups.invalid')),
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

  test('a recipe may carry an approximate kcal per serving', () {
    expect(_p(ContentKind.recipe, {...recipe, 'kcal': 320}), isEmpty);
    expect(_p(ContentKind.recipe, recipe), isEmpty);
    expect(
      _p(ContentKind.recipe, {...recipe, 'kcal': 5}),
      contains('kcal.invalid'),
    );
    expect(
      _p(ContentKind.recipe, {...recipe, 'kcal': '320'}),
      contains('kcal.invalid'),
    );
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
    expect(MediaRules.videoOf({'video': 4}), 4);
    expect(MediaRules.mediaIdsOf({'image': 3, 'video': 4}), {3, 4});
    expect(MediaRules.imageIdsOf({'image': 3, 'video': 4}), {3});
  });

  test('an exercise may have a video; other kinds may not', () {
    expect(
      _p(ContentKind.exercise, {'name': _l('x'), 'how': _l('y'), 'video': 4}),
      isEmpty,
    );
    expect(
      _p(ContentKind.exercise, {'name': _l('x'), 'how': _l('y'), 'video': 'a'}),
      contains('video.invalid'),
    );
    expect(
      _p(ContentKind.step, {'title': _l('x'), 'how': _l('y'), 'video': 4}),
      contains('video.unknown'),
    );
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

  group('banners', () {
    final banner = {
      'title': _l('Yeni bölmə'),
      'link': 'nutrition',
      'startsOn': '2026-12-01',
      'endsOn': '2026-12-31',
    };

    test('valid banners, links and dates', () {
      expect(_p(ContentKind.banner, banner), isEmpty);
      expect(ContentRules.categoriesFor(ContentKind.banner), [
        'today',
        'discover',
        'blog',
        'recipe',
      ]);
      for (final ok in ['blog', 'article:qis-deri', 'recipe:berry-oats']) {
        expect(ContentRules.isBannerLink(ok), isTrue, reason: ok);
      }
      for (final bad in [
        'https://shop.example.com',
        'article:Bad Slug',
        'settings',
        'video:x',
      ]) {
        expect(ContentRules.isBannerLink(bad), isFalse, reason: bad);
        expect(
          _p(ContentKind.banner, {...banner, 'link': bad}),
          contains('link.invalid'),
        );
      }
      expect(
        _p(ContentKind.banner, {...banner, 'endsOn': '2026-11-30'}),
        contains('endsOn.before_start'),
      );
      expect(
        _p(ContentKind.banner, {...banner}..remove('endsOn')),
        contains('endsOn.missing'),
      );
      expect(
        _p(ContentKind.banner, {
          ...banner,
          'countries': ['XX'],
        }),
        contains('countries.invalid'),
      );
      // No targeting by health or quiz answers.
      expect(
        _p(ContentKind.banner, {...banner, 'skinType': 'dry'}),
        contains('skinType.unknown'),
      );
    });

    test('brand campaigns need an expert; own banners an admin', () {
      expect(ContentRules.reviewerRole(ContentKind.banner, banner), 'admin');
      expect(
        ContentRules.adminPublishesDirectly(ContentKind.banner, banner),
        isTrue,
      );
      final ad = {...banner, 'sponsor': 'Brand X'};
      expect(ContentRules.isSponsored(ad), isTrue);
      expect(ContentRules.reviewerRole(ContentKind.banner, ad), 'expert');
      expect(
        ContentRules.adminPublishesDirectly(ContentKind.banner, ad),
        isFalse,
      );
      expect(ContentRules.reviewerRole(ContentKind.article, {}), 'expert');
      expect(
        _p(ContentKind.banner, {...banner, 'sponsor': ' '}),
        contains('sponsor.invalid'),
      );
    });

    test('dates, language and country decide visibility on the phone', () {
      bool on(
        Map<String, Object?> j,
        DateTime d, {
        String lang = 'az',
        String? c,
      }) => ContentRules.bannerVisible(j, d, language: lang, country: c);
      expect(on(banner, DateTime(2026, 12, 1)), isTrue);
      expect(on(banner, DateTime(2026, 12, 31)), isTrue);
      expect(on(banner, DateTime(2026, 11, 30)), isFalse);
      expect(on(banner, DateTime(2027, 1, 1)), isFalse);
      final ru = {
        ...banner,
        'languages': ['ru'],
      };
      expect(on(ru, DateTime(2026, 12, 5)), isFalse);
      expect(on(ru, DateTime(2026, 12, 5), lang: 'ru'), isTrue);
      final az = {
        ...banner,
        'countries': ['AZ'],
      };
      expect(on(az, DateTime(2026, 12, 5)), isFalse); // country unknown
      expect(on(az, DateTime(2026, 12, 5), c: 'AZ'), isTrue);
    });

    test('brand campaigns: outside https link, campaign, topics', () {
      final ad = {
        ...banner,
        'link': null,
        'url': 'https://brand.az/spring?utm_source=brand',
        'campaign': 7,
      }..remove('link');
      expect(_p(ContentKind.banner, ad), isEmpty);
      expect(ContentRules.isSponsored(ad), isTrue);
      expect(ContentRules.reviewerRole(ContentKind.banner, ad), 'expert');
      for (final bad in [
        'http://brand.az',
        'https://user:pw@brand.az',
        'https://brand.az:8443/x',
        'https://localhost/x',
        'javascript:alert(1)',
        ' https://brand.az',
        'https://${'a' * 500}.az',
      ]) {
        expect(
          _p(ContentKind.banner, {...ad, 'url': bad}),
          contains('url.invalid'),
          reason: bad,
        );
      }
      expect(
        _p(ContentKind.banner, {...ad, 'link': 'home'}),
        contains('url.with_link'),
      );
      expect(
        _p(ContentKind.banner, {...ad, 'campaign': 0}),
        contains('campaign.invalid'),
      );
      expect(
        _p(ContentKind.banner, {
          ...ad,
          'topics': ['care', 'lunch'],
        }),
        isEmpty,
      );
      expect(
        _p(ContentKind.banner, {
          ...ad,
          'topics': ['pregnancy'],
        }),
        contains('topics.invalid'),
      );
      expect(
        _p(ContentKind.banner, {...ad, 'topics': <String>[]}),
        contains('topics.invalid'),
      );
      expect(
        ContentRules.bannerTopicsFit('blog', {
          'topics': ['care'],
        }),
        isTrue,
      );
      expect(
        ContentRules.bannerTopicsFit('recipe', {
          'topics': ['care'],
        }),
        isFalse,
      );
      expect(
        ContentRules.bannerTopicsFit('today', {
          'topics': ['care'],
        }),
        isFalse,
      );
      expect(ContentRules.bannerTopicsFit('today', {}), isTrue);
    });

    test('adLink adds only Parla campaign tags, keeps the brand\'s', () {
      final link = ContentRules.adLink(
        'https://brand.az/spring?utm_source=brand&ref=1',
        campaign: 7,
      );
      expect(link.queryParameters, {
        'utm_source': 'brand',
        'ref': '1',
        'utm_medium': 'app',
        'utm_campaign': 'parla-7',
      });
      expect(
        ContentRules.adLink('https://brand.az').toString(),
        'https://brand.az?utm_source=parla&utm_medium=app',
      );
    });

    test('a banner limited to topics shows only under them', () {
      final under = {
        ...banner,
        'topics': ['care'],
      };
      final day = DateTime(2026, 12, 2);
      bool on(Map<String, Object?> j, String? topic) =>
          ContentRules.bannerVisible(j, day, language: 'az', topic: topic);
      expect(on(under, 'care'), isTrue);
      expect(on(under, 'hair'), isFalse);
      expect(on(under, null), isFalse);
      expect(on(banner, 'hair'), isTrue);
    });
  });

  group('products', () {
    final product = {
      'name': _l('Nəmləndirici krem'),
      'description': _l('Quru dəri üçün'),
      'brand': 'Brand X',
      'image': 5,
      'price': '12.50',
      'sale': 'redirect',
      'url': 'https://brand.az/krem',
    };

    test('a partner product is complete; categories are the shop areas', () {
      expect(_p(ContentKind.product, product, complete: true), isEmpty);
      expect(ContentRules.categoriesFor(ContentKind.product), [
        'face',
        'hair',
        'body',
        'makeup',
        'other',
      ]);
      // Products are always checked by an expert.
      expect(ContentRules.reviewerRole(ContentKind.product, product), 'expert');
      expect(
        ContentRules.adminPublishesDirectly(ContentKind.product, product),
        isFalse,
      );
    });

    test('price, sale, seller and links are checked', () {
      for (final bad in ['0', '-1', '12.505', '1,50', '100000', 12.5]) {
        expect(
          _p(ContentKind.product, {...product, 'price': bad}),
          contains('price.invalid'),
          reason: '$bad',
        );
      }
      expect(ContentRules.priceQepik('12.5'), 1250);
      expect(ContentRules.priceQepik('0.99'), 99);
      expect(ContentRules.priceQepik('7'), 700);
      expect(ContentRules.priceQepik('0'), isNull);
      expect(
        _p(ContentKind.product, {...product}..remove('url'), complete: true),
        contains('url.missing'),
      );
      expect(
        _p(ContentKind.product, {...product, 'url': 'http://brand.az'}),
        contains('url.invalid'),
      );
      expect(
        _p(ContentKind.product, {...product, 'seller': 'parla'}),
        contains('seller.unexpected'),
      );
      final own = {...product, 'sale': 'own', 'seller': 'brand'}..remove('url');
      expect(_p(ContentKind.product, own, complete: true), isEmpty);
      expect(
        _p(ContentKind.product, {...own, 'url': 'https://brand.az'}),
        contains('url.unexpected'),
      );
      expect(
        _p(ContentKind.product, {...own}..remove('seller'), complete: true),
        contains('seller.missing'),
      );
      expect(
        _p(ContentKind.product, {...own, 'seller': 'shop'}),
        contains('seller.invalid'),
      );
      expect(
        _p(ContentKind.product, {...product, 'sale': 'gift'}),
        contains('sale.invalid'),
      );
      expect(
        _p(ContentKind.product, {...product}..remove('image'), complete: true),
        contains('image.missing'),
      );
      expect(
        _p(ContentKind.product, {...product, 'score': 3}),
        contains('score.unknown'),
      );
    });

    test('a product in a brand campaign is an ad', () {
      final ad = {...product, 'campaign': 3};
      expect(ContentRules.isSponsored(ad), isTrue);
      expect(ContentRules.isSponsored(product), isFalse);
    });
  });

  test('messages: team announcements, admin publishes directly', () {
    final message = {
      'title': _l('Yenilik'),
      'body': _l('Qidalanma bölməsi açıldı.'),
      'startsOn': '2026-12-01',
      'endsOn': '2026-12-31',
      'link': 'nutrition',
    };
    expect(_p(ContentKind.message, message), isEmpty);
    expect(ContentRules.reviewerRole(ContentKind.message, message), 'admin');
    expect(
      ContentRules.adminPublishesDirectly(ContentKind.message, message),
      isTrue,
    );
    expect(
      _p(ContentKind.message, {...message, 'sponsor': 'Brand'}),
      contains('sponsor.unknown'),
    );
    expect(
      _p(ContentKind.message, {...message, 'link': 'https://x.az'}),
      contains('link.invalid'),
    );
    expect(
      ContentRules.bannerVisible(
        message,
        DateTime(2026, 12, 2),
        language: 'az',
      ),
      isTrue,
    );
  });

  test('push campaigns: short texts, in-app links, no dates or images', () {
    final push = {
      'title': _l('Yeni reseptlər'),
      'body': _l('Qidalanma bölməsinə bax'),
      'link': 'messages',
      'languages': ['az'],
    };
    expect(_p(ContentKind.push, push), isEmpty);
    expect(ContentRules.adminPublishesDirectly(ContentKind.push, push), isTrue);
    expect(
      _p(ContentKind.push, {...push, 'title': _l('x' * 61)}),
      contains('title.az.invalid'),
    );
    for (final extra in ['image', 'startsOn', 'sponsor']) {
      expect(
        _p(ContentKind.push, {...push, extra: 'x'}),
        contains('$extra.unknown'),
      );
    }
    expect(
      _p(ContentKind.push, {...push, 'link': 'https://x.az'}),
      contains('link.invalid'),
    );
  });

  test('articles: Markdown links and images, hashtags per language', () {
    final md = {
      ...article,
      'body': {
        ...?(article['body'] as Map<String, String>?),
        'az':
            '## Başlıq\n\n**Qalın** və [mənbə](https://aad.org).\n\n'
            '![Krem qabı](media:12)\n\n![İkinci](media:7 "başlıq")',
      },
      'tags': {
        'az': ['quruDəri', 'qış'],
        'ru': ['сухаяКожа'],
      },
    };
    expect(_p(ContentKind.article, md), isEmpty);
    expect(ContentRules.inlineImageIds(md), {12, 7});
    expect(MediaRules.imageIdsOf({...md, 'image': 3}), {3, 12, 7});

    Map<String, Object?> withBody(String az) => {
      ...article,
      'body': {...?(article['body'] as Map<String, String>?), 'az': az},
    };
    expect(
      _p(ContentKind.article, withBody('![x](https://evil.example/a.png)')),
      contains('body.az.image_invalid'),
    );
    expect(
      _p(ContentKind.article, withBody('[x](javascript:alert(1))')),
      contains('body.az.link_invalid'),
    );
    expect(
      _p(ContentKind.article, withBody('[x](http://plain.example)')),
      contains('body.az.link_invalid'),
    );
    expect(
      _p(ContentKind.article, {
        ...article,
        'tags': {
          'az': ['with space'],
        },
      }),
      contains('tags.az.invalid'),
    );
    expect(
      _p(ContentKind.article, {
        ...article,
        'tags': {'az': List.filled(11, 'a')},
      }),
      contains('tags.az.invalid'),
    );
    expect(ContentRules.cleanTag(' #quru Dəri '), 'quruDəri');
    expect(ContentRules.cleanTag('#'), isNull);
    expect(ContentRules.cleanTag('a-b'), isNull);
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

  test('a sport photo is only an image, filed under a workout type', () {
    expect(
      ContentRules.categoriesFor(ContentKind.sportPhoto),
      contains('pilates'),
    );
    expect(
      ContentRules.problems(ContentKind.sportPhoto, jsonEncode({'image': 3})),
      isEmpty,
    );
    expect(
      ContentRules.problems(ContentKind.sportPhoto, '{}'),
      contains('image.missing'),
    );
    expect(
      ContentRules.problems(
        ContentKind.sportPhoto,
        jsonEncode({'image': 3, 'title': 'x'}),
      ),
      contains('title.unknown'),
    );
    expect(
      ContentRules.adminPublishesDirectly(ContentKind.sportPhoto, const {}),
      isTrue,
    );
  });

  group('articles limited to countries', () {
    test('show only in their countries', () {
      final az = <String, Object?>{
        'countries': ['AZ'],
      };
      expect(ContentRules.shownInCountry(az, 'AZ'), isTrue);
      expect(ContentRules.shownInCountry(az, 'TR'), isFalse);
      // Unknown country: only items for every country.
      expect(ContentRules.shownInCountry(az, null), isFalse);
      expect(ContentRules.shownInCountry(const {}, null), isTrue);
    });

    test('an article accepts a valid countries list only', () {
      List<String> problems(Object countries) =>
          _p(ContentKind.article, {...article, 'countries': countries});
      expect(_p(ContentKind.article, article), isEmpty);
      expect(problems(['AZ']), isEmpty);
      expect(problems(['XX']), contains('countries.invalid'));
      expect(problems(<String>[]), contains('countries.invalid'));
    });
  });

  test('every editable website text starts complete in az, ru and en', () {
    expect(ContentKind.site.isCatalogue, isTrue);
    expect(siteTextKeys.toSet(), hasLength(siteTextKeys.length));
    for (final key in siteTextKeys) {
      expect(siteTextLabels[key], isNotNull, reason: key);
      final d = ContentRules.catalogueDefaults(ContentKind.site, key);
      expect(_p(ContentKind.site, d), isEmpty, reason: key);
    }
    expect(
      _p(ContentKind.site, {
        'text': {'az': 'A'},
        'extra': 1,
      }),
      isNotEmpty,
    );
    expect(
      ContentRules.adminPublishesDirectly(ContentKind.site, const {}),
      isTrue,
    );
  });
}
