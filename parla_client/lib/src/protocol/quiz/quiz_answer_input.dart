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

/// One answer as the app sends and receives it. [declined] means the user
/// chose "I'd rather not answer" (only allowed for health questions).
abstract class QuizAnswerInput
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  QuizAnswerInput._({
    required this.questionId,
    required this.optionIds,
    required this.declined,
    this.answeredMonth,
  });

  factory QuizAnswerInput({
    required String questionId,
    required List<String> optionIds,
    required bool declined,
    String? answeredMonth,
  }) = _QuizAnswerInputImpl;

  factory QuizAnswerInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return QuizAnswerInput(
      questionId: jsonSerialization['questionId'] as String,
      optionIds: _id6y4bzp.Protocol().deserialize<List<String>>(
        jsonSerialization['optionIds'],
      ),
      declined: _isc.BoolJsonExtension.fromJson(jsonSerialization['declined']),
      answeredMonth: jsonSerialization['answeredMonth'] as String?,
    );
  }

  String questionId;

  List<String> optionIds;

  bool declined;

  /// The month a health answer was last given or confirmed ("2026-11"),
  /// set by the server, never by the app. Kept inside the encrypted health
  /// record; `null` for non-health answers and older records (RET-2).
  String? answeredMonth;

  /// Returns a shallow copy of this [QuizAnswerInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  QuizAnswerInput copyWith({
    String? questionId,
    List<String>? optionIds,
    bool? declined,
    String? answeredMonth,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QuizAnswerInput',
      'questionId': questionId,
      'optionIds': optionIds.toJson(),
      'declined': declined,
      if (answeredMonth != null) 'answeredMonth': answeredMonth,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'QuizAnswerInput',
      'questionId': questionId,
      'optionIds': optionIds.toJson(),
      'declined': declined,
      if (answeredMonth != null) 'answeredMonth': answeredMonth,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QuizAnswerInputImpl extends QuizAnswerInput {
  _QuizAnswerInputImpl({
    required String questionId,
    required List<String> optionIds,
    required bool declined,
    String? answeredMonth,
  }) : super._(
         questionId: questionId,
         optionIds: optionIds,
         declined: declined,
         answeredMonth: answeredMonth,
       );

  /// Returns a shallow copy of this [QuizAnswerInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  QuizAnswerInput copyWith({
    String? questionId,
    List<String>? optionIds,
    bool? declined,
    Object? answeredMonth = _Undefined,
  }) {
    return QuizAnswerInput(
      questionId: questionId ?? this.questionId,
      optionIds: optionIds ?? this.optionIds.map((e0) => e0).toList(),
      declined: declined ?? this.declined,
      answeredMonth: answeredMonth is String?
          ? answeredMonth
          : this.answeredMonth,
    );
  }
}
