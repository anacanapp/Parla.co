import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/admin_api.dart';
import '../staff_session.dart';
import '../ui/texts.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';

/// Support conversations (support role and admins). The list shows no
/// message text; opening a conversation is recorded in the audit log.
class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key, required this.state});

  final StaffState state;

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  List<SupportThreadSummary>? _threads;
  SupportThreadSummary? _open;
  List<SupportEntry> _messages = const [];
  final _reply = TextEditingController();
  Object? _error;

  AdminApi get _api => widget.state.api;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  void _snack(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  Future<void> _load() async {
    try {
      final t = await _api.supportThreads();
      if (mounted) setState(() => _threads = t);
    } on Object catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _openThread(SupportThreadSummary t) async {
    try {
      final m = await _api.openSupportThread(t.id);
      if (mounted) {
        setState(() {
          _open = t;
          _messages = m;
        });
      }
    } on Object catch (e) {
      if (mounted) _snack(errorText(e));
    }
  }

  Future<void> _send() async {
    final t = _open;
    final text = _reply.text.trim();
    if (t == null || text.isEmpty) return;
    try {
      await _api.replySupport(t.id, text);
      _reply.clear();
      await _openThread(t);
      await _load();
    } on Object catch (e) {
      if (mounted) _snack(errorText(e));
    }
  }

  Future<void> _close() async {
    final t = _open;
    if (t == null) return;
    try {
      await _api.closeSupportThread(t.id);
      if (mounted) setState(() => _open = null);
      await _load();
    } on Object catch (e) {
      if (mounted) _snack(errorText(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final date = DateFormat('dd.MM.yyyy HH:mm');
    final threads = _threads;
    final open = _open;
    final narrow = MediaQuery.sizeOf(context).width < 700;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: narrow ? 16 : 40,
        vertical: narrow ? 20 : 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PageHeader(
            title: 'Dəstək',
            subtitle:
                'Mesajlarda sağlamlıq məlumatı ola bilər: yalnız lazım olanı '
                'oxuyun, tibbi məsləhət verməyin. Hər açılış audit jurnalına '
                'yazılır. Yazışmalar son mesajdan 12 ay sonra silinir.',
          ),
          const SizedBox(height: 20),
          if (_error != null) ...[
            Notice(
              tone: NoticeTone.danger,
              icon: Icons.error_outline,
              title: errorText(_error!),
            ),
            const SizedBox(height: 12),
          ],
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 340,
                  child: Card(
                    child: threads == null
                        ? const LoadingBlock()
                        : threads.isEmpty
                        ? const EmptyState(
                            title: 'Hələ mesaj yoxdur.',
                            icon: Icons.chat_bubble_outline,
                          )
                        : ListView(
                            children: [
                              for (final t in threads)
                                ListTile(
                                  key: ValueKey('thread-${t.id}'),
                                  selected: open?.id == t.id,
                                  selectedTileColor: AdminColors.sunSoft,
                                  selectedColor: AdminColors.espresso,
                                  leading: t.unreadByStaff
                                      ? const Icon(
                                          Icons.mark_email_unread,
                                          color: AdminColors.espresso,
                                        )
                                      : const Icon(Icons.mail_outline),
                                  title: Text(
                                    t.email,
                                    style: TextStyle(
                                      fontWeight: t.unreadByStaff
                                          ? FontWeight.w800
                                          : FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${date.format(t.lastMessageAt.toLocal())}'
                                    '${t.open ? '' : ' · bağlı'}',
                                  ),
                                  onTap: () => _openThread(t),
                                ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: open == null
                      ? const Card(
                          child: Center(
                            child: EmptyState(
                              title: 'Yazışma seçin.',
                              icon: Icons.forum_outlined,
                            ),
                          ),
                        )
                      : Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(open.email, style: text.titleMedium),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: ListView(
                                    children: [
                                      for (final m in _messages)
                                        Align(
                                          alignment: m.fromStaff
                                              ? Alignment.centerRight
                                              : Alignment.centerLeft,
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 4,
                                            ),
                                            constraints: const BoxConstraints(
                                              maxWidth: 520,
                                            ),
                                            decoration: BoxDecoration(
                                              color: m.fromStaff
                                                  ? AdminColors.sunSoft
                                                  : AdminColors.canvas,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    14,
                                                  ),
                                              border: Border.all(
                                                color: AdminColors.line,
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    m.fromStaff
                                                        ? 'Parla'
                                                        : 'İstifadəçi',
                                                    style: text.labelSmall,
                                                  ),
                                                  Text(m.text),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                TextField(
                                  key: const ValueKey('support-reply'),
                                  controller: _reply,
                                  minLines: 2,
                                  maxLines: 6,
                                  maxLength: 2000,
                                  decoration: const InputDecoration(
                                    labelText: 'Cavab',
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      key: const ValueKey('support-close'),
                                      onPressed: open.open ? _close : null,
                                      child: const Text('Bağla'),
                                    ),
                                    const SizedBox(width: 8),
                                    FilledButton(
                                      key: const ValueKey('support-send'),
                                      onPressed: _send,
                                      child: const Text('Göndər'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
