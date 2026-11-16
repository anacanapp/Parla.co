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
import '../staff/staff_role.dart' as _iopxo5n5;

/// An invitation to the admin panel. Only a hash of the one-time code is
/// kept; the code itself goes by email. Single use, expires after 72 hours.
abstract class StaffInvite
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StaffInvite._({
    this.id,
    required this.email,
    required this.role,
    required this.codeHash,
    required this.invitedBy,
    required this.expiresAt,
    this.usedAt,
    required this.createdAt,
  });

  factory StaffInvite({
    int? id,
    required String email,
    required _iopxo5n5.StaffRole role,
    required String codeHash,
    required _isc.UuidValue invitedBy,
    required DateTime expiresAt,
    DateTime? usedAt,
    required DateTime createdAt,
  }) = _StaffInviteImpl;

  factory StaffInvite.fromJson(Map<String, dynamic> jsonSerialization) {
    return StaffInvite(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      role: _iopxo5n5.StaffRole.fromJson((jsonSerialization['role'] as String)),
      codeHash: jsonSerialization['codeHash'] as String,
      invitedBy: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['invitedBy'],
      ),
      expiresAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      usedAt: jsonSerialization['usedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['usedAt']),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String email;

  _iopxo5n5.StaffRole role;

  String codeHash;

  _isc.UuidValue invitedBy;

  DateTime expiresAt;

  DateTime? usedAt;

  DateTime createdAt;

  /// Returns a shallow copy of this [StaffInvite]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StaffInvite copyWith({
    int? id,
    String? email,
    _iopxo5n5.StaffRole? role,
    String? codeHash,
    _isc.UuidValue? invitedBy,
    DateTime? expiresAt,
    DateTime? usedAt = const _isc.$UndefinedDateTime(),
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StaffInvite',
      if (id != null) 'id': id,
      'email': email,
      'role': role.toJson(),
      'codeHash': codeHash,
      'invitedBy': invitedBy.toJson(),
      'expiresAt': expiresAt.toJson(),
      if (usedAt != null) 'usedAt': usedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StaffInvite',
      if (id != null) 'id': id,
      'email': email,
      'role': role.toJson(),
      'codeHash': codeHash,
      'invitedBy': invitedBy.toJson(),
      'expiresAt': expiresAt.toJson(),
      if (usedAt != null) 'usedAt': usedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StaffInviteImpl extends StaffInvite {
  _StaffInviteImpl({
    int? id,
    required String email,
    required _iopxo5n5.StaffRole role,
    required String codeHash,
    required _isc.UuidValue invitedBy,
    required DateTime expiresAt,
    DateTime? usedAt,
    required DateTime createdAt,
  }) : super._(
         id: id,
         email: email,
         role: role,
         codeHash: codeHash,
         invitedBy: invitedBy,
         expiresAt: expiresAt,
         usedAt: usedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [StaffInvite]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StaffInvite copyWith({
    Object? id = _Undefined,
    String? email,
    _iopxo5n5.StaffRole? role,
    String? codeHash,
    _isc.UuidValue? invitedBy,
    DateTime? expiresAt,
    DateTime? usedAt = const _isc.$UndefinedDateTime(),
    DateTime? createdAt,
  }) {
    return StaffInvite(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      codeHash: codeHash ?? this.codeHash,
      invitedBy: invitedBy ?? this.invitedBy,
      expiresAt: expiresAt ?? this.expiresAt,
      usedAt: usedAt is _isc.UndefinedSentinel ? this.usedAt : usedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
