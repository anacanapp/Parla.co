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

/// A push campaign being sent in the background, in batches of users,
/// so a large audience does not run inside the publish request and a
/// restart resumes where it stopped. Holds ids and counts only.
abstract class PushJob
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PushJob._({
    this.id,
    required this.contentId,
    required this.status,
    required this.sent,
    this.cursor,
    this.leaseUntil,
    required this.createdAt,
    this.finishedAt,
  });

  factory PushJob({
    int? id,
    required int contentId,
    required String status,
    required int sent,
    _isc.UuidValue? cursor,
    DateTime? leaseUntil,
    required DateTime createdAt,
    DateTime? finishedAt,
  }) = _PushJobImpl;

  factory PushJob.fromJson(Map<String, dynamic> jsonSerialization) {
    return PushJob(
      id: jsonSerialization['id'] as int?,
      contentId: jsonSerialization['contentId'] as int,
      status: jsonSerialization['status'] as String,
      sent: jsonSerialization['sent'] as int,
      cursor: jsonSerialization['cursor'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['cursor']),
      leaseUntil: jsonSerialization['leaseUntil'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['leaseUntil'],
            ),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['finishedAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The published `push` content item.
  int contentId;

  /// queued, sending, done or stopped (the campaign was unpublished).
  String status;

  /// Phones the campaign reached so far.
  int sent;

  /// The last account handled, in id order; the next batch starts after it.
  _isc.UuidValue? cursor;

  /// While set and in the future, one server instance is sending.
  DateTime? leaseUntil;

  DateTime createdAt;

  DateTime? finishedAt;

  /// Returns a shallow copy of this [PushJob]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PushJob copyWith({
    int? id,
    int? contentId,
    String? status,
    int? sent,
    _isc.UuidValue? cursor = const _isc.$UndefinedUuidValue(),
    DateTime? leaseUntil = const _isc.$UndefinedDateTime(),
    DateTime? createdAt,
    DateTime? finishedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PushJob',
      if (id != null) 'id': id,
      'contentId': contentId,
      'status': status,
      'sent': sent,
      if (cursor != null) 'cursor': cursor?.toJson(),
      if (leaseUntil != null) 'leaseUntil': leaseUntil?.toJson(),
      'createdAt': createdAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PushJob',
      if (id != null) 'id': id,
      'contentId': contentId,
      'status': status,
      'sent': sent,
      if (cursor != null) 'cursor': cursor?.toJson(),
      if (leaseUntil != null) 'leaseUntil': leaseUntil?.toJson(),
      'createdAt': createdAt.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PushJobImpl extends PushJob {
  _PushJobImpl({
    int? id,
    required int contentId,
    required String status,
    required int sent,
    _isc.UuidValue? cursor,
    DateTime? leaseUntil,
    required DateTime createdAt,
    DateTime? finishedAt,
  }) : super._(
         id: id,
         contentId: contentId,
         status: status,
         sent: sent,
         cursor: cursor,
         leaseUntil: leaseUntil,
         createdAt: createdAt,
         finishedAt: finishedAt,
       );

  /// Returns a shallow copy of this [PushJob]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PushJob copyWith({
    Object? id = _Undefined,
    int? contentId,
    String? status,
    int? sent,
    _isc.UuidValue? cursor = const _isc.$UndefinedUuidValue(),
    DateTime? leaseUntil = const _isc.$UndefinedDateTime(),
    DateTime? createdAt,
    DateTime? finishedAt = const _isc.$UndefinedDateTime(),
  }) {
    return PushJob(
      id: id is int? ? id : this.id,
      contentId: contentId ?? this.contentId,
      status: status ?? this.status,
      sent: sent ?? this.sent,
      cursor: cursor is _isc.UndefinedSentinel ? this.cursor : cursor,
      leaseUntil: leaseUntil is _isc.UndefinedSentinel
          ? this.leaseUntil
          : leaseUntil,
      createdAt: createdAt ?? this.createdAt,
      finishedAt: finishedAt is _isc.UndefinedSentinel
          ? this.finishedAt
          : finishedAt,
    );
  }
}
