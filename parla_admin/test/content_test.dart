import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla_admin/api/admin_api.dart';
import 'package:parla_admin/app.dart';

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
}
