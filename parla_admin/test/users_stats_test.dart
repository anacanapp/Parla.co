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

StatsCount _c(String label, int? count) =>
    StatsCount(label: label, count: count);

final _dashboard = DashboardReport(
  generatedAt: DateTime.utc(2026, 11, 19),
  minGroupSize: 10,
  days: 30,
  kpis: [
    _c('accounts', 46),
    _c('signups', 12),
    _c('signups_previous', 8),
    _c('deleted', 0),
    _c('dau', null),
    _c('wau', 14),
    _c('mau', 30),
    _c('app_opens', 120),
    _c('tool_opens', 300),
    _c('banner_views', 200),
    _c('banner_taps', 20),
    _c('support_unread', 1),
  ],
  groups: [
    StatsGroup(
      metric: 'signups_daily',
      counts: [_c('2026-11-18', 4), _c('2026-11-19', 8)],
      total: 12,
    ),
    StatsGroup(
      metric: 'active_daily',
      counts: [_c('2026-11-18', 9), _c('2026-11-19', 12)],
    ),
    StatsGroup(
      metric: 'opens_country',
      counts: [_c('AZ', 120)],
      total: 120,
    ),
    StatsGroup(
      metric: 'tools',
      counts: [_c('check', 200), _c('shop', 100), _c('home', null)],
      total: 300,
    ),
    StatsGroup(
      metric: 'tools_country',
      counts: [_c('AZ|check', 200)],
      total: 300,
    ),
    StatsGroup(
      metric: 'recipes_top',
      counts: [_c('green-salad|Yaşıl salat', 40)],
    ),
    StatsGroup(
      metric: 'banner_views',
      counts: [_c('7|Yay kampaniyası|Brend A', 200)],
    ),
    StatsGroup(
      metric: 'banner_taps',
      counts: [_c('7|Yay kampaniyası|Brend A', 20)],
    ),
  ],
);

Future<FakeAdminApi> _pump(WidgetTester tester, StaffRole role) async {
  tester.view.physicalSize = const Size(1400, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final api = FakeAdminApi()
    ..signedIn = true
    ..meValue = StaffMe(
      role: role,
      signInExpiresAt: DateTime.now().toUtc().add(const Duration(hours: 12)),
    )
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
    )
    ..dashboardReport = _dashboard;
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
    await _tap(tester, _nav('İstifadəçilər'));
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

  testWidgets('admins see the dashboard tabs; small groups hidden', (
    tester,
  ) async {
    final api = await _pump(tester, StaffRole.admin);
    await _tap(tester, _nav('Dashboard'));
    expect(api.dashboardDays, [30]);
    expect(_text(tester, 'kpi-accounts'), '46');
    expect(_text(tester, 'kpi-signups'), '12');
    expect(_text(tester, 'kpi-dau'), '<10');
    expect(_text(tester, 'kpi-wau'), '14');
    expect(_text(tester, 'kpi-mau'), '30');
    expect(find.textContaining('+50%'), findsOneWidget);
    expect(find.byKey(const ValueKey('chart-signups')), findsOneWidget);
    expect(find.text('Azərbaycan'), findsOneWidget);

    await _tap(tester, find.byKey(const ValueKey('period-7')));
    expect(api.dashboardDays, [30, 7]);

    await _tap(tester, find.byKey(const ValueKey('dash-tab-tools')));
    expect(find.text('Yoxla (məhsul axtarışı)'), findsWidgets);
    expect(find.byKey(const ValueKey('tools-country')), findsOneWidget);

    await _tap(tester, find.byKey(const ValueKey('dash-tab-content')));
    expect(find.text('Yaşıl salat'), findsOneWidget);
    expect(find.text('Reklam · Brend A'), findsOneWidget);
    expect(find.text('10.0%'), findsOneWidget);

    await _tap(tester, find.byKey(const ValueKey('dash-tab-audience')));
    expect(find.text('40'), findsOneWidget);
    expect(find.text('87%'), findsOneWidget);
  });

  for (final role in [StaffRole.editor, StaffRole.expert, StaffRole.support]) {
    testWidgets('${role.name}s see neither users nor the dashboard', (
      tester,
    ) async {
      await _pump(tester, role);
      expect(_nav('İstifadəçilər'), findsNothing);
      expect(_nav('Dashboard'), findsNothing);
    });
  }
}

String? _text(WidgetTester tester, String key) =>
    tester.widget<Text>(find.byKey(ValueKey(key))).data;

/// A menu entry (the overview's guide cards repeat the same names).
Finder _nav(String label) => find.descendant(
  of: find.byKey(const ValueKey('admin-nav')),
  matching: find.text(label),
);
