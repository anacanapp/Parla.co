/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../shop/shop_order_status.dart' as _i78eg4or;

/// An order of a product sold in the app (phase 2). Card details never
/// reach Parla: the buyer pays on Epoint's page and Epoint reports the
/// result to `/shop/epoint/result`. The cardholder's name and card mask in
/// that report are dropped at once. Kept for accounting after the account
/// is deleted, with the user's id replaced by its pseudonym.
abstract class ShopOrder
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ShopOrder._({
    this.id,
    required this.number,
    required this.authUserId,
    required this.productId,
    required this.productSlug,
    required this.productTitle,
    required this.brand,
    required this.seller,
    required this.quantity,
    required this.unitQepik,
    required this.totalQepik,
    required this.status,
    this.transaction,
    required this.createdAt,
    required this.updatedAt,
    this.paidAt,
  });

  factory ShopOrder({
    int? id,
    required String number,
    required _isc.UuidValue authUserId,
    required int productId,
    required String productSlug,
    required String productTitle,
    required String brand,
    required String seller,
    required int quantity,
    required int unitQepik,
    required int totalQepik,
    required _i78eg4or.ShopOrderStatus status,
    String? transaction,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? paidAt,
  }) = _ShopOrderImpl;

  factory ShopOrder.fromJson(Map<String, dynamic> jsonSerialization) {
    return ShopOrder(
      id: jsonSerialization['id'] as int?,
      number: jsonSerialization['number'] as String,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      productId: jsonSerialization['productId'] as int,
      productSlug: jsonSerialization['productSlug'] as String,
      productTitle: jsonSerialization['productTitle'] as String,
      brand: jsonSerialization['brand'] as String,
      seller: jsonSerialization['seller'] as String,
      quantity: jsonSerialization['quantity'] as int,
      unitQepik: jsonSerialization['unitQepik'] as int,
      totalQepik: jsonSerialization['totalQepik'] as int,
      status: _i78eg4or.ShopOrderStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      transaction: jsonSerialization['transaction'] as String?,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      paidAt: jsonSerialization['paidAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['paidAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Shown to the buyer and sent to Epoint as `order_id` (e.g. P7KQ2M9XA4).
  String number;

  _isc.UuidValue authUserId;

  int productId;

  String productSlug;

  /// The product's name in az/ru/en at the time of the order (JSON).
  String productTitle;

  String brand;

  /// `parla` or `brand` (ContentRules.productSellers).
  String seller;

  int quantity;

  /// Price per item and total, in qəpik.
  int unitQepik;

  int totalQepik;

  _i78eg4or.ShopOrderStatus status;

  /// Epoint's transaction id.
  String? transaction;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? paidAt;

  /// Returns a shallow copy of this [ShopOrder]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ShopOrder copyWith({
    int? id,
    String? number,
    _isc.UuidValue? authUserId,
    int? productId,
    String? productSlug,
    String? productTitle,
    String? brand,
    String? seller,
    int? quantity,
    int? unitQepik,
    int? totalQepik,
    _i78eg4or.ShopOrderStatus? status,
    String? transaction,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? paidAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShopOrder',
      if (id != null) 'id': id,
      'number': number,
      'authUserId': authUserId.toJson(),
      'productId': productId,
      'productSlug': productSlug,
      'productTitle': productTitle,
      'brand': brand,
      'seller': seller,
      'quantity': quantity,
      'unitQepik': unitQepik,
      'totalQepik': totalQepik,
      'status': status.toJson(),
      if (transaction != null) 'transaction': transaction,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (paidAt != null) 'paidAt': paidAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShopOrder',
      if (id != null) 'id': id,
      'number': number,
      'authUserId': authUserId.toJson(),
      'productId': productId,
      'productSlug': productSlug,
      'productTitle': productTitle,
      'brand': brand,
      'seller': seller,
      'quantity': quantity,
      'unitQepik': unitQepik,
      'totalQepik': totalQepik,
      'status': status.toJson(),
      if (transaction != null) 'transaction': transaction,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (paidAt != null) 'paidAt': paidAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShopOrderImpl extends ShopOrder {
  _ShopOrderImpl({
    int? id,
    required String number,
    required _isc.UuidValue authUserId,
    required int productId,
    required String productSlug,
    required String productTitle,
    required String brand,
    required String seller,
    required int quantity,
    required int unitQepik,
    required int totalQepik,
    required _i78eg4or.ShopOrderStatus status,
    String? transaction,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? paidAt,
  }) : super._(
         id: id,
         number: number,
         authUserId: authUserId,
         productId: productId,
         productSlug: productSlug,
         productTitle: productTitle,
         brand: brand,
         seller: seller,
         quantity: quantity,
         unitQepik: unitQepik,
         totalQepik: totalQepik,
         status: status,
         transaction: transaction,
         createdAt: createdAt,
         updatedAt: updatedAt,
         paidAt: paidAt,
       );

  /// Returns a shallow copy of this [ShopOrder]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ShopOrder copyWith({
    Object? id = _Undefined,
    String? number,
    _isc.UuidValue? authUserId,
    int? productId,
    String? productSlug,
    String? productTitle,
    String? brand,
    String? seller,
    int? quantity,
    int? unitQepik,
    int? totalQepik,
    _i78eg4or.ShopOrderStatus? status,
    Object? transaction = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? paidAt = const _isc.$UndefinedDateTime(),
  }) {
    return ShopOrder(
      id: id is int? ? id : this.id,
      number: number ?? this.number,
      authUserId: authUserId ?? this.authUserId,
      productId: productId ?? this.productId,
      productSlug: productSlug ?? this.productSlug,
      productTitle: productTitle ?? this.productTitle,
      brand: brand ?? this.brand,
      seller: seller ?? this.seller,
      quantity: quantity ?? this.quantity,
      unitQepik: unitQepik ?? this.unitQepik,
      totalQepik: totalQepik ?? this.totalQepik,
      status: status ?? this.status,
      transaction: transaction is String? ? transaction : this.transaction,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      paidAt: paidAt is _isc.UndefinedSentinel ? this.paidAt : paidAt,
    );
  }
}
