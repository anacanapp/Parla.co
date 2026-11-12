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

/// A product as the app shows it (M-20, M-21). Public product data only:
/// nothing about the user who searched.
abstract class ProductSummary
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProductSummary._({
    required this.source,
    required this.code,
    required this.productName,
    this.brand,
    this.ingredientsText,
    this.sourceUrl,
  });

  factory ProductSummary({
    required String source,
    required String code,
    required String productName,
    String? brand,
    String? ingredientsText,
    String? sourceUrl,
  }) = _ProductSummaryImpl;

  factory ProductSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductSummary(
      source: jsonSerialization['source'] as String,
      code: jsonSerialization['code'] as String,
      productName: jsonSerialization['productName'] as String,
      brand: jsonSerialization['brand'] as String?,
      ingredientsText: jsonSerialization['ingredientsText'] as String?,
      sourceUrl: jsonSerialization['sourceUrl'] as String?,
    );
  }

  /// "parla" (our own catalogue) or "openbeautyfacts".
  String source;

  /// Barcode or catalogue id.
  String code;

  String productName;

  String? brand;

  /// The ingredient list as printed on the product, if known.
  String? ingredientsText;

  /// Link to the source record, shown with the licence notice.
  String? sourceUrl;

  /// Returns a shallow copy of this [ProductSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProductSummary copyWith({
    String? source,
    String? code,
    String? productName,
    String? brand,
    String? ingredientsText,
    String? sourceUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductSummary',
      'source': source,
      'code': code,
      'productName': productName,
      if (brand != null) 'brand': brand,
      if (ingredientsText != null) 'ingredientsText': ingredientsText,
      if (sourceUrl != null) 'sourceUrl': sourceUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProductSummary',
      'source': source,
      'code': code,
      'productName': productName,
      if (brand != null) 'brand': brand,
      if (ingredientsText != null) 'ingredientsText': ingredientsText,
      if (sourceUrl != null) 'sourceUrl': sourceUrl,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductSummaryImpl extends ProductSummary {
  _ProductSummaryImpl({
    required String source,
    required String code,
    required String productName,
    String? brand,
    String? ingredientsText,
    String? sourceUrl,
  }) : super._(
         source: source,
         code: code,
         productName: productName,
         brand: brand,
         ingredientsText: ingredientsText,
         sourceUrl: sourceUrl,
       );

  /// Returns a shallow copy of this [ProductSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProductSummary copyWith({
    String? source,
    String? code,
    String? productName,
    Object? brand = _Undefined,
    Object? ingredientsText = _Undefined,
    Object? sourceUrl = _Undefined,
  }) {
    return ProductSummary(
      source: source ?? this.source,
      code: code ?? this.code,
      productName: productName ?? this.productName,
      brand: brand is String? ? brand : this.brand,
      ingredientsText: ingredientsText is String?
          ? ingredientsText
          : this.ingredientsText,
      sourceUrl: sourceUrl is String? ? sourceUrl : this.sourceUrl,
    );
  }
}
