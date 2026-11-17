import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../consent/consent_endpoint.dart';
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

/// Sends a published push campaign: only to accounts that currently grant
/// the marketing consent, filtered by the profile's language and country
/// (never by health or quiz answers). Returns how many phones got it.
Future<int> sendPushCampaign(
  Session session,
  Map<String, Object?> json,
) async {
  final languages = (json['languages'] as List?)?.cast<String>() ?? const [];
  final countries = (json['countries'] as List?)?.cast<String>() ?? const [];
  final tokens = await DeviceToken.db.find(session);
  final users = {for (final t in tokens) t.authUserId};
  if (users.isEmpty) return 0;
  final profiles = {
    for (final p in await MemberProfile.db.find(
      session,
      where: (t) => t.authUserId.inSet(users),
    ))
      p.authUserId: p,
  };
  var sent = 0;
  for (final userId in users) {
    final profile = profiles[userId];
    if (profile == null) continue;
    if (languages.isNotEmpty && !languages.contains(profile.language)) continue;
    if (countries.isNotEmpty && !countries.contains(profile.countryCode)) {
      continue;
    }
    if (!await hasConsent(session, userId, ConsentType.marketing)) continue;
    final lang = profile.language;
    sent += await pushToUser(
      session,
      userId,
      PushMessage(
        title: ContentRules.pick(json['title'], lang),
        body: ContentRules.pick(json['body'], lang),
        link: json['link'] as String?,
      ),
    );
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
