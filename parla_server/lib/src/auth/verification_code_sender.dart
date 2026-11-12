import 'package:serverpod/serverpod.dart';

/// Sends sign-in verification codes by email.
///
/// The email provider is not chosen yet: it must store data in a country the
/// legal review allows (privacy checklist RES-5, lawyer question 5). Until
/// then only [DevelopmentCodeSender] exists, and staging/production refuse to
/// start without a real sender, so codes are never silently dropped.
abstract interface class VerificationCodeSender {
  Future<void> send(
    Session session, {
    required String email,
    required String code,
  });
}

/// Development and test only: writes the code to the server log.
///
/// The email address is not logged (checklist AUD-3), so the developer
/// matches the code by time.
class DevelopmentCodeSender implements VerificationCodeSender {
  const DevelopmentCodeSender();

  @override
  Future<void> send(
    Session session, {
    required String email,
    required String code,
  }) async {
    session.log(
      'Sign-in code (development only): $code',
      level: LogLevel.info,
    );
  }
}

/// Picks the sender for the current run mode.
VerificationCodeSender verificationCodeSenderFor(String runMode) {
  switch (runMode) {
    case ServerpodRunMode.development:
    case ServerpodRunMode.test:
      return const DevelopmentCodeSender();
    default:
      throw StateError(
        'No email provider is configured for run mode "$runMode". '
        'Add a VerificationCodeSender for an approved provider before '
        'deploying (see docs/ARCHITECTURE.md).',
      );
  }
}
