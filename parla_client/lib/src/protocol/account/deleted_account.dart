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

/// Marks a deleted account by its pseudonym only (never the real id), so
/// the retention job knows when the account's consent records may go
/// (3 years after deletion, proposal pending legal review).
abstract class DeletedAccount
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeletedAccount._({
    this.id,
    required this.pseudonym,
    required this.deletedAt,
  });

  factory DeletedAccount({
    int? id,
    required _isc.UuidValue pseudonym,
    required DateTime deletedAt,
  }) = _DeletedAccountImpl;

  factory DeletedAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeletedAccount(
      id: jsonSerialization['id'] as int?,
      pseudonym: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['pseudonym'],
      ),
      deletedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['deletedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue pseudonym;

  DateTime deletedAt;

  /// Returns a shallow copy of this [DeletedAccount]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeletedAccount copyWith({
    int? id,
    _isc.UuidValue? pseudonym,
    DateTime? deletedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeletedAccount',
      if (id != null) 'id': id,
      'pseudonym': pseudonym.toJson(),
      'deletedAt': deletedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeletedAccount',
      if (id != null) 'id': id,
      'pseudonym': pseudonym.toJson(),
      'deletedAt': deletedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeletedAccountImpl extends DeletedAccount {
  _DeletedAccountImpl({
    int? id,
    required _isc.UuidValue pseudonym,
    required DateTime deletedAt,
  }) : super._(
         id: id,
         pseudonym: pseudonym,
         deletedAt: deletedAt,
       );

  /// Returns a shallow copy of this [DeletedAccount]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeletedAccount copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? pseudonym,
    DateTime? deletedAt,
  }) {
    return DeletedAccount(
      id: id is int? ? id : this.id,
      pseudonym: pseudonym ?? this.pseudonym,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
