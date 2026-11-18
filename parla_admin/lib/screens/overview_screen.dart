import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../api/admin_api.dart';
import '../staff_session.dart';
import '../ui/texts.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';
import 'home_shell.dart';

/// What needs attention now, counted from the lists the panel already
/// reads. Only the parts the caller's role can open.
class _Todo {
  const _Todo(this.label, this.count, this.path, this.key, [this.hint]);

  final String label;
  final int count;
  final String path;
  final String key;
  final String? hint;
}

/// One section of the guide: what it is for and how to use it.
class _Guide {
  const _Guide(this.path, this.title, this.icon, this.text, this.steps);

  final String path;
  final String title;
  final IconData icon;
  final String text;
  final List<String> steps;
}

const _guides = [
  _Guide(
    '/content',
    'Məzmun',
    Icons.article_outlined,
    'Bloqlar, reseptlər, mütəxəssislər, tətbiqin seçim/məşq/addım mətnləri, '
        'bannerlər, elanlar və push.',
    [
      'Yuxarıdan növü seçin, "Yeni" ilə yaradın (kataloq mətnləri hazır '
          'siyahıdan açılır).',
      'Bloq mətnini Google Docs-dan "Google Docs-dan yapışdır" ilə gətirin; '
          'şəkilləri "Şəkil əlavə et" ilə qoyun, "Önizləmə" ilə yoxlayın.',
      'Hər dil tabını (AZ, RU, EN) doldurun; şəkillərə lisenziya və 3 dildə '
          'alternativ mətn yazın.',
      '"Yoxlamaya göndər": ekspert təsdiqləyir və ya qeydlə qaytarır. '
          'Təsdiqdən sonra "Dərc et".',
      'Admin öz bannerini, elanını və push-unu birbaşa dərc edir; brend '
          'kampaniyasını isə həmişə ekspert təsdiqləyir.',
      'Cədvəldəki yazı və reseptlər üçün (admin): Bloqlar → "Cədvəldən '
          'idxal et".',
    ],
  ),
  _Guide(
    '/users',
    'İstifadəçilər',
    Icons.people_outline,
    'Bir hesabı dəqiq e-poçtla tapmaq: hesab məlumatı və razılıqlar '
        '(sağlamlıq məlumatı görünmür).',
    [
      'Hər baxış audit jurnalına yazılır; yalnız lazım olanda açın.',
      'Sui-istifadədə "Blokla"; istifadəçi müraciət edəndə "Müraciətlə sil" '
          '(e-poçtu təsdiq üçün yenidən yazın).',
    ],
  ),
  _Guide(
    '/stats',
    'Statistika',
    Icons.insights_outlined,
    'Anonim rəqəmlər: qeydiyyat, dil, ölkə, razılıqlar, test cavabları, '
        'alətlər, gündəlik aktivlik. 10-dan az qruplar "<10" görünür.',
    [],
  ),
  _Guide(
    '/messages',
    'Dəstək',
    Icons.support_agent_outlined,
    'İstifadəçilərin yazışmaları. Mesajlarda sağlamlıq məlumatı ola bilər.',
    [
      'Siyahıda mətn görünmür; yazışmanı açanda audit jurnalına yazılır.',
      'Tibbi məsləhət verməyin; ciddi halda həkimə yönləndirin.',
      'Cavab verəndə istifadəçinin telefonuna mətnsiz bildiriş gedir.',
    ],
  ),
  _Guide(
    '/staff',
    'İşçilər',
    Icons.badge_outlined,
    'Komandanı e-poçtla dəvət edin və rol verin: admin, redaktor, ekspert, '
        'dəstək.',
    [],
  ),
];

/// The start page: what is waiting for you, and a short guide to every
/// section your role can open.
class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key, required this.state});

  final StaffState state;

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  List<_Todo>? _todos;

  StaffRole get _role => widget.state.me!.role;

  bool _can(String path) {
    final section = adminSections.where((s) => s.path == path).firstOrNull;
    return section != null &&
        (section.roles == null || section.roles!.contains(_role));
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final api = widget.state.api;
    final todos = <_Todo>[];
    try {
      if (_can('/content')) {
        final items = [
          for (final k in ContentKind.values) ...await api.listContent(k.name),
        ];
        final inReview = items
            .where((i) => i.status == ContentStatus.inReview)
            .toList();
        // Items whose approval belongs to this role (an expert for most
        // content, an admin for the team's own banners and messages).
        final mine = inReview
            .where(
              (i) =>
                  ContentRules.reviewerRole(
                    ContentKind.values.byName(i.kind),
                    jsonDecode(i.draftJson) as Map<String, Object?>,
                  ) ==
                  _role.name,
            )
            .toList();
        if (_role == StaffRole.expert || _role == StaffRole.admin) {
          todos.add(
            _Todo(
              'Yoxlamanızı gözləyir',
              mine.length,
              '/content/${mine.isEmpty ? 'article' : mine.first.kind}',
              'todo-review',
              'Sizin təsdiqinizə göndərilənlər',
            ),
          );
        }
        if (_role != StaffRole.expert) {
          final approved = items
              .where((i) => i.status == ContentStatus.approved)
              .toList();
          todos.add(
            _Todo(
              'Dərcə hazırdır',
              approved.length,
              '/content/${approved.isEmpty ? 'article' : approved.first.kind}',
              'todo-approved',
              'Təsdiqlənib, hələ dərc olunmayıb',
            ),
          );
          todos.add(
            _Todo(
              'Qaralamalar',
              items.where((i) => i.status == ContentStatus.draft).length,
              '/content/article',
              'todo-drafts',
              'Bütün növlər üzrə',
            ),
          );
        }
      }
      if (_can('/messages')) {
        final threads = await api.supportThreads();
        todos.add(
          _Todo(
            'Cavabsız dəstək',
            threads.where((t) => t.unreadByStaff).length,
            '/messages',
            'todo-support',
            'Oxunmamış söhbətlər',
          ),
        );
      }
    } on Object catch (e) {
      if (mounted) showToast(context, errorText(e));
    }
    if (mounted) setState(() => _todos = todos);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final todos = _todos;
    final guides = _guides.where((g) => _can(g.path)).toList();
    return AdminPage(
      title: 'Xoş gəldiniz',
      subtitle: 'Rolunuz: ${roleLabel(_role)}. ${roleHint(_role)}.',
      actions: [
        if (_role == StaffRole.admin || _role == StaffRole.editor)
          FilledButton.icon(
            onPressed: () => context.go('/content/article'),
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Məzmuna keç'),
          ),
      ],
      children: [
        if (todos == null)
          const LoadingBlock()
        else if (todos.isNotEmpty)
          ResponsiveGrid(
            minItemWidth: 210,
            children: [
              for (final t in todos)
                StatCard(
                  key: ValueKey(t.key),
                  valueKey: ValueKey('${t.key}-count'),
                  label: t.label,
                  value: '${t.count}',
                  hint: t.hint,
                  highlight: t.count > 0,
                  onTap: () => context.go(t.path),
                ),
            ],
          ),
        const SizedBox(height: 28),
        LayoutBuilder(
          builder: (context, c) {
            final wide = c.maxWidth >= 900;
            final sections = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Bölmələr', style: text.titleLarge),
                const SizedBox(height: 12),
                for (final g in guides) ...[
                  _GuideCard(guide: g),
                  const SizedBox(height: 12),
                ],
              ],
            );
            final side = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_can('/content')) ...[
                  const _FlowCard(),
                  const SizedBox(height: 16),
                ],
                const Notice(
                  tone: NoticeTone.info,
                  icon: Icons.lock_outline,
                  title: 'Təhlükəsizlik',
                  body:
                      'Şifrənizi heç kimlə paylaşmayın; 12 saatdan bir yenidən '
                      'daxil olmaq lazımdır. Paneldəki hər dəyişiklik audit '
                      'jurnalına yazılır. İstifadəçilərin sağlamlıq '
                      'məlumatları paneldə görünmür.',
                ),
              ],
            );
            if (!wide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [sections, const SizedBox(height: 8), side],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: sections),
                const SizedBox(width: 24),
                Expanded(flex: 2, child: side),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _GuideCard extends StatelessWidget {
  const _GuideCard({required this.guide});

  final _Guide guide;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final g = guide;
    return Card(
      key: ValueKey('guide-${g.path.substring(1)}'),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AdminColors.sunSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(g.icon, size: 20, color: AdminColors.espresso),
                ),
                const SizedBox(width: 14),
                Expanded(child: Text(g.title, style: text.titleMedium)),
                OutlinedButton(
                  onPressed: () => context.go(g.path),
                  child: const Text('Aç'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(g.text, style: text.bodyMedium),
            if (g.steps.isNotEmpty) ...[
              const SizedBox(height: 10),
              for (final (i, step) in g.steps.indexed)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AdminColors.hover,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          step,
                          style: text.bodyMedium?.copyWith(
                            color: AdminColors.ink,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

/// How content gets into the app, in three steps.
class _FlowCard extends StatelessWidget {
  const _FlowCard();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    const steps = [
      ('Redaktor', '3 dildə yazır və yoxlamaya göndərir.'),
      ('Mütəxəssis', 'təsdiqləyir və ya qeydlə qaytarır.'),
      ('Admin və ya redaktor', 'dərc edir: tətbiqdə görünür.'),
    ];
    return SectionCard(
      title: 'Məzmun necə dərc olunur',
      child: Column(
        children: [
          for (final (i, (who, what)) in steps.indexed)
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AdminColors.sun,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '$who ',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          TextSpan(text: what),
                        ],
                      ),
                      style: text.bodyMedium?.copyWith(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 14),
          Text(
            'Dərc olunmuş yazını redaktə etmək canlı mətni dəyişmir; yeni '
            'versiya yenidən yoxlanılır.',
            style: text.bodySmall,
          ),
        ],
      ),
    );
  }
}
