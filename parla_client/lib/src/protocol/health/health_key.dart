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

/// The user's data key, encrypted ("wrapped") with the key-encryption key
/// (KEK). Deleting this row makes every copy of the user's health data,
/// including backups, unreadable (crypto-shredding, ENC-3).
abstract class HealthKey
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  HealthKey._({
    this.id,
    required this.authUserId,
    required this.wrappedKey,
    required this.nonce,
    required this.kekVersion,
    required this.createdAt,
  });

  factory HealthKey({
    int? id,
    required _isc.UuidValue authUserId,
    required String wrappedKey,
    required String nonce,
    required int kekVersion,
    required DateTime createdAt,
  }) = _HealthKeyImpl;

  factory HealthKey.fromJson(Map<String, dynamic> jsonSerialization) {
    return HealthKey(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      wrappedKey: jsonSerialization['wrappedKey'] as String,
      nonce: jsonSerialization['nonce'] as String,
      kekVersion: jsonSerialization['kekVersion'] as int,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  String wrappedKey;

  String nonce;

  int kekVersion;

  DateTime createdAt;

  /// Returns a shallow copy of this [HealthKey]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  HealthKey copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    String? wrappedKey,
    String? nonce,
    int? kekVersion,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HealthKey',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'wrappedKey': wrappedKey,
      'nonce': nonce,
      'kekVersion': kekVersion,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HealthKey',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'wrappedKey': wrappedKey,
      'nonce': nonce,
      'kekVersion': kekVersion,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HealthKeyImpl extends HealthKey {
  _HealthKeyImpl({
    int? id,
    required _isc.UuidValue authUserId,
    required String wrappedKey,
    required String nonce,
    required int kekVersion,
    required DateTime createdAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         wrappedKey: wrappedKey,
         nonce: nonce,
         kekVersion: kekVersion,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [HealthKey]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  HealthKey copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    String? wrappedKey,
    String? nonce,
    int? kekVersion,
    DateTime? createdAt,
  }) {
    return HealthKey(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      wrappedKey: wrappedKey ?? this.wrappedKey,
      nonce: nonce ?? this.nonce,
      kekVersion: kekVersion ?? this.kekVersion,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
