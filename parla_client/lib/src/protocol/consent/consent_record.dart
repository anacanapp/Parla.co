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
import '../consent/consent_type.dart' as _ienhynl9;

/// One consent decision. Append-only: a change is a new row, never an update
/// (GDPR Art. 7(1), checklist CON-3). Retention: 3 years after account
/// deletion with a hashed user id (proposal, pending legal review).
abstract class ConsentRecord
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ConsentRecord._({
    this.id,
    required this.authUserId,
    required this.consentType,
    required this.granted,
    required this.textVersion,
    required this.textHash,
    required this.language,
    required this.source,
    required this.createdAt,
  });

  factory ConsentRecord({
    int? id,
    required _isc.UuidValue authUserId,
    required _ienhynl9.ConsentType consentType,
    required bool granted,
    required String textVersion,
    required String textHash,
    required String language,
    required String source,
    required DateTime createdAt,
  }) = _ConsentRecordImpl;

  factory ConsentRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return ConsentRecord(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      consentType: _ienhynl9.ConsentType.fromJson(
        (jsonSerialization['consentType'] as String),
      ),
      granted: _isc.BoolJsonExtension.fromJson(jsonSerialization['granted']),
      textVersion: jsonSerialization['textVersion'] as String,
      textHash: jsonSerialization['textHash'] as String,
      language: jsonSerialization['language'] as String,
      source: jsonSerialization['source'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The authenticated user who decided.
  _isc.UuidValue authUserId;

  _ienhynl9.ConsentType consentType;

  bool granted;

  /// Version of the text in parla_shared that was shown.
  String textVersion;

  /// SHA-256 of the exact text shown, in [language].
  String textHash;

  String language;

  /// Where the decision was made: app or web.
  String source;

  DateTime createdAt;

  /// Returns a shallow copy of this [ConsentRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ConsentRecord copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    _ienhynl9.ConsentType? consentType,
    bool? granted,
    String? textVersion,
    String? textHash,
    String? language,
    String? source,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ConsentRecord',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'consentType': consentType.toJson(),
      'granted': granted,
      'textVersion': textVersion,
      'textHash': textHash,
      'language': language,
      'source': source,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ConsentRecord',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'consentType': consentType.toJson(),
      'granted': granted,
      'textVersion': textVersion,
      'textHash': textHash,
      'language': language,
      'source': source,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ConsentRecordImpl extends ConsentRecord {
  _ConsentRecordImpl({
    int? id,
    required _isc.UuidValue authUserId,
    required _ienhynl9.ConsentType consentType,
    required bool granted,
    required String textVersion,
    required String textHash,
    required String language,
    required String source,
    required DateTime createdAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         consentType: consentType,
         granted: granted,
         textVersion: textVersion,
         textHash: textHash,
         language: language,
         source: source,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ConsentRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ConsentRecord copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    _ienhynl9.ConsentType? consentType,
    bool? granted,
    String? textVersion,
    String? textHash,
    String? language,
    String? source,
    DateTime? createdAt,
  }) {
    return ConsentRecord(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      consentType: consentType ?? this.consentType,
      granted: granted ?? this.granted,
      textVersion: textVersion ?? this.textVersion,
      textHash: textHash ?? this.textHash,
      language: language ?? this.language,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
