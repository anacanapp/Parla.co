import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../consent/consent_endpoint.dart';
import '../generated/protocol.dart';
import 'activity.dart' as activity;

/// Anonymous usage statistics from the app, only with the analytics
/// consent. The account is counted as active (a keyed hash, kept for
/// [UsageRules.markDays] days) and the report's counts are added to the
/// day's totals per country and platform; no row names the account.
class ActivityEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Older apps: marks the account as active today.
  Future<void> markActive(Session session) async {
    final userId = session.authenticated!.authUserId;
    if (!await hasConsent(session, userId, ConsentType.analytics)) return;
    await activity.markActive(session, userId);
  }

  /// Marks the account as active today and adds [report]'s counts. Returns
  /// whether they were counted (`false` without the analytics consent, so
  /// the app stops counting).
  Future<bool> report(Session session, UsageReport report) async {
    final userId = session.authenticated!.authUserId;
    if (!await hasConsent(session, userId, ConsentType.analytics)) {
      return false;
    }
    final platform = UsagePlatform.values.firstWhere(
      (p) => p.name == report.platform,
      orElse: () => UsagePlatform.other,
    );
    await activity.markActive(session, userId, platform: platform);
    final profile = await MemberProfile.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
    await activity.addUsage(
      session,
      country: profile?.countryCode ?? '--',
      platform: platform,
      counts: UsageRules.clean(report.counts),
    );
    return true;
  }
}
