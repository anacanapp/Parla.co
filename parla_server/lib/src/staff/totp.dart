import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// Time-based one-time passwords (RFC 6238) as used by authenticator apps:
/// HMAC-SHA1, 6 digits, 30-second steps.
abstract final class Totp {
  static const digits = 6;
  static const stepSeconds = 30;

  /// Steps either side of now that are still accepted (clock drift).
  static const window = 1;

  /// A new random 160-bit secret.
  static List<int> newSecret([Random? random]) {
    final r = random ?? Random.secure();
    return List.generate(20, (_) => r.nextInt(256));
  }

  static int stepAt(DateTime time) =>
      time.toUtc().millisecondsSinceEpoch ~/ 1000 ~/ stepSeconds;

  /// The code for [step] (RFC 4226 HOTP with the step as counter).
  static Future<String> code(List<int> secret, int step) async {
    final counter = ByteData(8)..setInt64(0, step);
    final mac = await Hmac.sha1().calculateMac(
      counter.buffer.asUint8List(),
      secretKey: SecretKey(secret),
    );
    final h = mac.bytes;
    final offset = h.last & 0x0f;
    final binary =
        ((h[offset] & 0x7f) << 24) |
        (h[offset + 1] << 16) |
        (h[offset + 2] << 8) |
        h[offset + 3];
    return (binary % pow(10, digits).toInt()).toString().padLeft(digits, '0');
  }

  /// The step [input] is valid for around [now], or `null`. Steps at or
  /// before [lastStep] are refused so a code cannot be used twice.
  static Future<int?> verify(
    List<int> secret,
    String input,
    DateTime now, {
    int? lastStep,
  }) async {
    final clean = input.replaceAll(RegExp(r'\s'), '');
    if (!RegExp(r'^\d{6}$').hasMatch(clean)) return null;
    final current = stepAt(now);
    for (var step = current - window; step <= current + window; step++) {
      if (lastStep != null && step <= lastStep) continue;
      if (_equal(await code(secret, step), clean)) return step;
    }
    return null;
  }

  /// Base32 (RFC 4648, no padding), as authenticator apps expect.
  static String base32(List<int> bytes) {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    final out = StringBuffer();
    var buffer = 0;
    var bits = 0;
    for (final b in bytes) {
      buffer = (buffer << 8) | b;
      bits += 8;
      while (bits >= 5) {
        out.write(alphabet[(buffer >> (bits - 5)) & 31]);
        bits -= 5;
      }
    }
    if (bits > 0) out.write(alphabet[(buffer << (5 - bits)) & 31]);
    return out.toString();
  }

  /// Decodes [base32] (as written by [base32]).
  static List<int> fromBase32(String base32) {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    final out = <int>[];
    var buffer = 0;
    var bits = 0;
    for (final ch in base32.toUpperCase().split('')) {
      final v = alphabet.indexOf(ch);
      if (v < 0) continue;
      buffer = (buffer << 5) | v;
      bits += 5;
      if (bits >= 8) {
        out.add((buffer >> (bits - 8)) & 0xff);
        bits -= 8;
      }
    }
    return out;
  }

  /// The otpauth URI an authenticator app reads from a QR code.
  static String uri(String base32Secret, String account) =>
      'otpauth://totp/${Uri.encodeComponent('Parla Admin:$account')}'
      '?secret=$base32Secret&issuer=${Uri.encodeComponent('Parla Admin')}'
      '&algorithm=SHA1&digits=$digits&period=$stepSeconds';

  /// Constant-time comparison.
  static bool _equal(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}
