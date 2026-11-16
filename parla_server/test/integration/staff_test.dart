import 'package:parla_server/src/auth/verification_code_sender.dart';
import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/staff/staff_guard.dart';
import 'package:parla_server/src/staff/totp.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

Matcher _error(String code) =>
    isA<ParlaException>().having((e) => e.code, 'code', code);

void main() {
  withServerpod('Given the admin panel staff endpoints', (
    sessionBuilder,
    endpoints,
  ) {
    var sessions = 0;

    /// A sign-in account with [email]; returns a session builder for a
    /// fresh sign-in session of it.
    Future<({String id, TestSessionBuilder Function() signIn})> account(
      String email,
    ) async {
      final db = sessionBuilder.build();
      final user = await const AuthUsers().create(db);
      await EmailAccount.db.insertRow(
        db,
        EmailAccount(authUserId: user.id, email: email, passwordHash: 'x'),
      );
      final id = user.id.toString();
      return (
        id: id,
        signIn: () => sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            id,
            {},
            authId: 'session-${sessions++}',
          ),
        ),
      );
    }

    /// Sets up the authenticator for [s] and returns its secret.
    Future<List<int>> enrol(TestSessionBuilder s) async {
      final enrollment = await endpoints.staff.startTotp(s);
      final secret = Totp.fromBase32(enrollment.secret);
      final code = await Totp.code(secret, Totp.stepAt(DateTime.now()));
      await endpoints.staff.confirmTotp(s, code);
      return secret;
    }

    /// The first admin, enrolled and verified in its session.
    Future<({String id, TestSessionBuilder session, List<int> secret})>
    firstAdmin() async {
      final a = await account('First-Admin@example.com');
      final s = a.signIn();
      await endpoints.staff.claimFirstAdmin(s);
      final secret = await enrol(s);
      return (id: a.id, session: s, secret: secret);
    }

    test('someone who is not staff gets nothing', () async {
      final a = await account('user@example.com');
      final s = a.signIn();
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
      expect(me.totpEnrolled, isTrue);
      expect(me.verified, isTrue);

      final again = await account('first-admin@example.com');
      await expectLater(
        endpoints.staff.claimFirstAdmin(again.signIn()),
        throwsA(_error(StaffErrors.inviteInvalid)),
      );
      final secret = await StaffMember.db.findFirstRow(sessionBuilder.build());
      expect(secret!.totpSecret, isNot(contains('=')));
    });

    test(
      'admin calls need the second factor in each sign-in session',
      () async {
        final admin = await firstAdmin();
        expect(
          await endpoints.staffAdmin.listStaff(admin.session),
          hasLength(1),
        );

        // A new sign-in session of the same account is not verified yet.
        final fresh = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            admin.id,
            {},
            authId: 'other-session',
          ),
        );
        await expectLater(
          endpoints.staffAdmin.listStaff(fresh),
          throwsA(_error(StaffErrors.totpRequired)),
        );
        // A code already used cannot be used again.
        final used = await Totp.code(admin.secret, Totp.stepAt(DateTime.now()));
        await expectLater(
          endpoints.staff.verifyTotp(fresh, used),
          throwsA(_error(StaffErrors.totpInvalid)),
        );
        final next = await Totp.code(
          admin.secret,
          Totp.stepAt(DateTime.now()) + 1,
        );
        await endpoints.staff.verifyTotp(fresh, next);
        expect(await endpoints.staffAdmin.listStaff(fresh), hasLength(1));

        await endpoints.staff.endSession(fresh);
        await expectLater(
          endpoints.staffAdmin.listStaff(fresh),
          throwsA(_error(StaffErrors.totpRequired)),
        );
      },
    );

    test('five wrong codes lock the account for a while', () async {
      final admin = await firstAdmin();
      final fresh = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          admin.id,
          {},
          authId: 'lock-session',
        ),
      );
      for (var i = 0; i < 4; i++) {
        await expectLater(
          endpoints.staff.verifyTotp(fresh, '000000'),
          throwsA(_error(StaffErrors.totpInvalid)),
        );
      }
      await expectLater(
        endpoints.staff.verifyTotp(fresh, '000000'),
        throwsA(_error(StaffErrors.locked)),
      );
      final good = await Totp.code(
        admin.secret,
        Totp.stepAt(DateTime.now()) + 1,
      );
      await expectLater(
        endpoints.staff.verifyTotp(fresh, good),
        throwsA(_error(StaffErrors.locked)),
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
        endpoints.staff.acceptInvite(other.signIn(), code),
        throwsA(_error(StaffErrors.inviteInvalid)),
      );

      final editor = await account('editor@example.com');
      final s = editor.signIn();
      final me = await endpoints.staff.acceptInvite(s, code.toLowerCase());
      expect(me.role, StaffRole.editor);
      expect(me.totpEnrolled, isFalse);
      await expectLater(
        endpoints.staff.acceptInvite(s, code),
        throwsA(_error(StaffErrors.already)),
      );

      // Editors cannot manage staff, and need the second factor first.
      await expectLater(
        endpoints.staffAdmin.listStaff(s),
        throwsA(_error(StaffErrors.totpRequired)),
      );
      await enrol(s);
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
        final s = expert.signIn();
        await endpoints.staff.acceptInvite(
          s,
          DevelopmentCodeSender.lastStaffInviteCode!,
        );
        await enrol(s);
        final expertId = UuidValue.fromString(expert.id);

        await endpoints.staffAdmin.setRole(
          admin.session,
          expertId,
          StaffRole.admin,
        );
        expect(await endpoints.staffAdmin.listStaff(s), hasLength(2));

        await endpoints.staffAdmin.setActive(admin.session, expertId, false);
        expect(await endpoints.staff.me(s), isNull);
        expect(
          await StaffSession.db.count(
            sessionBuilder.build(),
            where: (t) => t.authUserId.equals(expertId),
          ),
          0,
        );
      },
    );

    test('a reset authenticator must be set up again', () async {
      final admin = await firstAdmin();
      await endpoints.staffAdmin.invite(
        admin.session,
        'editor2@example.com',
        StaffRole.editor,
      );
      final editor = await account('editor2@example.com');
      final s = editor.signIn();
      await endpoints.staff.acceptInvite(
        s,
        DevelopmentCodeSender.lastStaffInviteCode!,
      );
      await enrol(s);
      await endpoints.staffAdmin.resetTotp(
        admin.session,
        UuidValue.fromString(editor.id),
      );
      final me = await endpoints.staff.me(s);
      expect(me!.totpEnrolled, isFalse);
      expect(me.verified, isFalse);
      await enrol(s);
    });

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
          'staff.totp_enrolled',
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
        expect(await StaffSession.db.count(sessionBuilder.build()), 0);
      },
    );
  });
}
