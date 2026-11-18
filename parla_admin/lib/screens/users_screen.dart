import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/admin_api.dart';
import '../staff_session.dart';
import '../ui/texts.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';

String _consentLabel(ConsentType t) => switch (t) {
  ConsentType.health => 'Sağlamlıq məlumatı',
  ConsentType.analytics => 'Analitika',
  ConsentType.marketing => 'Marketinq',
};

/// App accounts (admins only): exact-email look-up, block, delete on the
/// user's request. Account data and consents only, no health data. Every
/// look-up is recorded in the audit log.
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key, required this.state});

  final StaffState state;

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final _email = TextEditingController();
  UserAdminView? _user;
  bool _searched = false;
  bool _busy = false;

  AdminApi get _api => widget.state.api;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _snack(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  Future<void> _find() async {
    final email = _email.text.trim();
    if (email.isEmpty) return;
    setState(() => _busy = true);
    try {
      final user = await _api.findUser(email);
      if (mounted) {
        setState(() {
          _user = user;
          _searched = true;
        });
      }
    } on Object catch (e) {
      if (mounted) _snack(errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _setBlocked(bool blocked) async {
    final user = _user!;
    final yes = await _confirm(
      blocked ? 'Hesabı bloklamaq?' : 'Bloku açmaq?',
      blocked
          ? 'İstifadəçi daxil ola bilməyəcək, açıq sessiyaları bağlanacaq. '
                'Məlumatı silinmir.'
          : 'İstifadəçi yenidən daxil ola biləcək.',
    );
    if (!yes) return;
    try {
      final updated = await _api.setUserBlocked(user.userId, blocked);
      if (mounted) {
        setState(() => _user = updated);
        _snack(blocked ? 'Bloklandı.' : 'Blok açıldı.');
      }
    } on Object catch (e) {
      if (mounted) _snack(errorText(e));
    }
  }

  Future<void> _delete() async {
    final user = _user!;
    final confirm = TextEditingController();
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hesabı silmək (istifadəçinin müraciəti ilə)'),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Yalnız istifadəçinin öz müraciəti ilə (məs. e-poçtla) edin. '
                'Tətbiqdəki silmə ilə eynidir: sağlamlıq məlumatı, rutinlər, '
                'siyahılar, profil və hesab silinir; razılıq və audit '
                'qeydləri təxəllüslə qalır. Geri qaytarmaq olmur.',
              ),
              const SizedBox(height: 12),
              TextField(
                key: const ValueKey('users-confirm-email'),
                controller: confirm,
                decoration: const InputDecoration(
                  labelText: 'Təsdiq üçün e-poçtu yenidən yazın',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Ləğv et'),
          ),
          FilledButton(
            key: const ValueKey('users-delete-yes'),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
    final typed = confirm.text;
    WidgetsBinding.instance.addPostFrameCallback((_) => confirm.dispose());
    if (yes != true) return;
    try {
      await _api.deleteUserOnRequest(user.userId, typed);
      if (mounted) {
        setState(() => _user = null);
        _snack('Hesab silindi.');
      }
    } on Object catch (e) {
      if (mounted) _snack(errorText(e));
    }
  }

  Future<bool> _confirm(String title, String body) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Ləğv et'),
            ),
            FilledButton(
              key: const ValueKey('users-confirm-yes'),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Bəli'),
            ),
          ],
        ),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final user = _user;
    final date = DateFormat('dd.MM.yyyy');
    return AdminPage(
      title: 'İstifadəçilər',
      subtitle:
          'Hesabı yalnız dəqiq e-poçtla tapmaq olar; siyahı yoxdur. Hər baxış '
          'audit jurnalına yazılır. Sağlamlıq məlumatı burada görünmür.',
      maxWidth: 860,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                key: const ValueKey('users-email'),
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'E-poçt'),
                onSubmitted: (_) => _find(),
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              key: const ValueKey('users-find'),
              onPressed: _busy ? null : _find,
              child: const Text('Tap'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_searched && user == null)
          const Card(
            child: EmptyState(
              key: ValueKey('users-none'),
              title: 'Bu e-poçtla hesab yoxdur.',
              icon: Icons.person_search_outlined,
            ),
          ),
        if (user != null)
          Card(
            key: const ValueKey('users-card'),
            elevation: 0,
            color: AdminColors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(user.email, style: text.titleMedium),
                      ),
                      if (user.blocked)
                        const Pill(
                          'bloklanıb',
                          key: ValueKey('users-blocked'),
                          tone: dangerTone,
                        ),
                      if (user.isStaff) const Chip(label: Text('işçi')),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    [
                      if (user.registeredAt != null)
                        'Qeydiyyat: ${date.format(user.registeredAt!.toLocal())}',
                      if (user.countryCode != null) 'Ölkə: ${user.countryCode}',
                      if (user.language != null) 'Dil: ${user.language}',
                    ].join(' · '),
                  ),
                  const SizedBox(height: 12),
                  Text('Razılıqlar', style: text.titleSmall),
                  for (final c in user.consents)
                    Text(
                      '${_consentLabel(c.consentType)}: '
                      '${c.granted ? 'verilib' : 'yoxdur'}'
                      '${c.textVersion == null ? '' : ' (${c.textVersion}'
                                '${c.updatedAt == null ? '' : ', ${date.format(c.updatedAt!.toLocal())}'})'}',
                    ),
                  const SizedBox(height: 16),
                  if (!user.isStaff)
                    Wrap(
                      spacing: 8,
                      children: [
                        OutlinedButton(
                          key: const ValueKey('users-block'),
                          onPressed: () => _setBlocked(!user.blocked),
                          child: Text(
                            user.blocked ? 'Bloku aç' : 'Blokla',
                          ),
                        ),
                        TextButton(
                          key: const ValueKey('users-delete'),
                          onPressed: _delete,
                          style: TextButton.styleFrom(
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.error,
                          ),
                          child: const Text('Müraciətlə sil'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
