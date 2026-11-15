import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../consent/consent_endpoint.dart';
import '../generated/protocol.dart';
import '../health/health_store.dart';

/// Error codes returned by [RoutineEndpoint]. The app translates them.
abstract final class RoutineErrors {
  static const invalid = 'routines.invalid';
  static const healthConsentRequired = 'consent.health_required';
}

/// The user's own routines and their daily ticks, kept encrypted in
/// `custom_routine_record` and only with a health consent whose text covers
/// them ([healthVersionsCoveringOwnRoutines]): the names and steps are free
/// text that may hold health details. The server never reads
/// the content beyond checking it against [CustomRoutineRules].
///
/// Saves are not written to the audit log: the user changes her own data
/// many times a day (every tick), and nobody else can read it.
class RoutineEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The stored routines as JSON, or `null` when there are none or the
  /// health consent is not granted.
  Future<String?> myRoutines(Session session) async {
    final userId = session.authenticated!.authUserId;
    if (!await _covered(session, userId)) return null;
    return HealthStore.of(session).readRoutines(session, userId);
  }

  /// Replaces the stored routines with [json]. Ticks older than
  /// [CustomRoutineRules.keepTickDays] are dropped.
  Future<void> saveRoutines(Session session, String json) async {
    final userId = session.authenticated!.authUserId;
    if (!CustomRoutineRules.isValid(json)) {
      throw ParlaException(code: RoutineErrors.invalid);
    }
    if (!await _covered(session, userId)) {
      throw ParlaException(code: RoutineErrors.healthConsentRequired);
    }
    final pruned = CustomRoutineRules.pruneTicks(json, DateTime.now().toUtc());
    await session.db.transaction(
      (transaction) => HealthStore.of(
        session,
      ).writeRoutines(session, userId, pruned, transaction: transaction),
    );
  }

  static Future<bool> _covered(Session session, UuidValue userId) async {
    final version = await grantedConsentVersion(
      session,
      userId,
      ConsentType.health,
    );
    return version != null &&
        healthVersionsCoveringOwnRoutines.contains(version);
  }
}
