import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla_admin/api/admin_api.dart';
import 'package:parla_admin/app.dart';

import 'fake_admin_api.dart';

final _leyla = UserAdminView(
  userId: UuidValue.fromString('7f2e9d4c-1b3a-4e5f-8c6d-9a0b1c2d3e02'),
  email: 'leyla@example.com',
  registeredAt: DateTime.utc(2026, 11, 1),
  countryCode: 'AZ',
  language: 'az',
  blocked: false,
  isStaff: false,
  consents: [
    ConsentState(
      consentType: ConsentType.health,
      granted: true,
      textVersion: 'health-2026-11-draft5',
      updatedAt: DateTime.utc(2026, 11, 1),
    ),
    ConsentState(consentType: ConsentType.analytics, granted: false),
  ],
);

Future<FakeAdminApi> _pump(WidgetTester tester, StaffRole role) async {
  tester.view.physicalSize = const Size(1400, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final api = FakeAdminApi()
    ..signedIn = true
    ..meValue = StaffMe(role: role, totpEnrolled: true, verified: true)
    ..users['leyla@example.com'] = _leyla
    ..stats = StatsReport(
      generatedAt: DateTime.utc(2026, 11, 17),
      minGroupSize: 10,
      groups: [
        StatsGroup(
          metric: 'language',
          counts: [
            StatsCount(label: 'az', count: 40),
            StatsCount(label: 'ru', count: null),
          ],
          total: 46,
        ),
      ],
    );
  await tester.pumpWidget(AdminApp(api: api));
  await tester.pumpAndSettle();
  return api;
}

Future<void> _tap(WidgetTester tester, Finder f) async {
  await tester.ensureVisible(f);
  await tester.pumpAndSettle();
  await tester.tap(f);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('admins find by exact email, block and delete on request', (
    tester,
  ) async {
    final api = await _pump(tester, StaffRole.admin);
    await _tap(tester, find.text('İstifadəçilər'));
    await tester.enterText(
      find.byKey(const ValueKey('users-email')),
      'nobody@x.az',
    );
    await _tap(tester, find.byKey(const ValueKey('users-find')));
    expect(find.byKey(const ValueKey('users-none')), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('users-email')),
      'leyla@example.com',
    );
    await _tap(tester, find.byKey(const ValueKey('users-find')));
    expect(find.byKey(const ValueKey('users-card')), findsOneWidget);
    expect(find.textContaining('Sağlamlıq məlumatı: verilib'), findsOneWidget);
    expect(find.textContaining('Analitika: yoxdur'), findsOneWidget);

    await _tap(tester, find.byKey(const ValueKey('users-block')));
    await _tap(tester, find.byKey(const ValueKey('users-confirm-yes')));
    expect(find.byKey(const ValueKey('users-blocked')), findsOneWidget);
    expect(api.calls, contains('block:${_leyla.userId}:true'));

    // A wrong confirmation is refused.
    await _tap(tester, find.byKey(const ValueKey('users-delete')));
    await tester.enterText(
      find.byKey(const ValueKey('users-confirm-email')),
      'someone@else.az',
    );
    await _tap(tester, find.byKey(const ValueKey('users-delete-yes')));
    expect(find.textContaining('uyğun gəlmir'), findsOneWidget);
    expect(api.users, isNotEmpty);

    await _tap(tester, find.byKey(const ValueKey('users-delete')));
    await tester.enterText(
      find.byKey(const ValueKey('users-confirm-email')),
      'leyla@example.com',
    );
    await _tap(tester, find.byKey(const ValueKey('users-delete-yes')));
    expect(api.users, isEmpty);
    expect(find.byKey(const ValueKey('users-card')), findsNothing);
  });

  testWidgets('editors see statistics but not users; small groups hidden', (
    tester,
  ) async {
    await _pump(tester, StaffRole.editor);
    expect(find.text('İstifadəçilər'), findsNothing);
    await _tap(tester, find.text('Statistika'));
    expect(find.text('40'), findsOneWidget);
    expect(find.text('<10'), findsOneWidget);
    expect(find.text('87%'), findsOneWidget);
  });

  testWidgets('experts see neither users nor statistics', (tester) async {
    await _pump(tester, StaffRole.expert);
    expect(find.text('İstifadəçilər'), findsNothing);
    expect(find.text('Statistika'), findsNothing);
  });
}
