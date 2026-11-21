import 'package:serverpod/serverpod.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';
import '../staff/staff_guard.dart';
import 'shop.dart';

const _admins = {StaffRole.admin};

/// Orders in the admin panel (admins only). No buyer details are shown:
/// there are none yet besides the account, which stays hidden.
class ShopAdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<ShopOrderView>> orders(Session session) async {
    await requireStaff(session, roles: _admins);
    final rows = await ShopOrder.db.find(
      session,
      orderByList: (t) => [t.createdAt.desc()],
      limit: 500,
    );
    return [for (final o in rows) orderView(o)];
  }

  /// Moves an order on: paid → shipped → delivered, or cancels one that
  /// was never paid.
  Future<ShopOrderView> setStatus(
    Session session,
    String number,
    ShopOrderStatus status,
  ) async {
    final staff = await requireStaff(session, roles: _admins);
    final order = await _get(session, number);
    final allowed = switch ((order.status, status)) {
      (ShopOrderStatus.paid, ShopOrderStatus.shipped) => true,
      (ShopOrderStatus.shipped, ShopOrderStatus.delivered) => true,
      (ShopOrderStatus.created, ShopOrderStatus.cancelled) => true,
      (ShopOrderStatus.failed, ShopOrderStatus.cancelled) => true,
      _ => false,
    };
    if (!allowed) throw ParlaException(code: ShopErrors.wrongStatus);
    final updated = await ShopOrder.db.updateRow(
      session,
      order.copyWith(status: status, updatedAt: DateTime.now().toUtc()),
    );
    await _audit(session, staff, 'shop.${status.name}', updated);
    return orderView(updated);
  }

  /// Returns the money of a paid order through Epoint.
  Future<ShopOrderView> refund(Session session, String number) async {
    final staff = await requireStaff(session, roles: _admins);
    final order = await _get(session, number);
    final transaction = order.transaction;
    final gateway = Shop.gatewayFor(session);
    if (!const {
          ShopOrderStatus.paid,
          ShopOrderStatus.shipped,
          ShopOrderStatus.delivered,
        }.contains(order.status) ||
        transaction == null) {
      throw ParlaException(code: ShopErrors.wrongStatus);
    }
    if (gateway == null ||
        !await gateway.reverse(transaction, order.totalQepik, 'az')) {
      throw ParlaException(code: ShopErrors.paymentUnavailable);
    }
    final updated = await ShopOrder.db.updateRow(
      session,
      order.copyWith(
        status: ShopOrderStatus.refunded,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await _audit(session, staff, 'shop.refunded', updated);
    return orderView(updated);
  }

  Future<ShopOrder> _get(Session session, String number) async {
    final order = await ShopOrder.db.findFirstRow(
      session,
      where: (t) => t.number.equals(number),
    );
    if (order == null) throw ParlaException(code: ShopErrors.notFound);
    return order;
  }

  Future<void> _audit(
    Session session,
    StaffMember staff,
    String action,
    ShopOrder order,
  ) => writeAudit(
    session,
    actorId: staff.authUserId,
    actorRole: AuditActor.staff,
    action: action,
    objectType: 'shop_order',
    objectId: order.id.toString(),
  );
}
