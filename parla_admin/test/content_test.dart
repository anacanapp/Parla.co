import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:parla_admin/api/admin_api.dart';
import 'package:parla_admin/app.dart';
import 'package:parla_admin/markdown/markdown_field.dart';
import 'package:parla_admin/media/image_field.dart';
import 'package:parla_shared/parla_shared.dart';

import 'fake_admin_api.dart';

Future<FakeAdminApi> _pump(WidgetTester tester, StaffRole role) async {
  tester.view.physicalSize = const Size(1400, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final api = FakeAdminApi()
    ..signedIn = true
    ..meValue = StaffMe(role: role, totpEnrolled: true, verified: true);
  await tester.pumpWidget(AdminApp(api: api));
  await tester.pumpAndSettle();
  return api;
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _type(WidgetTester tester, String key, String text) async {
  final f = find.byKey(ValueKey(key));
  await tester.ensureVisible(f);
  await tester.enterText(f, text);
  await tester.pump();
}

void main() {
  testWidgets('an editor writes an article in three languages and sends '
      'it for review', (tester) async {
    final api = await _pump(tester, StaffRole.editor);
    await _tap(tester, _nav('Məzmun'));
    expect(find.text('Hələ heç nə yoxdur.'), findsOneWidget);

    await _tap(tester, find.byKey(const ValueKey('content-new')));
    await tester.enterText(find.byKey(const ValueKey('new-slug')), 'qis');
    await _tap(tester, find.byKey(const ValueKey('new-create')));

    await _type(tester, 'field-title-az', 'Qışda dəri');
    await _type(tester, 'field-summary-az', 'Qısa');
    await _type(tester, 'field-body-az', 'Mətn');
    await _type(tester, 'field-tips-az', 'Ilıq su\nNəmləndirici');
    await _type(tester, 'field-minutes', '4');
    // Russian and English still missing.
    expect(find.byKey(const ValueKey('content-problems')), findsOneWidget);

    await _tap(tester, find.text('Русский'));
    await _type(tester, 'field-title-ru', 'Кожа зимой');
    await _tap(tester, find.byKey(const ValueKey('content-save')));
    final saved = api.calls.lastWhere((c) => c.startsWith('save:'));
    final json = jsonDecode(saved.substring(saved.indexOf('{'))) as Map;
    expect(json['title'], {'az': 'Qışda dəri', 'ru': 'Кожа зимой'});
    expect(json['tips'], [
      {'az': 'Ilıq su'},
      {'az': 'Nəmləndirici'},
    ]);
    expect(json['minutes'], 4);

    await _tap(tester, find.byKey(const ValueKey('content-submit')));
    expect(find.text('Yoxlamada'), findsWidgets);
    // Editors cannot approve.
    expect(find.byKey(const ValueKey('content-approve')), findsNothing);
  });

  testWidgets('an expert approves or returns with a note; editors publish', (
    tester,
  ) async {
    final api = await _pump(tester, StaffRole.expert);
    final item = await api.createContent('article', 'spf', 'care');
    await api.submitContent(item.id);

    await _tap(tester, _nav('Məzmun'));
    // Experts cannot create.
    expect(find.byKey(const ValueKey('content-new')), findsNothing);
    await _tap(tester, find.byKey(ValueKey('content-${item.id}')));
    expect(find.byKey(const ValueKey('content-save')), findsNothing);

    await _tap(tester, find.byKey(const ValueKey('content-return')));
    await tester.enterText(find.byKey(const ValueKey('ask-field')), 'Mənbə?');
    await _tap(tester, find.byKey(const ValueKey('ask-ok')));
    expect(find.text('Mütəxəssisin qeydi'), findsOneWidget);
    expect(find.text('Mənbə?'), findsOneWidget);

    await api.submitContent(item.id);
    await api.approveContent(item.id);
    expect(
      (await api.listContent('article')).single.status,
      ContentStatus.approved,
    );
  });

  testWidgets('expert profiles: the admin records consent, then publishes', (
    tester,
  ) async {
    final api = await _pump(tester, StaffRole.admin);
    final item = await api.createContent('expert', 'dr-a', 'dermatologist');
    await _tap(tester, _nav('Məzmun'));
    await _tap(tester, find.text('Mütəxəssislər'));
    await _tap(tester, find.byKey(ValueKey('content-${item.id}')));
    expect(find.byKey(const ValueKey('content-publish')), findsNothing);

    await _tap(tester, find.byKey(const ValueKey('content-consent')));
    await tester.enterText(
      find.byKey(const ValueKey('ask-field')),
      'Forma #1, seyf',
    );
    await _tap(tester, find.byKey(const ValueKey('ask-ok')));
    await _tap(tester, find.byKey(const ValueKey('content-publish')));
    expect(find.text('canlı'), findsWidgets);
    expect((await api.listContent('expert')).single.live, isTrue);
  });

  testWidgets('admins import the sheet once; editors do not see the button', (
    tester,
  ) async {
    final api = await _pump(tester, StaffRole.admin);
    api.sheet = [
      (
        'article',
        'winter',
        'body',
        jsonEncode({
          'title': {'az': 'Qış'},
          'body': {'az': '${ContentRules.planMarker}: sil]\n## Başlıq'},
          'sources': ['https://www.aad.org/a'],
        }),
      ),
    ];
    await _tap(tester, _nav('Məzmun'));
    await _tap(tester, find.byKey(const ValueKey('content-import')));
    await _tap(tester, find.byKey(const ValueKey('import-yes')));
    expect(find.text('1 yazı qaralama kimi əlavə olundu.'), findsOneWidget);
    expect(find.text('Qış'), findsOneWidget);
    expect(find.textContaining('Bədən'), findsOneWidget);

    await _tap(tester, find.byKey(const ValueKey('content-import')));
    await _tap(tester, find.byKey(const ValueKey('import-yes')));
    expect(find.text('0 yazı qaralama kimi əlavə olundu.'), findsOneWidget);

    await _tap(tester, find.text('Qış'));
    expect(find.byKey(const ValueKey('content-plan-left')), findsOneWidget);
    final sources = tester.widget<TextField>(
      find.byKey(const ValueKey('field-sources')),
    );
    expect(sources.controller!.text, 'https://www.aad.org/a');
  });

  testWidgets('editors do not see the import button', (tester) async {
    await _pump(tester, StaffRole.editor);
    await _tap(tester, _nav('Məzmun'));
    expect(find.byKey(const ValueKey('content-import')), findsNothing);
  });

  testWidgets('recipe allergens: none must be chosen on purpose', (
    tester,
  ) async {
    final api = await _pump(tester, StaffRole.editor);
    await _tap(tester, _nav('Məzmun'));
    await _tap(tester, find.text('Reseptlər'));
    await _tap(tester, find.byKey(const ValueKey('content-new')));
    await tester.enterText(find.byKey(const ValueKey('new-slug')), 'oats');
    await _tap(tester, find.byKey(const ValueKey('new-create')));

    Map<String, Object?> saved() {
      final call = api.calls.lastWhere((c) => c.startsWith('save:'));
      return jsonDecode(call.substring(call.indexOf('{')))
          as Map<String, Object?>;
    }

    await _tap(tester, find.byKey(const ValueKey('content-save')));
    expect(saved().containsKey('allergens'), isFalse);

    await _tap(tester, find.byKey(const ValueKey('allergen-none')));
    await _tap(tester, find.byKey(const ValueKey('content-save')));
    expect(saved()['allergens'], isEmpty);

    await _tap(tester, find.byKey(const ValueKey('allergen-milk')));
    await _tap(tester, find.byKey(const ValueKey('allergen-gluten')));
    await _tap(tester, find.byKey(const ValueKey('content-save')));
    expect(saved()['allergens'], ['gluten', 'milk']);
  });

  testWidgets('an editor uploads a shrunk image with licence and alt text', (
    tester,
  ) async {
    final big = img.Image(width: 3200, height: 1600);
    img.fill(big, color: img.ColorRgb8(200, 150, 120));
    final file = img.encodePng(big);
    final original = pickImageFile;
    pickImageFile = () async => file;
    addTearDown(() => pickImageFile = original);

    final api = await _pump(tester, StaffRole.editor);
    await _tap(tester, _nav('Məzmun'));
    await _tap(tester, find.byKey(const ValueKey('content-new')));
    await tester.enterText(find.byKey(const ValueKey('new-slug')), 'krem');
    await _tap(tester, find.byKey(const ValueKey('new-create')));

    await _tap(tester, find.byKey(const ValueKey('image-upload')));
    // A licence is required.
    await _tap(tester, find.byKey(const ValueKey('image-save')));
    expect(find.byKey(const ValueKey('image-error')), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('image-license')),
      'Öz fotomuz',
    );
    await tester.enterText(
      find.byKey(const ValueKey('image-alt-az')),
      'Krem qabı',
    );
    await _tap(tester, find.byKey(const ValueKey('image-save')));

    final upload = api.calls.singleWhere((c) => c.startsWith('upload:'));
    expect(upload, contains(':Öz fotomuz:'));
    // Shrunk to at most 1600 px and re-encoded as JPEG before upload.
    final sent = img.decodeJpg(api.imageBytes.values.single)!;
    expect((sent.width, sent.height), (1600, 800));
    expect(find.text('Krem qabı'), findsOneWidget);
    expect(find.byKey(const ValueKey('image-missing')), findsOneWidget);

    await _tap(tester, find.byKey(const ValueKey('content-save')));
    final saved = api.calls.lastWhere((c) => c.startsWith('save:'));
    final json = jsonDecode(saved.substring(saved.indexOf('{'))) as Map;
    expect(json['image'], api.images.single.id);

    await _tap(tester, find.byKey(const ValueKey('image-remove')));
    await _tap(tester, find.byKey(const ValueKey('content-save')));
    final again = api.calls.lastWhere((c) => c.startsWith('save:'));
    expect(
      jsonDecode(again.substring(again.indexOf('{'))),
      isNot(contains('image')),
    );

    await _tap(tester, find.byKey(const ValueKey('image-library')));
    await _tap(tester, find.byKey(ValueKey('library-${api.images.single.id}')));
    expect(find.text('Krem qabı'), findsOneWidget);
  });

  testWidgets('catalogue texts start from the app texts; hiding is direct', (
    tester,
  ) async {
    final api = await _pump(tester, StaffRole.editor);
    await _tap(tester, _nav('Məzmun'));
    await _tap(tester, find.text('Məşqlər'));
    expect(find.byKey(const ValueKey('content-new')), findsNothing);
    expect(find.text('tətbiqdəki mətn'), findsNothing);
    expect(find.textContaining('tətbiqdəki mətn'), findsWidgets);

    await _tap(tester, find.byKey(const ValueKey('catalogue-squat')));
    final saved = api.calls.lastWhere((c) => c.startsWith('save:'));
    final json = jsonDecode(saved.substring(saved.indexOf('{'))) as Map;
    expect(
      json,
      ContentRules.catalogueDefaults(ContentKind.exercise, 'squat'),
    );
    expect(find.byKey(const ValueKey('field-name-az')), findsOneWidget);
    expect(find.byKey(const ValueKey('image-field')), findsOneWidget);
    expect(find.byKey(const ValueKey('content-category')), findsNothing);

    await _tap(tester, find.byKey(const ValueKey('content-hidden')));
    expect(api.calls.last, startsWith('hidden:'));
    expect(api.calls.last, endsWith(':true'));

    // Preferences and steps have no image.
    await _tap(tester, _nav('Məzmun'));
    await _tap(tester, find.text('Seçimlər'));
    await _tap(tester, find.byKey(const ValueKey('catalogue-fragrance_free')));
    expect(find.byKey(const ValueKey('image-field')), findsNothing);
  });

  testWidgets('banners: admins publish their own; brand ads need review', (
    tester,
  ) async {
    final api = await _pump(tester, StaffRole.admin);
    await _tap(tester, _nav('Məzmun'));
    await _tap(tester, find.text('Bannerlər'));
    await _tap(tester, find.byKey(const ValueKey('content-new')));
    await tester.enterText(find.byKey(const ValueKey('new-slug')), 'qidalanma');
    await _tap(tester, find.byKey(const ValueKey('new-create')));

    await _type(tester, 'field-title-az', 'Yeni bölmə');
    await _type(tester, 'field-link', 'nutrition');
    await _type(tester, 'field-startsOn', '2026-12-01');
    await _type(tester, 'field-endsOn', '2026-12-31');
    await _tap(tester, find.byKey(const ValueKey('multi-languages-az')));
    await _tap(tester, find.byKey(const ValueKey('content-save')));
    final saved = api.calls.lastWhere((c) => c.startsWith('save:'));
    final json = jsonDecode(saved.substring(saved.indexOf('{'))) as Map;
    expect(json['languages'], ['az']);
    expect(json.containsKey('countries'), isFalse);
    // The team's own banner: the admin may publish without a review.
    expect(find.byKey(const ValueKey('content-publish')), findsOneWidget);
    expect(find.byKey(const ValueKey('banner-ad-note')), findsNothing);

    await _type(tester, 'field-sponsor', 'Brand X');
    expect(find.byKey(const ValueKey('banner-ad-note')), findsOneWidget);
    expect(find.byKey(const ValueKey('content-publish')), findsNothing);
  });

  testWidgets('push: an admin sends once after confirming', (tester) async {
    final api = await _pump(tester, StaffRole.admin);
    await _tap(tester, _nav('Məzmun'));
    await _tap(tester, find.text('Push'));
    await _tap(tester, find.byKey(const ValueKey('content-new')));
    await tester.enterText(find.byKey(const ValueKey('new-slug')), 'yeni');
    await _tap(tester, find.byKey(const ValueKey('new-create')));
    expect(find.byKey(const ValueKey('image-field')), findsNothing);
    await _type(tester, 'field-title-az', 'Yeni reseptlər');
    await _type(tester, 'field-body-az', 'Bax');
    await _tap(tester, find.byKey(const ValueKey('content-save')));

    await _tap(tester, find.byKey(const ValueKey('content-publish')));
    expect(find.textContaining('Geri almaq olmur'), findsOneWidget);
    await _tap(tester, find.text('Ləğv et'));
    expect(api.calls.where((c) => c.startsWith('publish')), isEmpty);

    await _tap(tester, find.byKey(const ValueKey('content-publish')));
    await _tap(tester, find.byKey(const ValueKey('push-confirm')));
    expect(api.calls.where((c) => c.startsWith('publish')), hasLength(1));
  });

  testWidgets('blog: paste from Google Docs, hashtags, inline image, preview', (
    tester,
  ) async {
    final original = readRichClipboard;
    readRichClipboard = () async =>
        '<b style="font-weight:normal"><h2><span>Qış qaydaları</span></h2>'
        '<p><span>Su </span><span style="font-weight:700">ılıq</span>'
        '<span> olsun.</span></p><ul><li><p>Krem</p></li></ul></b>';
    addTearDown(() => readRichClipboard = original);

    final api = await _pump(tester, StaffRole.editor);
    api.images.add(
      MediaAdminItem(
        id: 77,
        pixelWidth: 40,
        pixelHeight: 30,
        bytes: 10,
        license: 'Öz fotomuz',
        altJson: jsonEncode({'az': 'Krem qabı'}),
        public: false,
        createdAt: DateTime.utc(2026, 11, 17),
      ),
    );
    api.imageBytes[77] = Uint8List.fromList(
      img.encodePng(img.Image(width: 2, height: 2)),
    );
    await _tap(tester, _nav('Məzmun'));
    await _tap(tester, find.byKey(const ValueKey('content-new')));
    await tester.enterText(find.byKey(const ValueKey('new-slug')), 'qis');
    await _tap(tester, find.byKey(const ValueKey('new-create')));

    await _type(tester, 'field-title-az', 'Qışda dəri');
    await _type(tester, 'field-tags-az', '#quruDəri, qış #quruDəri bad-tag');
    await _tap(tester, find.byKey(const ValueKey('md-paste-body-az')));
    await _tap(tester, find.byKey(const ValueKey('md-image-body-az')));
    await _tap(tester, find.byKey(const ValueKey('image-library')).last);
    await _tap(tester, find.byKey(const ValueKey('library-77')));

    await _tap(tester, find.byKey(const ValueKey('content-save')));
    final saved = api.calls.lastWhere((c) => c.startsWith('save:'));
    final json = jsonDecode(saved.substring(saved.indexOf('{'))) as Map;
    final body = (json['body'] as Map)['az'] as String;
    expect(body, contains('### Qış qaydaları'));
    expect(body, contains('Su **ılıq** olsun.'));
    expect(body, contains('- Krem'));
    expect(body, contains('![](media:77)'));
    expect(json['tags'], {
      'az': ['quruDəri', 'qış'],
    });

    await _tap(tester, find.byKey(const ValueKey('md-preview-body-az')));
    expect(
      find.byKey(const ValueKey('md-preview-box-body-az')),
      findsOneWidget,
    );
    expect(find.text('Qış qaydaları'), findsOneWidget);
  });
}

/// A menu entry (the overview's guide cards repeat the same names).
Finder _nav(String label) => find.descendant(
  of: find.byType(NavigationRail),
  matching: find.text(label),
);
