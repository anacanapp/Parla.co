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

/// One user's conversation with the Parla team (one per account). The
/// messages are in [SupportMessage], encrypted. Deleted with the account
/// and 12 months after the last message.
abstract class SupportThread
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SupportThread._({
    this.id,
    required this.authUserId,
    required this.open,
    required this.unreadByStaff,
    required this.unreadByUser,
    required this.createdAt,
    required this.lastMessageAt,
  });

  factory SupportThread({
    int? id,
    required _isc.UuidValue authUserId,
    required bool open,
    required bool unreadByStaff,
    required bool unreadByUser,
    required DateTime createdAt,
    required DateTime lastMessageAt,
  }) = _SupportThreadImpl;

  factory SupportThread.fromJson(Map<String, dynamic> jsonSerialization) {
    return SupportThread(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      open: _isc.BoolJsonExtension.fromJson(jsonSerialization['open']),
      unreadByStaff: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['unreadByStaff'],
      ),
      unreadByUser: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['unreadByUser'],
      ),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      lastMessageAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastMessageAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  bool open;

  bool unreadByStaff;

  bool unreadByUser;

  DateTime createdAt;

  DateTime lastMessageAt;

  /// Returns a shallow copy of this [SupportThread]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SupportThread copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    bool? open,
    bool? unreadByStaff,
    bool? unreadByUser,
    DateTime? createdAt,
    DateTime? lastMessageAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SupportThread',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'open': open,
      'unreadByStaff': unreadByStaff,
      'unreadByUser': unreadByUser,
      'createdAt': createdAt.toJson(),
      'lastMessageAt': lastMessageAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SupportThread',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'open': open,
      'unreadByStaff': unreadByStaff,
      'unreadByUser': unreadByUser,
      'createdAt': createdAt.toJson(),
      'lastMessageAt': lastMessageAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SupportThreadImpl extends SupportThread {
  _SupportThreadImpl({
    int? id,
    required _isc.UuidValue authUserId,
    required bool open,
    required bool unreadByStaff,
    required bool unreadByUser,
    required DateTime createdAt,
    required DateTime lastMessageAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         open: open,
         unreadByStaff: unreadByStaff,
         unreadByUser: unreadByUser,
         createdAt: createdAt,
         lastMessageAt: lastMessageAt,
       );

  /// Returns a shallow copy of this [SupportThread]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SupportThread copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    bool? open,
    bool? unreadByStaff,
    bool? unreadByUser,
    DateTime? createdAt,
    DateTime? lastMessageAt,
  }) {
    return SupportThread(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      open: open ?? this.open,
      unreadByStaff: unreadByStaff ?? this.unreadByStaff,
      unreadByUser: unreadByUser ?? this.unreadByUser,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }
}
