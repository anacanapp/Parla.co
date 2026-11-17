import 'package:parla_server/src/account/retention.dart';
import 'package:parla_server/src/audit/append_only.dart';
import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/health/health_kms.dart';
import 'package:parla_server/src/health/health_store.dart';
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
  final healthVersion = currentConsentText(ConsentKind.health).version;

  tearDown(() => HealthKms.wrapper = null);

  withServerpod('Given production security', (sessionBuilder, endpoints) {
    Future<String> member() async {
      final user = await const AuthUsers().create(sessionBuilder.build());
      final s = _as(sessionBuilder, user.id.toString());
      await endpoints.profile.create(
        s,
        birthYear: 1990,
        countryCode: 'AZ',
        language: 'az',
      );
      await endpoints.consent.decide(
        s,
        consentType: ConsentType.health,
        granted: true,
        textVersion: healthVersion,
        language: 'az',
        source: 'app',
      );
      return user.id.toString();
    }

    group('ENC-3: data keys wrapped by KMS', () {
      test('new keys go to KMS; old KEK keys move on first use', () async {
        // A user from before KMS: key wrapped by the KEK.
        final old = await member();
        await endpoints.quiz.saveAnswers(_as(sessionBuilder, old), [
          _answer('pregnancy', ['no']),
        ]);
        final db = sessionBuilder.build();
        HealthKey keyOf(List<HealthKey> keys, String id) =>
            keys.singleWhere((k) => k.authUserId.toString() == id);
        expect(keyOf(await HealthKey.db.find(db), old).kekVersion, 1);

        final kms = FakeKmsKeyWrapper();
        HealthKms.wrapper = kms;

        // Reading moves the key to KMS; the answers still read.
        final answers = await endpoints.quiz.myAnswers(
          _as(sessionBuilder, old),
        );
        expect(answers.map((a) => a.questionId), contains('pregnancy'));
        expect(
          keyOf(await HealthKey.db.find(db), old).kekVersion,
          HealthStore.kmsVersion,
        );

        // A new user's key is wrapped by KMS from the start.
        final fresh = await member();
        await endpoints.quiz.saveAnswers(_as(sessionBuilder, fresh), [
          _answer('pregnancy', ['pregnant']),
        ]);
        expect(
          keyOf(await HealthKey.db.find(db), fresh).kekVersion,
          HealthStore.kmsVersion,
        );
        final again = await endpoints.quiz.myAnswers(
          _as(sessionBuilder, fresh),
        );
        expect(
          again.singleWhere((a) => a.questionId == 'pregnancy').optionIds,
          ['pregnant'],
        );
        expect(kms.calls, greaterThan(0));

        // A wrapped key copied to another account does not open.
        final k = keyOf(await HealthKey.db.find(db), fresh);
        final other = UuidValue.fromString(old);
        expect(
          await kms.unwrap(k.wrappedKey, other),
          isNot(await kms.unwrap(k.wrappedKey, k.authUserId)),
        );
      });

      test('deleting the account still shreds the KMS-wrapped key', () async {
        HealthKms.wrapper = FakeKmsKeyWrapper();
        final id = await member();
        await endpoints.quiz.saveAnswers(_as(sessionBuilder, id), [
          _answer('pregnancy', ['no']),
        ]);
        await endpoints.account.deleteAccount(_as(sessionBuilder, id));
        expect(await HealthKey.db.find(sessionBuilder.build()), isEmpty);
      });
    });

    group('AUD-2: append-only at the database level', () {
      setUp(() async => installAppendOnlyGuards(sessionBuilder.build()));

      test('consent and audit rows cannot be changed or deleted', () async {
        final id = await member();
        final db = sessionBuilder.build();
        final consent = (await ConsentRecord.db.find(db)).single;
        await expectLater(
          ConsentRecord.db.updateRow(db, consent.copyWith(granted: false)),
          throwsA(isA<DatabaseException>()),
        );
        await expectLater(
          ConsentRecord.db.deleteRow(db, consent),
          throwsA(isA<DatabaseException>()),
        );
        final audit = (await AuditLogEntry.db.find(db)).first;
        await expectLater(
          AuditLogEntry.db.updateRow(db, audit.copyWith(action: 'x')),
          throwsA(isA<DatabaseException>()),
        );
        await expectLater(
          AuditLogEntry.db.deleteRow(db, audit),
          throwsA(isA<DatabaseException>()),
        );
        expect(id, isNotEmpty);
      });
    });
  });

  // Account deletion and retention run under the guards. Separate group:
  // a refused statement aborts the test's transaction.
  withServerpod('Given the guards installed', (sessionBuilder, endpoints) {
    setUp(() async => installAppendOnlyGuards(sessionBuilder.build()));

    test(
      'deletion pseudonymises; retention deletes only expired rows',
      () async {
        final user = await const AuthUsers().create(sessionBuilder.build());
        final id = user.id.toString();
        final s = _as(sessionBuilder, id);
        await endpoints.profile.create(
          s,
          birthYear: 1990,
          countryCode: 'AZ',
          language: 'az',
        );
        await endpoints.consent.decide(
          s,
          consentType: ConsentType.health,
          granted: true,
          textVersion: healthVersion,
          language: 'az',
          source: 'app',
        );
        // Pseudonymisation is allowed by the guards.
        await endpoints.account.deleteAccount(s);
        final db = sessionBuilder.build();
        expect(
          (await ConsentRecord.db.find(db)).single.authUserId.toString(),
          isNot(id),
        );

        // Rows past their retention (inserting is always allowed).
        final now = DateTime.now().toUtc();
        final gone = UuidValue.fromString(
          '00000000-0000-4000-8000-000000000001',
        );
        await DeletedAccount.db.insertRow(
          db,
          DeletedAccount(
            pseudonym: gone,
            deletedAt: now.subtract(const Duration(days: 3 * 365 + 5)),
          ),
        );
        await ConsentRecord.db.insertRow(
          db,
          ConsentRecord(
            authUserId: gone,
            consentType: ConsentType.health,
            granted: true,
            textVersion: healthVersion,
            textHash: 'x',
            language: 'az',
            source: 'app',
            createdAt: now.subtract(const Duration(days: 4 * 365)),
          ),
        );
        await AuditLogEntry.db.insertRow(
          db,
          AuditLogEntry(
            actorRole: 'user',
            action: 'old',
            objectType: 'account',
            createdAt: now.subtract(const Duration(days: 400)),
          ),
        );
        final result = await runRetention(db);
        expect(result.consentRows, 1);
        expect(result.auditRows, 1);
        // The recent consent of the account deleted today stays.
        expect(await ConsentRecord.db.find(db), hasLength(1));
      },
    );
  });
}
