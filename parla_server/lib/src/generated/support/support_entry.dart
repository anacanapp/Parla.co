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

/// A decrypted support message as the app or the panel shows it.
abstract class SupportEntry
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SupportEntry._({
    required this.fromStaff,
    required this.text,
    required this.createdAt,
  });

  factory SupportEntry({
    required bool fromStaff,
    required String text,
    required DateTime createdAt,
  }) = _SupportEntryImpl;

  factory SupportEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return SupportEntry(
      fromStaff: _is.BoolJsonExtension.fromJson(jsonSerialization['fromStaff']),
      text: jsonSerialization['text'] as String,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  bool fromStaff;

  String text;

  DateTime createdAt;

  /// Returns a shallow copy of this [SupportEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SupportEntry copyWith({
    bool? fromStaff,
    String? text,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SupportEntry',
      'fromStaff': fromStaff,
      'text': text,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SupportEntry',
      'fromStaff': fromStaff,
      'text': text,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SupportEntryImpl extends SupportEntry {
  _SupportEntryImpl({
    required bool fromStaff,
    required String text,
    required DateTime createdAt,
  }) : super._(
         fromStaff: fromStaff,
         text: text,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SupportEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SupportEntry copyWith({
    bool? fromStaff,
    String? text,
    DateTime? createdAt,
  }) {
    return SupportEntry(
      fromStaff: fromStaff ?? this.fromStaff,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
