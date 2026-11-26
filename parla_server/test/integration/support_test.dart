import 'dart:convert';

import 'package:parla_server/src/auth/verification_code_sender.dart';
import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/health/health_kms.dart';
import 'package:parla_server/src/staff/staff_guard.dart';
import 'package:parla_server/src/support/support.dart';
import 'package:parla_server/src/support/support_crypto.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

import 'staff_sign_in.dart';

Matcher _error(String code) =>
    isA<ParlaException>().having((e) => e.code, 'code', code);

TestSessionBuilder _as(TestSessionBuilder builder, String userId) =>
    builder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(userId, {}),
    );

void main() {
  withServerpod('Given support conversations', (sessionBuilder, endpoints) {
    Future<TestSessionBuilder> staff(String email, StaffRole role) async {
      final db = sessionBuilder.build();
      final user = await const AuthUsers().create(db);
      await EmailAccount.db.insertRow(
        db,
        EmailAccount(authUserId: user.id, email: email, passwordHash: 'x'),
      );
      final s = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          user.id.toString(),
          {},
          authId: await signInSession(db, user.id),
        ),
      );
      if (email.startsWith('first-admin')) {
        await endpoints.staff.claimFirstAdmin(s);
      } else {
        await endpoints.staff.acceptInvite(
          s,
          DevelopmentCodeSender.lastStaffInviteCode!,
        );
      }
      return s;
    }

    Future<String> member(String email) async {
      final db = sessionBuilder.build();
      final user = await const AuthUsers().create(db);
      await EmailAccount.db.insertRow(
        db,
        EmailAccount(authUserId: user.id, email: email, passwordHash: 'x'),
      );
      await endpoints.profile.create(
        _as(sessionBuilder, user.id.toString()),
        birthYear: 1995,
        countryCode: 'AZ',
        language: 'az',
      );
      return user.id.toString();
    }

    test('messages are encrypted at rest and only support and admins read '
        'them; opening is audited', () async {
      final admin = await staff('first-admin@example.com', StaffRole.admin);
      await endpoints.staffAdmin.invite(
        admin,
        'help@example.com',
        StaffRole.support,
      );
      final helper = await staff('help@example.com', StaffRole.support);
      await endpoints.staffAdmin.invite(
        admin,
        'ed@example.com',
        StaffRole.editor,
      );
      final editor = await staff('ed@example.com', StaffRole.editor);

      final id = await member('aysel@example.com');
      final user = _as(sessionBuilder, id);
      expect(await endpoints.support.myMessages(user), isEmpty);
      await endpoints.support.send(user, 'Retinoldan sonra dərim qızarır.');

      final rows = await SupportMessage.db.find(sessionBuilder.build());
      expect(rows.single.ciphertext, isNot(contains('Retinol')));
      expect(
        utf8.decode(
          base64.decode(rows.single.ciphertext),
          allowMalformed: true,
        ),
        isNot(contains('Retinol')),
      );

      await expectLater(
        endpoints.supportAdmin.threads(editor),
        throwsA(_error(StaffErrors.forbidden)),
      );
      final list = await endpoints.supportAdmin.threads(helper);
      expect(list.single.email, 'aysel@example.com');
      expect(list.single.unreadByStaff, isTrue);

      final opened = await endpoints.supportAdmin.open(helper, list.single.id);
      expect(opened.single.text, 'Retinoldan sonra dərim qızarır.');
      final audit = await AuditLogEntry.db.find(
        sessionBuilder.build(),
        where: (t) => t.action.equals('support.viewed'),
      );
      expect(audit.single.objectId, id);
      for (final a in await AuditLogEntry.db.find(sessionBuilder.build())) {
        expect(a.objectId ?? '', isNot(contains('Retinol')));
      }

      await endpoints.supportAdmin.reply(
        helper,
        list.single.id,
        'Bir neçə gün fasilə verin; keçməsə həkimə müraciət edin.',
      );
      expect(await endpoints.support.hasUnreadReply(user), isTrue);
      final mine = await endpoints.support.myMessages(user);
      expect(mine.map((m) => m.fromStaff), [false, true]);
      expect(await endpoints.support.hasUnreadReply(user), isFalse);

      // Admins may answer too.
      await endpoints.supportAdmin.reply(admin, list.single.id, 'Əlavə sual?');
      await endpoints.supportAdmin.close(admin, list.single.id);
      expect(
        (await endpoints.supportAdmin.threads(admin)).single.open,
        isFalse,
      );

      // The user's export holds the conversation.
      final export =
          jsonDecode(await endpoints.account.exportMyData(user)) as Map;
      expect((export['supportMessages'] as List), hasLength(3));
    });

    test('with KMS each thread gets its own support key; older messages '
        'still read and a stale thread never drops the key', () async {
      addTearDown(() => HealthKms.wrapper = null);
      final admin = await staff('first-admin@example.com', StaffRole.admin);
      final id = await member('kms@example.com');
      final user = _as(sessionBuilder, id);
      final db = sessionBuilder.build();

      // Before KMS: the key derived from the KEK.
      await endpoints.support.send(user, 'Köhnə mesaj.');
      final stale = (await SupportThread.db.findFirstRow(db))!;
      expect(stale.wrappedKey, isNull);

      final kms = FakeKmsKeyWrapper();
      HealthKms.wrapper = kms;
      await endpoints.support.send(user, 'Yeni mesaj.');
      final thread = (await SupportThread.db.findById(db, stale.id!))!;
      final key = thread.wrappedKey;
      expect(key, isNotNull);
      // Bound to the support purpose: as a health key it is another key.
      expect(
        await kms.unwrap(key!, thread.authUserId),
        isNot(
          await kms.unwrap(
            key,
            thread.authUserId,
            purpose: SupportCrypto.purpose,
          ),
        ),
      );

      // The thread object read before the key was made: the key is reused
      // and kept.
      await addSupportMessage(db, stale, 'Köhnə obyektlə.', staffId: null);
      await endpoints.supportAdmin.reply(admin, stale.id!, 'Cavab.');
      final after = (await SupportThread.db.findById(db, stale.id!))!;
      expect(after.wrappedKey, key);

      final rows = await SupportMessage.db.find(
        db,
        orderBy: (t) => t.id,
      );
      expect(rows.map((r) => r.keyVersion), [null, 2, 2, 2]);
      final opened = await endpoints.supportAdmin.open(admin, stale.id!);
      expect(opened.map((m) => m.text), [
        'Köhnə mesaj.',
        'Yeni mesaj.',
        'Köhnə obyektlə.',
        'Cavab.',
      ]);
      expect(
        (await endpoints.support.myMessages(user)).map((m) => m.text),
        hasLength(4),
      );

      // A KMS-sealed message never falls back to another key.
      HealthKms.wrapper = null;
      await expectLater(
        endpoints.support.myMessages(user),
        throwsA(isA<StateError>()),
      );
    });

    test('empty and too long messages are refused', () async {
      final user = _as(sessionBuilder, await member('n@example.com'));
      await expectLater(
        endpoints.support.send(user, '   '),
        throwsA(_error(SupportErrors.empty)),
      );
      await expectLater(
        endpoints.support.send(user, 'x' * (SupportRules.maxLength + 1)),
        throwsA(_error(SupportErrors.tooLong)),
      );
    });

    test('conversations go with the account and after 12 months', () async {
      final a = await member('a@example.com');
      final b = await member('b@example.com');
      await endpoints.support.send(_as(sessionBuilder, a), 'Salam');
      await endpoints.support.send(_as(sessionBuilder, b), 'Salam');
      await endpoints.account.deleteAccount(_as(sessionBuilder, a));
      final db = sessionBuilder.build();
      expect(await SupportThread.db.find(db), hasLength(1));
      expect(await SupportMessage.db.find(db), hasLength(1));

      expect(await expireSupport(db), 0);
      expect(
        await expireSupport(
          db,
          now: DateTime.now().add(const Duration(days: 366)),
        ),
        1,
      );
      expect(await SupportThread.db.find(db), isEmpty);
      expect(await SupportMessage.db.find(db), isEmpty);
    });
  });
}
