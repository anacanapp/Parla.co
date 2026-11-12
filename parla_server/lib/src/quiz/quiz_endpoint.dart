import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../audit/audit.dart';
import '../consent/consent_endpoint.dart';
import '../generated/protocol.dart';
import '../health/health_store.dart';

/// Error codes returned by [QuizEndpoint]. The app translates them.
abstract final class QuizErrors {
  static const unknownQuestion = 'quiz.unknown_question';
  static const invalidAnswer = 'quiz.invalid_answer';
  static const notStorable = 'quiz.not_storable';
  static const healthConsentRequired = 'consent.health_required';
}

/// Saves and returns the user's onboarding quiz answers (M-09 to M-13).
///
/// Non-health answers go to `quiz_answer`; health answers are encrypted in
/// `health_record` and only accepted with the health consent (CON-2).
/// Warning-sign answers are refused outright: they never leave the device.
class QuizEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Saves [answers], replacing earlier answers to the same questions.
  Future<void> saveAnswers(
    Session session,
    List<QuizAnswerInput> answers,
  ) async {
    final userId = session.authenticated!.authUserId;

    final core = <QuizAnswerInput>[];
    final health = <QuizAnswerInput>[];
    for (final answer in answers) {
      final question = quizQuestion(answer.questionId);
      if (question == null) {
        throw ParlaException(code: QuizErrors.unknownQuestion);
      }
      if (!question.stored) {
        throw ParlaException(code: QuizErrors.notStorable);
      }
      final valid = answer.declined
          ? question.declinable && answer.optionIds.isEmpty
          : question.accepts(answer.optionIds);
      if (!valid) throw ParlaException(code: QuizErrors.invalidAnswer);
      (question.sensitive ? health : core).add(answer);
    }

    if (health.isNotEmpty &&
        !await hasConsent(session, userId, ConsentType.health)) {
      throw ParlaException(code: QuizErrors.healthConsentRequired);
    }

    await session.db.transaction((transaction) async {
      final now = DateTime.now().toUtc();
      for (final answer in core) {
        await QuizAnswer.db.deleteWhere(
          session,
          where: (t) =>
              t.authUserId.equals(userId) &
              t.questionId.equals(answer.questionId),
          transaction: transaction,
        );
        await QuizAnswer.db.insertRow(
          session,
          QuizAnswer(
            authUserId: userId,
            questionId: answer.questionId,
            optionIds: answer.optionIds,
            contentVersion: quizContentVersion,
            answeredAt: now,
          ),
          transaction: transaction,
        );
      }

      if (health.isNotEmpty) {
        final store = HealthStore.of(session);
        final merged = await store.read(
          session,
          userId,
          transaction: transaction,
        );
        for (final answer in health) {
          merged[answer.questionId] = answer;
        }
        await store.write(
          session,
          userId,
          merged.values,
          transaction: transaction,
        );
      }

      await writeAudit(
        session,
        actorId: userId,
        actorRole: AuditActor.user,
        action: 'quiz.answers_saved',
        objectType: 'quiz',
        transaction: transaction,
      );
    });
  }

  /// The user's saved answers. Health answers are included only while the
  /// health consent is granted.
  Future<List<QuizAnswerInput>> myAnswers(Session session) async {
    final userId = session.authenticated!.authUserId;
    final core = await QuizAnswer.db.find(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    final result = [
      for (final a in core)
        QuizAnswerInput(
          questionId: a.questionId,
          optionIds: a.optionIds,
          declined: false,
        ),
    ];
    if (await hasConsent(session, userId, ConsentType.health)) {
      result.addAll(
        (await HealthStore.of(session).read(session, userId)).values,
      );
    }
    return result;
  }
}
