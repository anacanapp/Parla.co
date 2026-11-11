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
import '../consent/consent_type.dart' as _ienhynl9;

/// The latest decision for one consent type, as shown to the user.
abstract class ConsentState
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ConsentState._({
    required this.consentType,
    required this.granted,
    this.textVersion,
    this.updatedAt,
  });

  factory ConsentState({
    required _ienhynl9.ConsentType consentType,
    required bool granted,
    String? textVersion,
    DateTime? updatedAt,
  }) = _ConsentStateImpl;

  factory ConsentState.fromJson(Map<String, dynamic> jsonSerialization) {
    return ConsentState(
      consentType: _ienhynl9.ConsentType.fromJson(
        (jsonSerialization['consentType'] as String),
      ),
      granted: _is.BoolJsonExtension.fromJson(jsonSerialization['granted']),
      textVersion: jsonSerialization['textVersion'] as String?,
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  _ienhynl9.ConsentType consentType;

  bool granted;

  String? textVersion;

  DateTime? updatedAt;

  /// Returns a shallow copy of this [ConsentState]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ConsentState copyWith({
    _ienhynl9.ConsentType? consentType,
    bool? granted,
    String? textVersion,
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ConsentState',
      'consentType': consentType.toJson(),
      'granted': granted,
      if (textVersion != null) 'textVersion': textVersion,
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ConsentState',
      'consentType': consentType.toJson(),
      'granted': granted,
      if (textVersion != null) 'textVersion': textVersion,
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ConsentStateImpl extends ConsentState {
  _ConsentStateImpl({
    required _ienhynl9.ConsentType consentType,
    required bool granted,
    String? textVersion,
    DateTime? updatedAt,
  }) : super._(
         consentType: consentType,
         granted: granted,
         textVersion: textVersion,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ConsentState]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ConsentState copyWith({
    _ienhynl9.ConsentType? consentType,
    bool? granted,
    Object? textVersion = _Undefined,
    DateTime? updatedAt = const _is.$UndefinedDateTime(),
  }) {
    return ConsentState(
      consentType: consentType ?? this.consentType,
      granted: granted ?? this.granted,
      textVersion: textVersion is String? ? textVersion : this.textVersion,
      updatedAt: updatedAt is _is.UndefinedSentinel
          ? this.updatedAt
          : updatedAt,
    );
  }
}
