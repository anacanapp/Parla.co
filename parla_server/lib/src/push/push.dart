import 'dart:async';
import 'dart:convert';

import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'push_sender.dart';

/// Tokens unseen this long are deleted.
const tokenRetention = Duration(days: 90);

/// The service notice for a support reply, in the user's language. It says
/// only that there is a reply, never what it says.
PushMessage supportReplyNotice(String language) => switch (language) {
  'ru' => const PushMessage(
    title: 'Parla',
    body: 'Команда Parla ответила на твоё сообщение.',
    link: 'messages',
  ),
  'en' => const PushMessage(
    title: 'Parla',
    body: 'The Parla team replied to your message.',
    link: 'messages',
  ),
  _ => const PushMessage(
    title: 'Parla',
    body: 'Parla komandası mesajına cavab verdi.',
    link: 'messages',
  ),
};

/// Sends [message] to every token of [userId]; removes tokens FCM reports
/// gone. Returns how many were sent.
Future<int> pushToUser(
  Session session,
  UuidValue userId,
  PushMessage message,
) async {
  final tokens = await DeviceToken.db.find(
    session,
    where: (t) => t.authUserId.equals(userId),
  );
  var sent = 0;
  for (final t in tokens) {
    final result = await Push.sender.send(t.token, message);
    if (result == PushResult.sent) sent++;
    if (result == PushResult.gone) await DeviceToken.db.deleteRow(session, t);
  }
  return sent;
}

/// Queues a published push campaign; [runPushJobs] sends it in the
/// background. Sending is publishing and happens once, so a second call
/// for the same item does nothing.
Future<void> queuePushCampaign(Session session, int contentId) async {
  final existing = await PushJob.db.findFirstRow(
    session,
    where: (t) => t.contentId.equals(contentId),
  );
  if (existing != null) return;
  await PushJob.db.insertRow(
    session,
    PushJob(
      contentId: contentId,
      status: PushJobs.queued,
      sent: 0,
      createdAt: DateTime.now().toUtc(),
    ),
  );
  if (PushJobs.kickOnQueue) unawaited(PushJobs.kick(session.serverpod));
}

/// Background sending of push campaigns.
abstract final class PushJobs {
  static const queued = 'queued';
  static const sending = 'sending';
  static const done = 'done';
  static const stopped = 'stopped';

  /// Accounts per batch, and FCM requests at a time within a batch.
  static int batchSize = 500;
  static int parallel = 20;

  /// How long one instance holds a job before another may take it over.
  static const lease = Duration(minutes: 2);

  /// Start sending right after a campaign is queued (off in tests, which
  /// call [runPushJobs] themselves).
  static bool kickOnQueue = true;

  static bool _running = false;

  /// Runs [runPushJobs] in a fresh session unless a run is going on.
  static Future<void> kick(Serverpod pod) async {
    if (_running) return;
    _running = true;
    final session = await pod.createSession(enableLogging: true);
    try {
      await runPushJobs(session);
    } on Object catch (error, stackTrace) {
      session.log(
        'Push jobs failed',
        level: LogLevel.error,
        exception: error,
        stackTrace: stackTrace,
      );
    } finally {
      _running = false;
      await session.close();
    }
  }

  /// Picks up queued or interrupted campaigns every [every] (after a
  /// restart too).
  static Timer schedule(
    Serverpod pod, {
    Duration every = const Duration(seconds: 30),
  }) => Timer.periodic(every, (_) => kick(pod));
}

/// Sends every queued or interrupted campaign to the end, batch by batch.
/// Returns how many phones were reached in this run.
Future<int> runPushJobs(Session session) async {
  var total = 0;
  while (true) {
    final job = await _claim(session);
    if (job == null) return total;
    total += await _sendJob(session, job);
  }
}

/// Takes the oldest open job whose lease has run out, or `null`.
Future<PushJob?> _claim(Session session) async {
  final now = DateTime.now().toUtc();
  final open = await PushJob.db.find(
    session,
    where: (t) =>
        t.status.inSet({PushJobs.queued, PushJobs.sending}) &
        (t.leaseUntil.equals(null) | (t.leaseUntil < now)),
    orderBy: (t) => t.id,
    limit: 1,
  );
  if (open.isEmpty) return null;
  // Claim it only if nobody else did in the meantime.
  final claimed = await session.db.unsafeQuery(
    'UPDATE "push_job" SET "leaseUntil" = @lease, "status" = @sending '
    'WHERE "id" = @id AND ("leaseUntil" IS NULL OR "leaseUntil" < @now) '
    'RETURNING "id"',
    parameters: QueryParameters.named({
      'lease': now.add(PushJobs.lease),
      'sending': PushJobs.sending,
      'id': open.first.id,
      'now': now,
    }),
  );
  if (claimed.isEmpty) return null;
  return PushJob.db.findById(session, open.first.id!);
}

Future<int> _sendJob(Session session, PushJob job) async {
  final item = await ContentItem.db.findById(session, job.contentId);
  final json = item?.publishedJson;
  if (item == null || json == null) {
    await PushJob.db.updateRow(
      session,
      job.copyWith(
        status: PushJobs.stopped,
        leaseUntil: null,
        finishedAt: DateTime.now().toUtc(),
      ),
    );
    return 0;
  }
  final campaign = (jsonDecode(json) as Map).cast<String, Object?>();
  var current = job;
  var reached = 0;
  while (true) {
    final users = await _nextUsers(session, current.cursor);
    final sent = users.isEmpty ? 0 : await _sendBatch(session, users, campaign);
    reached += sent;
    final last = users.length < PushJobs.batchSize;
    current = await PushJob.db.updateRow(
      session,
      current.copyWith(
        sent: current.sent + sent,
        cursor: users.isEmpty ? current.cursor : users.last,
        status: last ? PushJobs.done : PushJobs.sending,
        leaseUntil: last ? null : DateTime.now().toUtc().add(PushJobs.lease),
        finishedAt: last ? DateTime.now().toUtc() : null,
      ),
    );
    if (last) {
      session.log(
        'Push campaign ${job.contentId} sent to ${current.sent} phones.',
      );
      return reached;
    }
  }
}

/// The next accounts with a phone token, in id order after [cursor].
Future<List<UuidValue>> _nextUsers(Session session, UuidValue? cursor) async {
  final rows = await session.db.unsafeQuery(
    'SELECT DISTINCT "authUserId" FROM "device_token" '
    'WHERE @cursor::uuid IS NULL OR "authUserId" > @cursor::uuid '
    'ORDER BY "authUserId" LIMIT @limit',
    parameters: QueryParameters.named({
      'cursor': cursor?.toString(),
      'limit': PushJobs.batchSize,
    }),
  );
  return [for (final r in rows) UuidValue.fromString(r.first.toString())];
}

/// Sends [campaign] to those of [users] who currently grant the marketing
/// consent and match its languages and countries (never chosen by health or
/// quiz answers). Returns how many phones got it.
Future<int> _sendBatch(
  Session session,
  List<UuidValue> users,
  Map<String, Object?> campaign,
) async {
  final languages =
      (campaign['languages'] as List?)?.cast<String>() ?? const [];
  final countries =
      (campaign['countries'] as List?)?.cast<String>() ?? const [];
  final ids = users.toSet();
  final profiles = {
    for (final p in await MemberProfile.db.find(
      session,
      where: (t) => t.authUserId.inSet(ids),
    ))
      p.authUserId: p,
  };
  // The newest marketing decision per account, checked right before
  // sending, so a consent withdrawn while a campaign runs is respected.
  final consented = <UuidValue>{};
  final seen = <UuidValue>{};
  for (final r in await ConsentRecord.db.find(
    session,
    where: (t) =>
        t.authUserId.inSet(ids) & t.consentType.equals(ConsentType.marketing),
    orderByList: (t) => [t.createdAt.desc(), t.id.desc()],
  )) {
    if (seen.add(r.authUserId) && r.granted) consented.add(r.authUserId);
  }
  final targets = <(UuidValue, PushMessage)>[];
  for (final userId in users) {
    final profile = profiles[userId];
    if (profile == null || !consented.contains(userId)) continue;
    if (languages.isNotEmpty && !languages.contains(profile.language)) continue;
    if (countries.isNotEmpty && !countries.contains(profile.countryCode)) {
      continue;
    }
    final lang = profile.language;
    targets.add((
      userId,
      PushMessage(
        title: ContentRules.pick(campaign['title'], lang),
        body: ContentRules.pick(campaign['body'], lang),
        link: campaign['link'] as String?,
      ),
    ));
  }
  var sent = 0;
  for (var i = 0; i < targets.length; i += PushJobs.parallel) {
    final chunk = targets.skip(i).take(PushJobs.parallel);
    final counts = await Future.wait([
      for (final (userId, message) in chunk)
        pushToUser(session, userId, message),
    ]);
    sent += counts.fold(0, (a, b) => a + b);
  }
  return sent;
}

/// Deletes tokens not seen for [tokenRetention].
Future<int> expireTokens(Session session, {DateTime? now}) async {
  final cutoff = (now ?? DateTime.now()).toUtc().subtract(tokenRetention);
  final gone = await DeviceToken.db.deleteWhere(
    session,
    where: (t) => t.lastSeenAt < cutoff,
  );
  return gone.length;
}
