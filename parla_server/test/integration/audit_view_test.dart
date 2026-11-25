import 'package:parla_server/src/audit/audit.dart';
import 'package:parla_server/src/audit/audit_admin_endpoint.dart';
import 'package:parla_server/src/auth/verification_code_sender.dart';
import 'package:parla_server/src/generated/protocol.dart';
import 'package:parla_server/src/staff/staff_guard.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

import 'staff_sign_in.dart';

Matcher _error(String code) =>
    isA<ParlaException>().having((e) => e.code, 'code', code);

void main() {
  withServerpod('Given the audit log view', (sessionBuilder, endpoints) {
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

    Future<List<AuditLogEntry>> list(
      TestSessionBuilder s, {
      String? action,
      String? role,
      String? type,
      String? object,
      DateTime? from,
      DateTime? to,
      int? beforeId,
    }) => endpoints.auditAdmin.list(
      s,
      action,
      role,
      type,
      object,
      from,
      to,
      beforeId,
    );

    test('admins read the newest entries first, with filters', () async {
      final admin = await staff('first-admin@example.com', StaffRole.admin);
      final db = sessionBuilder.build();
      for (final (action, type) in [
        ('content.published', 'content_item'),
        ('content.saved', 'content_item'),
        ('staff.invite_revoked', 'staff_invite'),
        ('staff.invited', 'staff_invite'),
        ('consent.granted', 'consent_record'),
      ]) {
        await writeAudit(
          db,
          actorId: null,
          actorRole: action.startsWith('consent') ? 'user' : 'staff',
          action: action,
          objectType: type,
          objectId: '7',
        );
      }

      final all = await list(admin);
      final ids = [for (final e in all) e.id!];
      expect(ids, [...ids]..sort((a, b) => b.compareTo(a)));
      expect(all.first.action, 'consent.granted');

      expect(
        [for (final e in await list(admin, action: 'content.')) e.action],
        ['content.saved', 'content.published'],
      );
      // "_" is matched literally, not as a wildcard.
      expect(
        [for (final e in await list(admin, action: 'staff.invite_')) e.action],
        ['staff.invite_revoked'],
      );
      expect(
        [for (final e in await list(admin, role: 'user')) e.action],
        ['consent.granted'],
      );
      expect(
        (await list(admin, type: 'staff_invite', object: '7')).length,
        greaterThanOrEqualTo(2),
      );
      expect(
        await list(admin, from: DateTime.now().add(const Duration(days: 1))),
        isEmpty,
      );

      final older = await list(admin, beforeId: all.first.id);
      expect(older.first.id, lessThan(all.first.id!));
      expect(
        () => list(admin, action: "x'; drop"),
        throwsA(_error(AuditErrors.invalidFilter)),
      );
    });

    test('opening the log is audited; paging is not', () async {
      final admin = await staff('first-admin@example.com', StaffRole.admin);
      Future<int> views() async => (await AuditLogEntry.db.find(
        sessionBuilder.build(),
        where: (t) => t.action.equals('audit.viewed'),
      )).length;
      await list(admin);
      expect(await views(), 1);
      await list(admin, beforeId: 1 << 30);
      expect(await views(), 1);
    });

    test('only admins can read it', () async {
      final admin = await staff('first-admin@example.com', StaffRole.admin);
      for (final role in [
        StaffRole.editor,
        StaffRole.expert,
        StaffRole.support,
      ]) {
        await endpoints.staffAdmin.invite(
          admin,
          '${role.name}@example.com',
          role,
        );
        final s = await staff('${role.name}@example.com', role);
        await expectLater(
          list(s),
          throwsA(_error(StaffErrors.forbidden)),
          reason: role.name,
        );
      }
    });
  });
}
