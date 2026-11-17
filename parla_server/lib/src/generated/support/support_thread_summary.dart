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

/// A support conversation in the panel's list: no message text.
abstract class SupportThreadSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SupportThreadSummary._({
    required this.id,
    required this.email,
    required this.open,
    required this.unreadByStaff,
    required this.lastMessageAt,
  });

  factory SupportThreadSummary({
    required int id,
    required String email,
    required bool open,
    required bool unreadByStaff,
    required DateTime lastMessageAt,
  }) = _SupportThreadSummaryImpl;

  factory SupportThreadSummary.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SupportThreadSummary(
      id: jsonSerialization['id'] as int,
      email: jsonSerialization['email'] as String,
      open: _is.BoolJsonExtension.fromJson(jsonSerialization['open']),
      unreadByStaff: _is.BoolJsonExtension.fromJson(
        jsonSerialization['unreadByStaff'],
      ),
      lastMessageAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastMessageAt'],
      ),
    );
  }

  int id;

  String email;

  bool open;

  bool unreadByStaff;

  DateTime lastMessageAt;

  /// Returns a shallow copy of this [SupportThreadSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SupportThreadSummary copyWith({
    int? id,
    String? email,
    bool? open,
    bool? unreadByStaff,
    DateTime? lastMessageAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SupportThreadSummary',
      'id': id,
      'email': email,
      'open': open,
      'unreadByStaff': unreadByStaff,
      'lastMessageAt': lastMessageAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SupportThreadSummary',
      'id': id,
      'email': email,
      'open': open,
      'unreadByStaff': unreadByStaff,
      'lastMessageAt': lastMessageAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SupportThreadSummaryImpl extends SupportThreadSummary {
  _SupportThreadSummaryImpl({
    required int id,
    required String email,
    required bool open,
    required bool unreadByStaff,
    required DateTime lastMessageAt,
  }) : super._(
         id: id,
         email: email,
         open: open,
         unreadByStaff: unreadByStaff,
         lastMessageAt: lastMessageAt,
       );

  /// Returns a shallow copy of this [SupportThreadSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SupportThreadSummary copyWith({
    int? id,
    String? email,
    bool? open,
    bool? unreadByStaff,
    DateTime? lastMessageAt,
  }) {
    return SupportThreadSummary(
      id: id ?? this.id,
      email: email ?? this.email,
      open: open ?? this.open,
      unreadByStaff: unreadByStaff ?? this.unreadByStaff,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }
}
