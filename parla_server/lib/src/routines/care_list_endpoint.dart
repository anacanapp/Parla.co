import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../consent/consent_endpoint.dart';
import '../generated/protocol.dart';
import '../health/health_store.dart';

/// Error codes returned by [CareListEndpoint]. The app translates them.
abstract final class CareListErrors {
  static const invalid = 'care_list.invalid';
  static const healthConsentRequired = 'consent.health_required';
}

/// The user's product preferences, recently checked products and shopping
/// list ("Yoxla"), kept encrypted in `care_list_record` and only with a
/// health consent whose text covers them ([healthVersionsCoveringCareList]):
/// the shopping list is free text that may hold health details. The server
/// never reads the content beyond checking it against [CareListRules].
///
/// Saves are not written to the audit log, like own routines: the user
/// changes her own data often and nobody else can read it.
class CareListEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The stored care list as JSON, or `null` when there is none or the
  /// covering health consent is not granted.
  Future<String?> myCareList(Session session) async {
    final userId = session.authenticated!.authUserId;
    if (!await _covered(session, userId)) return null;
    return HealthStore.of(session).readCareList(session, userId);
  }

  /// Replaces the stored care list with [json].
  Future<void> saveCareList(Session session, String json) async {
    final userId = session.authenticated!.authUserId;
    if (!CareListRules.isValid(json)) {
      throw ParlaException(code: CareListErrors.invalid);
    }
    if (!await _covered(session, userId)) {
      throw ParlaException(code: CareListErrors.healthConsentRequired);
    }
    await session.db.transaction(
      (transaction) => HealthStore.of(
        session,
      ).writeCareList(session, userId, json, transaction: transaction),
    );
  }

  static Future<bool> _covered(Session session, UuidValue userId) async {
    final version = await grantedConsentVersion(
      session,
      userId,
      ConsentType.health,
    );
    return version != null && healthVersionsCoveringCareList.contains(version);
  }
}
