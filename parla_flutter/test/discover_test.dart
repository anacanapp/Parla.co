import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla/app.dart';
import 'package:parla/discover/discover_screens.dart';
import 'package:parla/habits/habit_store.dart';
import 'package:parla/home/widgets/parla_nav_bar.dart';
import 'package:parla/services/parla_api.dart';
import 'package:parla/state/app_settings.dart';
import 'package:parla/ui/brand.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_api.dart';
import 'support/fake_reminders.dart';
import 'support/text_sizes.dart';

Map<String, String> _l(String s) => {
  'az': '$s az',
  'ru': '$s ru',
  'en': '$s en',
};

final _published = <String, List<PublishedItem>>{
  'article': [
    PublishedItem(
      id: 1,
      kind: 'article',
      slug: 'winter',
      category: 'care',
      publishedAt: DateTime.utc(2026, 11, 10),
      reviewedAt: DateTime.utc(2026, 11, 9),
      data: {
        'title': _l('Winter skin'),
        'summary': _l('Why skin dries'),
        'body': _l('First paragraph.\n\nSecond paragraph.'),
        'minutes': 4,
        'tips': [_l('Lukewarm water'), _l('Moisturise')],
      },
    ),
    PublishedItem(
      id: 2,
      kind: 'article',
      slug: 'capsule',
      category: 'fashion',
      publishedAt: DateTime.utc(2026, 11, 8),
      data: {
        'title': _l('Capsule wardrobe'),
        'summary': _l('12 pieces'),
        'body': _l('Text.'),
        'minutes': 3,
      },
    ),
  ],
  'recipe': [
    PublishedItem(
      id: 3,
      kind: 'recipe',
      slug: 'oats',
      category: 'breakfast',
      publishedAt: DateTime.utc(2026, 11, 7),
      reviewedAt: DateTime.utc(2026, 11, 6),
      data: {
        'title': _l('Berry oats'),
        'minutes': 10,
        'servings': 1,
        'groups': ['whole_grain', 'fruit'],
        'ingredients': [
          {'name': _l('Oats'), 'amount': _l('4 tbsp')},
          {'name': _l('Berries'), 'amount': _l('1 handful')},
        ],
        'steps': [_l('Mix'), _l('Top')],
      },
    ),
  ],
  'expert': [
    PublishedItem(
      id: 4,
      kind: 'expert',
      slug: 'dr-a',
      category: 'dermatologist',
      publishedAt: DateTime.utc(2026, 11, 5),
      data: {
        'name': 'Aysel Test',
        'workplace': _l('Clinic'),
        'city': _l('Baku'),
        'years': 8,
        'phone': '+994501234567',
        'whatsapp': '+994501234567',
      },
    ),
  ],
};

class _App {
  _App(this.api, this.nutrition, this.careList);

  final FakeApi api;
  final MemoryHabitStore nutrition;
  final MemoryHabitStore careList;
}

Future<_App> _open(
  WidgetTester tester, {
  String language = 'en',
  bool healthConsent = false,
  Map<String, List<PublishedItem>>? published,
  Object? contentError,
  double textScale = 1,
}) async {
  tester.view.physicalSize = const Size(390 * 3, 844 * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final settings = await AppSettings.load();
  await settings.setLanguage(language);
  final api = FakeApi()
    ..signedIn = true
    ..profile = ProfileSummary(countryCode: 'AZ', language: language)
    ..healthConsent = healthConsent
    ..contentError = contentError;
  api.published.addAll(published ?? _published);
  final nutrition = MemoryHabitStore();
  final careList = MemoryHabitStore();
  await tester.pumpWidget(
    ParlaApp(
      key: UniqueKey(),
      api: api,
      reminderScheduler: FakeReminderScheduler(),
      settings: settings,
      clock: () => DateTime(2026, 11, 16, 10),
      habitStore: MemoryHabitStore(),
      routineStore: MemoryHabitStore(),
      careListStore: careList,
      sportStore: MemoryHabitStore(),
      nutritionStore: nutrition,
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(
    find
        .descendant(
          of: find.byType(ParlaNavBar),
          matching: find.byType(InkWell),
        )
        .at(4),
  );
  await tester.pumpAndSettle();
  return _App(api, nutrition, careList);
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  final list = find.byType(Scrollable);
  if (finder.evaluate().isEmpty && list.evaluate().isNotEmpty) {
    await tester.scrollUntilVisible(finder, 200, scrollable: list.first);
  }
  await tester.ensureVisible(finder.first);
  await tester.pumpAndSettle();
  await tester.tap(finder.first);
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('blogs: newest on Discover, filter, the article with its '
      'expert review and steps', (tester) async {
    await _open(tester);
    expect(find.text('New articles'), findsOneWidget);
    await _tap(tester, find.text('Blogs').first);
    expect(find.text('Winter skin en'), findsOneWidget);
    expect(find.text('Capsule wardrobe en'), findsOneWidget);

    await _tap(tester, find.byKey(const ValueKey('cat-fashion')));
    expect(find.text('Winter skin en'), findsNothing);
    await _tap(tester, find.byKey(const ValueKey('cat-all')));

    await _tap(tester, find.byKey(const ValueKey('article-winter')));
    expect(find.text('First paragraph.'), findsOneWidget);
    expect(find.text('Second paragraph. en'), findsOneWidget);
    expect(find.textContaining('Reviewed by an expert'), findsOneWidget);
    expect(find.text('Moisturise en'), findsOneWidget);
  });

  testWidgets('content shows in Russian, and the last copy shows offline', (
    tester,
  ) async {
    await _open(tester, language: 'ru');
    await _tap(tester, find.text('Блоги').first);
    expect(find.text('Winter skin ru'), findsOneWidget);

    await _open(tester, language: 'ru', published: {}, contentError: 'down');
    await _tap(tester, find.text('Блоги').first);
    expect(find.text('Winter skin ru'), findsOneWidget);
    expect(find.textContaining('Нет интернета'), findsOneWidget);
  });

  testWidgets('nothing published shows a note', (tester) async {
    await _open(tester, published: {});
    expect(find.text('New articles'), findsNothing);
    await _tap(tester, find.text('Experts').first);
    expect(find.text('Nothing here yet. Coming soon.'), findsOneWidget);
  });

  testWidgets('experts: contacts open the phone apps, with the disclaimer', (
    tester,
  ) async {
    final opened = <Uri>[];
    final original = ExpertsScreen.launcher;
    ExpertsScreen.launcher = (uri) async {
      opened.add(uri);
      return true;
    };
    addTearDown(() => ExpertsScreen.launcher = original);

    await _open(tester);
    await _tap(tester, find.text('Experts').first);
    expect(find.text('Aysel Test'), findsOneWidget);
    expect(find.text('8 years of experience'), findsOneWidget);
    expect(find.textContaining('Parla only introduces experts'), findsOne);
    await _tap(tester, find.byKey(const ValueKey('call-dr-a')));
    await _tap(tester, find.byKey(const ValueKey('whatsapp-dr-a')));
    expect(opened, [
      Uri.parse('tel:+994501234567'),
      Uri.parse('https://wa.me/994501234567'),
    ]);
  });

  testWidgets('nutrition: the plate is kept, no calories, recipes add to '
      'the list', (tester) async {
    final app = await _open(tester);
    await _tap(tester, find.text('Nutrition').first);
    expect(find.text('0 of 6 groups'), findsOneWidget);
    expect(find.textContaining('do not count calories'), findsOneWidget);
    expect(find.text("Today's tip for your skin"), findsOneWidget);

    await _tap(tester, find.byKey(const ValueKey('plate-vegetables')));
    await _tap(tester, find.byKey(const ValueKey('plate-protein')));
    expect(find.text('2 of 6 groups'), findsOneWidget);
    final local = jsonDecode(app.nutrition.data['user-1']!) as Map;
    expect(local['plates'], {
      '2026-11-16': ['vegetables', 'protein'],
    });
    expect(app.api.nutrition, isNull);

    await _tap(tester, find.byKey(const ValueKey('recipe-oats')));
    expect(find.text('Oats en'), findsOneWidget);
    expect(find.text('4 tbsp en'), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('recipe-add')));
    expect(find.text('2 items added to your shopping list.'), findsOneWidget);
    final list = jsonDecode(app.careList.data['user-1']!) as Map;
    expect(
      [for (final i in list['shopping'] as List) (i as Map)['origin']],
      ['recipe', 'recipe'],
    );
  });

  testWidgets('with the health consent the plate is kept on the server', (
    tester,
  ) async {
    final app = await _open(tester, healthConsent: true);
    await _tap(tester, find.text('Nutrition').first);
    await _tap(tester, find.byKey(const ValueKey('plate-fruit')));
    expect(jsonDecode(app.api.nutrition!)['plates'], {
      '2026-11-16': ['fruit'],
    });
  });

  for (final language in ['az', 'ru', 'en']) {
    testWidgets('$language: Discover screens hold at 200% text', (
      tester,
    ) async {
      await _open(tester, language: language, textScale: 2);
      void check() {
        expect(tester.takeException(), isNull);
        for (final size in paintedFontSizes(tester)) {
          expect(size, greaterThanOrEqualTo(kMinTextSize));
        }
      }

      check();
      Future<void> open(String key) async {
        await _tap(tester, find.byKey(ValueKey(key)));
        check();
      }

      Future<void> back() => _tap(tester, find.byType(BackButton));

      // The article opens from Discover; back goes to the blog list,
      // then to Discover.
      await open('article-winter');
      await back();
      check();
      await back();
      const titles = {
        'az': ['Mütəxəssislər', 'Qidalanma'],
        'ru': ['Специалисты', 'Питание'],
        'en': ['Experts', 'Nutrition'],
      };
      for (final title in titles[language]!) {
        await _tap(tester, find.text(title));
        check();
        if (title == titles[language]!.last) {
          await open('recipe-oats');
          await back();
        }
        await back();
      }
    });
  }
}
