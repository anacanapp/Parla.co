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

/// A phone's push token (Firebase Cloud Messaging) for an account. Only
/// stored while the user has turned notifications on in the app; deleted
/// on sign-out, with the account, when FCM reports it gone, and after 90
/// days without being seen.
abstract class DeviceToken
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceToken._({
    this.id,
    required this.authUserId,
    required this.token,
    required this.platform,
    required this.createdAt,
    required this.lastSeenAt,
  });

  factory DeviceToken({
    int? id,
    required _isc.UuidValue authUserId,
    required String token,
    required String platform,
    required DateTime createdAt,
    required DateTime lastSeenAt,
  }) = _DeviceTokenImpl;

  factory DeviceToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceToken(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      token: jsonSerialization['token'] as String,
      platform: jsonSerialization['platform'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      lastSeenAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastSeenAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  String token;

  String platform;

  DateTime createdAt;

  DateTime lastSeenAt;

  /// Returns a shallow copy of this [DeviceToken]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceToken copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    String? token,
    String? platform,
    DateTime? createdAt,
    DateTime? lastSeenAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceToken',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'token': token,
      'platform': platform,
      'createdAt': createdAt.toJson(),
      'lastSeenAt': lastSeenAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceToken',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'token': token,
      'platform': platform,
      'createdAt': createdAt.toJson(),
      'lastSeenAt': lastSeenAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceTokenImpl extends DeviceToken {
  _DeviceTokenImpl({
    int? id,
    required _isc.UuidValue authUserId,
    required String token,
    required String platform,
    required DateTime createdAt,
    required DateTime lastSeenAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         token: token,
         platform: platform,
         createdAt: createdAt,
         lastSeenAt: lastSeenAt,
       );

  /// Returns a shallow copy of this [DeviceToken]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceToken copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    String? token,
    String? platform,
    DateTime? createdAt,
    DateTime? lastSeenAt,
  }) {
    return DeviceToken(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      token: token ?? this.token,
      platform: platform ?? this.platform,
      createdAt: createdAt ?? this.createdAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }
}
