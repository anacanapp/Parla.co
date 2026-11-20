import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../discover/discover_widgets.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/parla_icons.dart';
import 'journal_book.dart';

/// The private journal: entries by day, newest first. Kept only on this
/// phone (see [JournalBook]).
class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final locale = Localizations.localeOf(context).toString();
    final scope = ParlaScope.of(context);
    final book = scope.journal;
    if (!book.loaded) scope.attachAccount();
    return ListenableBuilder(
      listenable: book,
      builder: (context, _) {
        final byDay = <String, List<JournalEntry>>{};
        for (final e in book.entries) {
          byDay
              .putIfAbsent(
                DateFormat.yMMMMd(locale).format(e.createdAt),
                () => [],
              )
              .add(e);
        }
        return SubPage(
          title: l10n.discoverJournal,
          onBack: () => context.go(Routes.discover),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ParlaColors.lilac,
                borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ParlaIcon(ParlaIconName.lock, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(l10n.journalIntro, style: text.bodyMedium),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              key: const ValueKey('journal-new'),
              onPressed: () => context.go(Routes.journalEntry),
              icon: const ParlaIcon(
                ParlaIconName.plus,
                size: 20,
                color: ParlaColors.white,
              ),
              label: Text(l10n.journalNew),
            ),
            const SizedBox(height: 18),
            if (book.entries.isEmpty)
              Text(
                l10n.journalEmpty,
                style: text.bodyMedium?.copyWith(color: ParlaColors.muted),
              ),
            for (final day in byDay.entries) ...[
              Semantics(
                header: true,
                child: Text(
                  day.key.toUpperCase(),
                  style: text.labelMedium?.copyWith(
                    color: ParlaColors.sunInk,
                    letterSpacing: .6,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              for (final e in day.value)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    color: ParlaColors.white,
                    borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      key: ValueKey('journal-${e.id}'),
                      onTap: () => context.go(Routes.journalEntry, extra: e.id),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat.Hm(locale).format(e.createdAt),
                              style: text.labelMedium?.copyWith(
                                color: ParlaColors.muted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              e.text,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: text.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
            ],
          ],
        );
      },
    );
  }
}

/// Writes a new entry, or edits [id]. Leaving with Back keeps what was
/// written; blank text keeps nothing.
class JournalEntryScreen extends StatefulWidget {
  const JournalEntryScreen({super.key, this.id});

  final String? id;

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  late final TextEditingController _text;
  String _initial = '';
  bool _started = false;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _text = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final id = widget.id;
    if (id != null) {
      _initial = ParlaScope.of(context).journal.find(id)?.text ?? '';
      _text.text = _initial;
    }
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  /// Saves (if changed) and goes back to the list.
  Future<void> _close() async {
    if (_done) return;
    _done = true;
    final l10n = AppLocalizations.of(context);
    final book = ParlaScope.of(context).journal;
    if (_text.text.trim() != _initial.trim()) {
      final ok = await book.save(id: widget.id, text: _text.text);
      if (!ok && mounted) {
        _done = false;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.journalFull)));
        return;
      }
    }
    if (mounted) context.go(Routes.journal);
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final id = widget.id;
    if (id == null) return;
    final sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.journalDeleteTitle),
        content: Text(l10n.journalDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.privacyCancel),
          ),
          TextButton(
            key: const ValueKey('journal-delete-confirm'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.journalDelete),
          ),
        ],
      ),
    );
    if (sure != true || !mounted) return;
    _done = true;
    await ParlaScope.of(context).journal.delete(id);
    if (mounted) context.go(Routes.journal);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _close();
      },
      child: Scaffold(
        backgroundColor: ParlaColors.cream,
        appBar: AppBar(
          backgroundColor: ParlaColors.cream,
          leading: BackButton(onPressed: _close),
          title: Text(l10n.journalEntryTitle),
          actions: [
            if (widget.id != null)
              IconButton(
                key: const ValueKey('journal-delete'),
                tooltip: l10n.journalDelete,
                onPressed: _delete,
                icon: const Icon(Icons.delete_outline),
              ),
            TextButton(
              key: const ValueKey('journal-save'),
              onPressed: _close,
              child: Text(l10n.journalSave),
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              ParlaSpace.page,
              4,
              ParlaSpace.page,
              16,
            ),
            child: TextField(
              key: const ValueKey('journal-text'),
              controller: _text,
              autofocus: widget.id == null,
              maxLength: JournalRules.maxLength,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(hintText: l10n.journalHint),
            ),
          ),
        ),
      ),
    );
  }
}
