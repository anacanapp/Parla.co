import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

abstract final class PushErrors {
  static const invalid = 'push.invalid';
}

/// The app turns push notifications on or off for this phone.
class PushEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<void> register(Session session, String token, String platform) async {
    final clean = token.trim();
    if (clean.isEmpty ||
        clean.length > 4096 ||
        !const {'android', 'ios'}.contains(platform)) {
      throw ParlaException(code: PushErrors.invalid);
    }
    final userId = session.authenticated!.authUserId;
    final now = DateTime.now().toUtc();
    final existing = await DeviceToken.db.findFirstRow(
      session,
      where: (t) => t.token.equals(clean),
    );
    if (existing == null) {
      await DeviceToken.db.insertRow(
        session,
        DeviceToken(
          authUserId: userId,
          token: clean,
          platform: platform,
          createdAt: now,
          lastSeenAt: now,
        ),
      );
    } else {
      // A phone that changed accounts follows the new account.
      await DeviceToken.db.updateRow(
        session,
        existing.copyWith(authUserId: userId, lastSeenAt: now),
      );
    }
  }

  /// Notifications off, or signing out on this phone.
  Future<void> unregister(Session session, String token) async {
    await DeviceToken.db.deleteWhere(
      session,
      where: (t) =>
          t.token.equals(token.trim()) &
          t.authUserId.equals(session.authenticated!.authUserId),
    );
  }
}
