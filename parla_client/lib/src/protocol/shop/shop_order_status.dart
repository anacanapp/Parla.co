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

/// Where an order stands. `created` until Epoint reports the payment;
/// the seller then marks it shipped and delivered.
enum ShopOrderStatus implements _isc.SerializableModel {
  created,
  paid,
  failed,
  shipped,
  delivered,
  cancelled,
  refunded;

  static ShopOrderStatus fromJson(String name) {
    switch (name) {
      case 'created':
        return ShopOrderStatus.created;
      case 'paid':
        return ShopOrderStatus.paid;
      case 'failed':
        return ShopOrderStatus.failed;
      case 'shipped':
        return ShopOrderStatus.shipped;
      case 'delivered':
        return ShopOrderStatus.delivered;
      case 'cancelled':
        return ShopOrderStatus.cancelled;
      case 'refunded':
        return ShopOrderStatus.refunded;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "ShopOrderStatus"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
