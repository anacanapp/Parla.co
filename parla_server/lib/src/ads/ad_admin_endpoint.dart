import 'dart:convert';

import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';
import '../staff/staff_guard.dart';
import '../stats/activity.dart' show dayOf;
import '../stats/stats_admin_endpoint.dart' show minGroupSize;

/// Error codes of the ads section. The panel translates them.
abstract final class AdErrors {
  static const notFound = 'ads.not_found';
  static const invalid = 'ads.invalid';
  static const nameTaken = 'ads.name_taken';

  /// The advertiser still has campaigns, or the campaign still has banners.
  static const inUse = 'ads.in_use';
}

const _admins = {StaffRole.admin};

/// Advertisers, their campaigns and the campaign reports (admins only).
/// Contracts hold company facts only (no contact person). Reports are
/// totals over users with the analytics consent; counts under
/// [minGroupSize] are hidden. Every change and every report is audited.
class AdAdminEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<List<Advertiser>> advertisers(Session session) async {
    await requireStaff(session, roles: _admins);
    return Advertiser.db.find(session, orderBy: (t) => t.company);
  }

  /// Adds an advertiser (no id) or changes one.
  Future<Advertiser> saveAdvertiser(Session session, Advertiser input) async {
    final staff = await requireStaff(session, roles: _admins);
    final clean = cleanAdvertiser(input);
    final now = DateTime.now().toUtc();
    final same = await Advertiser.db.findFirstRow(
      session,
      where: (t) => t.company.ilike(_likeEscape(clean.company)),
    );
    if (same != null && same.id != input.id) {
      throw ParlaException(code: AdErrors.nameTaken);
    }
    final Advertiser saved;
    if (input.id == null) {
      saved = await Advertiser.db.insertRow(
        session,
        clean.copyWith(createdAt: now, updatedAt: now),
      );
    } else {
      final old = await Advertiser.db.findById(session, input.id!);
      if (old == null) throw ParlaException(code: AdErrors.notFound);
      saved = await Advertiser.db.updateRow(
        session,
        clean.copyWith(id: old.id, createdAt: old.createdAt, updatedAt: now),
      );
    }
    await _audit(
      session,
      staff,
      'ads.advertiser_saved',
      'advertiser',
      saved.id,
    );
    return saved;
  }

  /// Deletes an advertiser that has no campaigns.
  Future<void> deleteAdvertiser(Session session, int id) async {
    final staff = await requireStaff(session, roles: _admins);
    final row = await Advertiser.db.findById(session, id);
    if (row == null) throw ParlaException(code: AdErrors.notFound);
    final campaigns = await AdCampaign.db.count(
      session,
      where: (t) => t.advertiserId.equals(id),
    );
    if (campaigns > 0) throw ParlaException(code: AdErrors.inUse);
    await Advertiser.db.deleteRow(session, row);
    await _audit(session, staff, 'ads.advertiser_deleted', 'advertiser', id);
  }

  Future<List<AdCampaign>> campaigns(Session session) async {
    await requireStaff(session, roles: _admins);
    return AdCampaign.db.find(
      session,
      orderByList: (t) => [t.startsOn.desc(), t.title],
    );
  }

  /// Adds a campaign (no id) or changes one. Its banners must still fit
  /// the new dates.
  Future<AdCampaign> saveCampaign(Session session, AdCampaign input) async {
    final staff = await requireStaff(session, roles: _admins);
    final clean = cleanCampaign(input);
    if (await Advertiser.db.findById(session, clean.advertiserId) == null) {
      throw ParlaException(code: AdErrors.notFound);
    }
    final now = DateTime.now().toUtc();
    final AdCampaign saved;
    if (input.id == null) {
      saved = await AdCampaign.db.insertRow(
        session,
        clean.copyWith(createdAt: now, updatedAt: now),
      );
    } else {
      final old = await AdCampaign.db.findById(session, input.id!);
      if (old == null) throw ParlaException(code: AdErrors.notFound);
      for (final b in await campaignBanners(session, old.id!)) {
        for (final json in [b.draftJson, b.publishedJson]) {
          if (json != null && !bannerInsideCampaign(_decode(json), clean)) {
            throw ParlaException(code: AdErrors.inUse);
          }
        }
      }
      saved = await AdCampaign.db.updateRow(
        session,
        clean.copyWith(id: old.id, createdAt: old.createdAt, updatedAt: now),
      );
    }
    await _audit(session, staff, 'ads.campaign_saved', 'ad_campaign', saved.id);
    return saved;
  }

  /// Deletes a campaign that no banner names.
  Future<void> deleteCampaign(Session session, int id) async {
    final staff = await requireStaff(session, roles: _admins);
    final row = await AdCampaign.db.findById(session, id);
    if (row == null) throw ParlaException(code: AdErrors.notFound);
    if ((await campaignBanners(session, id)).isNotEmpty) {
      throw ParlaException(code: AdErrors.inUse);
    }
    await AdCampaign.db.deleteRow(session, row);
    await _audit(session, staff, 'ads.campaign_deleted', 'ad_campaign', id);
  }

  /// The campaigns a banner may join, for the banner editor (writers and
  /// the reviewing expert see which brand a banner belongs to).
  Future<List<AdCampaignOption>> campaignOptions(Session session) async {
    await requireStaff(session);
    final campaigns = await AdCampaign.db.find(
      session,
      orderByList: (t) => [t.startsOn.desc(), t.title],
    );
    final advertisers = {
      for (final a in await Advertiser.db.find(session)) a.id: a.company,
    };
    return [
      for (final c in campaigns)
        AdCampaignOption(
          id: c.id!,
          title: c.title,
          advertiser: advertisers[c.advertiserId] ?? '',
          startsOn: c.startsOn,
          endsOn: c.endsOn,
        ),
    ];
  }

  /// The campaign's views and taps by day and by banner.
  Future<AdReport> report(Session session, int campaignId) async {
    final staff = await requireStaff(session, roles: _admins);
    final result = await buildAdReport(session, campaignId);
    await _audit(
      session,
      staff,
      'ads.report_viewed',
      'ad_campaign',
      campaignId,
    );
    return result;
  }

  Future<void> _audit(
    Session session,
    StaffMember staff,
    String action,
    String type,
    int? id,
  ) => writeAudit(
    session,
    actorId: staff.authUserId,
    actorRole: AuditActor.staff,
    action: action,
    objectType: type,
    objectId: id?.toString(),
  );
}

final _day = RegExp(r'^\d{4}-\d{2}-\d{2}$');
final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

String? _optional(String? v, int max, {RegExp? pattern}) {
  final t = v?.trim() ?? '';
  if (t.isEmpty) return null;
  if (t.length > max || (pattern != null && !pattern.hasMatch(t))) {
    throw ParlaException(code: AdErrors.invalid);
  }
  return t;
}

String _required(String v, int max, {RegExp? pattern}) =>
    _optional(v, max, pattern: pattern) ??
    (throw ParlaException(code: AdErrors.invalid));

bool _validDay(String d) {
  if (!_day.hasMatch(d)) return false;
  final t = DateTime.tryParse(d);
  return t != null && dayOf(t) == d;
}

String? _dayOrNull(String? v) {
  final t = _optional(v, 10);
  if (t != null && !_validDay(t)) throw ParlaException(code: AdErrors.invalid);
  return t;
}

/// The advertiser with trimmed fields; throws on bad input.
Advertiser cleanAdvertiser(Advertiser a) {
  final start = _dayOrNull(a.contractStart);
  final end = _dayOrNull(a.contractEnd);
  if (start != null && end != null && end.compareTo(start) < 0) {
    throw ParlaException(code: AdErrors.invalid);
  }
  return a.copyWith(
    company: _required(a.company, 80),
    email: _optional(a.email, 120, pattern: _email)?.toLowerCase(),
    contractNumber: _optional(a.contractNumber, 60),
    contractStart: start,
    contractEnd: end,
    note: _optional(a.note, 500),
  );
}

/// The campaign with trimmed fields; throws on bad input.
AdCampaign cleanCampaign(AdCampaign c) {
  final starts = _required(c.startsOn, 10);
  final ends = _required(c.endsOn, 10);
  if (!_validDay(starts) || !_validDay(ends) || ends.compareTo(starts) < 0) {
    throw ParlaException(code: AdErrors.invalid);
  }
  return c.copyWith(
    title: _required(c.title, 80),
    startsOn: starts,
    endsOn: ends,
    priceNote: _optional(c.priceNote, 200),
  );
}

/// Whether the banner's dates lie inside the campaign's.
bool bannerInsideCampaign(Map<String, Object?> banner, AdCampaign c) {
  final starts = banner['startsOn'];
  final ends = banner['endsOn'];
  if (starts is String && starts.compareTo(c.startsOn) < 0) return false;
  if (ends is String && ends.compareTo(c.endsOn) > 0) return false;
  return true;
}

Map<String, Object?> _decode(String json) {
  try {
    final v = jsonDecode(json);
    return v is Map<String, Object?> ? v : const {};
  } on FormatException {
    return const {};
  }
}

String _likeEscape(String v) =>
    v.replaceAll(r'\', r'\\').replaceAll('%', r'\%').replaceAll('_', r'\_');

/// Banners and products whose draft or published copy names [campaignId].
Future<List<ContentItem>> campaignBanners(
  Session session,
  int campaignId,
) async {
  final rows = await ContentItem.db.find(
    session,
    where: (t) => t.kind.inSet({
      ContentKind.banner.name,
      ContentKind.product.name,
    }),
  );
  return [
    for (final r in rows)
      if (_decode(r.draftJson)['campaign'] == campaignId ||
          (r.publishedJson != null &&
              _decode(r.publishedJson!)['campaign'] == campaignId))
        r,
  ];
}

/// For a banner draft naming a campaign: checks that the campaign exists
/// and the banner's dates fit it, and writes the advertiser's name into
/// `sponsor` (so the "Ad · brand" label always matches the contract).
/// Other content is returned as it is.
Future<String> withCampaignSponsor(
  Session session,
  ContentKind kind,
  String json,
) async {
  if (kind != ContentKind.banner && kind != ContentKind.product) return json;
  final data = _decode(json);
  final id = data['campaign'];
  if (id == null) {
    // A product is an ad only through a campaign: no brand typed by hand.
    if (kind == ContentKind.product && data.containsKey('sponsor')) {
      return jsonEncode({...data}..remove('sponsor'));
    }
    return json;
  }
  if (id is! int) throw ParlaException(code: 'content.invalid');
  final campaign = await AdCampaign.db.findById(session, id);
  if (campaign == null) throw ParlaException(code: 'content.invalid');
  if (!bannerInsideCampaign(data, campaign)) {
    throw ParlaException(code: 'content.outside_campaign');
  }
  final advertiser = await Advertiser.db.findById(
    session,
    campaign.advertiserId,
  );
  if (advertiser == null) throw ParlaException(code: 'content.invalid');
  return jsonEncode({...data, 'sponsor': advertiser.company});
}

int? _safe(int n) => n < minGroupSize ? null : n;

String _bannerTitle(ContentItem b) {
  final json = _decode(b.publishedJson ?? b.draftJson);
  final title = ContentRules.pick(json['title'] ?? json['name'], 'az');
  final label = title.isEmpty ? b.slug : title;
  return b.kind == ContentKind.product.name ? 'Məhsul: $label' : label;
}

/// The report of [campaignId] up to [now] (today by default).
Future<AdReport> buildAdReport(
  Session session,
  int campaignId, {
  DateTime? now,
}) async {
  final campaign = await AdCampaign.db.findById(session, campaignId);
  if (campaign == null) throw ParlaException(code: AdErrors.notFound);
  final advertiser = await Advertiser.db.findById(
    session,
    campaign.advertiserId,
  );
  final today = dayOf(now ?? DateTime.now());
  final to = today.compareTo(campaign.endsOn) < 0 ? today : campaign.endsOn;
  final banners = await campaignBanners(session, campaignId);
  // Banners are counted by content id, products by slug.
  String key(ContentItem b) =>
      b.kind == ContentKind.product.name ? 'p:${b.slug}' : 'b:${b.id}';
  final bannerIds = {
    for (final b in banners)
      if (b.kind == ContentKind.banner.name) b.id.toString(),
  };
  final productSlugs = {
    for (final b in banners)
      if (b.kind == ContentKind.product.name) b.slug,
  };
  const viewEvents = {'bannerView', 'product'};
  final rows = banners.isEmpty || to.compareTo(campaign.startsOn) < 0
      ? <UsageDaily>[]
      : [
          for (final r in await UsageDaily.db.find(
            session,
            where: (t) =>
                (t.event.inSet({
                      UsageEvent.bannerView.name,
                      UsageEvent.bannerTap.name,
                    }) &
                    t.target.inSet(bannerIds.isEmpty ? {'-'} : bannerIds)) |
                (t.event.inSet({
                      UsageEvent.product.name,
                      UsageEvent.productTap.name,
                    }) &
                    t.target.inSet(
                      productSlugs.isEmpty ? {'-'} : productSlugs,
                    )),
          ))
            if (r.day.compareTo(campaign.startsOn) >= 0 &&
                r.day.compareTo(to) <= 0)
              r,
        ];
  final days = <String, (int, int)>{};
  if (to.compareTo(campaign.startsOn) >= 0) {
    var d = DateTime.parse(campaign.startsOn);
    while (dayOf(d).compareTo(to) <= 0) {
      days[dayOf(d)] = (0, 0);
      d = d.add(const Duration(days: 1));
    }
  }
  final byBanner = {for (final b in banners) key(b): (0, 0)};
  var views = 0;
  var taps = 0;
  (int, int) add((int, int) v, UsageDaily r) => viewEvents.contains(r.event)
      ? (v.$1 + r.times, v.$2)
      : (v.$1, v.$2 + r.times);
  for (final r in rows) {
    final isProduct = r.event.startsWith('product');
    final k = isProduct ? 'p:${r.target}' : 'b:${r.target}';
    days[r.day] = add(days[r.day] ?? (0, 0), r);
    byBanner[k] = add(byBanner[k] ?? (0, 0), r);
    if (viewEvents.contains(r.event)) {
      views += r.times;
    } else {
      taps += r.times;
    }
  }
  return AdReport(
    campaignId: campaignId,
    campaign: campaign.title,
    advertiser: advertiser?.company ?? '',
    startsOn: campaign.startsOn,
    endsOn: campaign.endsOn,
    countedTo: to,
    views: _safe(views),
    taps: _safe(taps),
    days: [
      for (final e in days.entries)
        AdReportRow(
          label: e.key,
          views: _safe(e.value.$1),
          taps: _safe(e.value.$2),
        ),
    ],
    banners: [
      for (final b in banners)
        AdReportRow(
          label: _bannerTitle(b),
          views: _safe(byBanner[key(b)]!.$1),
          taps: _safe(byBanner[key(b)]!.$2),
        ),
    ],
  );
}
