import 'dart:io';

import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import 'src/account/retention.dart';
import 'src/audit/append_only.dart';
import 'src/auth/staff_password_reset.dart';
import 'src/auth/verification_code_sender.dart';
import 'src/content/content_images_task.dart';
import 'src/content/recipe_kcal.dart';
import 'src/content/content_import.dart';
import 'src/generated/serverpod.dart';
import 'src/health/health_kms.dart';
import 'src/media/media_store.dart';
import 'src/media/s3_media_store.dart';
import 'src/push/push_sender.dart';
import 'src/web/web_routes.dart';

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
        // Passwords are only used by staff for the admin panel; the app
        // signs in with one-time codes. Staff may also sign in to the panel
        // with a one-time code (decision of 2026-11-22).
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
        // Reset codes go only to active staff (see staff_password_reset).
        sendPasswordResetVerificationCode:
            (
              session, {
              required email,
              required passwordResetRequestId,
              required verificationCode,
              required transaction,
            }) => sendStaffPasswordResetCode(
              session,
              codeSender,
              email: email,
              code: verificationCode,
              transaction: transaction,
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
  // Health data keys wrapped by AWS KMS when configured (ENC-3).
  final kmsKey = Platform.environment['PARLA_HEALTH_KMS_KEY_ID'];
  if (kmsKey != null && kmsKey.isNotEmpty) {
    HealthKms.wrapper = AwsKmsKeyWrapper(
      keyId: kmsKey,
      region:
          Platform.environment['PARLA_MEDIA_REGION'] ??
          Platform.environment['AWS_REGION'] ??
          'eu-central-1',
    );
  }
  // Push notifications only when the Firebase service account is set
  // (Terraform var.enable_push); otherwise nothing leaves the server.
  final fcm = pod.getPassword('fcmServiceAccount');
  if (fcm != null && fcm.isNotEmpty) Push.sender = FcmPushSender(fcm);

  // Admin panel and published images on the web server (production).
  addWebRoutes(pod);

  await pod.start();

  // Append-only consent and audit tables at the database level (AUD-2).
  final guardSession = await pod.createSession(enableLogging: false);
  try {
    await installAppendOnlyGuards(guardSession);
  } finally {
    await guardSession.close();
  }

  // A one-off maintenance task (an ECS task with PARLA_TASK set): it runs
  // and the process ends; it never serves traffic.
  final task = Platform.environment['PARLA_TASK'];
  if (task != null && task.isNotEmpty) {
    await _runTask(pod, task, Platform.environment['PARLA_TASK_ACTOR'] ?? '');
    return;
  }

  // Deletes data past its retention period once a day (RET-1, RET-2).
  if (pod.runMode != ServerpodRunMode.test) {
    scheduleDailyRetention(pod);
  }
}

Future<void> _runTask(Serverpod pod, String task, String actor) async {
  final session = await pod.createSession(enableLogging: true);
  var code = 0;
  try {
    switch (task) {
      case 'publish-imported':
        final restore = {
          for (final slug
              in (Platform.environment['PARLA_TASK_RESTORE'] ?? '').split(','))
            if (slug.trim().isNotEmpty) slug.trim(),
        };
        final result = await runPublishImportedTask(
          session,
          actor,
          restore: restore,
        );
        session.log('Task $task: $result', level: LogLevel.info);
        stdout.writeln('Task $task: $result');
      case 'attach-content-images':
        final result = await runAttachContentImagesTask(session, actor);
        session.log('Task $task: $result', level: LogLevel.info);
        stdout.writeln('Task $task: $result');
      case 'publish-exercise-drafts':
        final slugs = {
          for (final s
              in (Platform.environment['PARLA_TASK_SLUGS'] ?? '').split(','))
            if (s.trim().isNotEmpty) s.trim(),
        };
        final result = await runPublishExerciseDraftsTask(
          session,
          actor,
          slugs,
        );
        session.log('Task $task: $result', level: LogLevel.info);
        stdout.writeln('Task $task: $result');
      case 'set-recipe-kcal':
        final result = await runSetRecipeKcalTask(session, actor);
        session.log('Task $task: $result', level: LogLevel.info);
        stdout.writeln('Task $task: $result');
      case 'seed-sample-experts':
        final result = await runSeedSampleExpertsTask(session, actor);
        session.log('Task $task: $result', level: LogLevel.info);
        stdout.writeln('Task $task: $result');
      default:
        throw StateError('Unknown task $task');
    }
  } on Object catch (error, stackTrace) {
    code = 1;
    session.log(
      'Task $task failed',
      level: LogLevel.error,
      exception: error,
      stackTrace: stackTrace,
    );
    stderr.writeln('Task $task failed: $error');
  } finally {
    await session.close();
  }
  await pod.shutdown(exitProcess: false);
  exit(code);
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
