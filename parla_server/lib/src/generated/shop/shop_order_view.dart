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
import 'package:serverpod/serverpod.dart' as _is;
import '../shop/shop_order_status.dart' as _i78eg4or;

/// An order as the buyer's "My orders" and the admin panel show it.
abstract class ShopOrderView
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ShopOrderView._({
    required this.number,
    required this.productSlug,
    required this.productTitle,
    required this.brand,
    required this.seller,
    required this.quantity,
    required this.totalQepik,
    required this.status,
    required this.createdAt,
    this.paidAt,
  });

  factory ShopOrderView({
    required String number,
    required String productSlug,
    required String productTitle,
    required String brand,
    required String seller,
    required int quantity,
    required int totalQepik,
    required _i78eg4or.ShopOrderStatus status,
    required DateTime createdAt,
    DateTime? paidAt,
  }) = _ShopOrderViewImpl;

  factory ShopOrderView.fromJson(Map<String, dynamic> jsonSerialization) {
    return ShopOrderView(
      number: jsonSerialization['number'] as String,
      productSlug: jsonSerialization['productSlug'] as String,
      productTitle: jsonSerialization['productTitle'] as String,
      brand: jsonSerialization['brand'] as String,
      seller: jsonSerialization['seller'] as String,
      quantity: jsonSerialization['quantity'] as int,
      totalQepik: jsonSerialization['totalQepik'] as int,
      status: _i78eg4or.ShopOrderStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      paidAt: jsonSerialization['paidAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['paidAt']),
    );
  }

  String number;

  String productSlug;

  String productTitle;

  String brand;

  String seller;

  int quantity;

  int totalQepik;

  _i78eg4or.ShopOrderStatus status;

  DateTime createdAt;

  DateTime? paidAt;

  /// Returns a shallow copy of this [ShopOrderView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ShopOrderView copyWith({
    String? number,
    String? productSlug,
    String? productTitle,
    String? brand,
    String? seller,
    int? quantity,
    int? totalQepik,
    _i78eg4or.ShopOrderStatus? status,
    DateTime? createdAt,
    DateTime? paidAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShopOrderView',
      'number': number,
      'productSlug': productSlug,
      'productTitle': productTitle,
      'brand': brand,
      'seller': seller,
      'quantity': quantity,
      'totalQepik': totalQepik,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
      if (paidAt != null) 'paidAt': paidAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShopOrderView',
      'number': number,
      'productSlug': productSlug,
      'productTitle': productTitle,
      'brand': brand,
      'seller': seller,
      'quantity': quantity,
      'totalQepik': totalQepik,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
      if (paidAt != null) 'paidAt': paidAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ShopOrderViewImpl extends ShopOrderView {
  _ShopOrderViewImpl({
    required String number,
    required String productSlug,
    required String productTitle,
    required String brand,
    required String seller,
    required int quantity,
    required int totalQepik,
    required _i78eg4or.ShopOrderStatus status,
    required DateTime createdAt,
    DateTime? paidAt,
  }) : super._(
         number: number,
         productSlug: productSlug,
         productTitle: productTitle,
         brand: brand,
         seller: seller,
         quantity: quantity,
         totalQepik: totalQepik,
         status: status,
         createdAt: createdAt,
         paidAt: paidAt,
       );

  /// Returns a shallow copy of this [ShopOrderView]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ShopOrderView copyWith({
    String? number,
    String? productSlug,
    String? productTitle,
    String? brand,
    String? seller,
    int? quantity,
    int? totalQepik,
    _i78eg4or.ShopOrderStatus? status,
    DateTime? createdAt,
    DateTime? paidAt = const _is.$UndefinedDateTime(),
  }) {
    return ShopOrderView(
      number: number ?? this.number,
      productSlug: productSlug ?? this.productSlug,
      productTitle: productTitle ?? this.productTitle,
      brand: brand ?? this.brand,
      seller: seller ?? this.seller,
      quantity: quantity ?? this.quantity,
      totalQepik: totalQepik ?? this.totalQepik,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      paidAt: paidAt is _is.UndefinedSentinel ? this.paidAt : paidAt,
    );
  }
}
