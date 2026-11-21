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

/// A brand that pays for campaigns (admin panel, admins only). Company
/// facts only: no contact person's name or phone (decision of
/// 2026-11-21); those stay in the signed contract.
abstract class Advertiser
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Advertiser._({
    this.id,
    required this.company,
    this.email,
    this.contractNumber,
    this.contractStart,
    this.contractEnd,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Advertiser({
    int? id,
    required String company,
    String? email,
    String? contractNumber,
    String? contractStart,
    String? contractEnd,
    String? note,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AdvertiserImpl;

  factory Advertiser.fromJson(Map<String, dynamic> jsonSerialization) {
    return Advertiser(
      id: jsonSerialization['id'] as int?,
      company: jsonSerialization['company'] as String,
      email: jsonSerialization['email'] as String?,
      contractNumber: jsonSerialization['contractNumber'] as String?,
      contractStart: jsonSerialization['contractStart'] as String?,
      contractEnd: jsonSerialization['contractEnd'] as String?,
      note: jsonSerialization['note'] as String?,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String company;

  /// The company's general address (e.g. info@brand.az), optional.
  String? email;

  String? contractNumber;

  /// Contract dates as YYYY-MM-DD.
  String? contractStart;

  String? contractEnd;

  String? note;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Advertiser]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Advertiser copyWith({
    int? id,
    String? company,
    String? email,
    String? contractNumber,
    String? contractStart,
    String? contractEnd,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Advertiser',
      if (id != null) 'id': id,
      'company': company,
      if (email != null) 'email': email,
      if (contractNumber != null) 'contractNumber': contractNumber,
      if (contractStart != null) 'contractStart': contractStart,
      if (contractEnd != null) 'contractEnd': contractEnd,
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Advertiser',
      if (id != null) 'id': id,
      'company': company,
      if (email != null) 'email': email,
      if (contractNumber != null) 'contractNumber': contractNumber,
      if (contractStart != null) 'contractStart': contractStart,
      if (contractEnd != null) 'contractEnd': contractEnd,
      if (note != null) 'note': note,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AdvertiserImpl extends Advertiser {
  _AdvertiserImpl({
    int? id,
    required String company,
    String? email,
    String? contractNumber,
    String? contractStart,
    String? contractEnd,
    String? note,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         company: company,
         email: email,
         contractNumber: contractNumber,
         contractStart: contractStart,
         contractEnd: contractEnd,
         note: note,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Advertiser]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Advertiser copyWith({
    Object? id = _Undefined,
    String? company,
    Object? email = _Undefined,
    Object? contractNumber = _Undefined,
    Object? contractStart = _Undefined,
    Object? contractEnd = _Undefined,
    Object? note = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Advertiser(
      id: id is int? ? id : this.id,
      company: company ?? this.company,
      email: email is String? ? email : this.email,
      contractNumber: contractNumber is String?
          ? contractNumber
          : this.contractNumber,
      contractStart: contractStart is String?
          ? contractStart
          : this.contractStart,
      contractEnd: contractEnd is String? ? contractEnd : this.contractEnd,
      note: note is String? ? note : this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
