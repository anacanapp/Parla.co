import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla_admin/api/admin_api.dart';
import 'package:parla_admin/app.dart';

import 'fake_admin_api.dart';

Future<FakeAdminApi> _pump(WidgetTester tester, StaffRole role) async {
  tester.view.physicalSize = const Size(1400, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final api = FakeAdminApi()
    ..signedIn = true
    ..meValue = StaffMe(
      role: role,
      signInExpiresAt: DateTime.now().toUtc().add(const Duration(hours: 12)),
    );
  api.threads.add(
    SupportThreadSummary(
      id: 1,
      email: 'aysel@example.com',
      open: true,
      unreadByStaff: true,
      lastMessageAt: DateTime.utc(2026, 11, 17, 9),
    ),
  );
  api.supportByThread[1] = [
    SupportEntry(
      fromStaff: false,
      text: 'Dərim qızarır',
      createdAt: DateTime.utc(2026, 11, 17, 9),
    ),
  ];
  await tester.pumpWidget(AdminApp(api: api));
  await tester.pumpAndSettle();
  return api;
}

Future<void> _tap(WidgetTester tester, Finder f) async {
  await tester.tap(f);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('the support role reads and answers conversations only', (
    tester,
  ) async {
    final api = await _pump(tester, StaffRole.support);
    expect(find.text('Məzmun'), findsNothing);
    expect(find.text('İstifadəçilər'), findsNothing);
    expect(find.text('Statistika'), findsNothing);
    await _tap(
      tester,
      find
          .descendant(
            of: find.byKey(const ValueKey('admin-nav')),
            matching: find.text('Dəstək'),
          )
          .first,
    );
    // The list shows no message text until a conversation is opened.
    expect(find.text('Dərim qızarır'), findsNothing);
    await _tap(tester, find.byKey(const ValueKey('thread-1')));
    expect(api.calls, contains('openSupport:1'));
    expect(find.text('Dərim qızarır'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('support-reply')),
      'Fasilə verin, keçməsə həkimə müraciət edin.',
    );
    await _tap(tester, find.byKey(const ValueKey('support-send')));
    expect(api.calls.any((c) => c.startsWith('reply:1:')), isTrue);
    expect(find.textContaining('Fasilə verin'), findsOneWidget);

    await _tap(tester, find.byKey(const ValueKey('support-close')));
    expect(api.calls, contains('close:1'));
  });

  testWidgets('editors and experts do not see support', (tester) async {
    await _pump(tester, StaffRole.editor);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('admin-nav')),
        matching: find.text('Dəstək'),
      ),
      findsNothing,
    );
  });

  testWidgets('admins see support too', (tester) async {
    await _pump(tester, StaffRole.admin);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('admin-nav')),
        matching: find.text('Dəstək'),
      ),
      findsOneWidget,
    );
  });
}
