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

/// The user's daily plate entries (food groups per day, no amounts), one
/// row per user. [ciphertext] is AES-256-GCM
/// under the same data key as the health answers, with the user id bound
/// in as associated data. Stored only with a health consent whose text
/// covers it; deleted with the consent.
abstract class NutritionRecord
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  NutritionRecord._({
    this.id,
    required this.authUserId,
    required this.ciphertext,
    required this.nonce,
    required this.format,
    required this.updatedAt,
  });

  factory NutritionRecord({
    int? id,
    required _isc.UuidValue authUserId,
    required String ciphertext,
    required String nonce,
    required int format,
    required DateTime updatedAt,
  }) = _NutritionRecordImpl;

  factory NutritionRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return NutritionRecord(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      ciphertext: jsonSerialization['ciphertext'] as String,
      nonce: jsonSerialization['nonce'] as String,
      format: jsonSerialization['format'] as int,
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  String ciphertext;

  String nonce;

  int format;

  DateTime updatedAt;

  /// Returns a shallow copy of this [NutritionRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  NutritionRecord copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    String? ciphertext,
    String? nonce,
    int? format,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NutritionRecord',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'ciphertext': ciphertext,
      'nonce': nonce,
      'format': format,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NutritionRecord',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'ciphertext': ciphertext,
      'nonce': nonce,
      'format': format,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NutritionRecordImpl extends NutritionRecord {
  _NutritionRecordImpl({
    int? id,
    required _isc.UuidValue authUserId,
    required String ciphertext,
    required String nonce,
    required int format,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         ciphertext: ciphertext,
         nonce: nonce,
         format: format,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NutritionRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  NutritionRecord copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    String? ciphertext,
    String? nonce,
    int? format,
    DateTime? updatedAt,
  }) {
    return NutritionRecord(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      ciphertext: ciphertext ?? this.ciphertext,
      nonce: nonce ?? this.nonce,
      format: format ?? this.format,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
