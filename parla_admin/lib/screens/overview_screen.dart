import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../api/admin_api.dart';
import '../staff_session.dart';
import '../ui/texts.dart';
import '../ui/theme.dart';
import 'home_shell.dart';

/// What needs attention now, counted from the lists the panel already
/// reads. Only the parts the caller's role can open.
class _Todo {
  const _Todo(this.label, this.count, this.path, this.key);

  final String label;
  final int count;
  final String path;
  final String key;
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
        'dəstək. Hər kəs 2FA qurur.',
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
            ),
          );
        }
        if (_role != StaffRole.expert) {
          final approved = items
              .where((i) => i.status == ContentStatus.approved)
              .toList();
          todos.add(
            _Todo(
              'Təsdiqlənib, dərc gözləyir',
              approved.length,
              '/content/${approved.isEmpty ? 'article' : approved.first.kind}',
              'todo-approved',
            ),
          );
          todos.add(
            _Todo(
              'Qaralama',
              items.where((i) => i.status == ContentStatus.draft).length,
              '/content/article',
              'todo-drafts',
            ),
          );
        }
      }
      if (_can('/messages')) {
        final threads = await api.supportThreads();
        todos.add(
          _Todo(
            'Cavabsız dəstək mesajı',
            threads.where((t) => t.unreadByStaff).length,
            '/messages',
            'todo-support',
          ),
        );
      }
    } on Object catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(errorText(e))));
      }
    }
    if (mounted) setState(() => _todos = todos);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final todos = _todos;
    final guides = _guides.where((g) => _can(g.path)).toList();
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        Semantics(
          header: true,
          child: Text('Xoş gəldiniz', style: text.headlineMedium),
        ),
        const SizedBox(height: 4),
        Text(
          'Rolunuz: ${roleLabel(_role)}. ${roleHint(_role)}.',
          style: text.bodyMedium?.copyWith(color: AdminColors.muted),
        ),
        const SizedBox(height: 20),
        Text('İndi nə gözləyir', style: text.titleLarge),
        const SizedBox(height: 8),
        if (todos == null)
          const LinearProgressIndicator()
        else
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final t in todos)
                SizedBox(
                  width: 230,
                  child: Card(
                    key: ValueKey(t.key),
                    elevation: 0,
                    color: t.count > 0 ? AdminColors.cream : AdminColors.white,
                    child: InkWell(
                      onTap: () => context.go(t.path),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${t.count}', style: text.headlineMedium),
                            Text(t.label),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        const SizedBox(height: 28),
        Text('Bölmələr', style: text.titleLarge),
        const SizedBox(height: 8),
        for (final g in guides)
          Card(
            key: ValueKey('guide-${g.path.substring(1)}'),
            elevation: 0,
            color: AdminColors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(g.icon),
                      const SizedBox(width: 10),
                      Expanded(child: Text(g.title, style: text.titleMedium)),
                      TextButton(
                        onPressed: () => context.go(g.path),
                        child: const Text('Aç'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(g.text),
                  for (final (i, step) in g.steps.indexed)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 4),
                      child: Text('${i + 1}. $step', style: text.bodyMedium),
                    ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          'Təhlükəsizlik: şifrənizi və 2FA kodlarınızı heç kimlə paylaşmayın. '
          'Paneldə edilən hər dəyişiklik audit jurnalına yazılır.',
          style: text.bodySmall?.copyWith(color: AdminColors.muted),
        ),
      ],
    );
  }
}
