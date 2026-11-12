import 'dart:convert';

import 'package:parla_server/src/account/account_endpoint.dart';
import 'package:parla_server/src/account/pseudonym.dart';
import 'package:parla_server/src/account/retention.dart';
import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

TestSessionBuilder _as(TestSessionBuilder builder, String userId) =>
    builder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(userId, {}),
    );

QuizAnswerInput _answer(String q, List<String> o) =>
    QuizAnswerInput(questionId: q, optionIds: o, declined: false);

void main() {
  const bob = '7f2e9d4c-1b3a-4e5f-8c6d-9a0b1c2d3e02';
  final healthVersion = currentConsentText(ConsentKind.health).version;

  withServerpod('Given the account endpoint', (sessionBuilder, endpoints) {
    /// A real sign-in account with a profile, consent, quiz and health data.
    Future<String> fullUser() async {
      final user = await const AuthUsers().create(sessionBuilder.build());
      final id = user.id.toString();
      final session = _as(sessionBuilder, id);
      await endpoints.profile.create(
        session,
        birthYear: 1990,
        countryCode: 'AZ',
        language: 'az',
      );
      await endpoints.consent.decide(
        session,
        consentType: ConsentType.health,
        granted: true,
        textVersion: healthVersion,
        language: 'az',
        source: 'app',
      );
      await endpoints.quiz.saveAnswers(session, [
        _answer('skin_type', ['dry']),
        _answer('pregnancy', ['no']),
      ]);
      return id;
    }

    test('export holds every kind of data, health answers decrypted', () async {
      final alice = await fullUser();
      final json =
          jsonDecode(
                await endpoints.account.exportMyData(
                  _as(sessionBuilder, alice),
                ),
              )
              as Map<String, dynamic>;

      expect(json['format'], exportFormat);
      expect(json['account']['id'], alice);
      expect(json['profile']['birthYear'], 1990);
      expect((json['consents'] as List).single['type'], 'health');
      expect((json['quizAnswers'] as List).single['question'], 'skin_type');
      final health = (json['healthAnswers'] as List).single as Map;
      expect(health['question'], 'pregnancy');
      expect(health['options'], ['no']);

      final actions = (await AuditLogEntry.db.find(
        sessionBuilder.build(),
      )).map((e) => e.action);
      expect(actions, contains('account.exported'));
    });

    test('export shows only the caller\'s data', () async {
      await fullUser();
      final json =
          jsonDecode(
                await endpoints.account.exportMyData(_as(sessionBuilder, bob)),
              )
              as Map<String, dynamic>;
      expect(json['profile'], isNull);
      expect(json['consents'], isEmpty);
      expect(json['healthAnswers'], isEmpty);
    });

    test('deleting the account removes personal data and the sign-in '
        'account, and pseudonymises what must stay', () async {
      final alice = await fullUser();
      final aliceId = UuidValue.fromString(alice);
      await endpoints.account.deleteAccount(_as(sessionBuilder, alice));

      final db = sessionBuilder.build();
      expect(await MemberProfile.db.find(db), isEmpty);
      expect(await QuizAnswer.db.find(db), isEmpty);
      expect(await HealthRecord.db.find(db), isEmpty);
      expect(await HealthKey.db.find(db), isEmpty);
      expect(await AuthUser.db.findById(db, aliceId), isNull);

      final pseudonym = await pseudonymFor(db, aliceId);
      final consents = await ConsentRecord.db.find(db);
      expect(consents, isNotEmpty);
      expect(consents.every((c) => c.authUserId == pseudonym), isTrue);

      final audit = await AuditLogEntry.db.find(db);
      expect(audit.any((e) => e.actorId == aliceId), isFalse);
      expect(
        audit.where((e) => e.action == 'account.deleted').single.actorId,
        pseudonym,
      );
      expect(
        (await DeletedAccount.db.find(db)).single.pseudonym,
        pseudonym,
      );
    });

    test("deleting one account leaves another user's data alone", () async {
      final alice = await fullUser();
      final bobUser = await fullUser();
      await endpoints.account.deleteAccount(_as(sessionBuilder, alice));
      final db = sessionBuilder.build();
      expect(await MemberProfile.db.find(db), hasLength(1));
      expect(await HealthKey.db.find(db), hasLength(1));
      expect(
        await endpoints.profile.me(_as(sessionBuilder, bobUser)),
        isNotNull,
      );
    });

    test('deleting twice does not fail', () async {
      final alice = await fullUser();
      await endpoints.account.deleteAccount(_as(sessionBuilder, alice));
      await endpoints.account.deleteAccount(_as(sessionBuilder, alice));
    });

    test('retention deletes only what is past its period', () async {
      final db = sessionBuilder.build();
      final now = DateTime.utc(2030, 1, 1);
      final oldPseudonym = UuidValue.fromString(
        '11111111-1111-4111-8111-111111111111',
      );
      final recentPseudonym = UuidValue.fromString(
        '22222222-2222-4222-8222-222222222222',
      );

      Future<void> audit(DateTime at) => AuditLogEntry.db.insertRow(
        db,
        AuditLogEntry(
          actorRole: 'user',
          action: 'test',
          objectType: 'test',
          createdAt: at,
        ),
      );
      await audit(now.subtract(const Duration(days: 400)));
      await audit(now.subtract(const Duration(days: 10)));

      for (final (pseudonym, deletedDaysAgo) in [
        (oldPseudonym, 4 * 365),
        (recentPseudonym, 30),
      ]) {
        await DeletedAccount.db.insertRow(
          db,
          DeletedAccount(
            pseudonym: pseudonym,
            deletedAt: now.subtract(Duration(days: deletedDaysAgo)),
          ),
        );
        await ConsentRecord.db.insertRow(
          db,
          ConsentRecord(
            authUserId: pseudonym,
            consentType: ConsentType.analytics,
            granted: true,
            textVersion: 'v',
            textHash: 'h',
            language: 'az',
            source: 'app',
            createdAt: now.subtract(Duration(days: deletedDaysAgo + 1)),
          ),
        );
      }

      final result = await runRetention(db, now: now);
      expect(result.auditRows, 1);
      expect(result.consentRows, 1);
      expect(result.deletedAccounts, 1);

      expect(await AuditLogEntry.db.find(db), hasLength(1));
      final consents = await ConsentRecord.db.find(db);
      expect(consents.single.authUserId, recentPseudonym);
      expect(
        (await DeletedAccount.db.find(db)).single.pseudonym,
        recentPseudonym,
      );

      // Running again changes nothing.
      final again = await runRetention(db, now: now);
      expect(again.auditRows + again.consentRows + again.deletedAccounts, 0);
    });
  });

  group('pseudonym', () {
    final id = UuidValue.fromString(bob);

    test('is stable for the same pepper and differs for another', () async {
      final a = await pseudonymWithPepper('pepper-one', id);
      final b = await pseudonymWithPepper('pepper-one', id);
      final c = await pseudonymWithPepper('pepper-two', id);
      expect(a, b);
      expect(a, isNot(c));
      expect(a, isNot(id));
    });

    test('is a valid version 4 UUID', () async {
      final p = (await pseudonymWithPepper('pepper', id)).toString();
      expect(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ).hasMatch(p),
        isTrue,
      );
    });

    test('a missing pepper fails loudly', () {
      expect(() => pseudonymWithPepper(null, id), throwsStateError);
    });
  });
}
