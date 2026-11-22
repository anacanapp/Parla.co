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

/// What the admin panel needs to know about the signed-in staff member.
/// [signInExpiresAt]: 12 hours after the sign-in (password or emailed
/// code); afterwards the panel asks to sign in again.
abstract class StaffMe
    implements _is.SerializableModel, _is.ProtocolSerialization {
  StaffMe._({
    required this.role,
    required this.signInExpiresAt,
  });

  factory StaffMe({
    required _iopxo5n5.StaffRole role,
    required DateTime signInExpiresAt,
  }) = _StaffMeImpl;

  factory StaffMe.fromJson(Map<String, dynamic> jsonSerialization) {
    return StaffMe(
      role: _iopxo5n5.StaffRole.fromJson((jsonSerialization['role'] as String)),
      signInExpiresAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['signInExpiresAt'],
      ),
    );
  }

  _iopxo5n5.StaffRole role;

  DateTime signInExpiresAt;

  /// Returns a shallow copy of this [StaffMe]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StaffMe copyWith({
    _iopxo5n5.StaffRole? role,
    DateTime? signInExpiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StaffMe',
      'role': role.toJson(),
      'signInExpiresAt': signInExpiresAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StaffMe',
      'role': role.toJson(),
      'signInExpiresAt': signInExpiresAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _StaffMeImpl extends StaffMe {
  _StaffMeImpl({
    required _iopxo5n5.StaffRole role,
    required DateTime signInExpiresAt,
  }) : super._(
         role: role,
         signInExpiresAt: signInExpiresAt,
       );

  /// Returns a shallow copy of this [StaffMe]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StaffMe copyWith({
    _iopxo5n5.StaffRole? role,
    DateTime? signInExpiresAt,
  }) {
    return StaffMe(
      role: role ?? this.role,
      signInExpiresAt: signInExpiresAt ?? this.signInExpiresAt,
    );
  }
}
