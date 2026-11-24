import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla/app.dart';
import 'package:parla/check/shop_screen.dart';
import 'package:parla/discover/banner_strip.dart';
import 'package:parla/discover/blog_widgets.dart';
import 'package:parla/discover/discover_bento.dart';
import 'package:parla/discover/discover_screens.dart';
import 'package:parla/discover/discover_widgets.dart';
import 'package:parla/push/push_client.dart';
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
      id: 40,
      kind: 'article',
      slug: 'markdown',
      category: 'care',
      publishedAt: DateTime.utc(2026, 11, 12),
      inlineImages: const [
        ContentImageRef(
          id: 9,
          url: 'https://media.test/inline.jpg',
          width: 800,
          height: 600,
          alt: {'en': 'A step photo'},
        ),
      ],
      data: {
        'title': _l('Markdown post'),
        'summary': _l('Formatted'),
        'body': {
          'en':
              '## Steps\n\nWater should be **lukewarm**.\n\n- Cream\n- SPF\n\n'
              '![A step](media:9)\n\n[Source](https://aad.org/x)',
        },
        'minutes': 3,
        'tags': {
          'en': ['drySkin', 'winter'],
          'az': ['quruDəri'],
        },
      },
    ),
    PublishedItem(
      id: 1,
      kind: 'article',
      slug: 'winter',
      category: 'care',
      publishedAt: DateTime.utc(2026, 11, 10),
      reviewedAt: DateTime.utc(2026, 11, 9),
      image: ContentImageRef(
        url: 'https://media.test/winter.jpg',
        width: 1600,
        height: 900,
        alt: _l('A jar of cream'),
      ),
      data: {
        'title': _l('Winter skin'),
        'summary': _l('Why skin dries'),
        'body': _l('First paragraph.\n\n## Habits\n\nSecond paragraph.'),
        'minutes': 4,
        'tips': [_l('Lukewarm water'), _l('Moisturise')],
        'sources': ['https://www.aad.org/dry-skin'],
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
  'banner': [
    PublishedItem(
      id: 20,
      kind: 'banner',
      slug: 'new-recipes',
      category: 'discover',
      publishedAt: DateTime.utc(2026, 11, 10),
      data: {
        'title': _l('New recipes'),
        'link': 'recipe:oats',
        'startsOn': '2026-11-01',
        'endsOn': '2026-11-30',
      },
    ),
    PublishedItem(
      id: 21,
      kind: 'banner',
      slug: 'brand-x',
      category: 'discover',
      publishedAt: DateTime.utc(2026, 11, 10),
      data: {
        'title': _l('Brand X cream'),
        'sponsor': 'Brand X',
        'startsOn': '2026-11-01',
        'endsOn': '2026-11-30',
      },
    ),
    PublishedItem(
      id: 22,
      kind: 'banner',
      slug: 'expired',
      category: 'discover',
      publishedAt: DateTime.utc(2026, 10, 1),
      data: {
        'title': _l('Old news'),
        'startsOn': '2026-10-01',
        'endsOn': '2026-10-31',
      },
    ),
    PublishedItem(
      id: 23,
      kind: 'banner',
      slug: 'russian-only',
      category: 'discover',
      publishedAt: DateTime.utc(2026, 11, 10),
      data: {
        'title': _l('For Russian'),
        'languages': ['ru'],
        'startsOn': '2026-11-01',
        'endsOn': '2026-11-30',
      },
    ),
    PublishedItem(
      id: 24,
      kind: 'banner',
      slug: 'today-only',
      category: 'today',
      publishedAt: DateTime.utc(2026, 11, 10),
      data: {
        'title': _l('On Today'),
        'startsOn': '2026-11-01',
        'endsOn': '2026-11-30',
      },
    ),
  ],
  'message': [
    PublishedItem(
      id: 30,
      kind: 'message',
      slug: 'nutrition-open',
      category: 'announcement',
      publishedAt: DateTime.utc(2026, 11, 10),
      data: {
        'title': _l('Nutrition is open'),
        'body': _l('Try the plate.'),
        'startsOn': '2026-11-01',
        'endsOn': '2026-11-30',
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
        'allergens': ['gluten', 'milk'],
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
  _App(this.api, this.nutrition, this.careList, this.journal);

  final FakeApi api;
  final MemoryHabitStore nutrition;
  final MemoryHabitStore careList;
  final MemoryHabitStore journal;
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
  final journal = MemoryHabitStore();
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
      journalStore: journal,
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(
    find
        .descendant(
          of: find.byType(ParlaNavBar),
          matching: find.byType(InkWell),
        )
        .at(3),
  );
  await tester.pumpAndSettle();
  return _App(api, nutrition, careList, journal);
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

// A 1×1 PNG.
final _pixel = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

class _FakePush implements PushClient {
  bool allow = true;
  final links = StreamController<String>.broadcast();

  @override
  String get platform => 'android';

  @override
  Future<bool> requestPermission() async => allow;

  @override
  Future<String?> token() async => 'phone-token';

  @override
  Stream<String> get openedLinks => links.stream;
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    ContentImage.provider = (_) => MemoryImage(_pixel);
  });

  test('a published item keeps its image in the offline copy', () {
    final item = _published['article']!.firstWhere((i) => i.slug == 'winter');
    final back = PublishedItem.fromJson(
      jsonDecode(jsonEncode(item.toJson())) as Map<String, Object?>,
    );
    expect(back.image!.url, 'https://media.test/winter.jpg');
    expect(back.image!.aspectRatio, closeTo(16 / 9, 0.01));
    expect(back.image!.alt['en'], 'A jar of cream en');
  });

  testWidgets('the bento shows the counts and opens sport', (tester) async {
    await _open(tester);
    // Each tile is one button; its words are read out together.
    expect(
      find.bySemanticsLabel(RegExp(r'^Blogs\. 3\. 3 articles · Care')),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel(RegExp(r'1 recipe')), findsOneWidget);
    // The large number and its caption on the nutrition tile.
    expect(
      find.descendant(
        of: find.byType(DiscoverBento),
        matching: find.text('recipe'),
      ),
      findsOneWidget,
    );
    // The Blogs tile shows the newest article's title.
    expect(
      find.descendant(
        of: find.byType(DiscoverBento),
        matching: find.text('New articles'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(DiscoverBento),
        matching: find.text('Fitness · Yoga · Face yoga'),
      ),
      findsOneWidget,
    );
    await _tap(tester, find.text('Fitness · Yoga · Face yoga'));
    expect(find.text('A workout plan made for you'), findsOneWidget);
  });

  testWidgets('blog list: counts, the newest large; a post: source pills, '
      'disclaimer and related articles', (tester) async {
    final opened = <Uri>[];
    final original = ExpertsScreen.launcher;
    ExpertsScreen.launcher = (uri) async {
      opened.add(uri);
      return true;
    };
    addTearDown(() => ExpertsScreen.launcher = original);
    await _open(tester);
    await _tap(tester, find.text('Blogs').first);
    expect(find.text('All  3', findRichText: true), findsOneWidget);
    expect(find.text('Care  2', findRichText: true), findsOneWidget);
    expect(find.text('Fashion  1', findRichText: true), findsOneWidget);
    // The newest article is the large card; the others are rows.
    expect(
      find.descendant(
        of: find.byType(FeaturedArticleCard),
        matching: find.text('Markdown post en'),
      ),
      findsOneWidget,
    );
    expect(find.byType(ArticleRow), findsNWidgets(2));
    await _tap(tester, find.byKey(const ValueKey('cat-fashion')));
    expect(find.byType(FeaturedArticleCard), findsOneWidget);
    expect(find.byType(ArticleRow), findsNothing);
    await _tap(tester, find.byKey(const ValueKey('cat-all')));

    await _tap(tester, find.byKey(const ValueKey('article-winter')));
    final page = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.textContaining('replace a doctor'),
      200,
      scrollable: page,
    );
    expect(find.byType(SourceChips), findsOneWidget);
    // Related: the other article of the same category.
    expect(find.byKey(const ValueKey('related-markdown')), findsOneWidget);
    expect(find.byKey(const ValueKey('related-capsule')), findsNothing);
    await _tap(tester, find.byKey(const ValueKey('related-markdown')));
    expect(find.text('Markdown post en'), findsOneWidget);
    expect(find.byKey(const ValueKey('related-winter')), findsOneWidget);
  });

  testWidgets('journal: write, edit and delete entries; kept on the phone '
      'only', (tester) async {
    final app = await _open(tester);
    final tile = find.byKey(const ValueKey('discover-journal'));
    await tester.scrollUntilVisible(
      tile,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await _tap(tester, tile);
    expect(find.text('No entries yet.'), findsOneWidget);
    expect(find.textContaining('the Parla team cannot see them'), findsOne);

    // A new entry is kept when leaving with Back.
    await _tap(tester, find.byKey(const ValueKey('journal-new')));
    await tester.enterText(
      find.byKey(const ValueKey('journal-text')),
      'A calm day. Walked by the sea.',
    );
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('A calm day. Walked by the sea.'), findsOneWidget);
    final stored =
        jsonDecode(app.journal.data.values.single) as Map<String, Object?>;
    final entries = (stored['entries']! as List).cast<Map>();
    expect(entries.single['text'], 'A calm day. Walked by the sea.');

    // Blank new entries keep nothing.
    await _tap(tester, find.byKey(const ValueKey('journal-new')));
    await _tap(tester, find.byKey(const ValueKey('journal-save')));
    expect(find.byType(Card), findsNothing);
    final id = entries.single['id']! as String;
    expect(find.byKey(ValueKey('journal-$id')), findsOneWidget);
    expect(
      (jsonDecode(app.journal.data.values.single)['entries'] as List).length,
      1,
    );

    // Edit, then delete after a confirmation.
    await _tap(tester, find.byKey(ValueKey('journal-$id')));
    await tester.enterText(
      find.byKey(const ValueKey('journal-text')),
      'A calm day.',
    );
    await _tap(tester, find.byKey(const ValueKey('journal-save')));
    expect(find.text('A calm day.'), findsOneWidget);
    await _tap(tester, find.byKey(ValueKey('journal-$id')));
    await _tap(tester, find.byKey(const ValueKey('journal-delete')));
    await _tap(tester, find.byKey(const ValueKey('journal-delete-confirm')));
    expect(find.text('No entries yet.'), findsOneWidget);
    expect(
      (jsonDecode(app.journal.data.values.single)['entries'] as List),
      isEmpty,
    );
  });

  testWidgets('blogs: newest on Discover, filter, the article with its '
      'expert review and steps', (tester) async {
    final opened = <Uri>[];
    final original = ExpertsScreen.launcher;
    ExpertsScreen.launcher = (uri) async {
      opened.add(uri);
      return true;
    };
    addTearDown(() => ExpertsScreen.launcher = original);
    await _open(tester);
    await tester.scrollUntilVisible(
      find.text('New articles'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('New articles'), findsOneWidget);
    await _tap(tester, find.text('Blogs').first);
    expect(find.text('Winter skin en'), findsOneWidget);
    expect(find.text('Capsule wardrobe en'), findsOneWidget);

    await _tap(tester, find.byKey(const ValueKey('cat-fashion')));
    expect(find.text('Winter skin en'), findsNothing);
    await _tap(tester, find.byKey(const ValueKey('cat-all')));

    // The cover shows on the card and the page, with its alt text.
    expect(find.bySemanticsLabel(RegExp('A jar of cream en')), findsWidgets);
    await _tap(tester, find.byKey(const ValueKey('article-winter')));
    expect(find.bySemanticsLabel(RegExp('A jar of cream en')), findsOneWidget);
    expect(find.text('First paragraph.'), findsOneWidget);
    expect(find.text('Second paragraph. en'), findsOneWidget);
    expect(find.textContaining('Reviewed by an expert'), findsOneWidget);
    expect(find.text('Moisturise en'), findsOneWidget);
    // "## " starts a heading; sources open in the browser.
    expect(find.text('Habits'), findsOneWidget);
    expect(find.textContaining('##'), findsNothing);
    await _tap(
      tester,
      find.byKey(const ValueKey('blog-source-https://www.aad.org/dry-skin')),
    );
    expect(opened, [Uri.parse('https://www.aad.org/dry-skin')]);
    expect(find.text('aad.org'), findsOneWidget);
  });

  testWidgets('banners: dates and language decide on the phone; ads are '
      'labelled; links open in the app', (tester) async {
    await _open(tester);
    expect(find.text('New recipes en'), findsOneWidget);
    expect(find.text('Brand X cream en'), findsOneWidget);
    expect(find.text('Ad · Brand X'), findsOneWidget);
    expect(find.text('Old news en'), findsNothing);
    expect(find.text('For Russian en'), findsNothing);
    expect(find.text('On Today en'), findsNothing);
    // The Today banner shows on the home screen.
    await tester.tap(
      find
          .descendant(
            of: find.byType(ParlaNavBar),
            matching: find.byType(InkWell),
          )
          .at(0),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('On Today en'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('On Today en'), findsOneWidget);
    // A banner opens its in-app link.
    await _open(tester);
    await _tap(tester, find.byKey(const ValueKey('banner-new-recipes')));
    expect(find.text('Oats en'), findsOneWidget);
  });

  testWidgets('ads under articles and recipes follow the topic; a brand '
      'site opens only after asking, with Parla tags only', (tester) async {
    final opened = <Uri>[];
    final original = BannerCard.launcher;
    BannerCard.launcher = (uri) async {
      opened.add(uri);
      return true;
    };
    addTearDown(() => BannerCard.launcher = original);
    PublishedItem ad(int id, String slug, String placement, Object? data) =>
        PublishedItem(
          id: id,
          kind: 'banner',
          slug: slug,
          category: placement,
          publishedAt: DateTime.utc(2026, 11, 10),
          data: {
            'startsOn': '2026-11-01',
            'endsOn': '2026-11-30',
            ...data! as Map<String, Object?>,
          },
        );
    await _open(
      tester,
      published: {
        ..._published,
        'banner': [
          ..._published['banner']!,
          ad(25, 'care-ad', 'blog', {
            'title': _l('Care cream'),
            'sponsor': 'Brand X',
            'campaign': 7,
            'url': 'https://brand.az/cream?ref=1',
            'topics': ['care'],
          }),
          ad(26, 'fashion-ad', 'blog', {
            'title': _l('Fashion bag'),
            'sponsor': 'Brand Y',
            'topics': ['fashion'],
          }),
          ad(27, 'recipe-ad', 'recipe', {
            'title': _l('Kitchen scale'),
            'sponsor': 'Brand Z',
          }),
        ],
      },
    );
    // Not on Discover: these belong under articles and recipes.
    expect(find.text('Care cream en'), findsNothing);
    await _tap(tester, find.text('Blogs').first);
    await _tap(tester, find.byKey(const ValueKey('article-winter')));
    await tester.scrollUntilVisible(
      find.text('Care cream en'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Ad · Brand X'), findsOneWidget);
    expect(find.text('Fashion bag en'), findsNothing);

    // Leaving the app is asked first; cancelling opens nothing.
    await _tap(tester, find.byKey(const ValueKey('banner-care-ad')));
    expect(find.textContaining('brand.az will open'), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('banner-leave-cancel')));
    expect(opened, isEmpty);
    await _tap(tester, find.byKey(const ValueKey('banner-care-ad')));
    await _tap(tester, find.byKey(const ValueKey('banner-leave-go')));
    expect(opened.single.host, 'brand.az');
    expect(opened.single.queryParameters, {
      'ref': '1',
      'utm_source': 'parla',
      'utm_medium': 'app',
      'utm_campaign': 'parla-7',
    });

    // Under a recipe: the recipe placement only.
    await _open(
      tester,
      published: {
        ..._published,
        'banner': [
          ..._published['banner']!,
          ad(27, 'recipe-ad', 'recipe', {
            'title': _l('Kitchen scale'),
            'sponsor': 'Brand Z',
          }),
        ],
      },
    );
    await _tap(tester, find.byKey(const ValueKey('banner-new-recipes')));
    await tester.scrollUntilVisible(
      find.text('Kitchen scale en'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Ad · Brand Z'), findsOneWidget);
  });

  testWidgets('shop: partner products, ads first and labelled, the '
      'partner site only after asking; in-app sales stay hidden', (
    tester,
  ) async {
    final opened = <Uri>[];
    final original = BannerCard.launcher;
    BannerCard.launcher = (uri) async {
      opened.add(uri);
      return true;
    };
    addTearDown(() => BannerCard.launcher = original);
    PublishedItem product(
      int id,
      String slug,
      String category,
      Map<String, Object?> data,
    ) => PublishedItem(
      id: id,
      kind: 'product',
      slug: slug,
      category: category,
      publishedAt: DateTime.utc(2026, 11, id),
      data: {
        'brand': 'Brand',
        'price': '12.50',
        'sale': 'redirect',
        'url': 'https://partner.az/p/$slug',
        ...data,
      },
    );
    await _open(
      tester,
      published: {
        ..._published,
        'product': [
          product(1, 'cream', 'face', {'name': _l('Day cream')}),
          product(2, 'serum', 'face', {
            'name': _l('Serum'),
            'campaign': 4,
            'sponsor': 'Brand X',
          }),
          product(3, 'shampoo', 'hair', {'name': _l('Shampoo')}),
          product(4, 'own', 'face', {
            'name': _l('Own sale'),
            'sale': 'own',
            'seller': 'parla',
          })..data.remove('url'),
        ],
      },
    );
    await _tap(tester, find.text('Shop').first);
    expect(find.text('Day cream en'), findsOneWidget);
    expect(find.text('Shampoo en'), findsOneWidget);
    expect(find.text('Own sale en'), findsNothing);
    expect(find.text('Ad · Brand X'), findsOneWidget);
    // The campaign product comes first.
    expect(
      tester.getTopLeft(find.text('Serum en')).dy,
      lessThan(tester.getTopLeft(find.text('Day cream en')).dy),
    );
    await _tap(tester, find.byKey(const ValueKey('shop-cat-hair')));
    expect(find.text('Day cream en'), findsNothing);
    expect(find.text('Shampoo en'), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('shop-cat-all')));

    await _tap(tester, find.byKey(const ValueKey('product-serum')));
    expect(find.text('12.50 ₼'), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('shop-visit')));
    expect(find.textContaining('partner.az will open'), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('banner-leave-go')));
    expect(opened.single.path, '/p/serum');
    expect(opened.single.queryParameters, {
      'utm_source': 'parla',
      'utm_medium': 'app',
      'utm_campaign': 'parla-4',
    });
  });

  testWidgets('shop sales: shown only when open; buying asks first, opens '
      'Epoint and lists the order', (tester) async {
    final opened = <Uri>[];
    final original = BannerCard.launcher;
    BannerCard.launcher = (uri) async {
      opened.add(uri);
      return true;
    };
    addTearDown(() => BannerCard.launcher = original);
    addTearDown(() => ShopSales.open.value = false);
    final own = PublishedItem(
      id: 9,
      kind: 'product',
      slug: 'own-cream',
      category: 'face',
      publishedAt: DateTime.utc(2026, 11, 9),
      data: {
        'name': _l('Own cream'),
        'brand': 'Brand Y',
        'price': '12.50',
        'sale': 'own',
        'seller': 'brand',
      },
    );
    final app = await _open(
      tester,
      published: {
        ..._published,
        'product': [own],
      },
    );
    await _tap(tester, find.text('Shop').first);
    expect(find.text('Own cream en'), findsNothing);
    expect(find.byKey(const ValueKey('shop-orders')), findsNothing);

    // Sales open: the product, the button and "My orders".
    app.api.salesOpen = true;
    await _tap(tester, find.byType(BackButton).first);
    await _tap(tester, find.text('Shop').first);
    expect(find.text('Own cream en'), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('product-own-cream')));
    expect(find.byKey(const ValueKey('shop-visit')), findsNothing);
    await _tap(tester, find.byKey(const ValueKey('shop-buy')));
    expect(
      find.textContaining('Sold by Brand Y; Parla takes the payment.'),
      findsOneWidget,
    );
    expect(find.textContaining('never reach Parla'), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('shop-buy-cancel')));
    expect(app.api.startedOrders, isEmpty);

    await _tap(tester, find.byKey(const ValueKey('shop-buy')));
    await _tap(tester, find.byKey(const ValueKey('shop-buy-go')));
    expect(app.api.startedOrders, ['own-cream:1:en']);
    expect(opened.single, Uri.parse('https://epoint.test/P1'));
    // "My orders" asks Epoint about the waiting order.
    expect(find.text('My orders'), findsWidgets);
    expect(find.text('Paid'), findsOneWidget);
    expect(find.text('12.50 ₼'), findsOneWidget);
  });

  testWidgets('messages: announcements, and a support conversation', (
    tester,
  ) async {
    final app = await _open(tester);
    app.api
      ..support.add(
        SupportItem(
          fromTeam: true,
          text: 'Hello from the team',
          at: DateTime.utc(2026, 11, 15),
        ),
      )
      ..supportUnread = true;
    // Back to the home tab: the button shows the unread reply.
    await tester.tap(
      find
          .descendant(
            of: find.byType(ParlaNavBar),
            matching: find.byType(InkWell),
          )
          .at(0),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('home-messages-dot')), findsOneWidget);
    await _tap(tester, find.byKey(const ValueKey('home-messages')));
    expect(find.text('Nutrition is open en'), findsOneWidget);
    expect(find.text('Hello from the team'), findsOneWidget);
    expect(find.textContaining('stored encrypted'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('support-text')),
      'My skin feels tight',
    );
    await _tap(tester, find.byKey(const ValueKey('support-send')));
    expect(app.api.support.last.text, 'My skin feels tight');
    expect(find.text('My skin feels tight'), findsOneWidget);
  });

  testWidgets('notifications: on and off from Messages; a tapped '
      'notification opens its link', (tester) async {
    final push = _FakePush();
    PushService.client = push;
    addTearDown(() => PushService.client = null);
    final app = await _open(tester);
    await tester.tap(
      find
          .descendant(
            of: find.byType(ParlaNavBar),
            matching: find.byType(InkWell),
          )
          .at(0),
    );
    await tester.pumpAndSettle();
    await _tap(tester, find.byKey(const ValueKey('home-messages')));
    await _tap(tester, find.byKey(const ValueKey('push-switch')));
    expect(app.api.pushTokens, {'phone-token'});
    await _tap(tester, find.byKey(const ValueKey('push-switch')));
    expect(app.api.pushTokens, isEmpty);

    // Permission refused: nothing is registered.
    push.allow = false;
    await _tap(tester, find.byKey(const ValueKey('push-switch')));
    expect(app.api.pushTokens, isEmpty);
    expect(find.textContaining('not allowed'), findsOneWidget);

    push.links.add('nutrition');
    await tester.pumpAndSettle();
    expect(find.text('0 of 6 groups'), findsOneWidget);
  });

  testWidgets('articles: Markdown, inline images, links and hashtags', (
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
    await _tap(tester, find.text('Blogs').first);
    await _tap(tester, find.byKey(const ValueKey('article-markdown')));
    expect(find.text('Steps'), findsOneWidget);
    expect(find.textContaining('**'), findsNothing);
    expect(find.textContaining('Cream'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('A step photo')), findsWidgets);
    await _tap(tester, find.textContaining('Source'));
    expect(opened, [Uri.parse('https://aad.org/x')]);

    // Hashtags in the user's language; tapping one filters the list.
    expect(find.text('#quruDəri'), findsNothing);
    await _tap(tester, find.byKey(const ValueKey('tag-winter')));
    expect(find.byKey(const ValueKey('active-tag')), findsOneWidget);
    expect(find.text('Markdown post en'), findsOneWidget);
    expect(find.text('Winter skin en'), findsNothing);
    await _tap(tester, find.byKey(const ValueKey('active-tag-clear')));
    expect(find.text('Winter skin en'), findsOneWidget);
  });

  test('inline images and tags survive the offline copy', () {
    final item = _published['article']!.firstWhere(
      (i) => i.slug == 'markdown',
    );
    final back = PublishedItem.fromJson(
      jsonDecode(jsonEncode(item.toJson())) as Map<String, Object?>,
    );
    expect(back.inlineImages.single.id, 9);
    expect(back.tags('en'), ['drySkin', 'winter']);
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

  testWidgets('experts: a sample profile is marked and dials no one', (
    tester,
  ) async {
    final opened = <Uri>[];
    final original = ExpertsScreen.launcher;
    ExpertsScreen.launcher = (uri) async {
      opened.add(uri);
      return true;
    };
    addTearDown(() => ExpertsScreen.launcher = original);
    await _open(
      tester,
      published: {
        ..._published,
        'expert': [
          PublishedItem(
            id: 9,
            kind: 'expert',
            slug: 'sample-dermatologist-1',
            category: 'dermatologist',
            publishedAt: DateTime.utc(2026, 11, 20),
            data: {
              'sample': true,
              'name': 'Nümunə Dermatoloq 1',
              'workplace': _l('Sample clinic'),
              'city': _l('Baku'),
              'years': 12,
              'phone': '+994000000001',
              'whatsapp': '+994000000001',
            },
          ),
        ],
      },
    );
    await _tap(tester, find.text('Experts').first);
    expect(
      find.byKey(const ValueKey('sample-sample-dermatologist-1')),
      findsOneWidget,
    );
    await _tap(
      tester,
      find.byKey(const ValueKey('call-sample-dermatologist-1')),
    );
    await _tap(
      tester,
      find.byKey(const ValueKey('whatsapp-sample-dermatologist-1')),
    );
    expect(opened, isEmpty);
    expect(find.textContaining('sample profile'), findsOneWidget);
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
    expect(find.text("Tip of the day"), findsOneWidget);

    await _tap(tester, find.byKey(const ValueKey('plate-vegetables')));
    await _tap(tester, find.byKey(const ValueKey('plate-protein')));
    expect(find.text('2 of 6 groups'), findsOneWidget);
    final local = jsonDecode(app.nutrition.data['user-1']!) as Map;
    expect(local['plates'], {
      '2026-11-16': ['vegetables', 'protein'],
    });
    expect(app.api.nutrition, isNull);

    // Meal pills filter the recipes; the recipe opens on its cover.
    await _tap(tester, find.byKey(const ValueKey('cat-dinner')));
    expect(find.byKey(const ValueKey('recipe-oats')), findsNothing);
    await _tap(tester, find.byKey(const ValueKey('cat-breakfast')));
    await _tap(tester, find.byKey(const ValueKey('recipe-oats')));
    expect(find.byType(CoverPage), findsOneWidget);
    expect(find.text('Oats en'), findsOneWidget);
    expect(find.text('4 tbsp en'), findsOneWidget);
    expect(find.text('Contains: gluten, milk'), findsOneWidget);
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
