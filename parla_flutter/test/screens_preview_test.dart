// Screen preview: renders main screens to PREVIEW_DIR (skipped normally).
// flutter test test/screens_preview_test.dart --dart-define=PALETTE_PREVIEW=true --dart-define=PREVIEW_DIR=<abs dir>
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:parla/ui/warm.dart';
import 'package:parla/app.dart';
import 'package:parla/habits/habit_log.dart';
import 'package:parla/habits/habit_store.dart';
import 'package:parla/routes.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla/state/app_settings.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_api.dart';
import 'support/fake_reminders.dart';

const _enabled = bool.fromEnvironment('PALETTE_PREVIEW');
const _language = String.fromEnvironment(
  'PREVIEW_LANG',
  defaultValue: 'az',
);
const _dir = String.fromEnvironment('PREVIEW_DIR');
final _today = DateTime(2026, 11, 12, 9);

const _answers = QuizAnswers(
  chosen: {
    'skin_type': ['combination'],
    'sensitivity': ['never'],
    'routine_level': ['standard'],
  },
);

/// Display-only sample ingredient data for the product screenshot.
final _dataset = IngredientDataset(
  source: 'CosIng',
  exportedOn: '2026-11-01',
  entries: const [
    IngredientEntry(
      inci: 'PHENOXYETHANOL',
      rules: [
        IngredientRule(
          annex: EuAnnex.v,
          reference: '29',
          conditions: 'Maximum concentration in ready for use preparation: 1 %',
        ),
      ],
    ),
  ],
);

const _product = ProductResult(
  source: 'openbeautyfacts',
  code: 'sample-1',
  name: 'Nəmləndirici gündüz kremi',
  brand: 'Nümunə',
  ingredientsText:
      'Aqua, Glycerin, Niacinamide, Squalane, Panthenol, Phenoxyethanol',
);

MemoryHabitStore _store() {
  final log = HabitLog();
  final days = {
    0: (6, 7.5, 20),
    1: (8, 7.0, 30),
    2: (5, 6.5, 20),
    3: (7, 8.0, null),
    4: (8, 7.5, 45),
    5: (4, 6.0, null),
    6: (7, 7.0, 25),
  };
  days.forEach((ago, v) {
    final d = log.day(_today.subtract(Duration(days: ago)))
      ..water = v.$1
      ..sleepHours = v.$2
      ..moveMinutes = v.$3;
    if (ago != 0) d.morningDone.add('face-cleanser-am');
    if (ago.isOdd) d.eveningDone.add('face-cleanser-pm');
  });
  log.day(_today)
    ..morningDone.addAll([
      'face-cleanser-am',
      'face-vitamin-c',
      'face-moisturiser',
    ])
    ..moveMinutes = 20;
  return MemoryHabitStore()..data['user-1'] = jsonEncode(log.toJson());
}

Future<void> _loadIconFont() async {
  // Material icons are not loaded in tests by default (chevrons would show
  // as boxes); take the font from the Flutter SDK running the test.
  final root = Platform.environment['FLUTTER_ROOT'];
  if (root == null) return;
  final file = File(
    '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  if (!file.existsSync()) return;
  final loader = FontLoader('MaterialIcons')
    ..addFont(Future.value(ByteData.sublistView(file.readAsBytesSync())));
  await loader.load();
}

Future<void> _open(WidgetTester tester) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues({'language': _language});
  final settings = await AppSettings.load();
  final api = FakeApi()
    ..signedIn = true
    ..healthConsent = true
    ..profile = const ProfileSummary(countryCode: 'AZ', language: _language)
    ..quizAnswers = _answers
    ..products = const [_product];
  api.published.addAll(_content);
  await tester.pumpWidget(
    ParlaApp(
      key: UniqueKey(),
      api: api,
      settings: settings,
      clock: () => _today,
      habitStore: _store(),
      reminderScheduler: FakeReminderScheduler(),
      ingredientDataset: _dataset,
    ),
  );
  // Decode the backdrop photo before the first shot.
  await tester.runAsync(
    () => precacheImage(
      const AssetImage(WarmBackdrop.asset),
      tester.element(find.byType(ParlaApp)),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _go(WidgetTester tester, String route) async {
  GoRouter.of(tester.element(find.byType(Scaffold).first)).go(route);
  await tester.pumpAndSettle();
}

Future<void> _shoot(WidgetTester tester, String name) async {
  await expectLater(
    find.byType(ParlaApp),
    matchesGoldenFile('$_dir/$name.png'),
  );
}

Map<String, String> _l(String s) => {'az': s, 'ru': s, 'en': s};

final _content = <String, List<PublishedItem>>{
  'article': [
    PublishedItem(
      id: 1,
      kind: 'article',
      slug: 'qis-deri',
      category: 'care',
      publishedAt: DateTime.utc(2026, 11, 10),
      reviewedAt: DateTime.utc(2026, 11, 9),
      data: {
        'title': _l('Qışda quru dəri: 5 sadə vərdiş'),
        'summary': _l('Soyuq havada dəri niyə quruyur və nə kömək edir'),
        'body': _l(
          'Soyuq hava və isti otaqlar dərinin nəmini azaldır.\n\n## Vərdişlər\n\nIlıq su ilə yuyun və nəmləndiricini nəm dəriyə çəkin.',
        ),
        'minutes': 4,
        'tips': [_l('Ilıq su'), _l('Nəmləndirici'), _l('SPF hər gün')],
      },
    ),
    PublishedItem(
      id: 2,
      kind: 'article',
      slug: 'kapsul',
      category: 'fashion',
      publishedAt: DateTime.utc(2026, 11, 8),
      data: {
        'title': _l('Kapsul qarderob: 12 əşya'),
        'summary': _l('Az əşya, çox kombin'),
        'body': _l('Mətn.'),
        'minutes': 3,
      },
    ),
  ],
  'recipe': [
    PublishedItem(
      id: 3,
      kind: 'recipe',
      slug: 'yulaf',
      category: 'breakfast',
      publishedAt: DateTime.utc(2026, 11, 7),
      data: {
        'title': _l('Giləmeyvəli yulaf'),
        'minutes': 10,
        'servings': 1,
        'groups': ['whole_grain', 'fruit'],
        'ingredients': [
          {'name': _l('Yulaf'), 'amount': _l('4 xörək qaşığı')},
        ],
        'steps': [_l('Qarışdır')],
        'allergens': ['gluten'],
      },
    ),
  ],
  'banner': [
    PublishedItem(
      id: 20,
      kind: 'banner',
      slug: 'yeni',
      category: 'discover',
      publishedAt: DateTime.utc(2026, 11, 10),
      data: {
        'title': _l('Qidalanma bölməsi açıldı'),
        'body': _l('Boşqab qaydası ilə sadə reseptlər'),
        'link': 'nutrition',
        'startsOn': '2026-11-01',
        'endsOn': '2026-11-30',
      },
    ),
  ],
  'product': [
    for (final (i, name, brand, price, cat, sponsor) in [
      (1, 'Nəmləndirici gündüz kremi', 'Nümunə', '24.90', 'face', 'Nümunə'),
      (2, 'Yumşaq təmizləyici gel', 'Brend A', '15.50', 'face', null),
      (3, 'Saç üçün yağ', 'Brend B', '19.00', 'hair', null),
    ])
      PublishedItem(
        id: 40 + i,
        kind: 'product',
        slug: 'p$i',
        category: cat,
        publishedAt: DateTime.utc(2026, 11, i),
        data: {
          'name': _l(name),
          'description': _l('Quru və normal dəri üçün yüngül krem.'),
          'brand': brand,
          'price': price,
          'sale': 'redirect',
          'url': 'https://partner.az/p$i',
          'sponsor': ?sponsor,
          if (sponsor != null) 'campaign': 1,
        },
      ),
  ],
};

void main() {
  setUpAll(() async {
    autoUpdateGoldenFiles = true;
    await _loadIconFont();
  });

  for (final (name, route) in [
    ('01_home', null),
    ('02_habits', Routes.habits),
    ('03_discover', Routes.discover),
    ('04_blog', Routes.blogPost),
    ('05_sport', Routes.sport),
    ('06_shop', Routes.shop),
    ('07_product', Routes.shopProduct),
    ('08_privacy', Routes.privacy),
    ('10_check', Routes.products),
    ('11_shopping', Routes.shoppingList),
    ('12_blog_list', Routes.blog),
    ('13_experts', Routes.experts),
    ('14_nutrition', Routes.nutrition),
  ]) {
    testWidgets(name, skip: !_enabled, (tester) async {
      await _open(tester);
      if (route == Routes.blogPost) {
        GoRouter.of(
          tester.element(find.byType(Scaffold).first),
        ).go(route!, extra: 'qis-deri');
        await tester.pumpAndSettle();
      } else if (route == Routes.shopProduct) {
        GoRouter.of(
          tester.element(find.byType(Scaffold).first),
        ).go(route!, extra: 'p1');
        await tester.pumpAndSettle();
      } else if (route != null) {
        await _go(tester, route);
      }
      await _shoot(tester, name);
    });
  }
}
