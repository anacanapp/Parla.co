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
import 'package:serverpod/serverpod.dart' as _is;
import '../staff/staff_role.dart' as _iopxo5n5;

/// An open invitation in the admin's staff list.
abstract class StaffInviteSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  StaffInviteSummary._({
    required this.id,
    required this.email,
    required this.role,
    required this.expiresAt,
  });

  factory StaffInviteSummary({
    required int id,
    required String email,
    required _iopxo5n5.StaffRole role,
    required DateTime expiresAt,
  }) = _StaffInviteSummaryImpl;

  factory StaffInviteSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return StaffInviteSummary(
      id: jsonSerialization['id'] as int,
      email: jsonSerialization['email'] as String,
      role: _iopxo5n5.StaffRole.fromJson((jsonSerialization['role'] as String)),
      expiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
    );
  }

  int id;

  String email;

  _iopxo5n5.StaffRole role;

  DateTime expiresAt;

  /// Returns a shallow copy of this [StaffInviteSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StaffInviteSummary copyWith({
    int? id,
    String? email,
    _iopxo5n5.StaffRole? role,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StaffInviteSummary',
      'id': id,
      'email': email,
      'role': role.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StaffInviteSummary',
      'id': id,
      'email': email,
      'role': role.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _StaffInviteSummaryImpl extends StaffInviteSummary {
  _StaffInviteSummaryImpl({
    required int id,
    required String email,
    required _iopxo5n5.StaffRole role,
    required DateTime expiresAt,
  }) : super._(
         id: id,
         email: email,
         role: role,
         expiresAt: expiresAt,
       );

  /// Returns a shallow copy of this [StaffInviteSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StaffInviteSummary copyWith({
    int? id,
    String? email,
    _iopxo5n5.StaffRole? role,
    DateTime? expiresAt,
  }) {
    return StaffInviteSummary(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
