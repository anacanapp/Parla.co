import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import '../stats/activity.dart' show dayOf;

/// The website's statistics (owner, 2026-11-27: detailed, with daily
/// unique visitors). Only daily totals are kept: no cookie, no stored IP
/// address and no identifier. A visitor is counted once a day with an
/// HMAC of the address and browser under that day's random salt; the
/// marks and the salt are deleted the next day ([expireSiteMarks]).
abstract final class SiteStats {
  /// The metrics, as stored in `site_stat_daily.metric`.
  static const view = 'view';
  static const visitors = 'visitors';
  static const language = 'language';
  static const referrer = 'referrer';
  static const campaign = 'campaign';
  static const device = 'device';
  static const browser = 'browser';
  static const os = 'os';
  static const click = 'click';
  static const depth = 'depth';

  static const metrics = [
    view,
    visitors,
    language,
    referrer,
    campaign,
    device,
    browser,
    os,
    click,
    depth,
  ];

  /// Buttons the page reports clicks on (`data-track`).
  static const clicks = {
    'appstore',
    'googleplay',
    'nav-features',
    'nav-privacy',
    'nav-blog',
    'blog-card',
    'blog-all',
    'lang-az',
    'lang-ru',
    'lang-en',
    'legal-privacy',
    'legal-terms',
  };

  /// Reading depths the page reports, in percent.
  static const depths = {'25', '50', '75', '100'};

  static final _bot = RegExp(
    r'bot|crawl|spider|slurp|preview|monitor|curl|wget|python|java/|'
    r'headless|lighthouse|facebookexternalhit|scan|http-client|okhttp|go-http',
    caseSensitive: false,
  );

  /// Whether [userAgent] is a robot (not counted).
  static bool isBot(String? userAgent) =>
      userAgent == null || userAgent.trim().isEmpty || _bot.hasMatch(userAgent);

  /// mobile, tablet or desktop.
  static String deviceOf(String ua) {
    if (RegExp('ipad|tablet', caseSensitive: false).hasMatch(ua) ||
        (RegExp('android', caseSensitive: false).hasMatch(ua) &&
            !RegExp('mobile', caseSensitive: false).hasMatch(ua))) {
      return 'tablet';
    }
    if (RegExp('mobi|iphone|android', caseSensitive: false).hasMatch(ua)) {
      return 'mobile';
    }
    return 'desktop';
  }

  /// The browser family, without its version.
  static String browserOf(String ua) {
    final l = ua.toLowerCase();
    if (l.contains('samsungbrowser')) return 'samsung';
    if (l.contains('yabrowser')) return 'yandex';
    if (l.contains('opr/') || l.contains('opera')) return 'opera';
    if (l.contains('edg/') || l.contains('edga/') || l.contains('edgios/')) {
      return 'edge';
    }
    if (l.contains('firefox/') || l.contains('fxios/')) return 'firefox';
    if (l.contains('chrome/') || l.contains('crios/')) return 'chrome';
    if (l.contains('safari/')) return 'safari';
    return 'other';
  }

  /// The operating system family, without its version.
  static String osOf(String ua) {
    final l = ua.toLowerCase();
    if (l.contains('iphone') || l.contains('ipad') || l.contains('ipod')) {
      return 'ios';
    }
    if (l.contains('android')) return 'android';
    if (l.contains('windows')) return 'windows';
    if (l.contains('mac os') || l.contains('macintosh')) return 'macos';
    if (l.contains('linux') || l.contains('cros')) return 'linux';
    return 'other';
  }

  /// The referring site's host (no path, query or `www.`), `direct`
  /// without one, or `null` for a link from the site itself.
  static String? referrerOf(String? header, String ownHost) {
    if (header == null || header.isEmpty) return 'direct';
    final uri = Uri.tryParse(header);
    final host = uri?.host.toLowerCase();
    if (host == null || host.isEmpty) return 'direct';
    if (host == ownHost.toLowerCase()) return null;
    final clean = host.startsWith('www.') ? host.substring(4) : host;
    return _short(clean, 80);
  }

  /// `source / medium / campaign` from the page's `utm_` parameters, or
  /// `null` without them.
  static String? campaignOf(Map<String, String> query) {
    String part(String key) {
      final v = (query['utm_$key'] ?? '').toLowerCase();
      return v.replaceAll(RegExp(r'[^a-z0-9._\-]'), '');
    }

    final source = part('source');
    final medium = part('medium');
    final name = part('campaign');
    if (source.isEmpty && medium.isEmpty && name.isEmpty) return null;
    return _short(
      '${_or(source)} / ${_or(medium)} / ${_or(name)}',
      120,
    );
  }

  static String _or(String v) => v.isEmpty ? '-' : _short(v, 40);

  static String _short(String v, int max) =>
      v.length <= max ? v : v.substring(0, max);

  /// The client's address behind the load balancer: the last address it
  /// appended to `X-Forwarded-For`, else the connection's.
  static String clientAddress(String? forwardedFor, String? remote) {
    final parts = (forwardedFor ?? '')
        .split(',')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
    return parts.isNotEmpty ? parts.last : (remote ?? '');
  }

  /// Counts one page view of [page] in [language] (see [record]).
  static Future<void> recordView(
    Session session, {
    required String page,
    required String language,
    required String userAgent,
    required String address,
    String? referrer,
    String? campaign,
    DateTime? now,
  }) async {
    final day = dayOf(now ?? DateTime.now());
    final counts = <(String, String)>[
      (view, page),
      (SiteStats.language, language),
      (device, deviceOf(userAgent)),
      (browser, browserOf(userAgent)),
      (os, osOf(userAgent)),
      if (referrer != null) (SiteStats.referrer, referrer),
      if (campaign != null) (SiteStats.campaign, campaign),
    ];
    if (await _isNewVisitor(session, day, address, userAgent)) {
      counts.add((visitors, 'all'));
    }
    await add(session, day, counts);
  }

  /// Counts a reported [kind] (`click` or `depth`) with [key] on [page];
  /// anything not on the lists is ignored. Returns whether it counted.
  static Future<bool> recordEvent(
    Session session, {
    required String kind,
    required String key,
    required String page,
    DateTime? now,
  }) async {
    final day = dayOf(now ?? DateTime.now());
    if (kind == click && clicks.contains(key)) {
      await add(session, day, [(click, key)]);
      return true;
    }
    if (kind == depth && depths.contains(key)) {
      await add(session, day, [(depth, '$page|$key')]);
      return true;
    }
    return false;
  }

  /// Adds one to each (metric, target) of [day].
  static Future<void> add(
    Session session,
    String day,
    List<(String, String)> counts,
  ) async {
    await session.db.transaction((transaction) async {
      for (final (metric, target) in counts) {
        await session.db.unsafeExecute(
          'INSERT INTO "site_stat_daily" ("day", "metric", "target", "times") '
          'VALUES (@day, @metric, @target, 1) '
          'ON CONFLICT ("day", "metric", "target") '
          'DO UPDATE SET "times" = "site_stat_daily"."times" + 1',
          parameters: QueryParameters.named({
            'day': day,
            'metric': metric,
            'target': target,
          }),
          transaction: transaction,
        );
      }
    });
  }

  static Future<bool> _isNewVisitor(
    Session session,
    String day,
    String address,
    String userAgent,
  ) async {
    final salt = await _salt(session, day);
    final mark = Hmac(
      sha256,
      base64.decode(salt),
    ).convert(utf8.encode('$address|$userAgent')).toString();
    final inserted = await session.db.unsafeExecute(
      'INSERT INTO "site_visitor_mark" ("day", "mark") VALUES (@day, @mark) '
      'ON CONFLICT ("day", "mark") DO NOTHING',
      parameters: QueryParameters.named({'day': day, 'mark': mark}),
    );
    return inserted == 1;
  }

  static Future<String> _salt(Session session, String day) async {
    final found = await SiteSalt.db.findFirstRow(
      session,
      where: (t) => t.day.equals(day),
    );
    if (found != null) return found.salt;
    final random = Random.secure();
    final salt = base64.encode([
      for (var i = 0; i < 32; i++) random.nextInt(256),
    ]);
    await session.db.unsafeExecute(
      'INSERT INTO "site_salt" ("day", "salt") VALUES (@day, @salt) '
      'ON CONFLICT ("day") DO NOTHING',
      parameters: QueryParameters.named({'day': day, 'salt': salt}),
    );
    // A parallel request may have stored its salt first: use that one.
    final stored = await SiteSalt.db.findFirstRow(
      session,
      where: (t) => t.day.equals(day),
    );
    return stored!.salt;
  }
}

/// Deletes the visitor marks and salts of the days before today, and
/// website totals older than [UsageRules.keepMonths]. Returns how many
/// marks were deleted.
Future<int> expireSiteMarks(Session session, {DateTime? now}) async {
  final time = (now ?? DateTime.now()).toUtc();
  final today = dayOf(time);
  final marks = await SiteVisitorMark.db.deleteWhere(
    session,
    where: (t) => t.day < today,
  );
  await SiteSalt.db.deleteWhere(session, where: (t) => t.day < today);
  final oldest = dayOf(
    DateTime.utc(time.year, time.month - UsageRules.keepMonths, time.day),
  );
  await SiteStatDaily.db.deleteWhere(session, where: (t) => t.day < oldest);
  return marks.length;
}
