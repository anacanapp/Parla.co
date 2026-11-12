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
import 'package:parla_server/src/generated/protocol.dart' as _i19kjxmt;
import 'package:serverpod/serverpod.dart' as _is;

/// One answer as the app sends and receives it. [declined] means the user
/// chose "I'd rather not answer" (only allowed for health questions).
abstract class QuizAnswerInput
    implements _is.SerializableModel, _is.ProtocolSerialization {
  QuizAnswerInput._({
    required this.questionId,
    required this.optionIds,
    required this.declined,
  });

  factory QuizAnswerInput({
    required String questionId,
    required List<String> optionIds,
    required bool declined,
  }) = _QuizAnswerInputImpl;

  factory QuizAnswerInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return QuizAnswerInput(
      questionId: jsonSerialization['questionId'] as String,
      optionIds: _i19kjxmt.Protocol().deserialize<List<String>>(
        jsonSerialization['optionIds'],
      ),
      declined: _is.BoolJsonExtension.fromJson(jsonSerialization['declined']),
    );
  }

  String questionId;

  List<String> optionIds;

  bool declined;

  /// Returns a shallow copy of this [QuizAnswerInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  QuizAnswerInput copyWith({
    String? questionId,
    List<String>? optionIds,
    bool? declined,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QuizAnswerInput',
      'questionId': questionId,
      'optionIds': optionIds.toJson(),
      'declined': declined,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'QuizAnswerInput',
      'questionId': questionId,
      'optionIds': optionIds.toJson(),
      'declined': declined,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _QuizAnswerInputImpl extends QuizAnswerInput {
  _QuizAnswerInputImpl({
    required String questionId,
    required List<String> optionIds,
    required bool declined,
  }) : super._(
         questionId: questionId,
         optionIds: optionIds,
         declined: declined,
       );

  /// Returns a shallow copy of this [QuizAnswerInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  QuizAnswerInput copyWith({
    String? questionId,
    List<String>? optionIds,
    bool? declined,
  }) {
    return QuizAnswerInput(
      questionId: questionId ?? this.questionId,
      optionIds: optionIds ?? this.optionIds.map((e0) => e0).toList(),
      declined: declined ?? this.declined,
    );
  }
}
