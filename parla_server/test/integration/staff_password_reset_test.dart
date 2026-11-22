import 'package:parla_server/src/auth/staff_password_reset.dart';
import 'package:parla_server/src/auth/verification_code_sender.dart';
import 'package:parla_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

/// Records what would be emailed.
class _RecordingSender implements VerificationCodeSender {
  final resets = <String>[];

  @override
  Future<void> sendStaffPasswordReset(
    Session session, {
    required String email,
    required String code,
  }) async => resets.add('$email:$code');

  @override
  Future<void> send(
    Session session, {
    required String email,
    required String code,
  }) async {}

  @override
  Future<void> sendStaffInvite(
    Session session, {
    required String email,
    required String code,
  }) async {}
}

void main() {
  withServerpod('Given a staff password reset', (sessionBuilder, endpoints) {
    Future<UuidValue> account(String email) async {
      final db = sessionBuilder.build();
      final user = await const AuthUsers().create(db);
      await EmailAccount.db.insertRow(
        db,
        EmailAccount(authUserId: user.id, email: email, passwordHash: 'x'),
      );
      return user.id;
    }

    Future<void> staff(UuidValue userId, {bool active = true}) =>
        StaffMember.db.insertRow(
          sessionBuilder.build(),
          StaffMember(
            authUserId: userId,
            role: StaffRole.editor,
            active: active,
            createdAt: DateTime.now().toUtc(),
          ),
        );

    test('an active staff member gets the code by email', () async {
      await staff(await account('editor@example.com'));
      final sender = _RecordingSender();
      await sendStaffPasswordResetCode(
        sessionBuilder.build(),
        sender,
        email: ' Editor@Example.com ',
        code: '123456',
      );
      expect(sender.resets, [' Editor@Example.com :123456']);
    });

    test(
      'an app user, a stranger or a deactivated member gets nothing',
      () async {
        await account('user@example.com');
        await staff(await account('gone@example.com'), active: false);
        final sender = _RecordingSender();
        for (final email in [
          'user@example.com',
          'nobody@example.com',
          'gone@example.com',
          '',
        ]) {
          await sendStaffPasswordResetCode(
            sessionBuilder.build(),
            sender,
            email: email,
            code: '123456',
          );
        }
        expect(sender.resets, isEmpty);
      },
    );

    test('the development sender keeps the code for tests', () async {
      await const DevelopmentCodeSender().sendStaffPasswordReset(
        sessionBuilder.build(),
        email: 'editor@example.com',
        code: '654321',
      );
      expect(DevelopmentCodeSender.lastStaffPasswordResetCode, '654321');
    });
  });

  test('the reset email holds only the code, in Azerbaijani', () {
    final message = staffPasswordResetMessage(
      from: 'info@example.com',
      to: 'editor@example.com',
      code: '123456',
    );
    expect(message.subject, 'Parla admin paneli: şifrə bərpası');
    expect(message.text, contains('123456'));
    expect(message.text, contains('15 dəqiqə'));
  });
}
