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

/// A sign-in session that passed the second factor. [authId] is the id of
/// the sign-in session (refresh token); admin calls are accepted only while
/// a row for it exists and has not expired (8 hours).
abstract class StaffSession
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StaffSession._({
    this.id,
    required this.authUserId,
    required this.authId,
    required this.verifiedAt,
    required this.expiresAt,
  });

  factory StaffSession({
    int? id,
    required _isc.UuidValue authUserId,
    required String authId,
    required DateTime verifiedAt,
    required DateTime expiresAt,
  }) = _StaffSessionImpl;

  factory StaffSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return StaffSession(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authId: jsonSerialization['authId'] as String,
      verifiedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['verifiedAt'],
      ),
      expiresAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  String authId;

  DateTime verifiedAt;

  DateTime expiresAt;

  /// Returns a shallow copy of this [StaffSession]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StaffSession copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    String? authId,
    DateTime? verifiedAt,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StaffSession',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'authId': authId,
      'verifiedAt': verifiedAt.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StaffSession',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'authId': authId,
      'verifiedAt': verifiedAt.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StaffSessionImpl extends StaffSession {
  _StaffSessionImpl({
    int? id,
    required _isc.UuidValue authUserId,
    required String authId,
    required DateTime verifiedAt,
    required DateTime expiresAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authId: authId,
         verifiedAt: verifiedAt,
         expiresAt: expiresAt,
       );

  /// Returns a shallow copy of this [StaffSession]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StaffSession copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    String? authId,
    DateTime? verifiedAt,
    DateTime? expiresAt,
  }) {
    return StaffSession(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authId: authId ?? this.authId,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
