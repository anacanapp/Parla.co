import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:serverpod/serverpod.dart';

/// Replaces a deleted user's id in records that must outlive the account
/// (consent proof, audit log).
///
/// HMAC-SHA256 of the user id with the `pseudonymPepper` secret, shaped as a
/// UUID. Without the pepper the pseudonym cannot be linked back to the user;
/// with it (and the original id, for example from a legal request) the
/// records can still be found.
Future<UuidValue> pseudonymFor(Session session, UuidValue userId) =>
    pseudonymWithPepper(session.passwords['pseudonymPepper'], userId);

Future<UuidValue> pseudonymWithPepper(String? pepper, UuidValue userId) async {
  if (pepper == null || pepper.isEmpty) {
    throw StateError(
      'Missing password "pseudonymPepper". Run tool/create_local_passwords.sh '
      'or set SERVERPOD_PASSWORD_pseudonymPepper.',
    );
  }
  final mac = await Hmac.sha256().calculateMac(
    utf8.encode(userId.toString()),
    secretKey: SecretKey(utf8.encode(pepper)),
  );
  final bytes = mac.bytes.sublist(0, 16);
  // Mark as a version 4, RFC 4122 variant UUID so it parses everywhere.
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return UuidValue.fromString(
    '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-'
    '${hex.substring(16, 20)}-${hex.substring(20)}',
  );
}
