import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:parla_shared/parla_shared.dart';

import '../api/admin_api.dart';
import '../ui/texts.dart';
import '../ui/theme.dart';
import 'shrink.dart';

void _snack(BuildContext context, String text) => ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text(text)));

/// Picks an image file in the browser. Replaced in tests.
Future<Uint8List?> Function() pickImageFile = () async {
  final file = await FilePicker.pickFile(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
  );
  return file?.readAsBytes();
};

/// The image of a content item: preview, upload, pick from the library,
/// edit the licence and alt text, or remove it from the item.
class ImageField extends StatefulWidget {
  const ImageField({
    super.key,
    required this.api,
    required this.imageId,
    required this.onChanged,
    required this.enabled,
    this.canDelete = false,
  });

  final AdminApi api;
  final int? imageId;
  final ValueChanged<int?> onChanged;
  final bool enabled;
  final bool canDelete;

  @override
  State<ImageField> createState() => _ImageFieldState();
}

class _ImageFieldState extends State<ImageField> {
  MediaAdminItem? _item;
  Uint8List? _preview;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(ImageField old) {
    super.didUpdateWidget(old);
    if (old.imageId != widget.imageId) _load();
  }

  Future<void> _load() async {
    final id = widget.imageId;
    if (id == null) {
      setState(() {
        _item = null;
        _preview = null;
      });
      return;
    }
    try {
      final items = await widget.api.listImages();
      final item = items.where((i) => i.id == id).firstOrNull;
      final preview = item == null ? null : await widget.api.imagePreview(id);
      if (mounted) {
        setState(() {
          _item = item;
          _preview = preview;
        });
      }
    } on Object catch (e) {
      if (mounted) _snack(context, errorText(e));
    }
  }

  Future<void> _upload() async {
    final file = await pickImageFile();
    if (file == null || !mounted) return;
    final small = shrinkForUpload(file);
    if (small == null) {
      _snack(context, errorText(const AdminError('media.not_image')));
      return;
    }
    final details = await showDialog<_Details>(
      context: context,
      builder: (_) => const _DetailsDialog(title: 'Yeni şəkil'),
    );
    if (details == null || !mounted) return;
    setState(() => _busy = true);
    try {
      final item = await widget.api.uploadImage(
        small,
        details.license,
        details.source,
        details.altJson,
      );
      widget.onChanged(item.id);
    } on Object catch (e) {
      if (mounted) _snack(context, errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickFromLibrary() async {
    final items = await widget.api.listImages();
    if (!mounted) return;
    final chosen = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kitabxanadan seç'),
        content: SizedBox(
          width: 520,
          height: 420,
          child: items.isEmpty
              ? const Text('Hələ şəkil yoxdur.')
              : ListView(
                  children: [
                    for (final i in items)
                      ListTile(
                        key: ValueKey('library-${i.id}'),
                        leading: const Icon(Icons.image_outlined),
                        title: Text(ContentRules.pick(_alt(i), 'az')),
                        subtitle: Text(
                          '${i.pixelWidth}×${i.pixelHeight} · ${i.license}',
                        ),
                        onTap: () => Navigator.of(context).pop(i.id),
                      ),
                  ],
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ləğv et'),
          ),
        ],
      ),
    );
    if (chosen != null) widget.onChanged(chosen);
  }

  Future<void> _edit() async {
    final item = _item;
    if (item == null) return;
    final details = await showDialog<_Details>(
      context: context,
      builder: (_) => _DetailsDialog(title: 'Şəklin məlumatı', initial: item),
    );
    if (details == null || !mounted) return;
    try {
      final updated = await widget.api.updateImage(
        item.id,
        details.license,
        details.source,
        details.altJson,
      );
      if (mounted) setState(() => _item = updated);
    } on Object catch (e) {
      if (mounted) _snack(context, errorText(e));
    }
  }

  static Map<String, Object?> _alt(MediaAdminItem i) =>
      jsonDecode(i.altJson) as Map<String, Object?>;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final item = _item;
    final missing = item == null
        ? const <String>[]
        : MediaRules.problems(
            license: item.license,
            source: item.source,
            altJson: item.altJson,
            complete: true,
          );
    return Card(
      key: const ValueKey('image-field'),
      elevation: 0,
      color: AdminColors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              height: 90,
              child: _preview == null
                  ? const ColoredBox(
                      color: AdminColors.cream,
                      child: Icon(Icons.image_outlined),
                    )
                  : Image.memory(_preview!, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Şəkil', style: text.titleSmall),
                  if (item != null) ...[
                    Text(
                      ContentRules.pick(_alt(item), 'az'),
                      key: const ValueKey('image-alt'),
                    ),
                    Text(
                      'Lisenziya: ${item.license}',
                      style: text.bodySmall,
                    ),
                    if (missing.isNotEmpty)
                      Text(
                        'Dərc üçün çatışmır: ${missing.join(', ')}',
                        key: const ValueKey('image-missing'),
                        style: text.bodySmall?.copyWith(
                          color: AdminColors.muted,
                        ),
                      ),
                  ] else
                    Text(
                      widget.imageId == null ? 'Şəkil yoxdur.' : '…',
                      style: text.bodySmall,
                    ),
                  const SizedBox(height: 8),
                  if (widget.enabled)
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        OutlinedButton.icon(
                          key: const ValueKey('image-upload'),
                          onPressed: _busy ? null : _upload,
                          icon: const Icon(Icons.upload),
                          label: const Text('Yüklə'),
                        ),
                        OutlinedButton(
                          key: const ValueKey('image-library'),
                          onPressed: _busy ? null : _pickFromLibrary,
                          child: const Text('Kitabxanadan'),
                        ),
                        if (item != null)
                          TextButton(
                            key: const ValueKey('image-edit'),
                            onPressed: _edit,
                            child: const Text('Məlumatı dəyiş'),
                          ),
                        if (widget.imageId != null)
                          TextButton(
                            key: const ValueKey('image-remove'),
                            onPressed: () => widget.onChanged(null),
                            child: const Text('Yazıdan çıxar'),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Details {
  const _Details(this.license, this.source, this.altJson);

  final String license;
  final String? source;
  final String altJson;
}

/// Licence, source and alt text in three languages.
class _DetailsDialog extends StatefulWidget {
  const _DetailsDialog({required this.title, this.initial});

  final String title;
  final MediaAdminItem? initial;

  @override
  State<_DetailsDialog> createState() => _DetailsDialogState();
}

class _DetailsDialogState extends State<_DetailsDialog> {
  late final _license = TextEditingController(text: widget.initial?.license);
  late final _source = TextEditingController(text: widget.initial?.source);
  late final Map<String, TextEditingController> _alt = {
    for (final l in ContentRules.languages)
      l: TextEditingController(
        text: widget.initial == null
            ? ''
            : ContentRules.pick(
                (jsonDecode(widget.initial!.altJson) as Map)[l],
                l,
              ),
      ),
  };
  String? _error;

  @override
  void dispose() {
    _license.dispose();
    _source.dispose();
    for (final c in _alt.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    final alt = jsonEncode({
      for (final e in _alt.entries)
        if (e.value.text.trim().isNotEmpty) e.key: e.value.text.trim(),
    });
    final source = _source.text.trim();
    final problems = MediaRules.problems(
      license: _license.text,
      source: source.isEmpty ? null : source,
      altJson: alt,
    );
    if (problems.isNotEmpty) {
      setState(() => _error = 'Düzəldin: ${problems.join(', ')}');
      return;
    }
    Navigator.of(
      context,
    ).pop(_Details(_license.text.trim(), source.isEmpty ? null : source, alt));
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: SizedBox(
      width: 460,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const ValueKey('image-license'),
              controller: _license,
              decoration: const InputDecoration(
                labelText: 'Lisenziya / icazə (vacib)',
                helperText: 'Məs.: "Unsplash lisenziyası", "öz fotomuz"',
              ),
            ),
            TextField(
              key: const ValueKey('image-source'),
              controller: _source,
              decoration: const InputDecoration(
                labelText: 'Mənbə (link və ya müəllif)',
              ),
            ),
            for (final (lang, label) in [
              ('az', 'Alternativ mətn (AZ)'),
              ('ru', 'Alternativ mətn (RU)'),
              ('en', 'Alternativ mətn (EN)'),
            ])
              TextField(
                key: ValueKey('image-alt-$lang'),
                controller: _alt[lang],
                maxLength: MediaRules.maxAlt,
                decoration: InputDecoration(
                  labelText: label,
                  helperText: lang == 'az'
                      ? 'Şəkildə nə görünür (ekran oxuyucular üçün)'
                      : null,
                ),
              ),
            const SizedBox(height: 8),
            const Text(
              'Şəkil serverdə yenidən kodlanır: kamera, yer (GPS) və tarix '
              'məlumatı silinir. İnsan olan şəkillər üçün yazılı icazə '
              'lazımdır.',
            ),
            if (_error != null)
              Text(
                _error!,
                key: const ValueKey('image-error'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Ləğv et'),
      ),
      FilledButton(
        key: const ValueKey('image-save'),
        onPressed: _save,
        child: const Text('Yadda saxla'),
      ),
    ],
  );
}
