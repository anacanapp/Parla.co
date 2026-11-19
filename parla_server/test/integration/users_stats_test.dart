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
      // Only admins see statistics and the dashboard.
      for (final role in [StaffRole.editor, StaffRole.expert]) {
        final email = '${role.name}@example.com';
        await endpoints.staffAdmin.invite(admin, email, role);
        final s = await staff(email, role);
        await expectLater(
          endpoints.statsAdmin.report(s),
          throwsA(_error(StaffErrors.forbidden)),
        );
        await expectLater(
          endpoints.dashboardAdmin.report(s, 30),
          throwsA(_error(StaffErrors.forbidden)),
        );
      }
    });

    test(
      'activity and usage are counted only with the analytics consent',
      () async {
        final admin = await staff('first-admin@example.com', StaffRole.admin);
        final ids = [
          for (var i = 0; i < 11; i++) await member('d$i@example.com'),
        ];
        final report = UsageReport(
          platform: 'ios',
          counts: {
            'appOpen|1.2.0': 1,
            'tool|check': 2,
            'tool|nutrition': 1,
            'recipe|green-salad': 1,
            'bannerView|7': 3,
            'bannerTap|7': 1,
            'quiz|skin_type': 4, // not a usage key: dropped
            'tool|shop': 999, // capped
          },
        );
        // Without the analytics consent nothing is stored.
        expect(
          await endpoints.activity.report(
            _as(sessionBuilder, ids.first),
            report,
          ),
          isFalse,
        );
        await endpoints.activity.markActive(_as(sessionBuilder, ids.first));
        final db = sessionBuilder.build();
        expect(await DailyActiveMark.db.find(db), isEmpty);
        expect(await UsageDaily.db.find(db), isEmpty);

        final analytics = currentConsentText(ConsentKind.analytics).version;
        Future<void> decide(String id, bool granted) =>
            endpoints.consent.decide(
              _as(sessionBuilder, id),
              consentType: ConsentType.analytics,
              granted: granted,
              textVersion: analytics,
              language: 'az',
              source: 'app',
            );
        for (final id in ids) {
          await decide(id, true);
        }
        for (final id in ids) {
          expect(
            await endpoints.activity.report(_as(sessionBuilder, id), report),
            isTrue,
          );
          // A second open the same day marks the account once.
          await endpoints.activity.markActive(_as(sessionBuilder, id));
        }
        final marks = await DailyActiveMark.db.find(db);
        expect(marks, hasLength(11));
        for (final m in marks) {
          expect(m.platform, 'ios');
          for (final id in ids) {
            expect(m.mark, isNot(contains(id)));
          }
        }
        // Totals only: one row per day, country, platform and count key.
        final usage = await UsageDaily.db.find(db);
        expect(usage, hasLength(7));
        int times(String event, String target) => usage
            .singleWhere((u) => u.event == event && u.target == target)
            .times;
        expect(times('tool', 'check'), 22);
        expect(times('tool', 'shop'), 11 * UsageRules.maxCount);
        expect(times('bannerView', '7'), 33);
        expect(usage.every((u) => u.country == 'AZ'), isTrue);

        // Withdrawing the consent removes the account's marks.
        await decide(ids.last, false);
        expect(await DailyActiveMark.db.find(db), hasLength(10));

        // Today's marks are counted after the day is over, once, and the
        // marks stay for the weekly and monthly totals.
        expect(await rollUpActivity(db), 0);
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(await rollUpActivity(db, now: tomorrow), 1);
        expect(await rollUpActivity(db, now: tomorrow), 0);
        expect(await DailyActiveMark.db.find(db), hasLength(10));
        final count = (await DailyActiveCount.db.find(db)).single;
        expect(count.accounts, 10);
        expect(count.weekly, 10);
        expect(count.monthly, 10);
        expect(count.ios, 10);
        // After 30 days the marks are gone.
        await rollUpActivity(
          db,
          now: DateTime.now().add(const Duration(days: 32)),
        );
        expect(await DailyActiveMark.db.find(db), isEmpty);

        final stats = await buildStatsReport(db, now: tomorrow);
        expect(
          stats.groups
              .singleWhere((g) => g.metric == 'daily_active')
              .counts
              .single
              .count,
          10,
        );

        final dash = await endpoints.dashboardAdmin.report(admin, 7);
        int? kpi(String id) =>
            dash.kpis.singleWhere((k) => k.label == id).count;
        StatsGroup g(String name) =>
            dash.groups.singleWhere((x) => x.metric == name);
        int? c(String group, String label) =>
            g(group).counts.singleWhere((x) => x.label == label).count;
        expect(dash.days, 7);
        expect(kpi('accounts'), 11);
        expect(kpi('signups'), 11);
        expect(kpi('app_opens'), 11);
        expect(kpi('banner_views'), 33);
        expect(c('tools', 'check'), 22);
        expect(c('tools', 'nutrition'), 11);
        expect(c('tools', 'home'), isNull); // 0: under the minimum
        expect(c('opens_country', 'AZ'), 11);
        expect(c('app_versions', '1.2.0'), 11);
        expect(c('tools_country', 'AZ|check'), 22);
        expect(
          g('recipes_top').counts.single.label,
          startsWith('green-salad|'),
        );
        expect(g('banner_views').counts.single.label, '7||');
        expect(g('banner_taps').counts.single.count, 11);
        expect(g('signups_daily').counts, hasLength(7));
        // Unknown periods fall back to 30 days.
        expect((await endpoints.dashboardAdmin.report(admin, 12)).days, 30);
      },
    );
  });
}
