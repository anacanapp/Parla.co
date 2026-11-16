import 'dart:io';

import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import 'src/account/retention.dart';
import 'src/auth/verification_code_sender.dart';
import 'src/generated/serverpod.dart';
import 'src/media/media_store.dart';
import 'src/media/s3_media_store.dart';

/// The starting point of the Parla server.
void run(List<String> args) async {
  final pod = Serverpod(args);

  // Staging/production send through SMTP and fail fast without settings.
  final codeSender = verificationCodeSenderFor(pod.runMode, pod.getPassword);

  pod.initializeAuthServices(
    tokenManagerBuilders: [
      // Short-lived JWT access tokens with refresh tokens (checklist ACC-6).
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      // Passwordless sign-in with a one-time code sent by email (PRD US-01).
      // Codes go through our own SMTP sender, not a hosted email service.
      EmailIdpConfigFromPasswords(
        // Passwords are only used by staff for the admin panel (with a
        // second factor); the app signs in with one-time codes.
        passwordValidationFunction: (password) =>
            password.length >= 12 && password.length <= 128,
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

  Media.instance = mediaFor(pod.runMode, Platform.environment);

  await pod.start();

  // Deletes data past its retention period once a day (RET-1, RET-2).
  if (pod.runMode != ServerpodRunMode.test) {
    scheduleDailyRetention(pod);
  }
}

/// Images: an S3 bucket in staging and production (set by Terraform),
/// memory for local development and tests.
Media mediaFor(String runMode, Map<String, String> env) {
  final bucket = env['PARLA_MEDIA_BUCKET'];
  if (bucket != null && bucket.isNotEmpty) {
    final region =
        env['PARLA_MEDIA_REGION'] ?? env['AWS_REGION'] ?? 'eu-central-1';
    final url = env['PARLA_MEDIA_PUBLIC_URL'];
    return Media(
      S3MediaStore(bucket: bucket, region: region),
      publicBaseUrl: url == null || url.isEmpty ? null : url,
    );
  }
  if (runMode == ServerpodRunMode.development ||
      runMode == ServerpodRunMode.test) {
    return Media(MemoryMediaStore());
  }
  return Media(UnconfiguredMediaStore());
}
