import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import 'src/auth/verification_code_sender.dart';
import 'src/generated/serverpod.dart';

/// The starting point of the Parla server.
void run(List<String> args) async {
  final pod = Serverpod(args);

  // Fails fast in staging/production until an approved email provider exists.
  final codeSender = verificationCodeSenderFor(pod.runMode);

  pod.initializeAuthServices(
    tokenManagerBuilders: [
      // Short-lived JWT access tokens with refresh tokens (checklist ACC-6).
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      // Passwordless sign-in with a one-time code sent by email (PRD US-01).
      // Codes go through our own sender, not a hosted email service, so the
      // email address never leaves an approved provider.
      EmailIdpConfigFromPasswords(
        sendOtpLoginVerificationCode:
            (
              session, {
              required email,
              required otpLoginRequestId,
              required verificationCode,
              required transaction,
            }) => codeSender.send(
              session,
              email: email,
              code: verificationCode,
            ),
        sendRegistrationVerificationCode:
            (
              session, {
              required email,
              required accountRequestId,
              required verificationCode,
              required transaction,
            }) => codeSender.send(
              session,
              email: email,
              code: verificationCode,
            ),
      ),
    ],
  );

  await pod.start();
}
