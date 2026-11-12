import 'package:parla_server/src/auth/verification_code_sender.dart';
import 'package:test/test.dart';

void main() {
  Map<String, String> full() => {
    'smtpHost': 'smtp.example.org',
    'smtpPort': '587',
    'smtpUser': 'info@example.org',
    'smtpPassword': 'secret',
    'smtpFrom': 'info@example.org',
  };

  test('SMTP settings need every value', () {
    expect(SmtpSettings.fromPasswords((k) => full()[k]), isNotNull);
    for (final key in full().keys) {
      final missing = full()..remove(key);
      expect(
        SmtpSettings.fromPasswords((k) => missing[k]),
        isNull,
        reason: key,
      );
    }
    final badPort = full()..['smtpPort'] = 'abc';
    expect(SmtpSettings.fromPasswords((k) => badPort[k]), isNull);
  });

  test('staging refuses to start without SMTP settings', () {
    expect(
      () => verificationCodeSenderFor('staging', (_) => null),
      throwsStateError,
    );
    expect(
      verificationCodeSenderFor('staging', (k) => full()[k]),
      isA<SmtpCodeSender>(),
    );
    expect(
      verificationCodeSenderFor('development', (_) => null),
      isA<DevelopmentCodeSender>(),
    );
  });

  test('the email holds the code in three languages and nothing else '
      'personal', () {
    final m = signInCodeMessage(
      from: 'info@example.org',
      to: 'user@example.org',
      code: '123456',
    );
    expect(m.subject, 'Parla: 123456');
    expect(m.text, contains('Parla-ya giriş kodunuz: 123456'));
    expect(m.text, contains('Ваш код для входа в Parla: 123456'));
    expect(m.text, contains('Your Parla sign-in code: 123456'));
    expect(m.text, isNot(contains('user@example.org')));
  });
}
