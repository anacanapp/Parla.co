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

/// A staff member of the admin panel: an existing sign-in account with a
/// role. The TOTP secret for the second factor is sealed with a key derived
/// from the server KEK (never stored in clear). No name or phone is kept.
abstract class StaffMember
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StaffMember._({
    this.id,
    required this.authUserId,
    required this.role,
    required this.active,
    this.totpSecret,
    this.totpNonce,
    this.totpConfirmedAt,
    this.lastTotpStep,
    required this.failedTotp,
    this.lockedUntil,
    this.invitedBy,
    required this.createdAt,
  });

  factory StaffMember({
    int? id,
    required _isc.UuidValue authUserId,
    required _iopxo5n5.StaffRole role,
    required bool active,
    String? totpSecret,
    String? totpNonce,
    DateTime? totpConfirmedAt,
    int? lastTotpStep,
    required int failedTotp,
    DateTime? lockedUntil,
    _isc.UuidValue? invitedBy,
    required DateTime createdAt,
  }) = _StaffMemberImpl;

  factory StaffMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return StaffMember(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      role: _iopxo5n5.StaffRole.fromJson((jsonSerialization['role'] as String)),
      active: _isc.BoolJsonExtension.fromJson(jsonSerialization['active']),
      totpSecret: jsonSerialization['totpSecret'] as String?,
      totpNonce: jsonSerialization['totpNonce'] as String?,
      totpConfirmedAt: jsonSerialization['totpConfirmedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['totpConfirmedAt'],
            ),
      lastTotpStep: jsonSerialization['lastTotpStep'] as int?,
      failedTotp: jsonSerialization['failedTotp'] as int,
      lockedUntil: jsonSerialization['lockedUntil'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lockedUntil'],
            ),
      invitedBy: jsonSerialization['invitedBy'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(
              jsonSerialization['invitedBy'],
            ),
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

  _iopxo5n5.StaffRole role;

  bool active;

  String? totpSecret;

  String? totpNonce;

  DateTime? totpConfirmedAt;

  /// The last accepted TOTP time step, so a code cannot be used twice.
  int? lastTotpStep;

  int failedTotp;

  DateTime? lockedUntil;

  _isc.UuidValue? invitedBy;

  DateTime createdAt;

  /// Returns a shallow copy of this [StaffMember]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StaffMember copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    _iopxo5n5.StaffRole? role,
    bool? active,
    String? totpSecret,
    String? totpNonce,
    DateTime? totpConfirmedAt = const _isc.$UndefinedDateTime(),
    int? lastTotpStep,
    int? failedTotp,
    DateTime? lockedUntil = const _isc.$UndefinedDateTime(),
    _isc.UuidValue? invitedBy = const _isc.$UndefinedUuidValue(),
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StaffMember',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'role': role.toJson(),
      'active': active,
      if (totpSecret != null) 'totpSecret': totpSecret,
      if (totpNonce != null) 'totpNonce': totpNonce,
      if (totpConfirmedAt != null) 'totpConfirmedAt': totpConfirmedAt?.toJson(),
      if (lastTotpStep != null) 'lastTotpStep': lastTotpStep,
      'failedTotp': failedTotp,
      if (lockedUntil != null) 'lockedUntil': lockedUntil?.toJson(),
      if (invitedBy != null) 'invitedBy': invitedBy?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StaffMember',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'role': role.toJson(),
      'active': active,
      if (totpSecret != null) 'totpSecret': totpSecret,
      if (totpNonce != null) 'totpNonce': totpNonce,
      if (totpConfirmedAt != null) 'totpConfirmedAt': totpConfirmedAt?.toJson(),
      if (lastTotpStep != null) 'lastTotpStep': lastTotpStep,
      'failedTotp': failedTotp,
      if (lockedUntil != null) 'lockedUntil': lockedUntil?.toJson(),
      if (invitedBy != null) 'invitedBy': invitedBy?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StaffMemberImpl extends StaffMember {
  _StaffMemberImpl({
    int? id,
    required _isc.UuidValue authUserId,
    required _iopxo5n5.StaffRole role,
    required bool active,
    String? totpSecret,
    String? totpNonce,
    DateTime? totpConfirmedAt,
    int? lastTotpStep,
    required int failedTotp,
    DateTime? lockedUntil,
    _isc.UuidValue? invitedBy,
    required DateTime createdAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         role: role,
         active: active,
         totpSecret: totpSecret,
         totpNonce: totpNonce,
         totpConfirmedAt: totpConfirmedAt,
         lastTotpStep: lastTotpStep,
         failedTotp: failedTotp,
         lockedUntil: lockedUntil,
         invitedBy: invitedBy,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [StaffMember]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StaffMember copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    _iopxo5n5.StaffRole? role,
    bool? active,
    Object? totpSecret = _Undefined,
    Object? totpNonce = _Undefined,
    DateTime? totpConfirmedAt = const _isc.$UndefinedDateTime(),
    Object? lastTotpStep = _Undefined,
    int? failedTotp,
    DateTime? lockedUntil = const _isc.$UndefinedDateTime(),
    _isc.UuidValue? invitedBy = const _isc.$UndefinedUuidValue(),
    DateTime? createdAt,
  }) {
    return StaffMember(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      role: role ?? this.role,
      active: active ?? this.active,
      totpSecret: totpSecret is String? ? totpSecret : this.totpSecret,
      totpNonce: totpNonce is String? ? totpNonce : this.totpNonce,
      totpConfirmedAt: totpConfirmedAt is _isc.UndefinedSentinel
          ? this.totpConfirmedAt
          : totpConfirmedAt,
      lastTotpStep: lastTotpStep is int? ? lastTotpStep : this.lastTotpStep,
      failedTotp: failedTotp ?? this.failedTotp,
      lockedUntil: lockedUntil is _isc.UndefinedSentinel
          ? this.lockedUntil
          : lockedUntil,
      invitedBy: invitedBy is _isc.UndefinedSentinel
          ? this.invitedBy
          : invitedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
