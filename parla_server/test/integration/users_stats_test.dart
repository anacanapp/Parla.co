import 'package:parla_server/src/auth/verification_code_sender.dart';
import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/stats/activity.dart';
import 'package:parla_server/src/stats/stats_admin_endpoint.dart';
import 'package:parla_server/src/staff/staff_guard.dart';
import 'package:parla_server/src/users/user_admin_endpoint.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';
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

QuizAnswerInput _answer(String q, List<String> o) =>
    QuizAnswerInput(questionId: q, optionIds: o, declined: false);

void main() {
  final healthVersion = currentConsentText(ConsentKind.health).version;

  withServerpod('Given the users section and statistics', (
    sessionBuilder,
    endpoints,
  ) {
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

    /// An app member with an email, profile, health consent and answers.
    Future<String> member(
      String email, {
      String country = 'AZ',
      String language = 'az',
      int birthYear = 1995,
      String skin = 'dry',
    }) async {
      final db = sessionBuilder.build();
      final user = await const AuthUsers().create(db);
      await EmailAccount.db.insertRow(
        db,
        EmailAccount(authUserId: user.id, email: email, passwordHash: 'x'),
      );
      final id = user.id.toString();
      final s = _as(sessionBuilder, id);
      await endpoints.profile.create(
        s,
        birthYear: birthYear,
        countryCode: country,
        language: language,
      );
      await endpoints.consent.decide(
        s,
        consentType: ConsentType.health,
        granted: true,
        textVersion: healthVersion,
        language: language,
        source: 'app',
      );
      await endpoints.quiz.saveAnswers(s, [
        _answer('skin_type', [skin]),
        _answer('pregnancy', ['no']),
      ]);
      return id;
    }

    test(
      'admins find an account by exact email only, and it is audited',
      () async {
        final admin = await staff('first-admin@example.com', StaffRole.admin);
        final id = await member('leyla@example.com');
        expect(await endpoints.userAdmin.find(admin, 'leyla@'), isNull);
        final view = (await endpoints.userAdmin.find(
          admin,
          ' Leyla@Example.com ',
        ))!;
        expect(view.userId.toString(), id);
        expect(view.countryCode, 'AZ');
        expect(view.blocked, isFalse);
        expect(
          view.consents
              .singleWhere((c) => c.consentType == ConsentType.health)
              .granted,
          isTrue,
        );
        final audit = await AuditLogEntry.db.find(
          sessionBuilder.build(),
          where: (t) => t.action.equals('user.viewed'),
        );
        expect(audit.single.objectId, id);

        await endpoints.staffAdmin.invite(
          admin,
          'ed@example.com',
          StaffRole.editor,
        );
        final editor = await staff('ed@example.com', StaffRole.editor);
        await expectLater(
          endpoints.userAdmin.find(editor, 'leyla@example.com'),
          throwsA(_error(StaffErrors.forbidden)),
        );
      },
    );

    test(
      'blocking stops sign-in and can be undone; staff are excluded',
      () async {
        final admin = await staff('first-admin@example.com', StaffRole.admin);
        final id = await member('aysel@example.com');
        final blocked = await endpoints.userAdmin.setBlocked(
          admin,
          UuidValue.fromString(id),
          true,
        );
        expect(blocked.blocked, isTrue);
        final user = await AuthUser.db.findById(
          sessionBuilder.build(),
          UuidValue.fromString(id),
        );
        expect(user!.blocked, isTrue);
        final open = await endpoints.userAdmin.setBlocked(
          admin,
          UuidValue.fromString(id),
          false,
        );
        expect(open.blocked, isFalse);

        final adminView = (await endpoints.userAdmin.find(
          admin,
          'first-admin@example.com',
        ))!;
        expect(adminView.isStaff, isTrue);
        await expectLater(
          endpoints.userAdmin.setBlocked(admin, adminView.userId, true),
          throwsA(_error(UserAdminErrors.isStaff)),
        );
      },
    );

    test(
      'deletion on request needs the email again and pseudonymises',
      () async {
        final admin = await staff('first-admin@example.com', StaffRole.admin);
        final id = await member('nigar@example.com');
        final userId = UuidValue.fromString(id);
        await endpoints.userAdmin.find(admin, 'nigar@example.com');
        await expectLater(
          endpoints.userAdmin.deleteOnRequest(
            admin,
            userId,
            'other@example.com',
          ),
          throwsA(_error(UserAdminErrors.confirmMismatch)),
        );
        await endpoints.userAdmin.deleteOnRequest(
          admin,
          userId,
          'NIGAR@example.com',
        );
        final db = sessionBuilder.build();
        expect(await AuthUser.db.findById(db, userId), isNull);
        expect(
          await MemberProfile.db.find(
            db,
            where: (t) => t.authUserId.equals(userId),
          ),
          isEmpty,
        );
        // No audit row names the deleted account any more.
        final audit = await AuditLogEntry.db.find(db);
        expect(
          audit.where((a) => a.objectId == id || a.actorId == userId),
          isEmpty,
        );
        expect(
          audit.where((a) => a.action == 'account.deleted_on_request'),
          hasLength(1),
        );
        expect(
          await endpoints.userAdmin.find(admin, 'nigar@example.com'),
          isNull,
        );
      },
    );

    test('statistics count only groups of 10 or more', () async {
      final admin = await staff('first-admin@example.com', StaffRole.admin);
      for (var i = 0; i < 12; i++) {
        await member('az$i@example.com', skin: i < 10 ? 'oily' : 'dry');
      }
      for (var i = 0; i < 3; i++) {
        await member('ru$i@example.com', language: 'ru', birthYear: 1960);
      }
      final report = await endpoints.statsAdmin.report(admin);
      StatsGroup g(String name) =>
          report.groups.singleWhere((x) => x.metric == name);
      int? c(String group, String label) =>
          g(group).counts.singleWhere((x) => x.label == label).count;

      expect(report.minGroupSize, 10);
      expect(c('accounts', 'total'), 15);
      expect(c('language', 'az'), 12);
      expect(c('language', 'ru'), isNull); // 3 people: hidden
      expect(c('country', 'AZ'), 15);
      expect(c('age_band', '55+'), isNull); // 3 people: hidden
      expect(c('consent_granted', 'health'), 15);
      expect(c('quiz:skin_type', 'oily'), 10);
      expect(c('quiz:skin_type', 'dry'), isNull);
      // Health questions are never counted.
      expect(report.groups.where((x) => x.metric == 'quiz:pregnancy'), isEmpty);
      // Editors may see statistics; experts may not.
      await endpoints.staffAdmin.invite(
        admin,
        'ed@example.com',
        StaffRole.editor,
      );
      await endpoints.statsAdmin.report(
        await staff('ed@example.com', StaffRole.editor),
      );
      await endpoints.staffAdmin.invite(
        admin,
        'ex@example.com',
        StaffRole.expert,
      );
      await expectLater(
        endpoints.statsAdmin.report(
          await staff('ex@example.com', StaffRole.expert),
        ),
        throwsA(_error(StaffErrors.forbidden)),
      );
    });

    test(
      'daily activity keeps only a total after the nightly roll-up',
      () async {
        final ids = [
          for (var i = 0; i < 11; i++) await member('d$i@example.com'),
        ];
        // Without the analytics consent nothing is marked.
        await endpoints.activity.markActive(_as(sessionBuilder, ids.first));
        expect(await DailyActiveMark.db.find(sessionBuilder.build()), isEmpty);
        final analytics = currentConsentText(ConsentKind.analytics).version;
        for (final id in ids) {
          await endpoints.consent.decide(
            _as(sessionBuilder, id),
            consentType: ConsentType.analytics,
            granted: true,
            textVersion: analytics,
            language: 'az',
            source: 'app',
          );
        }
        for (final id in ids) {
          await endpoints.activity.markActive(_as(sessionBuilder, id));
          // A second open the same day counts once.
          await endpoints.activity.markActive(_as(sessionBuilder, id));
        }
        final db = sessionBuilder.build();
        final marks = await DailyActiveMark.db.find(db);
        expect(marks, hasLength(11));
        for (final m in marks) {
          for (final id in ids) {
            expect(m.mark, isNot(contains(id)));
          }
        }
        // Today's marks stay until the day is over.
        expect(await rollUpActivity(db), 0);
        expect(
          await rollUpActivity(
            db,
            now: DateTime.now().add(const Duration(days: 1)),
          ),
          1,
        );
        expect(await DailyActiveMark.db.find(db), isEmpty);
        final count = await DailyActiveCount.db.find(db);
        expect(count.single.accounts, 11);
        final report = await buildStatsReport(db);
        expect(
          report.groups
              .singleWhere((g) => g.metric == 'daily_active')
              .counts
              .single
              .count,
          11,
        );
      },
    );
  });
}
