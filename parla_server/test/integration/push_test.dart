import 'dart:convert';

import 'package:parla_server/src/auth/verification_code_sender.dart';
import 'package:parla_server/src/content/content_admin_endpoint.dart';
import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/push/push.dart';
import 'package:parla_server/src/push/push_endpoint.dart';
import 'package:parla_server/src/push/push_sender.dart';
import 'package:parla_shared/parla_shared.dart';
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

Map<String, String> _l(String s) => {
  'az': '$s az',
  'ru': '$s ru',
  'en': '$s en',
};

void main() {
  late RecordingPushSender sender;

  setUp(() {
    sender = RecordingPushSender();
    Push.sender = sender;
    // Tests run the queue themselves.
    PushJobs.kickOnQueue = false;
    PushJobs.batchSize = 500;
  });

  withServerpod('Given push notifications', (sessionBuilder, endpoints) {
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

    Future<String> member(
      String email, {
      String language = 'az',
      bool marketing = false,
      String? token,
    }) async {
      final db = sessionBuilder.build();
      final user = await const AuthUsers().create(db);
      await EmailAccount.db.insertRow(
        db,
        EmailAccount(authUserId: user.id, email: email, passwordHash: 'x'),
      );
      final s = _as(sessionBuilder, user.id.toString());
      await endpoints.profile.create(
        s,
        birthYear: 1995,
        countryCode: 'AZ',
        language: language,
      );
      if (marketing) {
        await endpoints.consent.decide(
          s,
          consentType: ConsentType.marketing,
          granted: true,
          textVersion: currentConsentText(ConsentKind.marketing).version,
          language: language,
          source: 'app',
        );
      }
      if (token != null) await endpoints.push.register(s, token, 'android');
      return user.id.toString();
    }

    test('phones register and unregister their token', () async {
      final id = await member('a@example.com', token: 'tok-a');
      final s = _as(sessionBuilder, id);
      await endpoints.push.register(s, 'tok-a', 'android'); // again: no copy
      expect(await DeviceToken.db.find(sessionBuilder.build()), hasLength(1));
      await expectLater(
        endpoints.push.register(s, 'tok-b', 'windows'),
        throwsA(_error(PushErrors.invalid)),
      );
      await endpoints.push.unregister(s, 'tok-a');
      expect(await DeviceToken.db.find(sessionBuilder.build()), isEmpty);
    });

    test('a support reply sends a notice without the reply text', () async {
      final admin = await staff('first-admin@example.com', StaffRole.admin);
      final id = await member('b@example.com', language: 'ru', token: 'tok-b');
      await endpoints.support.send(_as(sessionBuilder, id), 'Вопрос');
      final thread = (await endpoints.supportAdmin.threads(admin)).single;
      await endpoints.supportAdmin.reply(admin, thread.id, 'Секретный ответ');
      final (token, message) = sender.sent.single;
      expect(token, 'tok-b');
      expect(message.body, contains('ответила'));
      expect(message.body, isNot(contains('Секретный')));
      expect(message.link, 'messages');
    });

    test('campaigns go once, only with the marketing consent and the '
        'chosen languages', () async {
      final admin = await staff('first-admin@example.com', StaffRole.admin);
      await member('yes@example.com', marketing: true, token: 'tok-yes');
      await member('no@example.com', token: 'tok-no');
      await member(
        'ru@example.com',
        language: 'ru',
        marketing: true,
        token: 'tok-ru',
      );
      await member('gone@example.com', marketing: true, token: 'tok-gone');
      sender.gone.add('tok-gone');

      final item = await endpoints.contentAdmin.create(
        admin,
        'push',
        'yeni-resept',
        'marketing',
      );
      await endpoints.contentAdmin.saveDraft(
        admin,
        item.id,
        jsonEncode({
          'title': _l('Yeni reseptlər'),
          'body': _l('Qidalanma bölməsinə bax'),
          'link': 'nutrition',
          'languages': ['az'],
        }),
        'marketing',
      );
      await endpoints.contentAdmin.publish(admin, item.id);
      // Publishing only queues it; the background run sends it.
      expect(sender.sent, isEmpty);
      expect(
        (await endpoints.contentAdmin.pushStatus(admin, item.id))!.status,
        PushJobs.queued,
      );
      await runPushJobs(sessionBuilder.build());
      expect(sender.sent.map((s) => s.$1), ['tok-yes']);
      final status = (await endpoints.contentAdmin.pushStatus(admin, item.id))!;
      expect(status.status, PushJobs.done);
      expect(status.sent, 1);
      expect(status.finishedAt, isNotNull);
      expect(sender.sent.single.$2.title, 'Yeni reseptlər az');
      // FCM said the token is gone: it is deleted.
      final tokens = await DeviceToken.db.find(sessionBuilder.build());
      expect(tokens.map((t) => t.token), isNot(contains('tok-gone')));

      await expectLater(
        endpoints.contentAdmin.publish(admin, item.id),
        throwsA(_error(ContentErrors.wrongStatus)),
      );
      await runPushJobs(sessionBuilder.build());
      expect(sender.sent, hasLength(1));
    });

    Future<int> campaign(TestSessionBuilder admin, String slug) async {
      final item = await endpoints.contentAdmin.create(
        admin,
        'push',
        slug,
        'marketing',
      );
      await endpoints.contentAdmin.saveDraft(
        admin,
        item.id,
        jsonEncode({'title': _l('Salam'), 'body': _l('Mətn')}),
        'marketing',
      );
      await endpoints.contentAdmin.publish(admin, item.id);
      return item.id;
    }

    test(
      'large audiences go in batches and resume after the last account',
      () async {
        final admin = await staff('first-admin@example.com', StaffRole.admin);
        for (var i = 0; i < 5; i++) {
          await member('m$i@example.com', marketing: true, token: 'tok-$i');
        }
        PushJobs.batchSize = 2;
        final id = await campaign(admin, 'boyuk');
        // A restart after the first two accounts: the job remembers them.
        final db = sessionBuilder.build();
        final job = (await PushJob.db.findFirstRow(
          db,
          where: (t) => t.contentId.equals(id),
        ))!;
        final first = (await DeviceToken.db.find(
          db,
          orderBy: (t) => t.authUserId,
        )).take(2).toList();
        await PushJob.db.updateRow(
          db,
          job.copyWith(
            status: PushJobs.sending,
            sent: 2,
            cursor: first.last.authUserId,
          ),
        );
        await runPushJobs(db);
        expect(sender.sent, hasLength(3));
        expect(
          sender.sent.map((s) => s.$1),
          isNot(contains(anyOf(first.map((t) => t.token).toList()))),
        );
        final status = (await endpoints.contentAdmin.pushStatus(admin, id))!;
        expect(status.status, PushJobs.done);
        expect(status.sent, 5);
      },
    );

    test(
      'a job held by another instance is left alone until its lease ends',
      () async {
        final admin = await staff('first-admin@example.com', StaffRole.admin);
        await member('a@example.com', marketing: true, token: 'tok-a');
        final id = await campaign(admin, 'lease');
        final db = sessionBuilder.build();
        final job = (await PushJob.db.findFirstRow(
          db,
          where: (t) => t.contentId.equals(id),
        ))!;
        await PushJob.db.updateRow(
          db,
          job.copyWith(
            leaseUntil: DateTime.now().toUtc().add(const Duration(minutes: 1)),
          ),
        );
        await runPushJobs(db);
        expect(sender.sent, isEmpty);
        await PushJob.db.updateRow(
          db,
          job.copyWith(
            leaseUntil: DateTime.now().toUtc().subtract(
              const Duration(minutes: 1),
            ),
          ),
        );
        await runPushJobs(db);
        expect(sender.sent, hasLength(1));
      },
    );

    test('consent withdrawn before sending, or an unpublished campaign, '
        'sends nothing', () async {
      final admin = await staff('first-admin@example.com', StaffRole.admin);
      final user = await member(
        'w@example.com',
        marketing: true,
        token: 'tok-w',
      );
      final id = await campaign(admin, 'geri');
      await endpoints.consent.decide(
        _as(sessionBuilder, user),
        consentType: ConsentType.marketing,
        granted: false,
        textVersion: currentConsentText(ConsentKind.marketing).version,
        language: 'az',
        source: 'app',
      );
      await runPushJobs(sessionBuilder.build());
      expect(sender.sent, isEmpty);
      expect(
        (await endpoints.contentAdmin.pushStatus(admin, id))!.status,
        PushJobs.done,
      );

      await member('v@example.com', marketing: true, token: 'tok-v');
      final second = await campaign(admin, 'ikinci');
      await endpoints.contentAdmin.unpublish(admin, second);
      await runPushJobs(sessionBuilder.build());
      expect(sender.sent, isEmpty);
      expect(
        (await endpoints.contentAdmin.pushStatus(admin, second))!.status,
        PushJobs.stopped,
      );
    });

    test('an editor\'s campaign needs an admin', () async {
      final admin = await staff('first-admin@example.com', StaffRole.admin);
      await endpoints.staffAdmin.invite(
        admin,
        'ed@example.com',
        StaffRole.editor,
      );
      final editor = await staff('ed@example.com', StaffRole.editor);
      final item = await endpoints.contentAdmin.create(
        editor,
        'push',
        'kampaniya',
        'marketing',
      );
      await endpoints.contentAdmin.saveDraft(
        editor,
        item.id,
        jsonEncode({'title': _l('Salam'), 'body': _l('Mətn')}),
        'marketing',
      );
      await expectLater(
        endpoints.contentAdmin.publish(editor, item.id),
        throwsA(_error(ContentErrors.wrongStatus)),
      );
      await endpoints.contentAdmin.submitForReview(editor, item.id);
      await endpoints.contentAdmin.approve(admin, item.id);
      await endpoints.contentAdmin.publish(editor, item.id);
    });

    test('tokens go with the account and after 90 days unseen', () async {
      final a = await member('x@example.com', token: 'tok-x');
      await member('y@example.com', token: 'tok-y');
      await endpoints.account.deleteAccount(_as(sessionBuilder, a));
      final db = sessionBuilder.build();
      expect((await DeviceToken.db.find(db)).map((t) => t.token), ['tok-y']);
      expect(await expireTokens(db), 0);
      expect(
        await expireTokens(
          db,
          now: DateTime.now().add(const Duration(days: 91)),
        ),
        1,
      );
    });
  });
}
