import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';

/// Error codes returned by [ConsentEndpoint]. The app translates them.
abstract final class ConsentErrors {
  static const unknownVersion = 'consent.unknown_version';
  static const outdatedVersion = 'consent.outdated_version';
  static const languageUnsupported = 'language.unsupported';
  static const sourceUnsupported = 'consent.source_unsupported';
}

/// Where a consent decision can be made.
const consentSources = {'app', 'web'};

/// Grants and withdraws the three consents (screens M-08, M-28).
///
/// Every decision is a new [ConsentRecord] row; nothing is updated in place.
class ConsentEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The latest decision for every consent type. Defaults to not granted
  /// (checklist CON-1).
  Future<List<ConsentState>> current(Session session) async {
    final userId = session.authenticated!.authUserId;
    return currentConsents(session, userId);
  }

  /// Records a decision for [consentType] about the text [textVersion] that
  /// the user saw in [language].
  ///
  /// Granting is only possible for the current text version. Withdrawing is
  /// always possible.
  Future<ConsentState> decide(
    Session session, {
    required ConsentType consentType,
    required bool granted,
    required String textVersion,
    required String language,
    required String source,
  }) async {
    final userId = session.authenticated!.authUserId;
    final kind = ConsentKind.values.byName(consentType.name);

    final text = consentTextByVersion(kind, textVersion);
    if (text == null) {
      throw ParlaException(code: ConsentErrors.unknownVersion);
    }
    if (granted && text.version != currentConsentText(kind).version) {
      throw ParlaException(code: ConsentErrors.outdatedVersion);
    }
    final hash = text.hashFor(language);
    if (hash == null || !supportedLanguages.contains(language)) {
      throw ParlaException(code: ConsentErrors.languageUnsupported);
    }
    if (!consentSources.contains(source)) {
      throw ParlaException(code: ConsentErrors.sourceUnsupported);
    }

    return session.db.transaction((transaction) async {
      final record = await ConsentRecord.db.insertRow(
        session,
        ConsentRecord(
          authUserId: userId,
          consentType: consentType,
          granted: granted,
          textVersion: text.version,
          textHash: hash,
          language: language,
          source: source,
          createdAt: DateTime.now().toUtc(),
        ),
        transaction: transaction,
      );
      await writeAudit(
        session,
        actorId: userId,
        actorRole: AuditActor.user,
        action: granted ? 'consent.granted' : 'consent.withdrawn',
        objectType: 'consent_record',
        objectId: record.id.toString(),
        transaction: transaction,
      );
      // No health data tables exist yet. When they are added, withdrawing
      // the health consent must delete them in this transaction (CON-6).
      return ConsentState(
        consentType: record.consentType,
        granted: record.granted,
        textVersion: record.textVersion,
        updatedAt: record.createdAt,
      );
    });
  }
}

/// Latest decision per consent type for [userId].
Future<List<ConsentState>> currentConsents(
  Session session,
  UuidValue userId,
) async {
  final records = await ConsentRecord.db.find(
    session,
    where: (t) => t.authUserId.equals(userId),
    // Newest first; id breaks ties between decisions in the same instant.
    orderByList: (t) => [
      t.createdAt.desc(),
      t.id.desc(),
    ],
  );
  return [
    for (final type in ConsentType.values)
      _stateFor(type, records.where((r) => r.consentType == type).firstOrNull),
  ];
}

ConsentState _stateFor(ConsentType type, ConsentRecord? latest) => ConsentState(
  consentType: type,
  granted: latest?.granted ?? false,
  textVersion: latest?.textVersion,
  updatedAt: latest?.createdAt,
);

/// Whether [userId] currently grants [type]. Server-side guard for any
/// endpoint that stores consent-based data (checklist CON-2).
Future<bool> hasConsent(
  Session session,
  UuidValue userId,
  ConsentType type,
) async {
  final latest = await ConsentRecord.db.findFirstRow(
    session,
    where: (t) => t.authUserId.equals(userId) & t.consentType.equals(type),
    // Newest first; id breaks ties between decisions in the same instant.
    orderByList: (t) => [
      t.createdAt.desc(),
      t.id.desc(),
    ],
  );
  return latest?.granted ?? false;
}
