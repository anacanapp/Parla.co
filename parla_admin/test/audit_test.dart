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
    ..meValue = StaffMe(
      role: role,
      signInExpiresAt: DateTime.now().toUtc().add(const Duration(hours: 12)),
    );
  for (var i = 1; i <= 130; i++) {
    api.audit.add(
      AuditLogEntry(
        id: i,
        actorId: UuidValue.fromString('7f2e9d4c-1b3a-4e5f-8c6d-9a0b1c2d3e02'),
        actorRole: i.isEven ? 'staff' : 'user',
        action: i == 130 ? 'content.published' : 'consent.granted',
        objectType: i == 130 ? 'content_item' : 'consent_record',
        objectId: '$i',
        createdAt: DateTime.utc(2026, 11, 25, 9),
      ),
    );
  }
  await tester.pumpWidget(AdminApp(api: api));
  await tester.pumpAndSettle();
  return api;
}

Finder _nav(String label) => find.descendant(
  of: find.byKey(const ValueKey('admin-nav')),
  matching: find.text(label),
);

Future<void> _tap(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pumpAndSettle();
  await tester.tap(f);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('admins read the log newest first, page and filter it', (
    tester,
  ) async {
    final api = await _pump(tester, StaffRole.admin);
    await _tap(tester, _nav('Audit jurnalı'));
    expect(api.calls.last, 'listAudit::::');
    expect(find.byKey(const ValueKey('audit-row-130')), findsOneWidget);
    expect(find.text('Məzmun dərc olundu'), findsOneWidget);
    expect(find.byKey(const ValueKey('audit-row-30')), findsNothing);
    // Ids only, shortened; no edit or delete controls.
    expect(find.text('7f2e9d4c…'), findsWidgets);
    expect(find.byIcon(Icons.delete_outline), findsNothing);
    expect(find.byIcon(Icons.edit_outlined), findsNothing);

    await _tap(tester, find.byKey(const ValueKey('audit-more')));
    expect(api.calls.last, 'listAudit::::31');
    expect(find.byKey(const ValueKey('audit-row-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('audit-more')), findsNothing);

    await _tap(tester, find.byKey(const ValueKey('audit-group')));
    await _tap(tester, find.text('Məzmun').last);
    expect(api.calls.last, 'listAudit:content.:::');
    expect(find.byKey(const ValueKey('audit-row-130')), findsOneWidget);
    expect(find.byKey(const ValueKey('audit-row-129')), findsNothing);

    await tester.enterText(find.byKey(const ValueKey('audit-object')), '7');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(api.calls.last, 'listAudit:content.::7:');
    expect(find.byKey(const ValueKey('audit-empty')), findsOneWidget);
  });

  testWidgets('only admins see the audit log', (tester) async {
    for (final role in [StaffRole.editor, StaffRole.support]) {
      final api = await _pump(tester, role);
      expect(_nav('Audit jurnalı'), findsNothing);
      expect(api.calls.where((c) => c.startsWith('listAudit')), isEmpty);
    }
  });
}
