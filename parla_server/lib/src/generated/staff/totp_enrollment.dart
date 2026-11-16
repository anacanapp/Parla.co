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

/// Shown once while setting up the authenticator app.
abstract class TotpEnrollment
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TotpEnrollment._({
    required this.secret,
    required this.uri,
  });

  factory TotpEnrollment({
    required String secret,
    required String uri,
  }) = _TotpEnrollmentImpl;

  factory TotpEnrollment.fromJson(Map<String, dynamic> jsonSerialization) {
    return TotpEnrollment(
      secret: jsonSerialization['secret'] as String,
      uri: jsonSerialization['uri'] as String,
    );
  }

  String secret;

  String uri;

  /// Returns a shallow copy of this [TotpEnrollment]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TotpEnrollment copyWith({
    String? secret,
    String? uri,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TotpEnrollment',
      'secret': secret,
      'uri': uri,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TotpEnrollment',
      'secret': secret,
      'uri': uri,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _TotpEnrollmentImpl extends TotpEnrollment {
  _TotpEnrollmentImpl({
    required String secret,
    required String uri,
  }) : super._(
         secret: secret,
         uri: uri,
       );

  /// Returns a shallow copy of this [TotpEnrollment]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TotpEnrollment copyWith({
    String? secret,
    String? uri,
  }) {
    return TotpEnrollment(
      secret: secret ?? this.secret,
      uri: uri ?? this.uri,
    );
  }
}
