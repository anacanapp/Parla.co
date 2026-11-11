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

/// Core profile (data map rows 3-5). Stored in the user's country region.
/// Deliberately has no name, full birth date, phone or location
/// (data minimisation list).
abstract class MemberProfile
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MemberProfile._({
    this.id,
    required this.authUserId,
    required this.birthYear,
    required this.countryCode,
    required this.language,
    required this.createdAt,
  });

  factory MemberProfile({
    int? id,
    required _isc.UuidValue authUserId,
    required int birthYear,
    required String countryCode,
    required String language,
    required DateTime createdAt,
  }) = _MemberProfileImpl;

  factory MemberProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return MemberProfile(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      birthYear: jsonSerialization['birthYear'] as int,
      countryCode: jsonSerialization['countryCode'] as String,
      language: jsonSerialization['language'] as String,
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

  /// Only the year (age gate and age-appropriate routine).
  int birthYear;

  /// ISO 3166-1 alpha-2; decides the data region.
  String countryCode;

  /// Interface language: az, ru or en.
  String language;

  DateTime createdAt;

  /// Returns a shallow copy of this [MemberProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MemberProfile copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    int? birthYear,
    String? countryCode,
    String? language,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MemberProfile',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'birthYear': birthYear,
      'countryCode': countryCode,
      'language': language,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MemberProfile',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'birthYear': birthYear,
      'countryCode': countryCode,
      'language': language,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MemberProfileImpl extends MemberProfile {
  _MemberProfileImpl({
    int? id,
    required _isc.UuidValue authUserId,
    required int birthYear,
    required String countryCode,
    required String language,
    required DateTime createdAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         birthYear: birthYear,
         countryCode: countryCode,
         language: language,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [MemberProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MemberProfile copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    int? birthYear,
    String? countryCode,
    String? language,
    DateTime? createdAt,
  }) {
    return MemberProfile(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      birthYear: birthYear ?? this.birthYear,
      countryCode: countryCode ?? this.countryCode,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
