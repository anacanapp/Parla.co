import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';
import '../health/health_store.dart';
import 'erase_account.dart';

/// Export format version, written into every export.
const exportFormat = 'parla-export-v1';

/// The user's rights over their own data (privacy centre, M-27 to M-33).
class AccountEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Everything Parla stores about the caller, as JSON (GDPR Art. 15 and 20,
  /// checklist EXP-1). Health answers are decrypted for the export.
  ///
  /// The file is built on request and returned directly; it is never stored
  /// on the server.
  Future<String> exportMyData(Session session) async {
    final userId = session.authenticated!.authUserId;

    final profile = await MemberProfile.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    final emails = await EmailAccount.db.find(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    final consents = await ConsentRecord.db.find(
      session,
      where: (t) => t.authUserId.equals(userId),
      orderBy: (t) => t.createdAt,
    );
    final quiz = await QuizAnswer.db.find(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    final store = HealthStore.of(session);
    final health = await store.read(session, userId);
    final routines = await store.readRoutines(session, userId);
    final careList = await store.readCareList(session, userId);
    final sport = await store.readSport(session, userId);
    final nutrition = await store.readNutrition(session, userId);

    await writeAudit(
      session,
      actorId: userId,
      actorRole: AuditActor.user,
      action: 'account.exported',
      objectType: 'account',
    );

    return const JsonEncoder.withIndent('  ').convert({
      'format': exportFormat,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'account': {
        'id': userId.toString(),
        'emails': [for (final e in emails) e.email],
      },
      'profile': profile == null
          ? null
          : {
              'birthYear': profile.birthYear,
              'countryCode': profile.countryCode,
              'language': profile.language,
              'createdAt': profile.createdAt.toIso8601String(),
            },
      'consents': [
        for (final c in consents)
          {
            'type': c.consentType.name,
            'granted': c.granted,
            'textVersion': c.textVersion,
            'language': c.language,
            'source': c.source,
            'at': c.createdAt.toIso8601String(),
          },
      ],
      'quizAnswers': [
        for (final a in quiz)
          {
            'question': a.questionId,
            'options': a.optionIds,
            'contentVersion': a.contentVersion,
            'at': a.answeredAt.toIso8601String(),
          },
      ],
      'healthAnswers': [
        for (final a in health.values)
          {
            'question': a.questionId,
            'options': a.optionIds,
            'declined': a.declined,
          },
      ],
      'customRoutines': routines == null ? null : jsonDecode(routines),
      'careList': careList == null ? null : jsonDecode(careList),
      'sport': sport == null ? null : jsonDecode(sport),
      'nutrition': nutrition == null ? null : jsonDecode(nutrition),
    });
  }

  /// Deletes the caller's account (checklist DEL-1, DEL-2); see
  /// [eraseAccount].
  Future<void> deleteAccount(Session session) =>
      eraseAccount(session, session.authenticated!.authUserId);
}
