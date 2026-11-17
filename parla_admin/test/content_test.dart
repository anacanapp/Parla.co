import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:parla_admin/api/admin_api.dart';
import 'package:parla_admin/app.dart';
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
    await _tap(tester, find.text('Məzmun'));
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

    await _tap(tester, find.text('Məzmun'));
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
    await _tap(tester, find.text('Məzmun'));
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
    await _tap(tester, find.text('Məzmun'));
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
    await _tap(tester, find.text('Məzmun'));
    expect(find.byKey(const ValueKey('content-import')), findsNothing);
  });

  testWidgets('recipe allergens: none must be chosen on purpose', (
    tester,
  ) async {
    final api = await _pump(tester, StaffRole.editor);
    await _tap(tester, find.text('Məzmun'));
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
    await _tap(tester, find.text('Məzmun'));
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
}
