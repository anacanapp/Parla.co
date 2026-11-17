import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../consent/consent_endpoint.dart';
import '../generated/protocol.dart';
import 'activity.dart' as activity;

/// The app reports once a day that it was opened, for the anonymous daily
/// active count. Counted only with the analytics consent. Nothing but a
/// keyed hash is stored, and only until the nightly total is made.
class ActivityEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<void> markActive(Session session) async {
    final userId = session.authenticated!.authUserId;
    if (!await hasConsent(session, userId, ConsentType.analytics)) return;
    await activity.markActive(session, userId);
  }
}
