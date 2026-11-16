import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../api/admin_api.dart';
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
            if (_canWrite(widget.state))
              FilledButton.icon(
                key: const ValueKey('content-new'),
                onPressed: _create,
                icon: const Icon(Icons.add),
                label: const Text('Yeni'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        SegmentedButton<String>(
          segments: [
            for (final k in ContentKind.values)
              ButtonSegment(value: k.name, label: Text(kindLabel(k.name))),
          ],
          selected: {widget.kind},
          onSelectionChanged: (s) => context.go('/content/${s.first}'),
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
        if (items != null && items.isEmpty) const Text('Hələ heç nə yoxdur.'),
        if (items != null && items.isNotEmpty)
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

String _title(ContentAdminItem item) {
  final json = jsonDecode(item.draftJson) as Map<String, Object?>;
  final title = json['title'] ?? json['name'];
  final value = ContentRules.pick(title, 'az');
  return value.isEmpty ? '(adsız)' : value;
}

enum _FieldType { line, multiline, lines, number, groups, plain }

class _Field {
  const _Field(this.key, this.label, this.type, {this.localized = true});

  final String key;
  final String label;
  final _FieldType type;
  final bool localized;
}

const _fields = <String, List<_Field>>{
  'article': [
    _Field('title', 'Başlıq', _FieldType.line),
    _Field('summary', 'Qısa təsvir', _FieldType.multiline),
    _Field('body', 'Mətn', _FieldType.multiline),
    _Field('tips', 'Addımlar (hər sətir bir addım)', _FieldType.lines),
    _Field('minutes', 'Oxuma vaxtı (dəq)', _FieldType.number, localized: false),
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
  final Map<String, TextEditingController> _plain = {};
  final Map<String, Map<String, TextEditingController>> _localized = {};

  AdminApi get _api => widget.state.api;
  List<_Field> get _defs => _fields[widget.kind]!;
  ContentKind get _kind => ContentKind.values.byName(widget.kind);

  @override
  void initState() {
    super.initState();
    for (final f in _defs) {
      if (f.type == _FieldType.groups) continue;
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
    for (final f in _defs) {
      switch (f.type) {
        case _FieldType.groups:
          _groups
            ..clear()
            ..addAll((json['groups'] as List? ?? const []).cast<String>());
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
        case _FieldType.line || _FieldType.multiline:
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
        case _FieldType.line || _FieldType.multiline:
          final v = loc(f.key);
          if (v != null) out[f.key] = v;
      }
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
    final problems = ContentRules.problems(_kind, _json(), complete: true);

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
      if (role == StaffRole.expert &&
          item.status == ContentStatus.inReview) ...[
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
              : item.status == ContentStatus.approved))
        FilledButton(
          key: const ValueKey('content-publish'),
          onPressed: _busy
              ? null
              : () => _do(() => _api.publishContent(item.id), 'Dərc olundu.'),
          child: const Text('Dərc et'),
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
          if (item.reviewNote != null && item.reviewNote!.isNotEmpty)
            Card(
              color: AdminColors.cream,
              child: ListTile(
                leading: const Icon(Icons.comment_outlined),
                title: const Text('Mütəxəssisin qeydi'),
                subtitle: Text(item.reviewNote!),
              ),
            ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: const ValueKey('content-category'),
            initialValue: _category,
            decoration: const InputDecoration(labelText: 'Kateqoriya'),
            items: [
              for (final c in ContentRules.categoriesFor(_kind))
                DropdownMenuItem(value: c, child: Text(categoryLabel(c))),
            ],
            onChanged: writer ? (v) => setState(() => _category = v!) : null,
          ),
          const SizedBox(height: 16),
          for (final f in _defs.where((f) => !f.localized)) ...[
            if (f.type == _FieldType.groups)
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
                    : TextInputType.text,
                decoration: InputDecoration(labelText: f.label),
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
