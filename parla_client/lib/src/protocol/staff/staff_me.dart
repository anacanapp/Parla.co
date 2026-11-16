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

/// What the admin panel needs to know about the signed-in staff member.
abstract class StaffMe
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StaffMe._({
    required this.role,
    required this.totpEnrolled,
    required this.verified,
  });

  factory StaffMe({
    required _iopxo5n5.StaffRole role,
    required bool totpEnrolled,
    required bool verified,
  }) = _StaffMeImpl;

  factory StaffMe.fromJson(Map<String, dynamic> jsonSerialization) {
    return StaffMe(
      role: _iopxo5n5.StaffRole.fromJson((jsonSerialization['role'] as String)),
      totpEnrolled: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['totpEnrolled'],
      ),
      verified: _isc.BoolJsonExtension.fromJson(jsonSerialization['verified']),
    );
  }

  _iopxo5n5.StaffRole role;

  bool totpEnrolled;

  bool verified;

  /// Returns a shallow copy of this [StaffMe]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StaffMe copyWith({
    _iopxo5n5.StaffRole? role,
    bool? totpEnrolled,
    bool? verified,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StaffMe',
      'role': role.toJson(),
      'totpEnrolled': totpEnrolled,
      'verified': verified,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StaffMe',
      'role': role.toJson(),
      'totpEnrolled': totpEnrolled,
      'verified': verified,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _StaffMeImpl extends StaffMe {
  _StaffMeImpl({
    required _iopxo5n5.StaffRole role,
    required bool totpEnrolled,
    required bool verified,
  }) : super._(
         role: role,
         totpEnrolled: totpEnrolled,
         verified: verified,
       );

  /// Returns a shallow copy of this [StaffMe]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StaffMe copyWith({
    _iopxo5n5.StaffRole? role,
    bool? totpEnrolled,
    bool? verified,
  }) {
    return StaffMe(
      role: role ?? this.role,
      totpEnrolled: totpEnrolled ?? this.totpEnrolled,
      verified: verified ?? this.verified,
    );
  }
}
