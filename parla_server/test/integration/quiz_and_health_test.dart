import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/quiz/quiz_endpoint.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

TestSessionBuilder _as(TestSessionBuilder builder, String userId) =>
    builder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(userId, {}),
    );

Matcher _parlaError(String code) =>
    isA<ParlaException>().having((e) => e.code, 'code', code);

QuizAnswerInput _answer(String q, List<String> o, {bool declined = false}) =>
    QuizAnswerInput(questionId: q, optionIds: o, declined: declined);

void main() {
  const alice = '0b6c1f3e-8a4d-4c7e-9f21-3d5a7e9b1c01';
  const bob = '7f2e9d4c-1b3a-4e5f-8c6d-9a0b1c2d3e02';
  final healthVersion = currentConsentText(ConsentKind.health).version;

  withServerpod('Given the quiz endpoint', (sessionBuilder, endpoints) {
    Future<void> grantHealth(String user) => endpoints.consent.decide(
      _as(sessionBuilder, user),
      consentType: ConsentType.health,
      granted: true,
      textVersion: healthVersion,
      language: 'az',
      source: 'app',
    );

    Future<void> withdrawHealth(String user) => endpoints.consent.decide(
      _as(sessionBuilder, user),
      consentType: ConsentType.health,
      granted: false,
      textVersion: healthVersion,
      language: 'az',
      source: 'app',
    );

    test('non-health answers are saved and returned', () async {
      final session = _as(sessionBuilder, alice);
      await endpoints.quiz.saveAnswers(session, [
        _answer('skin_type', ['dry']),
        _answer('skin_goals', ['hydration', 'glow']),
      ]);
      final answers = await endpoints.quiz.myAnswers(session);
      expect(
        {for (final a in answers) a.questionId: a.optionIds},
        {
          'skin_type': ['dry'],
          'skin_goals': ['hydration', 'glow'],
        },
      );
    });

    test('answering again replaces the earlier answer', () async {
      final session = _as(sessionBuilder, alice);
      await endpoints.quiz.saveAnswers(session, [
        _answer('skin_type', ['dry']),
      ]);
      await endpoints.quiz.saveAnswers(session, [
        _answer('skin_type', ['oily']),
      ]);
      final rows = await QuizAnswer.db.find(sessionBuilder.build());
      expect(rows, hasLength(1));
      expect(rows.single.optionIds, ['oily']);
    });

    test('a health answer without the health consent is refused and '
        'nothing is stored', () async {
      await expectLater(
        endpoints.quiz.saveAnswers(_as(sessionBuilder, alice), [
          _answer('skin_type', ['dry']),
          _answer('pregnancy', ['pregnant']),
        ]),
        throwsA(_parlaError(QuizErrors.healthConsentRequired)),
      );
      final db = sessionBuilder.build();
      expect(await HealthRecord.db.find(db), isEmpty);
      expect(await QuizAnswer.db.find(db), isEmpty);
    });

    test('with consent, health answers are stored encrypted and returned '
        'decrypted', () async {
      await grantHealth(alice);
      final session = _as(sessionBuilder, alice);
      await endpoints.quiz.saveAnswers(session, [
        _answer('conditions', ['rosacea']),
        _answer('pregnancy', ['pregnant']),
        _answer('medication', [], declined: true),
      ]);

      final db = sessionBuilder.build();
      final record = (await HealthRecord.db.find(db)).single;
      expect(record.ciphertext, isNot(contains('rosacea')));
      expect(record.ciphertext, isNot(contains('pregnant')));
      expect(await HealthKey.db.find(db), hasLength(1));
      expect(await QuizAnswer.db.find(db), isEmpty);

      final answers = {
        for (final a in await endpoints.quiz.myAnswers(session))
          a.questionId: a,
      };
      expect(answers['conditions']!.optionIds, ['rosacea']);
      expect(answers['pregnancy']!.optionIds, ['pregnant']);
      expect(answers['medication']!.declined, isTrue);
    });

    test('later health answers merge with earlier ones', () async {
      await grantHealth(alice);
      final session = _as(sessionBuilder, alice);
      await endpoints.quiz.saveAnswers(session, [
        _answer('pregnancy', ['no']),
      ]);
      await endpoints.quiz.saveAnswers(session, [
        _answer('allergies', ['nickel']),
      ]);
      final ids = (await endpoints.quiz.myAnswers(
        session,
      )).map((a) => a.questionId);
      expect(ids, containsAll(['pregnancy', 'allergies']));
      expect(await HealthKey.db.find(sessionBuilder.build()), hasLength(1));
    });

    test(
      'withdrawing the health consent erases the data and the key',
      () async {
        await grantHealth(alice);
        final session = _as(sessionBuilder, alice);
        await endpoints.quiz.saveAnswers(session, [
          _answer('skin_type', ['dry']),
          _answer('pregnancy', ['no']),
        ]);

        await withdrawHealth(alice);

        final db = sessionBuilder.build();
        expect(await HealthRecord.db.find(db), isEmpty);
        expect(await HealthKey.db.find(db), isEmpty);
        final answers = await endpoints.quiz.myAnswers(session);
        expect(answers.map((a) => a.questionId), ['skin_type']);
        final actions = (await AuditLogEntry.db.find(db)).map((e) => e.action);
        expect(actions, contains('health.erased'));
      },
    );

    test('warning-sign answers are refused: they never leave the device', () {
      expect(
        endpoints.quiz.saveAnswers(_as(sessionBuilder, alice), [
          _answer('warning_signs', ['none']),
        ]),
        throwsA(_parlaError(QuizErrors.notStorable)),
      );
    });

    test('unknown questions and malformed answers are refused', () async {
      final session = _as(sessionBuilder, alice);
      await expectLater(
        endpoints.quiz.saveAnswers(session, [
          _answer('favourite_colour', ['yellow']),
        ]),
        throwsA(_parlaError(QuizErrors.unknownQuestion)),
      );
      for (final bad in [
        _answer('skin_type', ['oily', 'dry']),
        _answer('skin_type', ['shiny']),
        _answer('skin_type', []),
        _answer('skin_type', [], declined: true),
      ]) {
        await expectLater(
          endpoints.quiz.saveAnswers(session, [bad]),
          throwsA(_parlaError(QuizErrors.invalidAnswer)),
          reason: '${bad.questionId} ${bad.optionIds} ${bad.declined}',
        );
      }
    });

    test("one user cannot read another user's answers", () async {
      await grantHealth(alice);
      await endpoints.quiz.saveAnswers(_as(sessionBuilder, alice), [
        _answer('skin_type', ['dry']),
        _answer('pregnancy', ['no']),
      ]);
      await grantHealth(bob);
      expect(await endpoints.quiz.myAnswers(_as(sessionBuilder, bob)), isEmpty);
    });

    test('an anonymous caller is rejected', () async {
      await expectLater(
        endpoints.quiz.myAnswers(sessionBuilder),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });

    test('the audit log never holds answer content', () async {
      await grantHealth(alice);
      await endpoints.quiz.saveAnswers(_as(sessionBuilder, alice), [
        _answer('pregnancy', ['pregnant']),
      ]);
      for (final entry in await AuditLogEntry.db.find(sessionBuilder.build())) {
        expect(entry.toJson().toString(), isNot(contains('pregnant')));
      }
    });
  });
}
