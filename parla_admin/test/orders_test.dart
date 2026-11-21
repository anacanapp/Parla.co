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

Finder _nav(String label) => find.descendant(
  of: find.byKey(const ValueKey('admin-nav')),
  matching: find.text(label),
);

void main() {
  testWidgets('only admins see orders', (tester) async {
    await _pump(tester, StaffRole.editor);
    expect(_nav('Sifarişlər'), findsNothing);
  });

  testWidgets('an admin ships a paid order and refunds after confirming', (
    tester,
  ) async {
    final api = await _pump(tester, StaffRole.admin);
    api.orderRows.add(
      ShopOrderView(
        number: 'PABCDEFGHJ',
        productSlug: 'krem',
        productTitle: '{"az":"Krem","ru":"Крем","en":"Cream"}',
        brand: 'Brand X',
        seller: 'parla',
        quantity: 2,
        totalQepik: 2500,
        status: ShopOrderStatus.paid,
        createdAt: DateTime.utc(2026, 12, 1, 10),
        paidAt: DateTime.utc(2026, 12, 1, 10, 2),
      ),
    );
    await _tap(tester, _nav('Sifarişlər'));
    expect(find.text('PABCDEFGHJ · Krem'), findsOneWidget);
    expect(find.textContaining('25.00 ₼'), findsOneWidget);
    expect(find.text('Ödənilib'), findsOneWidget);

    await _tap(tester, find.byKey(const ValueKey('order-menu-PABCDEFGHJ')));
    await _tap(tester, find.text('Göndərildi'));
    expect(api.calls, contains('orderStatus:PABCDEFGHJ:shipped'));
    expect(find.text('Göndərilib'), findsOneWidget);

    await _tap(tester, find.byKey(const ValueKey('order-menu-PABCDEFGHJ')));
    await _tap(tester, find.text('Pulu qaytar'));
    await _tap(tester, find.text('Ləğv et'));
    expect(api.calls.where((c) => c.startsWith('refund')), isEmpty);
    await _tap(tester, find.byKey(const ValueKey('order-menu-PABCDEFGHJ')));
    await _tap(tester, find.text('Pulu qaytar'));
    await _tap(tester, find.byKey(const ValueKey('confirm-yes')));
    expect(api.calls, contains('refund:PABCDEFGHJ'));
    expect(find.text('Pul qaytarılıb'), findsOneWidget);
  });
}
