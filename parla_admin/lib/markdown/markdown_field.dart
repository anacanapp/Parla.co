import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../api/admin_api.dart';
import '../media/image_field.dart';
import '../ui/theme.dart';
import 'clipboard_html.dart';
import 'html_to_markdown.dart';

/// Reads rich clipboard HTML. Replaced in tests.
Future<String?> Function() readRichClipboard = readClipboardHtml;

/// The article text in Markdown: a toolbar (paste from Google Docs, add an
/// image, preview), the editor and a live preview.
class MarkdownField extends StatefulWidget {
  const MarkdownField({
    super.key,
    required this.fieldKey,
    required this.controller,
    required this.api,
    required this.enabled,
    required this.onChanged,
  });

  final String fieldKey;
  final TextEditingController controller;
  final AdminApi api;
  final bool enabled;
  final VoidCallback onChanged;

  @override
  State<MarkdownField> createState() => _MarkdownFieldState();
}

class _MarkdownFieldState extends State<MarkdownField> {
  bool _preview = false;

  void _snack(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  void _insert(String text) {
    final c = widget.controller;
    final sel = c.selection;
    final start = sel.isValid ? sel.start : c.text.length;
    final end = sel.isValid ? sel.end : c.text.length;
    c.value = TextEditingValue(
      text: c.text.replaceRange(start, end, text),
      selection: TextSelection.collapsed(offset: start + text.length),
    );
    widget.onChanged();
  }

  Future<void> _pasteFromDocs() async {
    final html = await readRichClipboard();
    if (!mounted) return;
    if (html == null || html.trim().isEmpty) {
      _snack(
        'Buferdə formatlı mətn tapılmadı. Google Docs-da mətni seçib '
        'kopyalayın, sonra yenidən basın (brauzer icazə istəyə bilər).',
      );
      return;
    }
    final md = htmlToMarkdown(html);
    _insert(widget.controller.text.trim().isEmpty ? md : '\n\n$md\n\n');
    widget.controller.text = cleanMarkdown(widget.controller.text);
    widget.onChanged();
    _snack('Google Docs-dan köçürüldü. Şəkilləri ayrıca əlavə edin.');
  }

  Future<void> _addImage() async {
    final id = await showDialog<int>(
      context: context,
      builder: (context) => _ImagePickDialog(api: widget.api),
    );
    if (id != null) _insert('\n\n![](media:$id)\n\n');
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Mətn (Markdown)', style: text.titleSmall),
            if (widget.enabled) ...[
              OutlinedButton.icon(
                key: ValueKey('md-paste-${widget.fieldKey}'),
                onPressed: _pasteFromDocs,
                icon: const Icon(Icons.content_paste, size: 18),
                label: const Text('Google Docs-dan yapışdır'),
              ),
              OutlinedButton.icon(
                key: ValueKey('md-image-${widget.fieldKey}'),
                onPressed: _addImage,
                icon: const Icon(Icons.image_outlined, size: 18),
                label: const Text('Şəkil əlavə et'),
              ),
            ],
            FilterChip(
              key: ValueKey('md-preview-${widget.fieldKey}'),
              label: const Text('Önizləmə'),
              selected: _preview,
              onSelected: (v) => setState(() => _preview = v),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '## Başlıq, **qalın**, *kursiv*, - siyahı, 1. nömrəli, > sitat, '
          '[mətn](https://link). HTML işləmir.',
          style: text.bodySmall?.copyWith(color: AdminColors.muted),
        ),
        const SizedBox(height: 8),
        if (_preview)
          Container(
            key: ValueKey('md-preview-box-${widget.fieldKey}'),
            constraints: const BoxConstraints(minHeight: 160),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AdminColors.white,
              border: Border.all(
                color: AdminColors.muted.withValues(alpha: .3),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: MarkdownBody(
              data: widget.controller.text,
              selectable: true,
              imageBuilder: (uri, title, alt) {
                final m = RegExp(r'^media:(\d+)$').firstMatch('$uri');
                if (m == null) return const SizedBox.shrink();
                return _PreviewImage(
                  api: widget.api,
                  id: int.parse(m.group(1)!),
                );
              },
            ),
          )
        else
          TextField(
            key: ValueKey('field-${widget.fieldKey}'),
            controller: widget.controller,
            enabled: widget.enabled,
            minLines: 10,
            maxLines: 30,
            style: const TextStyle(fontFamily: 'monospace', height: 1.4),
            decoration: const InputDecoration(
              hintText: 'Mətni yazın və ya Google Docs-dan yapışdırın',
            ),
            onChanged: (_) => widget.onChanged(),
          ),
      ],
    );
  }
}

class _PreviewImage extends StatelessWidget {
  const _PreviewImage({required this.api, required this.id});

  final AdminApi api;
  final int id;

  @override
  Widget build(BuildContext context) => FutureBuilder<Uint8List>(
    future: api.imagePreview(id),
    builder: (context, snap) => snap.hasData
        ? ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 240),
            child: Image.memory(snap.data!, fit: BoxFit.contain),
          )
        : const SizedBox(height: 40, child: Icon(Icons.image_outlined)),
  );
}

/// Upload a new image or pick one from the library; returns its id.
class _ImagePickDialog extends StatelessWidget {
  const _ImagePickDialog({required this.api});

  final AdminApi api;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Mətnə şəkil'),
    content: SizedBox(
      width: 520,
      child: ImageField(
        api: api,
        imageId: null,
        enabled: true,
        onChanged: (id) {
          if (id != null) Navigator.of(context).pop(id);
        },
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Ləğv et'),
      ),
    ],
  );
}
