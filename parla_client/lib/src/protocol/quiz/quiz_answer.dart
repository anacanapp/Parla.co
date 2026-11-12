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

/// A non-health quiz answer (data map row 7: skin and hair type, goals,
/// habits). Health answers never go here: they are encrypted in
/// health_record.
abstract class QuizAnswer
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  QuizAnswer._({
    this.id,
    required this.authUserId,
    required this.questionId,
    required this.optionIds,
    required this.contentVersion,
    required this.answeredAt,
  });

  factory QuizAnswer({
    int? id,
    required _isc.UuidValue authUserId,
    required String questionId,
    required List<String> optionIds,
    required String contentVersion,
    required DateTime answeredAt,
  }) = _QuizAnswerImpl;

  factory QuizAnswer.fromJson(Map<String, dynamic> jsonSerialization) {
    return QuizAnswer(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      questionId: jsonSerialization['questionId'] as String,
      optionIds: _id6y4bzp.Protocol().deserialize<List<String>>(
        jsonSerialization['optionIds'],
      ),
      contentVersion: jsonSerialization['contentVersion'] as String,
      answeredAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['answeredAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  String questionId;

  List<String> optionIds;

  /// Version of the question set the answer was given to.
  String contentVersion;

  DateTime answeredAt;

  /// Returns a shallow copy of this [QuizAnswer]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  QuizAnswer copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    String? questionId,
    List<String>? optionIds,
    String? contentVersion,
    DateTime? answeredAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QuizAnswer',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'questionId': questionId,
      'optionIds': optionIds.toJson(),
      'contentVersion': contentVersion,
      'answeredAt': answeredAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'QuizAnswer',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'questionId': questionId,
      'optionIds': optionIds.toJson(),
      'contentVersion': contentVersion,
      'answeredAt': answeredAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QuizAnswerImpl extends QuizAnswer {
  _QuizAnswerImpl({
    int? id,
    required _isc.UuidValue authUserId,
    required String questionId,
    required List<String> optionIds,
    required String contentVersion,
    required DateTime answeredAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         questionId: questionId,
         optionIds: optionIds,
         contentVersion: contentVersion,
         answeredAt: answeredAt,
       );

  /// Returns a shallow copy of this [QuizAnswer]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  QuizAnswer copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    String? questionId,
    List<String>? optionIds,
    String? contentVersion,
    DateTime? answeredAt,
  }) {
    return QuizAnswer(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      questionId: questionId ?? this.questionId,
      optionIds: optionIds ?? this.optionIds.map((e0) => e0).toList(),
      contentVersion: contentVersion ?? this.contentVersion,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }
}
