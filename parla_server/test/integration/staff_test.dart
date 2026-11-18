import 'package:parla_server/src/auth/verification_code_sender.dart';
import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/staff/staff_guard.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'staff_sign_in.dart';
import 'test_tools/serverpod_test_tools.dart';

Matcher _error(String code) =>
    isA<ParlaException>().having((e) => e.code, 'code', code);

void main() {
  withServerpod('Given the admin panel staff endpoints', (
    sessionBuilder,
    endpoints,
  ) {
    /// A sign-in account with [email]; `signIn` returns a session builder
    /// for a new password sign-in of it, [at] a given time (default now).
    Future<
      ({
        String id,
        Future<TestSessionBuilder> Function({DateTime? at}) signIn,
      })
    >
    account(String email) async {
      final db = sessionBuilder.build();
      final user = await const AuthUsers().create(db);
      await EmailAccount.db.insertRow(
        db,
        EmailAccount(authUserId: user.id, email: email, passwordHash: 'x'),
      );
      final id = user.id.toString();
      return (
        id: id,
        signIn: ({DateTime? at}) async => sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            id,
            {},
            authId: await signInSession(
              sessionBuilder.build(),
              user.id,
              at: at,
            ),
          ),
        ),
      );
    }

    /// The first admin, signed in now.
    Future<({String id, TestSessionBuilder session})> firstAdmin() async {
      final a = await account('First-Admin@example.com');
      final s = await a.signIn();
      await endpoints.staff.claimFirstAdmin(s);
      return (id: a.id, session: s);
    }

    test('someone who is not staff gets nothing', () async {
      final a = await account('user@example.com');
      final s = await a.signIn();
      expect(await endpoints.staff.me(s), isNull);
      await expectLater(
        endpoints.staffAdmin.listStaff(s),
        throwsA(_error(StaffErrors.notStaff)),
      );
      await expectLater(
        endpoints.staff.claimFirstAdmin(s),
        throwsA(_error(StaffErrors.inviteInvalid)),
      );
    });

    test('the bootstrap email claims the first admin once', () async {
      final admin = await firstAdmin();
      final me = await endpoints.staff.me(admin.session);
      expect(me!.role, StaffRole.admin);
      final left = me.signInExpiresAt.difference(DateTime.now().toUtc());
      expect(left, greaterThan(const Duration(hours: 11, minutes: 59)));
      expect(left, lessThanOrEqualTo(const Duration(hours: 12)));

      final again = await account('first-admin@example.com');
      await expectLater(
        endpoints.staff.claimFirstAdmin(await again.signIn()),
        throwsA(_error(StaffErrors.inviteInvalid)),
      );
    });

    test('the password is needed again 12 hours after signing in', () async {
      final admin = await firstAdmin();
      expect(await endpoints.staffAdmin.listStaff(admin.session), hasLength(1));

      final a = await account('late@example.com');
      await endpoints.staffAdmin.invite(
        admin.session,
        'late@example.com',
        StaffRole.editor,
      );
      final code = DevelopmentCodeSender.lastStaffInviteCode!;
      final old = await a.signIn(
        at: DateTime.now().subtract(const Duration(hours: 12, minutes: 1)),
      );
      await expectLater(
        endpoints.staff.acceptInvite(old, code),
        throwsA(_error(StaffErrors.signInAgain)),
      );
      // Nothing was stored by the refused call; a fresh sign-in works.
      final fresh = await a.signIn(
        at: DateTime.now().subtract(const Duration(hours: 11)),
      );
      final me = await endpoints.staff.acceptInvite(fresh, code);
      expect(me.role, StaffRole.editor);
      await expectLater(
        endpoints.staff.me(old),
        throwsA(_error(StaffErrors.signInAgain)),
      );
      await expectLater(
        endpoints.contentAdmin.list(old, 'article'),
        throwsA(_error(StaffErrors.signInAgain)),
      );
    });

    test("another account's sign-in session is not accepted", () async {
      final admin = await firstAdmin();
      final other = await account('other@example.com');
      final borrowed = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          admin.id,
          {},
          authId: await signInSession(
            sessionBuilder.build(),
            UuidValue.fromString(other.id),
          ),
        ),
      );
      await expectLater(
        endpoints.staffAdmin.listStaff(borrowed),
        throwsA(_error(StaffErrors.signInAgain)),
      );
    });

    test('an invitation lets that email join with its role, once', () async {
      final admin = await firstAdmin();
      await endpoints.staffAdmin.invite(
        admin.session,
        'Editor@Example.com',
        StaffRole.editor,
      );
      final code = DevelopmentCodeSender.lastStaffInviteCode!;
      expect(
        await endpoints.staffAdmin.listInvites(admin.session),
        hasLength(1),
      );

      final other = await account('someone@example.com');
      await expectLater(
        endpoints.staff.acceptInvite(await other.signIn(), code),
        throwsA(_error(StaffErrors.inviteInvalid)),
      );

      final editor = await account('editor@example.com');
      final s = await editor.signIn();
      final me = await endpoints.staff.acceptInvite(s, code.toLowerCase());
      expect(me.role, StaffRole.editor);
      await expectLater(
        endpoints.staff.acceptInvite(s, code),
        throwsA(_error(StaffErrors.already)),
      );

      // Editors cannot manage staff.
      await expectLater(
        endpoints.staffAdmin.listStaff(s),
        throwsA(_error(StaffErrors.forbidden)),
      );
      expect(await endpoints.staffAdmin.listInvites(admin.session), isEmpty);
    });

    test(
      'roles change, members are deactivated, the last admin stays',
      () async {
        final admin = await firstAdmin();
        await expectLater(
          endpoints.staffAdmin.setRole(
            admin.session,
            UuidValue.fromString(admin.id),
            StaffRole.editor,
          ),
          throwsA(_error(StaffErrors.lastAdmin)),
        );

        await endpoints.staffAdmin.invite(
          admin.session,
          'expert@example.com',
          StaffRole.expert,
        );
        final expert = await account('expert@example.com');
        final s = await expert.signIn();
        await endpoints.staff.acceptInvite(
          s,
          DevelopmentCodeSender.lastStaffInviteCode!,
        );
        final expertId = UuidValue.fromString(expert.id);

        await endpoints.staffAdmin.setRole(
          admin.session,
          expertId,
          StaffRole.admin,
        );
        expect(await endpoints.staffAdmin.listStaff(s), hasLength(2));

        await endpoints.staffAdmin.setActive(admin.session, expertId, false);
        expect(await endpoints.staff.me(s), isNull);
        await expectLater(
          endpoints.staffAdmin.listStaff(s),
          throwsA(_error(StaffErrors.inactive)),
        );
      },
    );

    test('every staff action is audited with ids only', () async {
      final admin = await firstAdmin();
      await endpoints.staffAdmin.invite(
        admin.session,
        'auditme@example.com',
        StaffRole.editor,
      );
      final rows = await AuditLogEntry.db.find(
        sessionBuilder.build(),
        where: (t) => t.actorRole.equals('staff'),
      );
      expect(
        rows.map((r) => r.action),
        containsAll([
          'staff.first_admin',
          'staff.invited',
        ]),
      );
      for (final r in rows) {
        expect('${r.objectId}', isNot(contains('@')));
      }
    });

    test(
      "deleting a staff member's account removes their panel access",
      () async {
        final admin = await firstAdmin();
        await endpoints.account.deleteAccount(admin.session);
        expect(await StaffMember.db.count(sessionBuilder.build()), 0);
      },
    );
  });
}
