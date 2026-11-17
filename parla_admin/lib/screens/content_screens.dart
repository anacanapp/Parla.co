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

void _snack(BuildContext context, String text) => ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text(text)));

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
          'Məzmun cədvəlindəki bloqlar və reseptlər qaralama kimi əlavə '
          'olunur. Artıq olan yazılara toxunulmur, heç nə dərc olunmur.',
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
      _snack(context, '$added yazı qaralama kimi əlavə olundu.');
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
    return ListTile(
      key: ValueKey('catalogue-$id'),
      title: Text(item == null ? _defaultTitle(_kind, id) : _title(item)),
      subtitle: Text(
        [
          id,
          if (item == null) 'tətbiqdəki mətn',
          if (item?.live ?? false) 'canlı',
          if (item?.hidden ?? false) 'gizli',
        ].join(' · '),
      ),
      trailing: item == null
          ? null
          : Chip(label: Text(statusLabel(item.status))),
      onTap: () => _openCatalogue(id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final items = _items;
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text('Məzmun', style: text.headlineMedium),
              ),
            ),
            if (widget.state.me?.role == StaffRole.admin &&
                (_kind == ContentKind.article ||
                    _kind == ContentKind.recipe)) ...[
              OutlinedButton.icon(
                key: const ValueKey('content-import'),
                onPressed: _importSheet,
                icon: const Icon(Icons.table_view_outlined),
                label: const Text('Cədvəldən idxal et'),
              ),
              const SizedBox(width: 8),
            ],
            if (_canWrite(widget.state) && !_kind.isCatalogue)
              FilledButton.icon(
                key: const ValueKey('content-new'),
                onPressed: _create,
                icon: const Icon(Icons.add),
                label: const Text('Yeni'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final k in ContentKind.values)
              ChoiceChip(
                label: Text(kindLabel(k.name)),
                selected: k.name == widget.kind,
                onSelected: (_) => context.go('/content/${k.name}'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Axın: redaktor yazır → mütəxəssis yoxlayır → dərc olunur. '
          'Dərc olunmuş yazını redaktə etmək canlı mətni dəyişmir; yeni '
          'versiya yenidən yoxlanılır.',
          style: text.bodySmall?.copyWith(color: AdminColors.muted),
        ),
        const SizedBox(height: 16),
        if (_error != null) Text(errorText(_error!)),
        if (items == null && _error == null)
          const Center(child: CircularProgressIndicator()),
        if (_kind.isCatalogue && items != null)
          Text(
            'Burada yalnız mətnlər${_kind == ContentKind.exercise ? ', şəkil' : ''} '
            'və tətbiqdə göstərmək/gizlətmək dəyişir. Qaydalar və '
            'təhlükəsizlik şərtləri kodda qalır.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        if (_kind.isCatalogue && items != null)
          Card(
            elevation: 0,
            color: AdminColors.white,
            child: Column(
              children: [
                for (final id in ContentRules.catalogueIds(_kind))
                  _catalogueTile(id, items),
              ],
            ),
          ),
        if (!_kind.isCatalogue && items != null && items.isEmpty)
          const Text('Hələ heç nə yoxdur.'),
        if (!_kind.isCatalogue && items != null && items.isNotEmpty)
          Card(
            elevation: 0,
            color: AdminColors.white,
            child: Column(
              children: [
                for (final item in items)
                  ListTile(
                    key: ValueKey('content-${item.id}'),
                    title: Text(_title(item)),
                    subtitle: Text(
                      [
                        item.slug,
                        categoryLabel(item.category),
                        if (item.live) 'canlı',
                      ].join(' · '),
                    ),
                    trailing: Chip(label: Text(statusLabel(item.status))),
                    onTap: () =>
                        context.go('/content/${widget.kind}/${item.id}'),
                  ),
              ],
            ),
          ),
      ],
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
      'Keçid',
      _FieldType.plain,
      localized: false,
      help:
          'Ekran: home, routine, check, sport, discover, blog, nutrition, '
          'experts; və ya article:slug, recipe:slug. Xarici link olmur.',
    ),
    _Field(
      'sponsor',
      'Brend (yalnız ödənişli kampaniya üçün)',
      _FieldType.plain,
      localized: false,
      help:
          'Doldurulsa banner "Reklam" nişanı ilə çıxır və ekspert təsdiqi lazımdır.',
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
  Object? _error;
  bool _busy = false;
  String _category = '';
  final Set<String> _groups = {};

  int? _imageId;

  /// Values of [_FieldType.multi] fields.
  final Map<String, Set<String>> _multi = {};

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
          f.type == _FieldType.multi) {
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

    for (final f in _defs) {
      switch (f.type) {
        case _FieldType.groups:
          if (_groups.isNotEmpty) {
            out['groups'] = [
              for (final g in ContentRules.plateGroups)
                if (_groups.contains(g)) g,
            ];
          }
        case _FieldType.multi:
          final chosen = _multi[f.key] ?? const {};
          if (chosen.isNotEmpty) {
            out[f.key] = [
              for (final o in f.options)
                if (chosen.contains(o)) o,
            ];
          }
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
    if (_imageId != null) out['image'] = _imageId;
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

    return DefaultTabController(
      length: 3,
      child: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Siyahıya qayıt',
                onPressed: () => context.go('/content/${widget.kind}'),
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(item.slug, style: text.headlineSmall),
                ),
              ),
              Chip(label: Text(statusLabel(item.status))),
              if (item.live) ...[
                const SizedBox(width: 8),
                const Chip(label: Text('canlı')),
              ],
            ],
          ),
          if (_kind == ContentKind.banner &&
              ContentRules.isSponsored(
                jsonDecode(_json()) as Map<String, Object?>,
              ))
            const Card(
              key: ValueKey('banner-ad-note'),
              color: AdminColors.cream,
              child: ListTile(
                leading: Icon(Icons.campaign_outlined),
                title: Text('Brend kampaniyası (reklam)'),
                subtitle: Text(
                  'Tətbiqdə "Reklam" nişanı və brendin adı ilə çıxır. '
                  'Ekspert yoxlayıb təsdiqləməlidir: "zərərli" sözü, bal və '
                  'ya sağlamlıq vədi olmamalıdır. Hədəf yalnız dil və ölkədir.',
                ),
              ),
            ),
          if (item.reviewNote != null && item.reviewNote!.isNotEmpty)
            Card(
              color: AdminColors.cream,
              child: ListTile(
                leading: const Icon(Icons.comment_outlined),
                title: const Text('Mütəxəssisin qeydi'),
                subtitle: Text(item.reviewNote!),
              ),
            ),
          if (_localized['body']?.values.any(
                (c) => c.text.contains(ContentRules.planMarker),
              ) ??
              false)
            const Card(
              key: ValueKey('content-plan-left'),
              color: AdminColors.cream,
              child: ListTile(
                leading: Icon(Icons.edit_note),
                title: Text('Mətndə yazı planı var'),
                subtitle: Text(
                  'Başlıqların altını doldurun və yoxlamaya göndərməzdən '
                  'əvvəl "[Yazı planı" blokunu silin.',
                ),
              ),
            ),
          const SizedBox(height: 12),
          if (!_kind.isCatalogue)
            DropdownButtonFormField<String>(
              key: const ValueKey('content-category'),
              isExpanded: true,
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Kateqoriya'),
              items: [
                for (final c in ContentRules.categoriesFor(_kind))
                  DropdownMenuItem(value: c, child: Text(categoryLabel(c))),
              ],
              onChanged: writer ? (v) => setState(() => _category = v!) : null,
            ),
          const SizedBox(height: 16),
          if (_kind.isCatalogue)
            SwitchListTile(
              key: const ValueKey('content-hidden'),
              contentPadding: EdgeInsets.zero,
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
          if (const {
            ContentKind.article,
            ContentKind.recipe,
            ContentKind.expert,
            ContentKind.exercise,
            ContentKind.banner,
          }.contains(_kind)) ...[
            ImageField(
              api: _api,
              imageId: _imageId,
              enabled: writer,
              onChanged: (id) => setState(() => _imageId = id),
            ),
            const SizedBox(height: 16),
          ],
          for (final f in _defs.where((f) => !f.localized)) ...[
            if (f.type == _FieldType.multi)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(f.label),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final o in f.options)
                        FilterChip(
                          key: ValueKey('multi-${f.key}-$o'),
                          label: Text(o),
                          selected: _multi[f.key]?.contains(o) ?? false,
                          onSelected: writer
                              ? (on) => setState(() {
                                  final set = _multi[f.key] ??= {};
                                  on ? set.add(o) : set.remove(o);
                                })
                              : null,
                        ),
                    ],
                  ),
                ],
              )
            else if (f.type == _FieldType.allergens)
              _allergenChips(writer)
            else if (f.type == _FieldType.groups)
              Wrap(
                spacing: 8,
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
            const SizedBox(height: 12),
          ],
          const TabBar(
            tabs: [
              Tab(text: 'Azərbaycan'),
              Tab(text: 'Русский'),
              Tab(text: 'English'),
            ],
          ),
          SizedBox(
            height: 640,
            child: TabBarView(
              children: [
                for (final lang in ContentRules.languages)
                  ListView(
                    padding: const EdgeInsets.only(top: 16),
                    children: [
                      for (final f in _defs.where((f) => f.localized)) ...[
                        if (f.type == _FieldType.markdown)
                          MarkdownField(
                            fieldKey: '${f.key}-$lang',
                            controller: _localized[f.key]![lang]!,
                            api: _api,
                            enabled: writer,
                            onChanged: () => setState(() {}),
                          )
                        else
                          TextField(
                            key: ValueKey('field-${f.key}-$lang'),
                            controller: _localized[f.key]![lang],
                            enabled: writer,
                            minLines: f.type == _FieldType.line ? 1 : 3,
                            maxLines: f.type == _FieldType.line ? 1 : 12,
                            decoration: InputDecoration(labelText: f.label),
                            onChanged: (_) => setState(() {}),
                          ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (problems.isNotEmpty)
            Text(
              'Yoxlamaya göndərmək üçün çatışmır: ${problems.take(6).join(', ')}'
              '${problems.length > 6 ? ' …' : ''}',
              key: const ValueKey('content-problems'),
              style: text.bodySmall?.copyWith(color: AdminColors.muted),
            ),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: actions),
        ],
      ),
    );
  }
}
