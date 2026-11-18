import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

/// A password sign-in session for [userId], as the email sign-in creates
/// it: a refresh token whose id is the session's `authId`. [at] is when the
/// sign-in happened (admin calls are accepted for 12 hours after it).
Future<String> signInSession(
  Session db,
  UuidValue userId, {
  DateTime? at,
}) async {
  final when = (at ?? DateTime.now()).toUtc();
  final token = await RefreshToken.db.insertRow(
    db,
    RefreshToken(
      authUserId: userId,
      scopeNames: {},
      method: 'test',
      fixedSecret: ByteData(16),
      rotatingSecretHash: 'test',
      lastUpdatedAt: when,
      createdAt: when,
    ),
  );
  return token.id!.toString();
}
