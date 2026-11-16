import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../consent/consent_endpoint.dart';
import '../generated/protocol.dart';
import '../health/health_store.dart';

/// Error codes returned by [NutritionEndpoint]. The app translates them.
abstract final class NutritionErrors {
  static const invalid = 'nutrition.invalid';
  static const healthConsentRequired = 'consent.health_required';
}

/// The user's daily plate entries (which food groups each day; no
/// calories or amounts), kept encrypted in `nutrition_record` and only with
/// a health consent whose text covers them
/// ([healthVersionsCoveringNutrition]).
///
/// Saves are not written to the audit log, like own routines.
class NutritionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The stored plate entries as JSON, or `null` when there are none or
  /// the covering health consent is not granted.
  Future<String?> myNutrition(Session session) async {
    final userId = session.authenticated!.authUserId;
    if (!await _covered(session, userId)) return null;
    return HealthStore.of(session).readNutrition(session, userId);
  }

  /// Replaces the stored plate entries with [json].
  Future<void> saveNutrition(Session session, String json) async {
    final userId = session.authenticated!.authUserId;
    if (!NutritionRules.isValid(json)) {
      throw ParlaException(code: NutritionErrors.invalid);
    }
    if (!await _covered(session, userId)) {
      throw ParlaException(code: NutritionErrors.healthConsentRequired);
    }
    await session.db.transaction(
      (transaction) => HealthStore.of(
        session,
      ).writeNutrition(session, userId, json, transaction: transaction),
    );
  }

  static Future<bool> _covered(Session session, UuidValue userId) async {
    final version = await grantedConsentVersion(
      session,
      userId,
      ConsentType.health,
    );
    return version != null && healthVersionsCoveringNutrition.contains(version);
  }
}
