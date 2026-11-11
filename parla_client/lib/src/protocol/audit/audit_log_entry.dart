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

/// Audit log (data map row 17, checklist AUD-1..AUD-4). Holds ids only,
/// never health content, emails or tokens. Append-only, kept 1 year.
abstract class AuditLogEntry
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AuditLogEntry._({
    this.id,
    this.actorId,
    required this.actorRole,
    required this.action,
    required this.objectType,
    this.objectId,
    required this.createdAt,
  });

  factory AuditLogEntry({
    int? id,
    _isc.UuidValue? actorId,
    required String actorRole,
    required String action,
    required String objectType,
    String? objectId,
    required DateTime createdAt,
  }) = _AuditLogEntryImpl;

  factory AuditLogEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuditLogEntry(
      id: jsonSerialization['id'] as int?,
      actorId: jsonSerialization['actorId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['actorId']),
      actorRole: jsonSerialization['actorRole'] as String,
      action: jsonSerialization['action'] as String,
      objectType: jsonSerialization['objectType'] as String,
      objectId: jsonSerialization['objectId'] as String?,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Who acted: the user themself or an internal account.
  _isc.UuidValue? actorId;

  String actorRole;

  /// For example: consent.granted, consent.withdrawn, profile.created.
  String action;

  String objectType;

  String? objectId;

  DateTime createdAt;

  /// Returns a shallow copy of this [AuditLogEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AuditLogEntry copyWith({
    int? id,
    _isc.UuidValue? actorId = const _isc.$UndefinedUuidValue(),
    String? actorRole,
    String? action,
    String? objectType,
    String? objectId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuditLogEntry',
      if (id != null) 'id': id,
      if (actorId != null) 'actorId': actorId?.toJson(),
      'actorRole': actorRole,
      'action': action,
      'objectType': objectType,
      if (objectId != null) 'objectId': objectId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuditLogEntry',
      if (id != null) 'id': id,
      if (actorId != null) 'actorId': actorId?.toJson(),
      'actorRole': actorRole,
      'action': action,
      'objectType': objectType,
      if (objectId != null) 'objectId': objectId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuditLogEntryImpl extends AuditLogEntry {
  _AuditLogEntryImpl({
    int? id,
    _isc.UuidValue? actorId,
    required String actorRole,
    required String action,
    required String objectType,
    String? objectId,
    required DateTime createdAt,
  }) : super._(
         id: id,
         actorId: actorId,
         actorRole: actorRole,
         action: action,
         objectType: objectType,
         objectId: objectId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AuditLogEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AuditLogEntry copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? actorId = const _isc.$UndefinedUuidValue(),
    String? actorRole,
    String? action,
    String? objectType,
    Object? objectId = _Undefined,
    DateTime? createdAt,
  }) {
    return AuditLogEntry(
      id: id is int? ? id : this.id,
      actorId: actorId is _isc.UndefinedSentinel ? this.actorId : actorId,
      actorRole: actorRole ?? this.actorRole,
      action: action ?? this.action,
      objectType: objectType ?? this.objectType,
      objectId: objectId is String? ? objectId : this.objectId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
