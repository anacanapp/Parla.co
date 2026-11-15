import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../consent/consent_endpoint.dart';
import '../generated/protocol.dart';
import '../health/health_store.dart';

/// Error codes returned by [SportEndpoint]. The app translates them.
abstract final class SportErrors {
  static const invalid = 'sport.invalid';
  static const healthConsentRequired = 'consent.health_required';
}

/// The user's sport answers (goals, areas, pregnancy, injuries, a doctor's
/// limit) and the log of finished workouts, kept encrypted in
/// `sport_record` and only with a health consent whose text covers them
/// ([healthVersionsCoveringSport]). The server never reads the content
/// beyond checking it against [SportRules].
///
/// Saves are not written to the audit log, like own routines: the user
/// changes her own data often and nobody else can read it.
class SportEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The stored sport document as JSON, or `null` when there is none or
  /// the covering health consent is not granted.
  Future<String?> mySport(Session session) async {
    final userId = session.authenticated!.authUserId;
    if (!await _covered(session, userId)) return null;
    return HealthStore.of(session).readSport(session, userId);
  }

  /// Replaces the stored sport document with [json]. Log entries older
  /// than [SportRules.keepLogDays] are the app's to drop; the size limit
  /// keeps the document small.
  Future<void> saveSport(Session session, String json) async {
    final userId = session.authenticated!.authUserId;
    if (!SportRules.isValid(json)) {
      throw ParlaException(code: SportErrors.invalid);
    }
    if (!await _covered(session, userId)) {
      throw ParlaException(code: SportErrors.healthConsentRequired);
    }
    await session.db.transaction(
      (transaction) => HealthStore.of(
        session,
      ).writeSport(session, userId, json, transaction: transaction),
    );
  }

  static Future<bool> _covered(Session session, UuidValue userId) async {
    final version = await grantedConsentVersion(
      session,
      userId,
      ConsentType.health,
    );
    return version != null && healthVersionsCoveringSport.contains(version);
  }
}
