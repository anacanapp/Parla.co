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

/// A rule violation the app can show to the user. [code] is stable and
/// translated on the client; it never contains personal data.
abstract class ParlaException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  ParlaException._({required this.code});

  factory ParlaException({required String code}) = _ParlaExceptionImpl;

  factory ParlaException.fromJson(Map<String, dynamic> jsonSerialization) {
    return ParlaException(code: jsonSerialization['code'] as String);
  }

  String code;

  /// Returns a shallow copy of this [ParlaException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ParlaException copyWith({String? code});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ParlaException',
      'code': code,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ParlaException',
      'code': code,
    };
  }

  @override
  String toString() {
    return 'ParlaException(code: $code)';
  }
}

class _ParlaExceptionImpl extends ParlaException {
  _ParlaExceptionImpl({required String code}) : super._(code: code);

  /// Returns a shallow copy of this [ParlaException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ParlaException copyWith({String? code}) {
    return ParlaException(code: code ?? this.code);
  }
}
