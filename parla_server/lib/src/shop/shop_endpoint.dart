import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'shop.dart';

/// The buyer's side of in-app sales: whether they are open, starting an
/// order and "My orders". Card details are entered on Epoint's page only.
class ShopEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Whether products sold in the app may be offered now.
  Future<bool> salesOpen(Session session) async => Shop.isOpen(session);

  /// Starts an order and returns Epoint's payment page.
  Future<ShopCheckout> startOrder(
    Session session,
    String slug,
    int quantity,
    String language,
  ) async {
    final userId = session.authenticated!.authUserId;
    final profile = await MemberProfile.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    if (profile == null) throw ParlaException(code: ShopErrors.invalid);
    return beginShopOrder(
      session,
      userId,
      slug: slug,
      quantity: quantity,
      language: language,
    );
  }

  /// The caller's orders, newest first.
  Future<List<ShopOrderView>> myOrders(Session session) async {
    final rows = await ShopOrder.db.find(
      session,
      where: (t) => t.authUserId.equals(session.authenticated!.authUserId),
      orderByList: (t) => [t.createdAt.desc()],
      limit: 100,
    );
    return [for (final o in rows) orderView(o)];
  }

  /// One of the caller's orders, asking Epoint first when it still waits
  /// for the payment.
  Future<ShopOrderView> refreshOrder(Session session, String number) async {
    final order = await ShopOrder.db.findFirstRow(
      session,
      where: (t) =>
          t.number.equals(number) &
          t.authUserId.equals(session.authenticated!.authUserId),
    );
    if (order == null) throw ParlaException(code: ShopErrors.notFound);
    return orderView(await refreshShopOrder(session, order));
  }
}
