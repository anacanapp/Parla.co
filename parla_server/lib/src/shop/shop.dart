import 'dart:convert';
import 'dart:math';

import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';
import 'epoint.dart';

/// Error codes of the Shop. The app and the panel translate them.
abstract final class ShopErrors {
  static const closed = 'shop.closed';
  static const notFound = 'shop.not_found';
  static const invalid = 'shop.invalid';
  static const tooMany = 'shop.too_many';
  static const paymentUnavailable = 'shop.payment_unavailable';
  static const wrongStatus = 'shop.wrong_status';
}

/// Most orders one account may start in an hour.
const maxOrdersPerHour = 5;

/// Most items of one product in an order.
const maxQuantity = 10;

/// In-app sales (Shop phase 2).
///
/// Open only when both Epoint keys are set (`epointPublicKey`,
/// `epointPrivateKey`) and the `shopSalesOpen` switch is `true`. Until
/// then products sold in the app are not offered.
abstract final class Shop {
  /// Replaced in tests.
  static PaymentGateway? Function(Session session) gatewayFor = _epoint;

  static EpointGateway? _cached;
  static String? _cachedKey;

  static PaymentGateway? _epoint(Session session) {
    final public = session.passwords['epointPublicKey'];
    final private = session.passwords['epointPrivateKey'];
    if (public == null ||
        private == null ||
        public.isEmpty ||
        private.isEmpty) {
      return null;
    }
    if (_cached == null || _cachedKey != public) {
      _cached = EpointGateway(publicKey: public, privateKey: private);
      _cachedKey = public;
    }
    return _cached;
  }

  /// Replaced in tests.
  static bool Function(Session session) switchedOn = (session) =>
      session.passwords['shopSalesOpen'] == 'true';

  static bool isOpen(Session session) =>
      switchedOn(session) && gatewayFor(session) != null;
}

/// A new order number: P and 9 characters without look-alikes.
String newOrderNumber([Random? random]) {
  const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  final r = random ?? Random.secure();
  return 'P${List.generate(9, (_) => alphabet[r.nextInt(alphabet.length)]).join()}';
}

ShopOrderView orderView(ShopOrder o) => ShopOrderView(
  number: o.number,
  productSlug: o.productSlug,
  productTitle: o.productTitle,
  brand: o.brand,
  seller: o.seller,
  quantity: o.quantity,
  totalQepik: o.totalQepik,
  status: o.status,
  createdAt: o.createdAt,
  paidAt: o.paidAt,
);

/// The site's own address for Epoint's return pages.
String publicBase(Session session) {
  final api = session.serverpod.config.apiServer;
  final port =
      (api.publicScheme == 'https' && api.publicPort == 443) ||
          (api.publicScheme == 'http' && api.publicPort == 80)
      ? ''
      : ':${api.publicPort}';
  return '${api.publicScheme}://${api.publicHost}$port';
}

/// Starts an order of [quantity] items of the published product [slug]
/// for [userId]. The price is always the published one, never the app's.
Future<ShopCheckout> beginShopOrder(
  Session session,
  UuidValue userId, {
  required String slug,
  required int quantity,
  required String language,
  DateTime? now,
}) async {
  if (!Shop.isOpen(session)) throw ParlaException(code: ShopErrors.closed);
  if (quantity < 1 || quantity > maxQuantity) {
    throw ParlaException(code: ShopErrors.invalid);
  }
  final at = (now ?? DateTime.now()).toUtc();
  final recent = await ShopOrder.db.count(
    session,
    where: (t) =>
        t.authUserId.equals(userId) &
        (t.createdAt > at.subtract(const Duration(hours: 1))),
  );
  if (recent >= maxOrdersPerHour) {
    throw ParlaException(code: ShopErrors.tooMany);
  }
  final item = await ContentItem.db.findFirstRow(
    session,
    where: (t) => t.kind.equals(ContentKind.product.name) & t.slug.equals(slug),
  );
  final published = item?.publishedJson;
  if (item == null || published == null) {
    throw ParlaException(code: ShopErrors.notFound);
  }
  final json = jsonDecode(published) as Map<String, Object?>;
  final unit = ContentRules.priceQepik(json['price']);
  final seller = json['seller'];
  if (json['sale'] != 'own' || unit == null || seller is! String) {
    throw ParlaException(code: ShopErrors.notFound);
  }
  var order = await ShopOrder.db.insertRow(
    session,
    ShopOrder(
      number: newOrderNumber(),
      authUserId: userId,
      productId: item.id!,
      productSlug: item.slug,
      productTitle: jsonEncode(json['name'] ?? const {}),
      brand: '${json['brand'] ?? ''}',
      seller: seller,
      quantity: quantity,
      unitQepik: unit,
      totalQepik: unit * quantity,
      status: ShopOrderStatus.created,
      createdAt: at,
      updatedAt: at,
    ),
  );
  final base = publicBase(session);
  final started = await Shop.gatewayFor(session)!.start(
    orderNumber: order.number,
    amountQepik: order.totalQepik,
    language: language,
    // No personal data in the description: Epoint shows it to the buyer.
    description: 'Parla ${order.number}',
    successUrl: '$base/shop/done?o=${order.number}',
    errorUrl: '$base/shop/done?o=${order.number}&e=1',
  );
  if (started == null) {
    await ShopOrder.db.updateRow(
      session,
      order.copyWith(status: ShopOrderStatus.failed, updatedAt: at),
    );
    throw ParlaException(code: ShopErrors.paymentUnavailable);
  }
  order = await ShopOrder.db.updateRow(
    session,
    order.copyWith(transaction: started.transaction),
  );
  await writeAudit(
    session,
    actorId: userId,
    actorRole: AuditActor.user,
    action: 'shop.order_started',
    objectType: 'shop_order',
    objectId: order.id.toString(),
  );
  return ShopCheckout(number: order.number, paymentUrl: started.url);
}

/// Applies a payment result to its order: paid or failed. Repeated and
/// late reports change nothing. Returns whether the report fit an order.
Future<bool> applyPaymentResult(
  Session session,
  PaymentResult result, {
  DateTime? now,
}) async {
  final order = await ShopOrder.db.findFirstRow(
    session,
    where: (t) => t.number.equals(result.orderNumber),
  );
  if (order == null) return false;
  if (result.transaction != null &&
      order.transaction != null &&
      result.transaction != order.transaction) {
    return false;
  }
  if (result.amountQepik != null && result.amountQepik != order.totalQepik) {
    session.log(
      'Epoint amount does not match order ${order.id}.',
      level: LogLevel.warning,
    );
    return false;
  }
  final at = (now ?? DateTime.now()).toUtc();
  final waiting =
      order.status == ShopOrderStatus.created ||
      order.status == ShopOrderStatus.failed;
  if (result.success && waiting) {
    await ShopOrder.db.updateRow(
      session,
      order.copyWith(
        status: ShopOrderStatus.paid,
        paidAt: at,
        updatedAt: at,
        transaction: order.transaction ?? result.transaction,
      ),
    );
    await writeAudit(
      session,
      actorId: null,
      actorRole: 'system',
      action: 'shop.paid',
      objectType: 'shop_order',
      objectId: order.id.toString(),
    );
  } else if (!result.success && order.status == ShopOrderStatus.created) {
    await ShopOrder.db.updateRow(
      session,
      order.copyWith(status: ShopOrderStatus.failed, updatedAt: at),
    );
  }
  return true;
}

/// Asks Epoint about a waiting order (when its report was lost).
Future<ShopOrder> refreshShopOrder(Session session, ShopOrder order) async {
  final gateway = Shop.gatewayFor(session);
  final transaction = order.transaction;
  if (order.status != ShopOrderStatus.created ||
      gateway == null ||
      transaction == null) {
    return order;
  }
  final status = await gateway.status(transaction);
  if (status == 'success' || status == 'error') {
    await applyPaymentResult(
      session,
      PaymentResult(
        orderNumber: order.number,
        success: status == 'success',
        amountQepik: null,
        transaction: transaction,
      ),
    );
  }
  return (await ShopOrder.db.findById(session, order.id!))!;
}
