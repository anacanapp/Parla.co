import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:parla_shared/parla_shared.dart';

import '../api/admin_api.dart';
import '../ui/texts.dart';
import '../ui/theme.dart';
import 'shrink.dart';
import 'video_preview.dart';

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

/// Picks a video file in the browser. Replaced in tests.
Future<Uint8List?> Function() pickVideoFile = () async {
  final file = await FilePicker.pickFile(
    type: FileType.custom,
    allowedExtensions: ['mp4', 'mov', 'm4v', 'webm', 'gif'],
  );
  return file?.readAsBytes();
};

/// The image of a content item (or, with [video], an exercise's video):
/// preview, upload, pick from the library, edit the licence and alt text,
/// or remove it from the item.
class ImageField extends StatefulWidget {
  const ImageField({
    super.key,
    required this.api,
    required this.imageId,
    required this.onChanged,
    required this.enabled,
    this.canDelete = false,
    this.video = false,
  });

  final AdminApi api;
  final int? imageId;
  final ValueChanged<int?> onChanged;
  final bool enabled;
  final bool canDelete;
  final bool video;

  @override
  State<ImageField> createState() => _ImageFieldState();
}

class _ImageFieldState extends State<ImageField> {
  MediaAdminItem? _item;
  Uint8List? _preview;
  bool _busy = false;
  double? _progress;

  String get _type => widget.video ? MediaRules.video : MediaRules.image;

  /// Keys of this field's widgets: `image-…` or `video-…`.
  ValueKey<String> _key(String name) => ValueKey('$_type-$name');

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
      // A video is fetched only when someone presses "Bax".
      final preview = item == null || widget.video
          ? null
          : await widget.api.imagePreview(id);
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
    final file = await (widget.video ? pickVideoFile() : pickImageFile());
    if (file == null || !mounted) return;
    final Uint8List bytes;
    if (widget.video) {
      if (file.isEmpty || file.length > MediaRules.maxVideoUploadBytes) {
        _snack(context, errorText(const AdminError('media.not_video')));
        return;
      }
      bytes = file;
    } else {
      final small = shrinkForUpload(file);
      if (small == null) {
        _snack(context, errorText(const AdminError('media.not_image')));
        return;
      }
      bytes = small;
    }
    final details = await showDialog<_Details>(
      context: context,
      builder: (_) => _DetailsDialog(
        title: widget.video ? 'Yeni video' : 'Yeni şəkil',
        video: widget.video,
      ),
    );
    if (details == null || !mounted) return;
    setState(() {
      _busy = true;
      _progress = widget.video ? 0 : null;
    });
    try {
      final item = widget.video
          ? await widget.api.uploadVideo(
              bytes,
              details.license,
              details.source,
              details.altJson,
              onProgress: (p) {
                if (mounted) setState(() => _progress = p);
              },
            )
          : await widget.api.uploadImage(
              bytes,
              details.license,
              details.source,
              details.altJson,
            );
      widget.onChanged(item.id);
    } on Object catch (e) {
      if (mounted) _snack(context, errorText(e));
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _progress = null;
        });
      }
    }
  }

  Future<void> _watch() async {
    final id = widget.imageId;
    if (id == null) return;
    setState(() => _busy = true);
    Uint8List? bytes;
    try {
      bytes = await widget.api.imagePreview(id);
    } on Object catch (e) {
      if (mounted) _snack(context, errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    if (bytes == null || !mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        content: VideoPreview(bytes: bytes!),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Bağla'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFromLibrary() async {
    final items = [
      for (final i in await widget.api.listImages())
        if (i.mediaType == _type) i,
    ];
    if (!mounted) return;
    final chosen = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kitabxanadan seç'),
        content: SizedBox(
          width: 520,
          height: 420,
          child: items.isEmpty
              ? Text(widget.video ? 'Hələ video yoxdur.' : 'Hələ şəkil yoxdur.')
              : ListView(
                  children: [
                    for (final i in items)
                      ListTile(
                        key: ValueKey('library-${i.id}'),
                        leading: Icon(
                          widget.video
                              ? Icons.movie_outlined
                              : Icons.image_outlined,
                        ),
                        title: Text(ContentRules.pick(_alt(i), 'az')),
                        subtitle: Text(
                          '${i.pixelWidth}×${i.pixelHeight}'
                          '${_seconds(i)} · ${i.license}',
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
      builder: (_) => _DetailsDialog(
        title: widget.video ? 'Videonun məlumatı' : 'Şəklin məlumatı',
        initial: item,
        video: widget.video,
      ),
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

  /// " · 4 san" for a video.
  static String _seconds(MediaAdminItem i) {
    final ms = i.durationMs;
    return ms == null ? '' : ' · ${(ms / 1000).round()} san';
  }

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
      key: _key('field'),
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
                  ? ColoredBox(
                      color: AdminColors.cream,
                      child: Icon(
                        widget.video
                            ? Icons.movie_outlined
                            : Icons.image_outlined,
                      ),
                    )
                  : Image.memory(_preview!, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.video ? 'Video' : 'Şəkil',
                    style: text.titleSmall,
                  ),
                  if (item != null) ...[
                    Text(
                      ContentRules.pick(_alt(item), 'az'),
                      key: _key('alt'),
                    ),
                    Text(
                      'Lisenziya: ${item.license}'
                      '${widget.video ? _seconds(item) : ''}',
                      style: text.bodySmall,
                    ),
                    if (missing.isNotEmpty)
                      Text(
                        'Dərc üçün çatışmır: ${missing.join(', ')}',
                        key: _key('missing'),
                        style: text.bodySmall?.copyWith(
                          color: AdminColors.muted,
                        ),
                      ),
                  ] else
                    Text(
                      widget.imageId == null
                          ? (widget.video ? 'Video yoxdur.' : 'Şəkil yoxdur.')
                          : '…',
                      style: text.bodySmall,
                    ),
                  if (_progress case final p?) ...[
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      key: _key('progress'),
                      value: p < 1 ? p : null,
                    ),
                    Text(
                      p < 1
                          ? 'Göndərilir… ${(p * 100).round()}%'
                          : 'Server videonu emal edir…',
                      style: text.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 8),
                  if (widget.enabled)
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        OutlinedButton.icon(
                          key: _key('upload'),
                          onPressed: _busy ? null : _upload,
                          icon: const Icon(Icons.upload),
                          label: const Text('Yüklə'),
                        ),
                        OutlinedButton(
                          key: _key('library'),
                          onPressed: _busy ? null : _pickFromLibrary,
                          child: const Text('Kitabxanadan'),
                        ),
                        if (item != null && widget.video)
                          TextButton(
                            key: _key('watch'),
                            onPressed: _busy ? null : _watch,
                            child: const Text('Bax'),
                          ),
                        if (item != null)
                          TextButton(
                            key: _key('edit'),
                            onPressed: _edit,
                            child: const Text('Məlumatı dəyiş'),
                          ),
                        if (widget.imageId != null)
                          TextButton(
                            key: _key('remove'),
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
  const _DetailsDialog({
    required this.title,
    this.initial,
    this.video = false,
  });

  final String title;
  final MediaAdminItem? initial;
  final bool video;

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
                      ? (widget.video
                            ? 'Videoda nə edilir (ekran oxuyucular üçün)'
                            : 'Şəkildə nə görünür (ekran oxuyucular üçün)')
                      : null,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              widget.video
                  ? 'Video serverdə yenidən kodlanır: səs, kamera, yer (GPS) və '
                        'tarix məlumatı silinir; ən çox 720px və '
                        '${MediaRules.maxVideoSeconds} saniyə saxlanır. Videoda '
                        'görünən insanın yazılı icazəsi və hərəkətin məşqçi '
                        'tərəfindən yoxlanması lazımdır.'
                  : 'Şəkil serverdə yenidən kodlanır: kamera, yer (GPS) və '
                        'tarix məlumatı silinir. İnsan olan şəkillər üçün '
                        'yazılı icazə lazımdır.',
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
