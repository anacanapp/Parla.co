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

/// One support message, sealed with a key derived from the server KEK and
/// bound to the thread's owner. [staffId] is set for the team's replies.
abstract class SupportMessage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SupportMessage._({
    this.id,
    required this.threadId,
    required this.fromStaff,
    this.staffId,
    required this.ciphertext,
    required this.nonce,
    required this.createdAt,
  });

  factory SupportMessage({
    int? id,
    required int threadId,
    required bool fromStaff,
    _isc.UuidValue? staffId,
    required String ciphertext,
    required String nonce,
    required DateTime createdAt,
  }) = _SupportMessageImpl;

  factory SupportMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return SupportMessage(
      id: jsonSerialization['id'] as int?,
      threadId: jsonSerialization['threadId'] as int,
      fromStaff: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['fromStaff'],
      ),
      staffId: jsonSerialization['staffId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['staffId']),
      ciphertext: jsonSerialization['ciphertext'] as String,
      nonce: jsonSerialization['nonce'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int threadId;

  bool fromStaff;

  _isc.UuidValue? staffId;

  String ciphertext;

  String nonce;

  DateTime createdAt;

  /// Returns a shallow copy of this [SupportMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SupportMessage copyWith({
    int? id,
    int? threadId,
    bool? fromStaff,
    _isc.UuidValue? staffId = const _isc.$UndefinedUuidValue(),
    String? ciphertext,
    String? nonce,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SupportMessage',
      if (id != null) 'id': id,
      'threadId': threadId,
      'fromStaff': fromStaff,
      if (staffId != null) 'staffId': staffId?.toJson(),
      'ciphertext': ciphertext,
      'nonce': nonce,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SupportMessage',
      if (id != null) 'id': id,
      'threadId': threadId,
      'fromStaff': fromStaff,
      if (staffId != null) 'staffId': staffId?.toJson(),
      'ciphertext': ciphertext,
      'nonce': nonce,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SupportMessageImpl extends SupportMessage {
  _SupportMessageImpl({
    int? id,
    required int threadId,
    required bool fromStaff,
    _isc.UuidValue? staffId,
    required String ciphertext,
    required String nonce,
    required DateTime createdAt,
  }) : super._(
         id: id,
         threadId: threadId,
         fromStaff: fromStaff,
         staffId: staffId,
         ciphertext: ciphertext,
         nonce: nonce,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SupportMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SupportMessage copyWith({
    Object? id = _Undefined,
    int? threadId,
    bool? fromStaff,
    _isc.UuidValue? staffId = const _isc.$UndefinedUuidValue(),
    String? ciphertext,
    String? nonce,
    DateTime? createdAt,
  }) {
    return SupportMessage(
      id: id is int? ? id : this.id,
      threadId: threadId ?? this.threadId,
      fromStaff: fromStaff ?? this.fromStaff,
      staffId: staffId is _isc.UndefinedSentinel ? this.staffId : staffId,
      ciphertext: ciphertext ?? this.ciphertext,
      nonce: nonce ?? this.nonce,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
