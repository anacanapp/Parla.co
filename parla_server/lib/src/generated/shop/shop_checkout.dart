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

/// A started order and Epoint's payment page to open in the browser.
abstract class ShopCheckout
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ShopCheckout._({
    required this.number,
    required this.paymentUrl,
  });

  factory ShopCheckout({
    required String number,
    required String paymentUrl,
  }) = _ShopCheckoutImpl;

  factory ShopCheckout.fromJson(Map<String, dynamic> jsonSerialization) {
    return ShopCheckout(
      number: jsonSerialization['number'] as String,
      paymentUrl: jsonSerialization['paymentUrl'] as String,
    );
  }

  String number;

  String paymentUrl;

  /// Returns a shallow copy of this [ShopCheckout]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ShopCheckout copyWith({
    String? number,
    String? paymentUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShopCheckout',
      'number': number,
      'paymentUrl': paymentUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShopCheckout',
      'number': number,
      'paymentUrl': paymentUrl,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ShopCheckoutImpl extends ShopCheckout {
  _ShopCheckoutImpl({
    required String number,
    required String paymentUrl,
  }) : super._(
         number: number,
         paymentUrl: paymentUrl,
       );

  /// Returns a shallow copy of this [ShopCheckout]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ShopCheckout copyWith({
    String? number,
    String? paymentUrl,
  }) {
    return ShopCheckout(
      number: number ?? this.number,
      paymentUrl: paymentUrl ?? this.paymentUrl,
    );
  }
}
