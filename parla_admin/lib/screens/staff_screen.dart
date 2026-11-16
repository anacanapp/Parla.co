import 'package:flutter/material.dart';

import '../api/admin_api.dart';
import '../staff_session.dart';
import '../ui/texts.dart';
import '../ui/theme.dart';

/// Staff accounts and open invitations (admins only).
class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key, required this.state});

  final StaffState state;

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  List<StaffSummary>? _staff;
  List<StaffInviteSummary> _invites = const [];
  Object? _error;
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  AdminApi get _api => widget.state.api;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final staff = await _api.listStaff();
      final invites = await _api.listInvites();
      if (!mounted) return;
      setState(() {
        _staff = staff;
        _invites = invites;
        _error = null;
      });
    } on Object catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _act(Future<void> Function() call, String done) async {
    try {
      await call();
      if (mounted) _snack(done);
      await _load();
    } on Object catch (e) {
      if (mounted) _snack(errorText(e));
    }
  }

  void _snack(String text) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  Future<void> _invite() async {
    final email = _email..clear();
    var role = StaffRole.editor;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('İşçi dəvət et'),
          content: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  key: const ValueKey('invite-email'),
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'E-poçt'),
                ),
                const SizedBox(height: 12),
                for (final r in StaffRole.values)
                  ListTile(
                    key: ValueKey('invite-role-${r.name}'),
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      r == role
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                    ),
                    title: Text(roleLabel(r)),
                    subtitle: Text(roleHint(r)),
                    onTap: () => setState(() => role = r),
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
              key: const ValueKey('invite-send'),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Dəvət göndər'),
            ),
          ],
        ),
      ),
    );
    if (ok ?? false) {
      await _act(
        () => _api.invite(email.text, role),
        'Dəvət göndərildi.',
      );
    }
  }

  Future<bool> _confirm(String text) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Ləğv et'),
            ),
            FilledButton(
              key: const ValueKey('confirm-yes'),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Bəli'),
            ),
          ],
        ),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final staff = _staff;
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text('İşçilər', style: text.headlineMedium),
              ),
            ),
            FilledButton.icon(
              key: const ValueKey('invite-open'),
              onPressed: _invite,
              icon: const Icon(Icons.person_add_alt),
              label: const Text('Dəvət et'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Hər işçi daxil olarkən e-poçt, şifrə və authenticator kodu ilə '
          'təsdiqlənir. İşçilər istifadəçilərin sağlamlıq məlumatlarını '
          'görmür. Bütün əməliyyatlar audit jurnalına yazılır.',
          style: text.bodyMedium?.copyWith(color: AdminColors.muted),
        ),
        const SizedBox(height: 24),
        if (_error != null) Text(errorText(_error!)),
        if (staff == null && _error == null)
          const Center(child: CircularProgressIndicator()),
        if (staff != null)
          Card(
            elevation: 0,
            color: AdminColors.white,
            child: Column(
              children: [
                for (final m in staff)
                  ListTile(
                    key: ValueKey('staff-${m.authUserId}'),
                    title: Text(m.email),
                    subtitle: Text(
                      [
                        roleLabel(m.role),
                        if (!m.active) 'deaktiv',
                        if (!m.totpEnrolled) '2FA qurulmayıb',
                      ].join(' · '),
                    ),
                    trailing: PopupMenuButton<String>(
                      key: ValueKey('staff-menu-${m.authUserId}'),
                      tooltip: 'Əməliyyatlar',
                      onSelected: (action) async {
                        switch (action) {
                          case 'deactivate':
                            if (await _confirm(
                              '${m.email} deaktiv edilsin?',
                            )) {
                              await _act(
                                () => _api.setActive(m.authUserId, false),
                                'Deaktiv edildi.',
                              );
                            }
                          case 'activate':
                            await _act(
                              () => _api.setActive(m.authUserId, true),
                              'Aktiv edildi.',
                            );
                          case 'reset':
                            if (await _confirm(
                              '${m.email} üçün 2FA sıfırlansın? Növbəti '
                              'girişdə yenidən quracaq.',
                            )) {
                              await _act(
                                () => _api.resetTotp(m.authUserId),
                                '2FA sıfırlandı.',
                              );
                            }
                          default:
                            final role = StaffRole.values.byName(action);
                            await _act(
                              () => _api.setRole(m.authUserId, role),
                              'Rol dəyişdi.',
                            );
                        }
                      },
                      itemBuilder: (context) => [
                        for (final r in StaffRole.values)
                          if (r != m.role)
                            PopupMenuItem(
                              value: r.name,
                              child: Text('Rol: ${roleLabel(r)}'),
                            ),
                        PopupMenuItem(
                          value: m.active ? 'deactivate' : 'activate',
                          child: Text(m.active ? 'Deaktiv et' : 'Aktiv et'),
                        ),
                        const PopupMenuItem(
                          value: 'reset',
                          child: Text('2FA-nı sıfırla'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        if (_invites.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text('Açıq dəvətlər', style: text.titleLarge),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: AdminColors.white,
            child: Column(
              children: [
                for (final i in _invites)
                  ListTile(
                    key: ValueKey('invite-${i.id}'),
                    title: Text(i.email),
                    subtitle: Text(roleLabel(i.role)),
                    trailing: IconButton(
                      tooltip: 'Dəvəti ləğv et',
                      onPressed: () => _act(
                        () => _api.revokeInvite(i.id),
                        'Dəvət ləğv edildi.',
                      ),
                      icon: const Icon(Icons.close),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
