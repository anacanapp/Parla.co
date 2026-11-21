import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../api/admin_api.dart';
import '../markdown/html_to_markdown.dart';
import '../markdown/markdown_field.dart';
import '../media/image_field.dart';
import '../staff_session.dart';
import '../ui/texts.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';

void _snack(BuildContext context, String text) => showToast(context, text);

bool _canWrite(StaffState s) =>
    s.me?.role == StaffRole.admin || s.me?.role == StaffRole.editor;

/// Articles, recipes and expert profiles, one tab each.
class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key, required this.state, required this.kind});

  final StaffState state;
  final String kind;

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  List<ContentAdminItem>? _items;
  Object? _error;
  String _query = '';
  ContentStatus? _status;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(ContentScreen old) {
    super.didUpdateWidget(old);
    if (old.kind != widget.kind) {
      _items = null;
      _error = null;
      _query = '';
      _status = null;
      _load();
    }
  }

  Future<void> _load() async {
    try {
      final items = await widget.state.api.listContent(widget.kind);
      if (mounted) setState(() => _items = items);
    } on Object catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _importSheet() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cədvəldən idxal'),
        content: const Text(
          'Bloqlar (tam mətn, 3 dildə) və reseptlər qaralama kimi əlavə '
          'olunur. Hələ yalnız yazı planı olan qaralamalar tam mətnlə '
          'doldurulur; redaktə olunmuş yazılara toxunulmur. Heç nə dərc '
          'olunmur: hər yazı ekspert təsdiqindən keçir.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Ləğv et'),
          ),
          FilledButton(
            key: const ValueKey('import-yes'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('İdxal et'),
          ),
        ],
      ),
    );
    if (yes != true) return;
    try {
      final added = await widget.state.api.importSheet();
      if (!mounted) return;
      _snack(
        context,
        added == 0
            ? 'Yeni heç nə yoxdur.'
            : '$added yazı qaralama kimi əlavə olundu və ya dolduruldu.',
      );
      await _load();
    } on Object catch (e) {
      if (mounted) _snack(context, errorText(e));
    }
  }

  Future<void> _publishImported() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ekspert yoxlaması olmadan dərc'),
        content: const Text(
          'Cədvəldən idxal olunan və hələ qaralama olan bütün bloq yazıları '
          'və reseptlər tətbiqdə dərc olunur. Ekspert onları yoxlamayıb, '
          'ona görə tətbiqdə "ekspert yoxlayıb" sətri görünmür. Bu '
          'əməliyyat audit jurnalına yazılır.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Ləğv et'),
          ),
          FilledButton(
            key: const ValueKey('publish-imported-yes'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Dərc et'),
          ),
        ],
      ),
    );
    if (yes != true) return;
    try {
      final n = await widget.state.api.publishImported();
      if (!mounted) return;
      _snack(
        context,
        n == 0
            ? 'Dərc olunacaq qaralama yoxdur.'
            : '$n yazı və resept dərc olundu.',
      );
      await _load();
    } on Object catch (e) {
      if (mounted) _snack(context, errorText(e));
    }
  }

  ContentKind get _kind => ContentKind.values.byName(widget.kind);

  /// Opens a catalogue item, creating its row with the app's own texts the
  /// first time.
  Future<void> _openCatalogue(String id) async {
    final existing = _items?.where((i) => i.slug == id).firstOrNull;
    if (existing != null) {
      context.go('/content/${widget.kind}/${existing.id}');
      return;
    }
    try {
      final api = widget.state.api;
      final created = await api.createContent(
        widget.kind,
        id,
        ContentRules.catalogueCategory,
      );
      await api.saveContent(
        created.id,
        jsonEncode(ContentRules.catalogueDefaults(_kind, id)),
        ContentRules.catalogueCategory,
      );
      if (mounted) context.go('/content/${widget.kind}/${created.id}');
    } on Object catch (e) {
      if (mounted) _snack(context, errorText(e));
    }
  }

  Future<void> _create() async {
    final kind = ContentKind.values.byName(widget.kind);
    final slug = TextEditingController();
    var category = ContentRules.categoriesFor(kind).first;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Yeni'),
          content: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  key: const ValueKey('new-slug'),
                  controller: slug,
                  decoration: const InputDecoration(
                    labelText: 'Slug (məs. qis-deri-qulluq)',
                    helperText: 'Kiçik latın hərfləri, rəqəmlər və tire',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  key: const ValueKey('new-category'),
                  isExpanded: true,
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Kateqoriya'),
                  items: [
                    for (final c in ContentRules.categoriesFor(kind))
                      DropdownMenuItem(value: c, child: Text(categoryLabel(c))),
                  ],
                  onChanged: (v) => setState(() => category = v!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Ləğv et'),
            ),
            FilledButton(
              key: const ValueKey('new-create'),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yarat'),
            ),
          ],
        ),
      ),
    );
    final value = slug.text.trim();
    WidgetsBinding.instance.addPostFrameCallback((_) => slug.dispose());
    if (!(ok ?? false) || !mounted) return;
    try {
      final item = await widget.state.api.createContent(
        widget.kind,
        value,
        category,
      );
      if (mounted) context.go('/content/${widget.kind}/${item.id}');
    } on Object catch (e) {
      if (mounted) _snack(context, errorText(e));
    }
  }

  Widget _catalogueTile(String id, List<ContentAdminItem> items) {
    final item = items.where((i) => i.slug == id).firstOrNull;
    return _ContentRow(
      key: ValueKey('catalogue-$id'),
      title: item == null ? _defaultTitle(_kind, id) : _title(item),
      subtitle: [id, if (item == null) 'tətbiqdəki mətn'].join(' · '),
      item: item,
      onTap: () => _openCatalogue(id),
    );
  }

  bool _matches(ContentAdminItem item) {
    if (_status != null && item.status != _status) return false;
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return _title(item).toLowerCase().contains(q) ||
        item.slug.toLowerCase().contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final items = _items;
    final kinds = ContentKind.values;
    final shown = items?.where(_matches).toList();
    final catalogueIds = _kind.isCatalogue
        ? [
            for (final id in ContentRules.catalogueIds(_kind))
              if (_query.trim().isEmpty ||
                  id.contains(_query.trim().toLowerCase()) ||
                  _defaultTitle(_kind, id).toLowerCase().contains(
                    _query.trim().toLowerCase(),
                  ))
                id,
          ]
        : const <String>[];
    return AdminPage(
      title: 'Məzmun',
      subtitle:
          'Bloqlar, reseptlər, mütəxəssislər, bannerlər, elanlar, push və '
          'tətbiqin kataloq mətnləri.',
      actions: [
        if (widget.state.me?.role == StaffRole.admin &&
            (_kind == ContentKind.article || _kind == ContentKind.recipe))
          OutlinedButton.icon(
            key: const ValueKey('content-import'),
            onPressed: _importSheet,
            icon: const Icon(Icons.table_view_outlined, size: 18),
            label: const Text('Cədvəldən idxal et'),
          ),
        if (widget.state.me?.role == StaffRole.admin &&
            (_kind == ContentKind.article || _kind == ContentKind.recipe))
          OutlinedButton.icon(
            key: const ValueKey('content-publish-imported'),
            onPressed: _publishImported,
            icon: const Icon(Icons.publish_outlined, size: 18),
            label: const Text('İdxal olunanları dərc et'),
          ),
        if (_canWrite(widget.state) && !_kind.isCatalogue)
          FilledButton.icon(
            key: const ValueKey('content-new'),
            onPressed: _create,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Yeni'),
          ),
      ],
      children: [
        PillTabs(
          labels: [for (final k in kinds) kindLabel(k.name)],
          keys: [for (final k in kinds) ValueKey('kind-${k.name}')],
          selected: kinds.indexOf(_kind),
          onSelected: (i) => context.go('/content/${kinds[i].name}'),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 340,
              child: TextField(
                key: const ValueKey('content-search'),
                onChanged: (v) => setState(() => _query = v),
                decoration: const InputDecoration(
                  hintText: 'Başlıq və ya slug ilə axtar',
                  prefixIcon: Icon(Icons.search, size: 20),
                  isDense: true,
                ),
              ),
            ),
            if (!_kind.isCatalogue)
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<ContentStatus?>(
                  key: const ValueKey('content-status-filter'),
                  initialValue: _status,
                  isDense: true,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Hamısı')),
                    for (final s in ContentStatus.values)
                      DropdownMenuItem(value: s, child: Text(statusLabel(s))),
                  ],
                  onChanged: (v) => setState(() => _status = v),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (_kind.isCatalogue)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Burada yalnız mətnlər${_kind == ContentKind.exercise ? ', şəkil, video' : ''} '
              'və tətbiqdə göstərmək/gizlətmək dəyişir. Qaydalar və '
              'təhlükəsizlik şərtləri kodda qalır.',
              style: text.bodySmall,
            ),
          ),
        if (_error != null)
          Notice(
            tone: NoticeTone.danger,
            icon: Icons.error_outline,
            title: errorText(_error!),
          )
        else if (items == null)
          const LoadingBlock()
        else if (_kind.isCatalogue)
          Card(
            child: Column(
              children: [
                const _ContentHeaderRow(),
                for (final id in catalogueIds) _catalogueTile(id, items),
              ],
            ),
          )
        else if (items.isEmpty)
          Card(
            child: EmptyState(
              title: 'Hələ heç nə yoxdur.',
              body: _canWrite(widget.state)
                  ? '"Yeni" ilə ilk ${kindLabel(widget.kind).toLowerCase()} '
                        'yazısını yaradın.'
                  : null,
              icon: Icons.article_outlined,
            ),
          )
        else if (shown!.isEmpty)
          const Card(
            child: EmptyState(
              title: 'Uyğun nəticə yoxdur',
              body: 'Axtarışı və ya status filtrini dəyişin.',
              icon: Icons.search_off,
            ),
          )
        else
          Card(
            child: Column(
              children: [
                const _ContentHeaderRow(),
                for (final item in shown)
                  _ContentRow(
                    key: ValueKey('content-${item.id}'),
                    title: _title(item),
                    subtitle: [
                      item.slug,
                      categoryLabel(item.category),
                    ].join(' · '),
                    item: item,
                    onTap: () =>
                        context.go('/content/${widget.kind}/${item.id}'),
                  ),
              ],
            ),
          ),
        if (!_kind.isCatalogue && items != null && items.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(
            '${shown!.length} / ${items.length} göstərilir',
            style: text.bodySmall,
          ),
        ],
      ],
    );
  }
}

/// Which of az, ru and en have a title (or name) in the working copy.
Set<String> _languagesFilled(ContentAdminItem item) {
  final json = jsonDecode(item.draftJson) as Map<String, Object?>;
  final title = json['title'] ?? json['name'];
  return {
    for (final l in ContentRules.languages)
      if (ContentRules.pick(title, l).isNotEmpty) l,
  };
}

class _ContentHeaderRow extends StatelessWidget {
  const _ContentHeaderRow();

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 1100;
    if (!wide) return const SizedBox.shrink();
    const style = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AdminColors.muted,
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AdminColors.line)),
      ),
      child: const Row(
        children: [
          Expanded(child: Text('Başlıq', style: style)),
          SizedBox(width: 130, child: Text('Dillər', style: style)),
          SizedBox(width: 170, child: Text('Status', style: style)),
          SizedBox(width: 24),
        ],
      ),
    );
  }
}

/// One item in a content list.
class _ContentRow extends StatelessWidget {
  const _ContentRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.item,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final ContentAdminItem? item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 1100;
    final item = this.item;
    final filled = item == null ? null : _languagesFilled(item);
    final badges = Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        if (item != null) StatusPill(item.status),
        if (item?.live ?? false) const Pill('canlı', tone: liveTone),
        if (item?.hidden ?? false) const Pill('gizli', tone: dangerTone),
      ],
    );
    final languages = filled == null
        ? const SizedBox.shrink()
        : Wrap(
            runSpacing: 4,
            children: [
              for (final l in ContentRules.languages)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Tooltip(
                    message: filled.contains(l) ? 'Doldurulub' : 'Boşdur',
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: filled.contains(l)
                            ? liveTone.background
                            : AdminColors.hover,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        l.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: filled.contains(l)
                              ? liveTone.text
                              : AdminColors.subtle,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: AdminColors.subtle),
        ),
      ],
    );
    return InkWell(
      onTap: onTap,
      hoverColor: AdminColors.canvas,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFF5F0E4))),
        ),
        child: wide
            ? Row(
                children: [
                  Expanded(child: heading),
                  SizedBox(width: 130, child: languages),
                  SizedBox(width: 170, child: badges),
                  const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: AdminColors.subtle,
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        heading,
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [languages, badges],
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: AdminColors.subtle,
                  ),
                ],
              ),
      ),
    );
  }
}

String _defaultTitle(ContentKind kind, String id) {
  final d = ContentRules.catalogueDefaults(kind, id);
  final v = ContentRules.pick(d['title'] ?? d['name'], 'az');
  return v.isEmpty ? id : v;
}

String _title(ContentAdminItem item) {
  final json = jsonDecode(item.draftJson) as Map<String, Object?>;
  final title = json['title'] ?? json['name'];
  final value = ContentRules.pick(title, 'az');
  return value.isEmpty ? '(adsız)' : value;
}

enum _FieldType {
  line,
  multiline,
  lines,
  number,
  groups,
  allergens,
  urls,
  plain,

  /// A set of codes from [_Field.options] (empty means "all").
  multi,

  /// Article text in Markdown with toolbar and preview.
  markdown,

  /// Hashtags per language, typed as "#one #two".
  tags,

  /// One code of [_Field.options], as choice chips.
  choice,
}

class _Field {
  const _Field(
    this.key,
    this.label,
    this.type, {
    this.localized = true,
    this.options = const [],
    this.help,
  });

  final List<String> options;
  final String? help;

  final String key;
  final String label;
  final _FieldType type;
  final bool localized;
}

const _fields = <String, List<_Field>>{
  'product': [
    _Field('name', 'Ad', _FieldType.line),
    _Field(
      'description',
      'Təsvir (neytral, sağlamlıq vədi olmadan)',
      _FieldType.multiline,
    ),
    _Field('brand', 'Brend', _FieldType.plain, localized: false),
    _Field(
      'price',
      'Qiymət, AZN (məs. 12.50)',
      _FieldType.plain,
      localized: false,
    ),
    _Field(
      'sale',
      'Necə satılır',
      _FieldType.choice,
      localized: false,
      options: ['redirect', 'own'],
    ),
    _Field(
      'url',
      'Partnyorun səhifəsi (https://…)',
      _FieldType.plain,
      localized: false,
      help:
          'Toxunanda istifadəçidən soruşulur və sayt brauzerdə açılır. '
          'Linkə yalnız utm_source=parla əlavə olunur.',
    ),
    _Field(
      'seller',
      'Satıcı',
      _FieldType.choice,
      localized: false,
      options: ['parla', 'brand'],
    ),
  ],
  'push': [
    _Field('title', 'Başlıq (ən çox 60 simvol)', _FieldType.line),
    _Field('body', 'Mətn (ən çox 180 simvol)', _FieldType.multiline),
    _Field(
      'link',
      'Keçid (istəyə görə)',
      _FieldType.plain,
      localized: false,
      help:
          'Toxunanda açılan ekran: home, routine, check, sport, discover, '
          'blog, nutrition, experts, messages; və ya article:slug.',
    ),
    _Field(
      'languages',
      'Dillər (heç biri seçilməsə: hamısı)',
      _FieldType.multi,
      localized: false,
      options: ['az', 'ru', 'en'],
    ),
    _Field(
      'countries',
      'Ölkələr (heç biri seçilməsə: hamısı)',
      _FieldType.multi,
      localized: false,
      options: ['AZ', 'TR', 'KZ', 'UZ'],
    ),
  ],
  'message': [
    _Field('title', 'Başlıq', _FieldType.line),
    _Field('body', 'Mətn', _FieldType.multiline),
    _Field(
      'link',
      'Keçid (istəyə görə)',
      _FieldType.plain,
      localized: false,
      help:
          'Ekran: home, routine, check, sport, discover, blog, nutrition, '
          'experts; və ya article:slug, recipe:slug.',
    ),
    _Field(
      'startsOn',
      'Görünmə başlanğıcı (YYYY-AA-GG)',
      _FieldType.plain,
      localized: false,
    ),
    _Field(
      'endsOn',
      'Görünmə sonu (YYYY-AA-GG)',
      _FieldType.plain,
      localized: false,
    ),
    _Field(
      'languages',
      'Dillər (heç biri seçilməsə: hamısı)',
      _FieldType.multi,
      localized: false,
      options: ['az', 'ru', 'en'],
    ),
    _Field(
      'countries',
      'Ölkələr (heç biri seçilməsə: hamısı)',
      _FieldType.multi,
      localized: false,
      options: ['AZ', 'TR', 'KZ', 'UZ'],
    ),
  ],
  'banner': [
    _Field('title', 'Başlıq', _FieldType.line),
    _Field('body', 'Qısa mətn', _FieldType.multiline),
    _Field(
      'link',
      'Tətbiqdaxili keçid',
      _FieldType.plain,
      localized: false,
      help:
          'Ekran: home, routine, check, sport, discover, blog, nutrition, '
          'experts; və ya article:slug, recipe:slug. Ya bu, ya da sayt.',
    ),
    _Field(
      'url',
      'Brendin saytı (https://…)',
      _FieldType.plain,
      localized: false,
      help:
          'Toxunanda istifadəçidən soruşulur və sayt brauzerdə açılır. '
          'Linkə yalnız utm_source=parla əlavə olunur, istifadəçi haqqında '
          'heç nə göndərilmir.',
    ),
    _Field(
      'topics',
      'Mövzular (heç biri seçilməsə: hamısı)',
      _FieldType.multi,
      localized: false,
    ),
    _Field(
      'startsOn',
      'Başlama tarixi (YYYY-AA-GG)',
      _FieldType.plain,
      localized: false,
    ),
    _Field(
      'endsOn',
      'Bitmə tarixi (YYYY-AA-GG)',
      _FieldType.plain,
      localized: false,
    ),
    _Field(
      'languages',
      'Dillər (heç biri seçilməsə: hamısı)',
      _FieldType.multi,
      localized: false,
      options: ['az', 'ru', 'en'],
    ),
    _Field(
      'countries',
      'Ölkələr (heç biri seçilməsə: hamısı)',
      _FieldType.multi,
      localized: false,
      options: ['AZ', 'TR', 'KZ', 'UZ'],
    ),
  ],
  'preference': [
    _Field('name', 'Ad', _FieldType.line),
    _Field('hint', 'Nəyi yoxlayır (neytral izah)', _FieldType.multiline),
  ],
  'exercise': [
    _Field('name', 'Ad', _FieldType.line),
    _Field('how', 'Necə edilir', _FieldType.multiline),
    _Field('caution', 'Ehtiyat (nə vaxt etməməli)', _FieldType.multiline),
  ],
  'step': [
    _Field('title', 'Ad', _FieldType.line),
    _Field('how', 'Necə edilir', _FieldType.multiline),
    _Field('tip', 'Məsləhət', _FieldType.multiline),
  ],
  'article': [
    _Field('title', 'Başlıq', _FieldType.line),
    _Field('summary', 'Qısa təsvir', _FieldType.multiline),
    _Field(
      'tags',
      'Heşteqlər (məs. #quruDəri #qış; ən çox 10)',
      _FieldType.tags,
    ),
    _Field('body', 'Mətn', _FieldType.markdown),
    _Field('tips', 'Addımlar (hər sətir bir addım)', _FieldType.lines),
    _Field('minutes', 'Oxuma vaxtı (dəq)', _FieldType.number, localized: false),
    _Field(
      'sources',
      'Mənbələr (hər sətir bir https:// link)',
      _FieldType.urls,
      localized: false,
    ),
  ],
  'recipe': [
    _Field('title', 'Başlıq', _FieldType.line),
    _Field(
      'ingredientNames',
      'Tərkib (hər sətir bir məhsul)',
      _FieldType.lines,
    ),
    _Field(
      'ingredientAmounts',
      'Miqdar (eyni sıra ilə, hər sətir bir miqdar)',
      _FieldType.lines,
    ),
    _Field('steps', 'Hazırlanma (hər sətir bir addım)', _FieldType.lines),
    _Field('note', 'Qeyd', _FieldType.multiline),
    _Field('minutes', 'Vaxt (dəq)', _FieldType.number, localized: false),
    _Field('servings', 'Nəfər', _FieldType.number, localized: false),
    _Field('groups', 'Boşqab qrupları', _FieldType.groups, localized: false),
    _Field('allergens', 'Allergenlər', _FieldType.allergens, localized: false),
  ],
  'expert': [
    _Field('name', 'Ad Soyad', _FieldType.plain, localized: false),
    _Field('workplace', 'İş yeri', _FieldType.line),
    _Field('city', 'Şəhər', _FieldType.line),
    _Field('bio', 'Qısa bio', _FieldType.multiline),
    _Field('years', 'Təcrübə (il)', _FieldType.number, localized: false),
    _Field(
      'phone',
      'Telefon (+994…)',
      _FieldType.plain,
      localized: false,
    ),
    _Field(
      'whatsapp',
      'WhatsApp (+994…)',
      _FieldType.plain,
      localized: false,
    ),
    _Field(
      'instagram',
      'Instagram (istifadəçi adı)',
      _FieldType.plain,
      localized: false,
    ),
  ],
};

/// Writes one item in az, ru and en, and moves it through the review
/// flow. What each role may do follows the server's rules.
class ContentEditorScreen extends StatefulWidget {
  const ContentEditorScreen({
    super.key,
    required this.state,
    required this.kind,
    required this.id,
  });

  final StaffState state;
  final String kind;
  final int id;

  @override
  State<ContentEditorScreen> createState() => _ContentEditorScreenState();
}

class _ContentEditorScreenState extends State<ContentEditorScreen> {
  ContentAdminItem? _item;
  String _lang = 'az';
  Object? _error;
  bool _busy = false;
  String _category = '';
  final Set<String> _groups = {};

  int? _imageId;
  int? _videoId;

  /// Banners: the advertiser's campaign (a paid ad) or `null` (the team's
  /// own banner), and the campaigns to choose from.
  int? _campaign;
  List<AdCampaignOption>? _campaigns;

  /// A brand typed by hand before campaigns existed; kept as it is.
  String? _legacySponsor;

  /// Values of [_FieldType.multi] fields.
  final Map<String, Set<String>> _multi = {};

  /// Values of [_FieldType.choice] fields.
  final Map<String, String?> _choice = {};

  /// `null` until chosen; empty means "none of the 14 allergens".
  Set<String>? _allergens;
  final Map<String, TextEditingController> _plain = {};
  final Map<String, Map<String, TextEditingController>> _localized = {};

  AdminApi get _api => widget.state.api;
  List<_Field> get _defs => _fields[widget.kind]!;
  ContentKind get _kind => ContentKind.values.byName(widget.kind);

  @override
  void initState() {
    super.initState();
    for (final f in _defs) {
      if (f.type == _FieldType.groups ||
          f.type == _FieldType.allergens ||
          f.type == _FieldType.multi ||
          f.type == _FieldType.choice) {
        continue;
      }
      if (f.localized) {
        _localized[f.key] = {
          for (final l in ContentRules.languages) l: TextEditingController(),
        };
      } else {
        _plain[f.key] = TextEditingController();
      }
    }
    _load();
    if (_kind == ContentKind.banner || _kind == ContentKind.product) {
      _loadCampaigns();
    }
  }

  Future<void> _loadCampaigns() async {
    try {
      final options = await _api.adCampaignOptions();
      if (mounted) setState(() => _campaigns = options);
    } on Object {
      if (mounted) setState(() => _campaigns = const []);
    }
  }

  /// The choices of a [_FieldType.multi] field; a banner's topics follow
  /// its placement.
  List<String> _optionsOf(_Field f) =>
      f.key == 'topics' ? ContentRules.bannerTopics(_category) : f.options;

  /// A product shows its partner link only when sold on the partner's
  /// site, and its seller only when sold in the app.
  bool _shown(_Field f) {
    if (_kind != ContentKind.product) return true;
    return switch (f.key) {
      'url' => _choice['sale'] == 'redirect',
      'seller' => _choice['sale'] == 'own',
      _ => true,
    };
  }

  @override
  void dispose() {
    for (final c in _plain.values) {
      c.dispose();
    }
    for (final m in _localized.values) {
      for (final c in m.values) {
        c.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final items = await _api.listContent(widget.kind);
      final item = items.where((i) => i.id == widget.id).firstOrNull;
      if (!mounted) return;
      if (item == null) {
        setState(() => _error = const AdminError('content.not_found'));
        return;
      }
      _fill(item);
    } on Object catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  void _fill(ContentAdminItem item) {
    final json = jsonDecode(item.draftJson) as Map<String, Object?>;
    String lines(Object? list, String lang, [String? inner]) => [
      for (final e in (list as List? ?? const []))
        ContentRules.pick(inner == null ? e : (e as Map)[inner], lang),
    ].join('\n');
    _imageId = MediaRules.imageOf(json);
    _videoId = MediaRules.videoOf(json);
    _campaign = json['campaign'] as int?;
    _legacySponsor = _campaign == null ? json['sponsor'] as String? : null;
    for (final f in _defs) {
      switch (f.type) {
        case _FieldType.groups:
          _groups
            ..clear()
            ..addAll((json['groups'] as List? ?? const []).cast<String>());
        case _FieldType.multi:
          _multi[f.key] = {
            ...(json[f.key] as List? ?? const []).cast<String>(),
          };
        case _FieldType.choice:
          _choice[f.key] = json[f.key] as String?;
        case _FieldType.allergens:
          final v = json['allergens'];
          _allergens = v is List ? v.cast<String>().toSet() : null;
        case _FieldType.urls:
          _plain[f.key]!.text = (json[f.key] as List? ?? const []).join('\n');
        case _FieldType.number || _FieldType.plain:
          final v = json[f.key];
          _plain[f.key]!.text = v == null ? '' : '$v';
        case _FieldType.lines:
          for (final l in ContentRules.languages) {
            _localized[f.key]![l]!.text = switch (f.key) {
              'ingredientNames' => lines(json['ingredients'], l, 'name'),
              'ingredientAmounts' => lines(json['ingredients'], l, 'amount'),
              _ => lines(json[f.key], l),
            };
          }
        case _FieldType.tags:
          final v = json[f.key];
          for (final l in ContentRules.languages) {
            final list = v is Map ? (v[l] as List? ?? const []) : const [];
            _localized[f.key]![l]!.text = [
              for (final t in list) '#$t',
            ].join(' ');
          }
        case _FieldType.line || _FieldType.multiline || _FieldType.markdown:
          final v = json[f.key];
          for (final l in ContentRules.languages) {
            _localized[f.key]![l]!.text = v is Map
                ? (v[l] as String? ?? '')
                : '';
          }
      }
    }
    setState(() {
      _item = item;
      _category = item.category;
    });
  }

  /// The form as content JSON; empty fields are left out.
  String _json() {
    final out = <String, Object?>{};
    Map<String, String>? loc(String key) {
      final m = {
        for (final l in ContentRules.languages)
          if (_localized[key]![l]!.text.trim().isNotEmpty)
            l: _localized[key]![l]!.text.trim(),
      };
      return m.isEmpty ? null : m;
    }

    List<String> split(String key, String lang) => [
      for (final line in _localized[key]![lang]!.text.split('\n'))
        if (line.trim().isNotEmpty) line.trim(),
    ];

    List<Map<String, String>> zip(String key) {
      final count = ContentRules.languages
          .map((l) => split(key, l).length)
          .fold(0, (a, b) => a > b ? a : b);
      return [
        for (var i = 0; i < count; i++)
          {
            for (final l in ContentRules.languages)
              if (i < split(key, l).length) l: split(key, l)[i],
          },
      ];
    }

    for (final f in _defs.where(_shown)) {
      switch (f.type) {
        case _FieldType.choice:
          final v = _choice[f.key];
          if (v != null) out[f.key] = v;
        case _FieldType.groups:
          if (_groups.isNotEmpty) {
            out['groups'] = [
              for (final g in ContentRules.plateGroups)
                if (_groups.contains(g)) g,
            ];
          }
        case _FieldType.multi:
          final chosen = _multi[f.key] ?? const {};
          final picked = [
            for (final o in _optionsOf(f))
              if (chosen.contains(o)) o,
          ];
          if (picked.isNotEmpty) out[f.key] = picked;
        case _FieldType.allergens:
          final a = _allergens;
          if (a != null) {
            out['allergens'] = [
              for (final id in ContentRules.recipeAllergens)
                if (a.contains(id)) id,
            ];
          }
        case _FieldType.urls:
          final urls = [
            for (final line in _plain[f.key]!.text.split('\n'))
              if (line.trim().isNotEmpty) line.trim(),
          ];
          if (urls.isNotEmpty) out[f.key] = urls;
        case _FieldType.number:
          final v = int.tryParse(_plain[f.key]!.text.trim());
          if (v != null) out[f.key] = v;
        case _FieldType.plain:
          final v = _plain[f.key]!.text.trim();
          if (v.isNotEmpty) out[f.key] = v;
        case _FieldType.lines when f.key == 'ingredientNames':
          final names = zip('ingredientNames');
          final amounts = zip('ingredientAmounts');
          if (names.isNotEmpty) {
            out['ingredients'] = [
              for (var i = 0; i < names.length; i++)
                {
                  'name': names[i],
                  'amount': i < amounts.length
                      ? amounts[i]
                      : <String, String>{},
                },
            ];
          }
        case _FieldType.lines when f.key == 'ingredientAmounts':
          break;
        case _FieldType.lines:
          final items = zip(f.key);
          if (items.isNotEmpty) out[f.key] = items;
        case _FieldType.tags:
          final byLang = <String, List<String>>{};
          for (final l in ContentRules.languages) {
            final tags = <String>[];
            for (final raw in _localized[f.key]![l]!.text.split(
              RegExp(r'[\s,]+'),
            )) {
              final t = ContentRules.cleanTag(raw);
              if (t != null && !tags.contains(t)) tags.add(t);
            }
            if (tags.isNotEmpty) byLang[l] = tags;
          }
          if (byLang.isNotEmpty) out[f.key] = byLang;
        case _FieldType.markdown:
          final v = {
            for (final l in ContentRules.languages)
              if (_localized[f.key]![l]!.text.trim().isNotEmpty)
                l: cleanMarkdown(_localized[f.key]![l]!.text),
          };
          if (v.isNotEmpty) out[f.key] = v;
        case _FieldType.line || _FieldType.multiline:
          final v = loc(f.key);
          if (v != null) out[f.key] = v;
      }
    }
    if (_kind == ContentKind.product && _campaign != null) {
      out['campaign'] = _campaign;
    }
    if (_kind == ContentKind.banner) {
      if (_campaign != null) {
        out['campaign'] = _campaign;
      } else if (_legacySponsor != null) {
        out['sponsor'] = _legacySponsor;
      }
    }
    if (_imageId != null) out['image'] = _imageId;
    if (_videoId != null && _kind == ContentKind.exercise) {
      out['video'] = _videoId;
    }
    return jsonEncode(out);
  }

  Future<void> _do(
    Future<ContentAdminItem?> Function() call,
    String done,
  ) async {
    setState(() => _busy = true);
    try {
      final item = await call();
      if (item != null && mounted) _fill(item);
      if (mounted) _snack(context, done);
    } on Object catch (e) {
      if (mounted) _snack(context, errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _allergenChips(bool writer) {
    final chosen = _allergens;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Allergenlər (AB-nin 14 allergeni)'),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            FilterChip(
              key: const ValueKey('allergen-none'),
              label: const Text('Heç biri'),
              selected: chosen != null && chosen.isEmpty,
              onSelected: writer
                  ? (on) => setState(() => _allergens = on ? {} : null)
                  : null,
            ),
            for (final a in ContentRules.recipeAllergens)
              FilterChip(
                key: ValueKey('allergen-$a'),
                label: Text(allergenLabel(a)),
                selected: chosen?.contains(a) ?? false,
                onSelected: writer
                    ? (on) => setState(() {
                        final next = {...?_allergens};
                        on ? next.add(a) : next.remove(a);
                        _allergens = next.isEmpty ? null : next;
                      })
                    : null,
              ),
          ],
        ),
      ],
    );
  }

  /// The banner's campaign: none (the team's own banner) or one of the
  /// advertisers' campaigns. The "Ad · brand" label then shows the
  /// advertiser's name, written by the server.
  Widget _campaignPicker(bool writer) {
    final options = _campaigns;
    if (options == null) return const LinearProgressIndicator();
    final known = options.any((o) => o.id == _campaign);
    return DropdownButtonFormField<int?>(
      key: const ValueKey('banner-campaign'),
      isExpanded: true,
      initialValue: known ? _campaign : null,
      decoration: InputDecoration(
        labelText: 'Reklam kampaniyası',
        helperText: _legacySponsor != null && _campaign == null
            ? 'Əl ilə yazılmış brend: $_legacySponsor'
            : 'Seçilsə banner "Reklam · brend" nişanı ilə çıxır və ekspert '
                  'təsdiqi lazımdır. Tarixlər kampaniyanın içində olmalıdır.',
        helperMaxLines: 3,
      ),
      items: [
        const DropdownMenuItem<int?>(
          value: null,
          child: Text('Yoxdur (komandanın öz banneri)'),
        ),
        for (final o in options)
          DropdownMenuItem<int?>(
            value: o.id,
            child: Text(
              '${o.advertiser} · ${o.title} (${o.startsOn} – ${o.endsOn})',
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: writer
          ? (v) => setState(() {
              _campaign = v;
              if (v != null) _legacySponsor = null;
            })
          : null,
    );
  }

  Future<bool> _confirmPush() async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Push göndərilsin?'),
          content: const Text(
            'Yalnız marketinq razılığı verən və bildirişləri açan '
            'istifadəçilərə, seçilmiş dil və ölkələrə bir dəfə göndərilir. '
            'Geri almaq olmur. Mətndə şəxsi məlumat olmamalıdır.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Ləğv et'),
            ),
            FilledButton(
              key: const ValueKey('push-confirm'),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Göndər'),
            ),
          ],
        ),
      ) ??
      false;

  Future<String?> _ask(String title, String label) async {
    final c = TextEditingController();
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 380,
          child: TextField(
            key: const ValueKey('ask-field'),
            controller: c,
            maxLines: 3,
            decoration: InputDecoration(labelText: label),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ləğv et'),
          ),
          FilledButton(
            key: const ValueKey('ask-ok'),
            onPressed: () => Navigator.pop(context, c.text),
            child: const Text('Təsdiq'),
          ),
        ],
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => c.dispose());
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final item = _item;
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Text(errorText(_error!)),
      );
    }
    if (item == null) return const Center(child: CircularProgressIndicator());
    final role = widget.state.me!.role;
    final writer = role == StaffRole.admin || role == StaffRole.editor;
    final expertKind = _kind == ContentKind.expert;
    final draft = jsonDecode(_json()) as Map<String, Object?>;
    final problems = ContentRules.problems(_kind, _json(), complete: true);
    final reviewer = ContentRules.reviewerRole(_kind, draft) == role.name;
    final direct =
        role == StaffRole.admin &&
        ContentRules.adminPublishesDirectly(_kind, draft);

    final actions = <Widget>[
      if (writer)
        FilledButton(
          key: const ValueKey('content-save'),
          onPressed: _busy
              ? null
              : () => _do(
                  () => _api.saveContent(item.id, _json(), _category),
                  'Yadda saxlanıldı.',
                ),
          child: const Text('Yadda saxla'),
        ),
      if (writer && !expertKind && item.status == ContentStatus.draft)
        OutlinedButton(
          key: const ValueKey('content-submit'),
          onPressed: _busy
              ? null
              : () => _do(
                  () => _api.submitContent(item.id),
                  'Yoxlamaya göndərildi.',
                ),
          child: const Text('Yoxlamaya göndər'),
        ),
      if (reviewer && item.status == ContentStatus.inReview) ...[
        FilledButton(
          key: const ValueKey('content-approve'),
          onPressed: _busy
              ? null
              : () => _do(() => _api.approveContent(item.id), 'Təsdiqləndi.'),
          child: const Text('Təsdiqlə'),
        ),
        OutlinedButton(
          key: const ValueKey('content-return'),
          onPressed: _busy
              ? null
              : () async {
                  final note = await _ask('Geri qaytar', 'Qeyd');
                  if (note == null) return;
                  await _do(
                    () => _api.returnContent(item.id, note),
                    'Redaktora qaytarıldı.',
                  );
                },
          child: const Text('Qeydlə qaytar'),
        ),
      ],
      if (role == StaffRole.admin && expertKind && !item.consentRecorded)
        OutlinedButton(
          key: const ValueKey('content-consent'),
          onPressed: _busy
              ? null
              : () async {
                  final ref = await _ask(
                    'Yazılı razılıq',
                    'Razılıq sənədinin harada saxlandığı',
                  );
                  if (ref == null) return;
                  await _do(
                    () => _api.recordConsent(item.id, ref),
                    'Razılıq qeyd olundu.',
                  );
                },
          child: const Text('Razılığı qeyd et'),
        ),
      if (writer &&
          (expertKind
              ? item.consentRecorded
              : item.status == ContentStatus.approved || direct))
        FilledButton(
          key: const ValueKey('content-publish'),
          onPressed: _busy
              ? null
              : () async {
                  if (_kind == ContentKind.push && !await _confirmPush()) {
                    return;
                  }
                  await _do(
                    () => _api.publishContent(item.id),
                    _kind == ContentKind.push ? 'Göndərildi.' : 'Dərc olundu.',
                  );
                },
          child: Text(_kind == ContentKind.push ? 'Göndər' : 'Dərc et'),
        ),
      if (writer && item.live)
        OutlinedButton(
          key: const ValueKey('content-unpublish'),
          onPressed: _busy
              ? null
              : () => _do(
                  () => _api.unpublishContent(item.id),
                  'Dərcdən çıxarıldı.',
                ),
          child: const Text('Dərcdən çıxar'),
        ),
      if (role == StaffRole.admin && !item.live)
        TextButton(
          key: const ValueKey('content-delete'),
          onPressed: _busy
              ? null
              : () async {
                  await _do(() async {
                    await _api.deleteContent(item.id);
                    return null;
                  }, 'Silindi.');
                  if (context.mounted) {
                    context.go('/content/${widget.kind}');
                  }
                },
          child: const Text('Sil'),
        ),
    ];

    bool langEmpty(String l) => _defs
        .where(
          (f) =>
              f.localized &&
              (f.type == _FieldType.line || f.type == _FieldType.markdown),
        )
        .every((f) => _localized[f.key]![l]!.text.trim().isEmpty);
    const langNames = {'az': 'Azərbaycan', 'ru': 'Русский', 'en': 'English'};
    final languages = ContentRules.languages;

    final notices = <Widget>[
      if (_kind == ContentKind.product)
        const Notice(
          key: ValueKey('product-note'),
          icon: Icons.shopping_bag_outlined,
          title: 'Mağaza məhsulu',
          body:
              'Mətni ekspert yoxlayıb təsdiqləyir: "zərərli" sözü, bal və ya '
              'sağlamlıq vədi olmamalıdır. Kampaniyaya bağlansa "Reklam · '
              'brend" nişanı ilə çıxır. Tətbiqdə satış (Parla və ya brend '
              'satır) ödəniş qoşulana qədər tətbiqdə görünmür.',
        ),
      if (_kind == ContentKind.banner &&
          ContentRules.isSponsored(jsonDecode(_json()) as Map<String, Object?>))
        const Notice(
          key: ValueKey('banner-ad-note'),
          icon: Icons.campaign_outlined,
          title: 'Brend kampaniyası (reklam)',
          body:
              'Tətbiqdə "Reklam" nişanı və brendin adı ilə çıxır. Ekspert '
              'yoxlayıb təsdiqləməlidir: "zərərli" sözü, bal və ya sağlamlıq '
              'vədi olmamalıdır. Hədəf yalnız dil, ölkə və yazının '
              'mövzusudur. Brendin saytı varsa, istifadəçidən soruşulur və '
              'sayt brauzerdə açılır.',
        ),
      if (item.reviewNote != null && item.reviewNote!.isNotEmpty)
        Notice(
          tone: NoticeTone.danger,
          icon: Icons.comment_outlined,
          title: 'Mütəxəssisin qeydi',
          body: item.reviewNote!,
        ),
      if (_localized['body']?.values.any(
            (c) => c.text.contains(ContentRules.planMarker),
          ) ??
          false)
        const Notice(
          key: ValueKey('content-plan-left'),
          icon: Icons.edit_note,
          title: 'Mətndə yazı planı var',
          body:
              'Başlıqların altını doldurun və yoxlamaya göndərməzdən əvvəl '
              '"[Yazı planı" blokunu silin.',
        ),
    ];

    final localizedFields = [
      for (final f in _defs.where((f) => f.localized)) ...[
        if (f.type == _FieldType.markdown)
          MarkdownField(
            key: ValueKey('markdown-${f.key}-$_lang'),
            fieldKey: '${f.key}-$_lang',
            controller: _localized[f.key]![_lang]!,
            api: _api,
            enabled: writer,
            onChanged: () => setState(() {}),
          )
        else
          TextField(
            key: ValueKey('field-${f.key}-$_lang'),
            controller: _localized[f.key]![_lang],
            enabled: writer,
            minLines: f.type == _FieldType.line ? 1 : 3,
            maxLines: f.type == _FieldType.line ? 1 : 12,
            style: f.key == 'title' || f.key == 'name'
                ? const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)
                : null,
            decoration: InputDecoration(labelText: f.label),
            onChanged: (_) => setState(() {}),
          ),
        const SizedBox(height: 16),
      ],
    ];

    final sample =
        expertKind &&
        ContentRules.isSampleExpert(
          jsonDecode(item.draftJson) as Map<String, Object?>,
        );
    final plainFields = <Widget>[
      if (sample)
        Container(
          key: const ValueKey('content-sample-note'),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEDA1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Bu nümunə profildir: tətbiqdə "Nümunə" nişanı ilə görünür, '
            'əlaqə düymələri işləmir, razılıq tələb olunmur. Real '
            'mütəxəssisin məlumatı ilə yadda saxlayanda nümunə işarəsi '
            'silinir və dərc üçün yazılı razılıq lazım olur. Qeydiyyat '
            'açılmazdan əvvəl bütün nümunələri silin.',
          ),
        ),
      for (final f in _defs.where((f) => !f.localized && _shown(f))) ...[
        if (f.type == _FieldType.choice)
          _ChipGroup(
            label: f.label,
            children: [
              for (final o in f.options)
                ChoiceChip(
                  key: ValueKey('choice-${f.key}-$o'),
                  label: Text(choiceLabel(o)),
                  selected: _choice[f.key] == o,
                  onSelected: writer
                      ? (on) => setState(() => _choice[f.key] = on ? o : null)
                      : null,
                ),
            ],
          )
        else if (f.type == _FieldType.multi && _optionsOf(f).isEmpty)
          const SizedBox.shrink()
        else if (f.type == _FieldType.multi)
          _ChipGroup(
            label: f.label,
            children: [
              for (final o in _optionsOf(f))
                FilterChip(
                  key: ValueKey('multi-${f.key}-$o'),
                  label: Text(f.key == 'topics' ? categoryLabel(o) : o),
                  selected: _multi[f.key]?.contains(o) ?? false,
                  onSelected: writer
                      ? (on) => setState(() {
                          final set = _multi[f.key] ??= {};
                          on ? set.add(o) : set.remove(o);
                        })
                      : null,
                ),
            ],
          )
        else if (f.type == _FieldType.allergens)
          _allergenChips(writer)
        else if (f.type == _FieldType.groups)
          _ChipGroup(
            label: f.label,
            children: [
              for (final g in ContentRules.plateGroups)
                FilterChip(
                  key: ValueKey('group-$g'),
                  label: Text(groupLabel(g)),
                  selected: _groups.contains(g),
                  onSelected: writer
                      ? (on) => setState(
                          () => on ? _groups.add(g) : _groups.remove(g),
                        )
                      : null,
                ),
            ],
          )
        else
          TextField(
            key: ValueKey('field-${f.key}'),
            controller: _plain[f.key],
            enabled: writer,
            keyboardType: f.type == _FieldType.number
                ? TextInputType.number
                : f.type == _FieldType.urls
                ? TextInputType.multiline
                : TextInputType.text,
            minLines: f.type == _FieldType.urls ? 2 : 1,
            maxLines: f.type == _FieldType.urls ? 10 : 1,
            decoration: InputDecoration(
              labelText: f.label,
              helperText: f.help,
              helperMaxLines: 3,
            ),
            onChanged: (_) => setState(() {}),
          ),
        const SizedBox(height: 14),
      ],
    ];

    final main = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final n in notices) ...[n, const SizedBox(height: 12)],
        PillTabs(
          labels: [for (final l in languages) langNames[l]!],
          keys: [for (final l in languages) ValueKey('lang-$l')],
          badges: [for (final l in languages) langEmpty(l) ? 'boş' : null],
          selected: languages.indexOf(_lang),
          onSelected: (i) => setState(() => _lang = languages[i]),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: localizedFields,
            ),
          ),
        ),
        if (problems.isNotEmpty) ...[
          const SizedBox(height: 14),
          Notice(
            key: const ValueKey('content-problems'),
            tone: NoticeTone.info,
            icon: Icons.checklist_rounded,
            title: 'Yoxlamaya göndərmək üçün çatışmır',
            body:
                '${problems.take(6).join(', ')}'
                '${problems.length > 6 ? ' …' : ''}',
          ),
        ],
      ],
    );

    final side = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!expertKind && !_kind.isCatalogue) ...[
          _WorkflowCard(item: item, kind: _kind),
          const SizedBox(height: 16),
        ],
        if (_kind.isCatalogue) ...[
          Card(
            child: SwitchListTile(
              key: const ValueKey('content-hidden'),
              title: const Text('Tətbiqdə gizlət'),
              subtitle: const Text(
                'Dərhal təsir edir, yoxlama tələb etmir. Gizli element '
                'tətbiqdə təklif olunmur.',
              ),
              value: item.hidden,
              onChanged: writer && !_busy
                  ? (v) => _do(
                      () => _api.setContentHidden(item.id, v),
                      v ? 'Gizlədildi.' : 'Yenidən göstərilir.',
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (const {
          ContentKind.article,
          ContentKind.recipe,
          ContentKind.expert,
          ContentKind.exercise,
          ContentKind.banner,
          ContentKind.product,
        }.contains(_kind)) ...[
          SectionCard(
            title: 'Şəkil',
            child: ImageField(
              api: _api,
              imageId: _imageId,
              enabled: writer,
              onChanged: (id) => setState(() => _imageId = id),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (_kind == ContentKind.exercise) ...[
          SectionCard(
            title: 'Video',
            child: ImageField(
              api: _api,
              imageId: _videoId,
              enabled: writer,
              video: true,
              onChanged: (id) => setState(() => _videoId = id),
            ),
          ),
          const SizedBox(height: 16),
        ],
        SectionCard(
          title: 'Parametrlər',
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!_kind.isCatalogue) ...[
                DropdownButtonFormField<String>(
                  key: const ValueKey('content-category'),
                  isExpanded: true,
                  initialValue: _category,
                  decoration: const InputDecoration(labelText: 'Kateqoriya'),
                  items: [
                    for (final c in ContentRules.categoriesFor(_kind))
                      DropdownMenuItem(value: c, child: Text(categoryLabel(c))),
                  ],
                  onChanged: writer
                      ? (v) => setState(() => _category = v!)
                      : null,
                ),
                const SizedBox(height: 14),
              ],
              if (_kind == ContentKind.banner ||
                  _kind == ContentKind.product) ...[
                _campaignPicker(writer),
                const SizedBox(height: 14),
              ],
              ...plainFields,
              if (plainFields.isEmpty && _kind.isCatalogue)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Text(
                    'Qaydalar və təhlükəsizlik şərtləri kodda qalır; burada '
                    'yalnız mətnlər dəyişir.',
                    style: text.bodySmall,
                  ),
                ),
            ],
          ),
        ),
      ],
    );

    final narrow = MediaQuery.sizeOf(context).width < 700;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: narrow ? 12 : 28,
            vertical: 12,
          ),
          decoration: const BoxDecoration(
            color: AdminColors.white,
            border: Border(bottom: BorderSide(color: AdminColors.line)),
          ),
          child: Wrap(
            spacing: 12,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Siyahıya qayıt',
                    onPressed: () => context.go('/content/${widget.kind}'),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 4),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Semantics(
                          header: true,
                          child: Text(
                            _title(item),
                            style: text.titleMedium?.copyWith(fontSize: 17),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${kindLabel(widget.kind)} · ${item.slug}',
                          style: text.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  StatusPill(item.status),
                  if (item.live) ...[
                    const SizedBox(width: 6),
                    const Pill('canlı', tone: liveTone),
                  ],
                ],
              ),
              Wrap(spacing: 8, runSpacing: 8, children: actions),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: narrow ? 16 : 28,
              vertical: 24,
            ),
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1320),
                  child: LayoutBuilder(
                    builder: (context, c) => c.maxWidth >= 980
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: main),
                              const SizedBox(width: 24),
                              SizedBox(width: 380, child: side),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [main, const SizedBox(height: 24), side],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A label above a row of chips.
class _ChipGroup extends StatelessWidget {
  const _ChipGroup({required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: children),
    ],
  );
}

/// Where an item stands: draft, review, approved, published.
class _WorkflowCard extends StatelessWidget {
  const _WorkflowCard({required this.item, required this.kind});

  final ContentAdminItem item;
  final ContentKind kind;

  @override
  Widget build(BuildContext context) {
    const order = [
      ContentStatus.draft,
      ContentStatus.inReview,
      ContentStatus.approved,
      ContentStatus.published,
    ];
    final at = order.indexOf(item.status);
    return SectionCard(
      title: 'Dərc yolu',
      child: Column(
        children: [
          for (final (i, s) in order.indexed)
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : 12),
              child: Row(
                children: [
                  ExcludeSemantics(
                    child: Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i < at
                            ? AdminColors.espresso
                            : i == at
                            ? AdminColors.sun
                            : AdminColors.white,
                        border: Border.all(
                          color: i <= at
                              ? Colors.transparent
                              : AdminColors.field,
                          width: 2,
                        ),
                      ),
                      child: i < at
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: AdminColors.white,
                            )
                          : i == at
                          ? Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AdminColors.espresso,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      statusLabel(s),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: i == at ? FontWeight.w700 : FontWeight.w500,
                        color: i <= at
                            ? AdminColors.espresso
                            : AdminColors.muted,
                      ),
                    ),
                  ),
                  if (i == at)
                    const Text(
                      'indi',
                      style: TextStyle(fontSize: 13, color: AdminColors.muted),
                    ),
                ],
              ),
            ),
          if (item.live) ...[
            const SizedBox(height: 14),
            const Notice(
              tone: NoticeTone.info,
              icon: Icons.public,
              title: 'Tətbiqdə canlıdır',
              body:
                  'Redaktə canlı mətni dəyişmir; yeni versiya yenidən '
                  'yoxlanılıb dərc olunmalıdır.',
            ),
          ],
        ],
      ),
    );
  }
}
