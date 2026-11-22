import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla_admin/api/admin_api.dart';
import 'package:parla_admin/app.dart';

import 'fake_admin_api.dart';

final _adminId = UuidValue.fromString('0b6c1f3e-8a4d-4c7e-9f21-3d5a7e9b1c01');

Future<FakeAdminApi> _pump(WidgetTester tester, {FakeAdminApi? api}) async {
  tester.view.physicalSize = const Size(1280, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  api ??= FakeAdminApi();
  await tester.pumpWidget(AdminApp(api: api));
  await tester.pumpAndSettle();
  return api;
}

FakeAdminApi _ready(StaffRole role) => FakeAdminApi()
  ..signedIn = true
  ..meValue = StaffMe(
    role: role,
    signInExpiresAt: DateTime.now().toUtc().add(const Duration(hours: 12)),
  )
  ..staff.add(
    StaffSummary(
      authUserId: _adminId,
      email: 'admin@parla.az',
      role: StaffRole.admin,
      active: true,
      createdAt: DateTime.utc(2026, 11, 16),
    ),
  );

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a new staff member registers and joins with the invitation', (
    tester,
  ) async {
    final api = await _pump(tester);
    expect(find.byKey(const ValueKey('auth-submit')), findsOneWidget);

    // Registration with the emailed code and a password.
    await _tap(tester, find.byKey(const ValueKey('to-register')));
    await tester.enterText(find.byKey(const ValueKey('email')), 'new@parla.az');
    await _tap(tester, find.byKey(const ValueKey('auth-submit')));
    expect(api.calls, contains('register:new@parla.az'));
    await tester.enterText(find.byKey(const ValueKey('email-code')), '4242');
    await tester.enterText(find.byKey(const ValueKey('password')), 'short');
    await _tap(tester, find.byKey(const ValueKey('auth-submit')));
    expect(find.text('Şifrə ən azı 12 simvol olmalıdır.'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('password')),
      'a long enough password',
    );
    await _tap(tester, find.byKey(const ValueKey('auth-submit')));
    expect(find.text('Dəvət kodu'), findsWidgets);

    await tester.enterText(find.byKey(const ValueKey('invite-code')), 'BAD');
    await _tap(tester, find.byKey(const ValueKey('invite-accept')));
    expect(find.textContaining('Dəvət kodu yanlışdır'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('invite-code')),
      'goodcode',
    );
    await _tap(tester, find.byKey(const ValueKey('invite-accept')));
    expect(find.textContaining('Xoş gəldiniz'), findsOneWidget);
    expect(api.meValue!.role, StaffRole.admin);
  });

  testWidgets('after 12 hours the panel asks for the password again', (
    tester,
  ) async {
    final api = FakeAdminApi()
      ..signedIn = true
      ..meError = const AdminError('staff.sign_in_again');
    await _pump(tester, api: api);
    expect(find.byKey(const ValueKey('auth-submit')), findsOneWidget);
    expect(find.byKey(const ValueKey('sign-in-notice')), findsOneWidget);
    expect(api.signedIn, isFalse);
  });

  testWidgets('editors do not see users or staff', (tester) async {
    await _pump(tester, api: _ready(StaffRole.editor));
    expect(find.text('Məzmun'), findsWidgets);
    expect(find.text('İşçilər'), findsNothing);
    expect(find.text('İstifadəçilər'), findsNothing);
  });

  testWidgets('admins manage staff: invite, deactivate, errors', (
    tester,
  ) async {
    final api = await _pump(tester, api: _ready(StaffRole.admin));
    await _tap(tester, find.byKey(const ValueKey('nav-staff')));
    expect(find.text('admin@parla.az'), findsOneWidget);
    expect(find.textContaining('sağlamlıq məlumatlarını görmür'), findsOne);

    await _tap(tester, find.byKey(const ValueKey('invite-open')));
    await tester.enterText(
      find.byKey(const ValueKey('invite-email')),
      'expert@parla.az',
    );
    await _tap(tester, find.byKey(const ValueKey('invite-role-expert')));
    await _tap(tester, find.byKey(const ValueKey('invite-send')));
    expect(api.calls, contains('invite:expert@parla.az:expert'));
    expect(find.text('Açıq dəvətlər'), findsOneWidget);
    expect(find.text('expert@parla.az'), findsOneWidget);

    await _tap(tester, find.byKey(ValueKey('staff-menu-$_adminId')));
    await _tap(tester, find.text('Rol: Redaktor'));
    expect(find.text('Sonuncu aktiv admini dəyişmək olmaz.'), findsOneWidget);

    await _tap(tester, find.byKey(ValueKey('staff-menu-$_adminId')));
    await _tap(tester, find.text('Deaktiv et'));
    await _tap(tester, find.byKey(const ValueKey('confirm-yes')));
    expect(api.calls, contains('active:$_adminId:false'));

    await _tap(tester, find.byTooltip('Dəvəti ləğv et'));
    expect(find.text('Açıq dəvətlər'), findsNothing);
  });

  testWidgets('a wrong password is refused without saying why', (
    tester,
  ) async {
    final api = await _pump(tester);
    await tester.enterText(find.byKey(const ValueKey('email')), 'a@parla.az');
    await tester.enterText(find.byKey(const ValueKey('password')), 'nope');
    await _tap(tester, find.byKey(const ValueKey('auth-submit')));
    expect(find.textContaining('Alınmadı'), findsOneWidget);
    expect(api.signedIn, isFalse);

    await tester.enterText(
      find.byKey(const ValueKey('password')),
      'correct horse battery',
    );
    await _tap(tester, find.byKey(const ValueKey('auth-submit')));
    expect(find.text('Dəvət kodu'), findsWidgets);
  });

  testWidgets('a forgotten password: sign in with an emailed code', (
    tester,
  ) async {
    final api = await _pump(tester);
    await _tap(tester, find.byKey(const ValueKey('to-code')));
    expect(find.text('Kodla daxil ol'), findsOneWidget);
    expect(find.byKey(const ValueKey('password')), findsNothing);
    await tester.enterText(find.byKey(const ValueKey('email')), 'a@parla.az');
    await _tap(tester, find.byKey(const ValueKey('auth-submit')));
    expect(find.text('Kodu e-poçtunuza göndərdik.'), findsOneWidget);
    expect(find.byKey(const ValueKey('password')), findsNothing);

    await tester.enterText(find.byKey(const ValueKey('email-code')), '000000');
    await _tap(tester, find.byKey(const ValueKey('auth-submit')));
    expect(find.textContaining('Alınmadı'), findsOneWidget);
    expect(api.signedIn, isFalse);

    await tester.enterText(
      find.byKey(const ValueKey('email-code')),
      FakeAdminApi.loginCode,
    );
    await _tap(tester, find.byKey(const ValueKey('auth-submit')));
    expect(api.calls, contains('codeLogin'));
    expect(find.text('Dəvət kodu'), findsWidgets);
  });

  testWidgets('signing out returns to the sign-in page', (tester) async {
    final api = await _pump(tester, api: _ready(StaffRole.admin));
    await _tap(tester, find.byKey(const ValueKey('sign-out')));
    expect(api.calls, contains('signOut'));
    expect(find.byKey(const ValueKey('auth-submit')), findsOneWidget);
  });
}
