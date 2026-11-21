import 'dart:convert';

import 'package:parla_server/src/account/erase_account.dart';
import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/shop/epoint.dart';
import 'package:parla_server/src/shop/shop.dart';
import 'package:parla_server/src/staff/staff_guard.dart';
import 'package:serverpod/serverpod.dart' show Session, UuidValue;
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

import 'staff_sign_in.dart';

Matcher _error(String code) =>
    isA<ParlaException>().having((e) => e.code, 'code', code);

TestSessionBuilder _as(TestSessionBuilder builder, String userId) =>
    builder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(userId, {}),
    );

class _FakeGateway implements PaymentGateway {
  final started = <Map<String, Object?>>[];
  final reversed = <String>[];
  bool refuse = false;
  String? statusAnswer;

  @override
  Future<({String transaction, String url})?> start({
    required String orderNumber,
    required int amountQepik,
    required String language,
    required String description,
    required String successUrl,
    required String errorUrl,
  }) async {
    started.add({
      'order': orderNumber,
      'amount': amountQepik,
      'description': description,
      'success': successUrl,
    });
    if (refuse) return null;
    return (
      transaction: 'te-$orderNumber',
      url: 'https://epoint.test/pay/$orderNumber',
    );
  }

  @override
  Future<String?> status(String transaction) async => statusAnswer;

  @override
  Future<bool> reverse(String transaction, int amountQepik, String l) async {
    reversed.add('$transaction:$amountQepik');
    return true;
  }

  @override
  PaymentResult? readResult(String data, String signature) => null;
}

void main() {
  withServerpod('Given in-app sales', (sessionBuilder, endpoints) {
    late _FakeGateway gateway;
    var open = true;

    setUp(() {
      gateway = _FakeGateway();
      open = true;
      Shop.gatewayFor = (Session _) => gateway;
      Shop.switchedOn = (Session _) => open;
    });

    Future<String> member(String email) async {
      final db = sessionBuilder.build();
      final user = await const AuthUsers().create(db);
      await EmailAccount.db.insertRow(
        db,
        EmailAccount(authUserId: user.id, email: email, passwordHash: 'x'),
      );
      await endpoints.profile.create(
        _as(sessionBuilder, user.id.toString()),
        birthYear: 1995,
        countryCode: 'AZ',
        language: 'az',
      );
      return user.id.toString();
    }

    Future<TestSessionBuilder> admin() async {
      final db = sessionBuilder.build();
      final user = await const AuthUsers().create(db);
      await EmailAccount.db.insertRow(
        db,
        EmailAccount(
          authUserId: user.id,
          email: 'first-admin@example.com',
          passwordHash: 'x',
        ),
      );
      final s = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          user.id.toString(),
          {},
          authId: await signInSession(db, user.id),
        ),
      );
      await endpoints.staff.claimFirstAdmin(s);
      return s;
    }

    Future<void> product(String slug, Map<String, Object?> json) async {
      final db = sessionBuilder.build();
      final now = DateTime.now().toUtc();
      final data = jsonEncode({
        'name': {'az': 'Krem', 'ru': 'Крем', 'en': 'Cream'},
        'brand': 'Brand X',
        'price': '12.50',
        ...json,
      });
      await ContentItem.db.insertRow(
        db,
        ContentItem(
          kind: 'product',
          slug: slug,
          category: 'face',
          status: ContentStatus.published,
          draftJson: data,
          publishedJson: data,
          createdBy: UuidValue.fromString(
            "00000000-0000-4000-8000-000000000001",
          ),
          updatedBy: UuidValue.fromString(
            "00000000-0000-4000-8000-000000000001",
          ),
          createdAt: now,
          updatedAt: now,
          publishedAt: now,
        ),
      );
    }

    test('closed until switched on with keys; then an order goes to Epoint '
        'with the published price', () async {
      final buyer = _as(sessionBuilder, await member('a@example.com'));
      await product('krem', {'sale': 'own', 'seller': 'parla'});
      await product('partner', {
        'sale': 'redirect',
        'url': 'https://partner.az/x',
      });

      open = false;
      expect(await endpoints.shop.salesOpen(buyer), isFalse);
      await expectLater(
        endpoints.shop.startOrder(buyer, 'krem', 1, 'az'),
        throwsA(_error(ShopErrors.closed)),
      );
      open = true;
      Shop.gatewayFor = (Session _) => null; // no keys
      expect(await endpoints.shop.salesOpen(buyer), isFalse);
      Shop.gatewayFor = (Session _) => gateway;
      expect(await endpoints.shop.salesOpen(buyer), isTrue);

      final checkout = await endpoints.shop.startOrder(buyer, 'krem', 2, 'az');
      expect(checkout.paymentUrl, 'https://epoint.test/pay/${checkout.number}');
      expect(checkout.number, matches(RegExp(r'^P[A-Z2-9]{9}$')));
      expect(gateway.started.single['amount'], 2500);
      expect(gateway.started.single['description'], 'Parla ${checkout.number}');
      expect(
        gateway.started.single['success'],
        endsWith('/shop/done?o=${checkout.number}'),
      );

      await expectLater(
        endpoints.shop.startOrder(buyer, 'partner', 1, 'az'),
        throwsA(_error(ShopErrors.notFound)),
      );
      await expectLater(
        endpoints.shop.startOrder(buyer, 'krem', 11, 'az'),
        throwsA(_error(ShopErrors.invalid)),
      );
      final orders = await endpoints.shop.myOrders(buyer);
      expect(orders.single.status, ShopOrderStatus.created);
      expect(orders.single.totalQepik, 2500);
      // Another account does not see it.
      final other = _as(sessionBuilder, await member('b@example.com'));
      expect(await endpoints.shop.myOrders(other), isEmpty);
      await expectLater(
        endpoints.shop.refreshOrder(other, checkout.number),
        throwsA(_error(ShopErrors.notFound)),
      );
    });

    test(
      'a refused payment page fails the order; too many orders wait',
      () async {
        final buyer = _as(sessionBuilder, await member('a@example.com'));
        await product('krem', {'sale': 'own', 'seller': 'brand'});
        gateway.refuse = true;
        await expectLater(
          endpoints.shop.startOrder(buyer, 'krem', 1, 'az'),
          throwsA(_error(ShopErrors.paymentUnavailable)),
        );
        expect(
          (await endpoints.shop.myOrders(buyer)).single.status,
          ShopOrderStatus.failed,
        );
        gateway.refuse = false;
        for (var i = 1; i < maxOrdersPerHour; i++) {
          await endpoints.shop.startOrder(buyer, 'krem', 1, 'az');
        }
        await expectLater(
          endpoints.shop.startOrder(buyer, 'krem', 1, 'az'),
          throwsA(_error(ShopErrors.tooMany)),
        );
      },
    );

    test('Epoint\'s report pays the order once; a wrong amount changes '
        'nothing; a lost report is asked for', () async {
      final buyer = _as(sessionBuilder, await member('a@example.com'));
      await product('krem', {'sale': 'own', 'seller': 'parla'});
      final a = await endpoints.shop.startOrder(buyer, 'krem', 1, 'az');
      final b = await endpoints.shop.startOrder(buyer, 'krem', 1, 'az');
      final db = sessionBuilder.build();

      PaymentResult report(
        String number, {
        int amount = 1250,
        bool ok = true,
      }) => PaymentResult(
        orderNumber: number,
        success: ok,
        amountQepik: amount,
        transaction: 'te-$number',
      );
      expect(
        await applyPaymentResult(db, report(a.number, amount: 1)),
        isFalse,
      );
      expect(await applyPaymentResult(db, report('PNOTHERE')), isFalse);
      expect(await applyPaymentResult(db, report(a.number)), isTrue);
      // A later failure report does not undo the payment.
      await applyPaymentResult(db, report(a.number, ok: false));
      var orders = {
        for (final o in await endpoints.shop.myOrders(buyer)) o.number: o,
      };
      expect(orders[a.number]!.status, ShopOrderStatus.paid);
      expect(orders[a.number]!.paidAt, isNotNull);
      expect(orders[b.number]!.status, ShopOrderStatus.created);

      gateway.statusAnswer = 'success';
      final refreshed = await endpoints.shop.refreshOrder(buyer, b.number);
      expect(refreshed.status, ShopOrderStatus.paid);

      final audit = await AuditLogEntry.db.find(
        db,
        where: (t) => t.action.equals('shop.paid'),
      );
      expect(audit, hasLength(2));
      expect(audit.every((e) => e.actorId == null), isTrue);
    });

    test('admins ship, deliver and refund; accounts deleted keep orders '
        'under a pseudonym', () async {
      final staff = await admin();
      final buyerId = await member('a@example.com');
      final buyer = _as(sessionBuilder, buyerId);
      await product('krem', {'sale': 'own', 'seller': 'parla'});
      final a = await endpoints.shop.startOrder(buyer, 'krem', 1, 'az');
      final db = sessionBuilder.build();
      await applyPaymentResult(
        db,
        PaymentResult(
          orderNumber: a.number,
          success: true,
          amountQepik: 1250,
          transaction: 'te-${a.number}',
        ),
      );
      await expectLater(
        endpoints.shopAdmin.orders(buyer),
        throwsA(_error(StaffErrors.notStaff)),
      );
      expect((await endpoints.shopAdmin.orders(staff)).single.number, a.number);
      await expectLater(
        endpoints.shopAdmin.setStatus(
          staff,
          a.number,
          ShopOrderStatus.delivered,
        ),
        throwsA(_error(ShopErrors.wrongStatus)),
      );
      await endpoints.shopAdmin.setStatus(
        staff,
        a.number,
        ShopOrderStatus.shipped,
      );
      final refunded = await endpoints.shopAdmin.refund(staff, a.number);
      expect(refunded.status, ShopOrderStatus.refunded);
      expect(gateway.reversed, ['te-${a.number}:1250']);

      final pseudonym = await eraseAccount(db, UuidValue.fromString(buyerId));
      final kept = await ShopOrder.db.find(db);
      expect(kept.single.authUserId, pseudonym);
    });
  });
}
