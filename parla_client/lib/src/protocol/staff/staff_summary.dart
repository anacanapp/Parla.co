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

/// One staff member in the admin's staff list.
abstract class StaffSummary
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StaffSummary._({
    required this.authUserId,
    required this.email,
    required this.role,
    required this.active,
    required this.totpEnrolled,
    required this.createdAt,
  });

  factory StaffSummary({
    required _isc.UuidValue authUserId,
    required String email,
    required _iopxo5n5.StaffRole role,
    required bool active,
    required bool totpEnrolled,
    required DateTime createdAt,
  }) = _StaffSummaryImpl;

  factory StaffSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return StaffSummary(
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      email: jsonSerialization['email'] as String,
      role: _iopxo5n5.StaffRole.fromJson((jsonSerialization['role'] as String)),
      active: _isc.BoolJsonExtension.fromJson(jsonSerialization['active']),
      totpEnrolled: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['totpEnrolled'],
      ),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  _isc.UuidValue authUserId;

  String email;

  _iopxo5n5.StaffRole role;

  bool active;

  bool totpEnrolled;

  DateTime createdAt;

  /// Returns a shallow copy of this [StaffSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StaffSummary copyWith({
    _isc.UuidValue? authUserId,
    String? email,
    _iopxo5n5.StaffRole? role,
    bool? active,
    bool? totpEnrolled,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StaffSummary',
      'authUserId': authUserId.toJson(),
      'email': email,
      'role': role.toJson(),
      'active': active,
      'totpEnrolled': totpEnrolled,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StaffSummary',
      'authUserId': authUserId.toJson(),
      'email': email,
      'role': role.toJson(),
      'active': active,
      'totpEnrolled': totpEnrolled,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _StaffSummaryImpl extends StaffSummary {
  _StaffSummaryImpl({
    required _isc.UuidValue authUserId,
    required String email,
    required _iopxo5n5.StaffRole role,
    required bool active,
    required bool totpEnrolled,
    required DateTime createdAt,
  }) : super._(
         authUserId: authUserId,
         email: email,
         role: role,
         active: active,
         totpEnrolled: totpEnrolled,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [StaffSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StaffSummary copyWith({
    _isc.UuidValue? authUserId,
    String? email,
    _iopxo5n5.StaffRole? role,
    bool? active,
    bool? totpEnrolled,
    DateTime? createdAt,
  }) {
    return StaffSummary(
      authUserId: authUserId ?? this.authUserId,
      email: email ?? this.email,
      role: role ?? this.role,
      active: active ?? this.active,
      totpEnrolled: totpEnrolled ?? this.totpEnrolled,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
