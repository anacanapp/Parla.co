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
import 'package:parla_client/src/protocol/protocol.dart' as _id6y4bzp;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../consent/consent_state.dart' as _ic0vp8xp;

/// An app account as the admin panel shows it: account data and consent
/// decisions only, never health data or the birth year.
abstract class UserAdminView
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UserAdminView._({
    required this.userId,
    required this.email,
    this.registeredAt,
    this.countryCode,
    this.language,
    required this.blocked,
    required this.isStaff,
    required this.consents,
  });

  factory UserAdminView({
    required _isc.UuidValue userId,
    required String email,
    DateTime? registeredAt,
    String? countryCode,
    String? language,
    required bool blocked,
    required bool isStaff,
    required List<_ic0vp8xp.ConsentState> consents,
  }) = _UserAdminViewImpl;

  factory UserAdminView.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserAdminView(
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      email: jsonSerialization['email'] as String,
      registeredAt: jsonSerialization['registeredAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['registeredAt'],
            ),
      countryCode: jsonSerialization['countryCode'] as String?,
      language: jsonSerialization['language'] as String?,
      blocked: _isc.BoolJsonExtension.fromJson(jsonSerialization['blocked']),
      isStaff: _isc.BoolJsonExtension.fromJson(jsonSerialization['isStaff']),
      consents: _id6y4bzp.Protocol().deserialize<List<_ic0vp8xp.ConsentState>>(
        jsonSerialization['consents'],
      ),
    );
  }

  _isc.UuidValue userId;

  String email;

  DateTime? registeredAt;

  String? countryCode;

  String? language;

  bool blocked;

  bool isStaff;

  List<_ic0vp8xp.ConsentState> consents;

  /// Returns a shallow copy of this [UserAdminView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UserAdminView copyWith({
    _isc.UuidValue? userId,
    String? email,
    DateTime? registeredAt = const _isc.$UndefinedDateTime(),
    String? countryCode,
    String? language,
    bool? blocked,
    bool? isStaff,
    List<_ic0vp8xp.ConsentState>? consents,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserAdminView',
      'userId': userId.toJson(),
      'email': email,
      if (registeredAt != null) 'registeredAt': registeredAt?.toJson(),
      if (countryCode != null) 'countryCode': countryCode,
      if (language != null) 'language': language,
      'blocked': blocked,
      'isStaff': isStaff,
      'consents': consents.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserAdminView',
      'userId': userId.toJson(),
      'email': email,
      if (registeredAt != null) 'registeredAt': registeredAt?.toJson(),
      if (countryCode != null) 'countryCode': countryCode,
      if (language != null) 'language': language,
      'blocked': blocked,
      'isStaff': isStaff,
      'consents': consents.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserAdminViewImpl extends UserAdminView {
  _UserAdminViewImpl({
    required _isc.UuidValue userId,
    required String email,
    DateTime? registeredAt,
    String? countryCode,
    String? language,
    required bool blocked,
    required bool isStaff,
    required List<_ic0vp8xp.ConsentState> consents,
  }) : super._(
         userId: userId,
         email: email,
         registeredAt: registeredAt,
         countryCode: countryCode,
         language: language,
         blocked: blocked,
         isStaff: isStaff,
         consents: consents,
       );

  /// Returns a shallow copy of this [UserAdminView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UserAdminView copyWith({
    _isc.UuidValue? userId,
    String? email,
    DateTime? registeredAt = const _isc.$UndefinedDateTime(),
    Object? countryCode = _Undefined,
    Object? language = _Undefined,
    bool? blocked,
    bool? isStaff,
    List<_ic0vp8xp.ConsentState>? consents,
  }) {
    return UserAdminView(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      registeredAt: registeredAt is _isc.UndefinedSentinel
          ? this.registeredAt
          : registeredAt,
      countryCode: countryCode is String? ? countryCode : this.countryCode,
      language: language is String? ? language : this.language,
      blocked: blocked ?? this.blocked,
      isStaff: isStaff ?? this.isStaff,
      consents: consents ?? this.consents.map((e0) => e0.copyWith()).toList(),
    );
  }
}
