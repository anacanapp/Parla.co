import 'dart:convert';

import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';

/// Six sample expert profiles that show the format in the app before real
/// experts sign up (owner's request, 2026-11-20). They are no one: the
/// names start with "Nümunə", the numbers with
/// [ContentRules.sampleNumberPrefix] and there is no Instagram, so they
/// pass the rules without a recorded consent. Remove them before opening
/// registration (Content → Experts → delete).
final sampleExperts = <(String slug, String category, Map<String, Object?>)>[
  (
    'sample-dermatologist-1',
    'dermatologist',
    _profile(
      n: 1,
      title: 'Dermatoloq',
      years: 12,
      bio: {
        'az':
            'Nümunə profil. Burada mütəxəssisin qısa bio-su olacaq: '
            'ixtisası, maraq sahələri, qəbul etdiyi problemlər.',
        'ru':
            'Пример профиля. Здесь будет краткая биография специалиста: '
            'специализация, интересы, с какими проблемами работает.',
        'en':
            'Sample profile. A short bio goes here: specialty, interests '
            'and the concerns the expert works with.',
      },
      whatsapp: true,
    ),
  ),
  (
    'sample-dermatologist-2',
    'dermatologist',
    _profile(n: 2, title: 'Dermatoloq', years: 7, whatsapp: false),
  ),
  (
    'sample-cosmetologist-1',
    'cosmetologist',
    _profile(n: 3, title: 'Kosmetoloq', years: 9, whatsapp: true),
  ),
  (
    'sample-trichologist-1',
    'trichologist',
    _profile(n: 4, title: 'Trixoloq', years: 6, whatsapp: true),
  ),
  (
    'sample-dietitian-1',
    'dietitian',
    _profile(n: 5, title: 'Dietoloq', years: 10, whatsapp: false),
  ),
  (
    'sample-trainer-1',
    'trainer',
    _profile(n: 6, title: 'Məşqçi', years: 5, whatsapp: true),
  ),
];

Map<String, Object?> _profile({
  required int n,
  required String title,
  required int years,
  Map<String, String>? bio,
  required bool whatsapp,
}) {
  final number = '${ContentRules.sampleNumberPrefix}00$n';
  return {
    'sample': true,
    'name': '${ContentRules.samplePrefix} $title $n',
    'workplace': {
      'az': 'Nümunə klinika',
      'ru': 'Пример клиники',
      'en': 'Sample clinic',
    },
    'city': {'az': 'Bakı', 'ru': 'Баку', 'en': 'Baku'},
    'years': years,
    'bio':
        bio ??
        {
          'az': 'Nümunə profil: formatı göstərmək üçündür.',
          'ru': 'Пример профиля: показывает формат.',
          'en': 'Sample profile: it shows the format.',
        },
    'phone': number,
    if (whatsapp) 'whatsapp': number,
  };
}

/// Adds and publishes the sample profiles that are not there yet, as
/// [staff] (an admin). Returns how many were added.
Future<int> seedSampleExperts(Session session, StaffMember staff) async {
  var added = 0;
  for (final (slug, category, json) in sampleExperts) {
    final problems = ContentRules.problems(
      ContentKind.expert,
      jsonEncode(json),
      complete: true,
    );
    if (problems.isNotEmpty) {
      throw StateError('Sample $slug is invalid: $problems');
    }
    final exists = await ContentItem.db.findFirstRow(
      session,
      where: (t) =>
          t.kind.equals(ContentKind.expert.name) & t.slug.equals(slug),
    );
    if (exists != null) continue;
    final now = DateTime.now().toUtc();
    final encoded = jsonEncode(json);
    final row = await ContentItem.db.insertRow(
      session,
      ContentItem(
        kind: ContentKind.expert.name,
        slug: slug,
        category: category,
        status: ContentStatus.published,
        draftJson: encoded,
        publishedJson: encoded,
        publishedAt: now,
        createdBy: staff.authUserId,
        updatedBy: staff.authUserId,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await writeAudit(
      session,
      actorId: staff.authUserId,
      actorRole: AuditActor.staff,
      action: 'content.sample_published',
      objectType: 'content_item',
      objectId: row.id.toString(),
    );
    added++;
  }
  return added;
}
