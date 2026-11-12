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

/// Encrypted health answers (data map rows 8-11), one row per user.
/// [ciphertext] is AES-256-GCM under the user's data key; the user id is
/// bound in as associated data. Deleted when the health consent is
/// withdrawn (CON-6).
abstract class HealthRecord
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  HealthRecord._({
    this.id,
    required this.authUserId,
    required this.ciphertext,
    required this.nonce,
    required this.contentVersion,
    required this.updatedAt,
  });

  factory HealthRecord({
    int? id,
    required _isc.UuidValue authUserId,
    required String ciphertext,
    required String nonce,
    required String contentVersion,
    required DateTime updatedAt,
  }) = _HealthRecordImpl;

  factory HealthRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return HealthRecord(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      ciphertext: jsonSerialization['ciphertext'] as String,
      nonce: jsonSerialization['nonce'] as String,
      contentVersion: jsonSerialization['contentVersion'] as String,
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

  String contentVersion;

  DateTime updatedAt;

  /// Returns a shallow copy of this [HealthRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  HealthRecord copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    String? ciphertext,
    String? nonce,
    String? contentVersion,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HealthRecord',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'ciphertext': ciphertext,
      'nonce': nonce,
      'contentVersion': contentVersion,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HealthRecord',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'ciphertext': ciphertext,
      'nonce': nonce,
      'contentVersion': contentVersion,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HealthRecordImpl extends HealthRecord {
  _HealthRecordImpl({
    int? id,
    required _isc.UuidValue authUserId,
    required String ciphertext,
    required String nonce,
    required String contentVersion,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         ciphertext: ciphertext,
         nonce: nonce,
         contentVersion: contentVersion,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [HealthRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  HealthRecord copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    String? ciphertext,
    String? nonce,
    String? contentVersion,
    DateTime? updatedAt,
  }) {
    return HealthRecord(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      ciphertext: ciphertext ?? this.ciphertext,
      nonce: nonce ?? this.nonce,
      contentVersion: contentVersion ?? this.contentVersion,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
