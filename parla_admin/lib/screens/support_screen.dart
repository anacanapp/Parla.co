import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/admin_api.dart';
import '../staff_session.dart';
import '../ui/texts.dart';
import '../ui/theme.dart';

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
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text('Dəstək', style: text.headlineMedium),
          ),
          const SizedBox(height: 8),
          Text(
            'Mesajlarda sağlamlıq məlumatı ola bilər: yalnız lazım olanı '
            'oxuyun, tibbi məsləhət verməyin. Hər açılış audit jurnalına '
            'yazılır. Yazışmalar son mesajdan 12 ay sonra silinir.',
            style: text.bodySmall?.copyWith(color: AdminColors.muted),
          ),
          const SizedBox(height: 16),
          if (_error != null) Text(errorText(_error!)),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 360,
                  child: threads == null
                      ? const Center(child: CircularProgressIndicator())
                      : threads.isEmpty
                      ? const Text('Hələ mesaj yoxdur.')
                      : ListView(
                          children: [
                            for (final t in threads)
                              ListTile(
                                key: ValueKey('thread-${t.id}'),
                                selected: open?.id == t.id,
                                leading: t.unreadByStaff
                                    ? const Icon(Icons.mark_email_unread)
                                    : const Icon(Icons.mail_outline),
                                title: Text(t.email),
                                subtitle: Text(
                                  '${date.format(t.lastMessageAt.toLocal())}'
                                  '${t.open ? '' : ' · bağlı'}',
                                ),
                                onTap: () => _openThread(t),
                              ),
                          ],
                        ),
                ),
                const VerticalDivider(),
                Expanded(
                  child: open == null
                      ? const Center(child: Text('Yazışma seçin.'))
                      : Column(
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
                                      child: Card(
                                        color: m.fromStaff
                                            ? AdminColors.cream
                                            : AdminColors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
