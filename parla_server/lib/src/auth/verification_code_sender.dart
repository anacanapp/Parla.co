import 'package:mailer/mailer.dart' as mail;
import 'package:mailer/smtp_server.dart' as smtp;
import 'package:serverpod/serverpod.dart';

/// Sends sign-in verification codes by email.
///
/// Staging and production send through SMTP ([SmtpCodeSender]) and refuse to
/// start without SMTP settings, so codes are never silently dropped. The
/// mailbox provider is a processor of the email address: where it stores
/// mail is part of the legal review (privacy checklist RES-5).
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

/// SMTP settings, read from the passwords (`passwords.yaml` or
/// `SERVERPOD_PASSWORD_smtp*` environment variables).
class SmtpSettings {
  const SmtpSettings({
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    required this.fromAddress,
  });

  /// Reads the settings; `null` when any of them is missing.
  static SmtpSettings? fromPasswords(String? Function(String) get) {
    final host = get('smtpHost');
    final port = int.tryParse(get('smtpPort') ?? '');
    final username = get('smtpUser');
    final password = get('smtpPassword');
    final from = get('smtpFrom');
    if ([host, username, password, from].any((v) => v == null || v.isEmpty) ||
        port == null) {
      return null;
    }
    return SmtpSettings(
      host: host!,
      port: port,
      username: username!,
      password: password!,
      fromAddress: from!,
    );
  }

  final String host;

  /// 465 means implicit TLS; any other port (usually 587) uses STARTTLS.
  /// Unencrypted connections are never allowed.
  final int port;
  final String username;
  final String password;
  final String fromAddress;
}

/// The sign-in email. It is sent before the app knows the user's language,
/// so it carries all three languages, and only the code: no name, no health
/// information.
mail.Message signInCodeMessage({
  required String from,
  required String to,
  required String code,
}) => mail.Message()
  ..from = mail.Address(from, 'Parla')
  ..recipients = [to]
  ..subject = 'Parla: $code'
  ..text = [
    'Parla-ya giriş kodunuz: $code',
    'Ваш код для входа в Parla: $code',
    'Your Parla sign-in code: $code',
    '',
    'Kod 15 dəqiqə etibarlıdır. Bu kodu siz istəməmisinizsə, məktubu nəzərə almayın.',
    'Код действует 15 минут. Если вы его не запрашивали, просто проигнорируйте это письмо.',
    'The code is valid for 15 minutes. If you did not ask for it, ignore this email.',
  ].join('\n');

/// Sends the code through an SMTP mailbox (for now info@anacan.az).
class SmtpCodeSender implements VerificationCodeSender {
  SmtpCodeSender(this.settings)
    : _server = smtp.SmtpServer(
        settings.host,
        port: settings.port,
        ssl: settings.port == 465,
        allowInsecure: false,
        username: settings.username,
        password: settings.password,
      );

  final SmtpSettings settings;
  final smtp.SmtpServer _server;

  @override
  Future<void> send(
    Session session, {
    required String email,
    required String code,
  }) async {
    try {
      await mail.send(
        signInCodeMessage(from: settings.fromAddress, to: email, code: code),
        _server,
        timeout: const Duration(seconds: 20),
      );
    } on Object catch (error) {
      // Neither the address nor the code is logged (checklist AUD-3).
      session.log(
        'Sign-in email failed: ${error.runtimeType}',
        level: LogLevel.error,
      );
      rethrow;
    }
  }
}

/// Picks the sender for the current run mode. [password] reads a password
/// by name.
VerificationCodeSender verificationCodeSenderFor(
  String runMode,
  String? Function(String) password,
) {
  switch (runMode) {
    case ServerpodRunMode.development:
    case ServerpodRunMode.test:
      return const DevelopmentCodeSender();
    default:
      final smtp = SmtpSettings.fromPasswords(password);
      if (smtp == null) {
        throw StateError(
          'No email sender is configured for run mode "$runMode". Set the '
          'smtpHost, smtpPort, smtpUser, smtpPassword and smtpFrom passwords '
          '(see docs/RELEASE.md).',
        );
      }
      return SmtpCodeSender(smtp);
  }
}
