import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../api/admin_api.dart';
import '../staff_session.dart';
import '../ui/texts.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';

/// The groups of actions the log can be narrowed to (by action prefix).
const auditGroups = <(String, String)>[
  ('', 'Hamısı'),
  ('account.', 'Hesab'),
  ('consent.', 'Razılıq'),
  ('health.', 'Sağlamlıq məlumatı'),
  ('profile.', 'Profil'),
  ('quiz.', 'Test cavabları'),
  ('user.', 'İstifadəçilərə baxış'),
  ('support.', 'Dəstək'),
  ('content.', 'Məzmun'),
  ('media.', 'Media'),
  ('ads.', 'Reklam'),
  ('shop.', 'Mağaza'),
  ('staff.', 'İşçilər'),
  ('audit.', 'Audit jurnalı'),
];

/// Who acted.
const auditRoles = <(String, String)>[
  ('', 'Hamısı'),
  ('user', 'İstifadəçi'),
  ('staff', 'İşçi'),
  ('system', 'Sistem'),
];

/// A readable Azerbaijani name for an action; unknown ones show the code.
String auditActionLabel(String action) => switch (action) {
  'account.deleted' => 'Hesab silindi',
  'account.deleted_on_request' => 'Hesab müraciətlə silindi',
  'account.exported' => 'Məlumat yükləndi',
  'consent.granted' => 'Razılıq verildi',
  'consent.withdrawn' => 'Razılıq geri götürüldü',
  'health.erased' => 'Sağlamlıq məlumatı silindi',
  'profile.created' => 'Profil yaradıldı',
  'quiz.answers_saved' => 'Test cavabları saxlanıldı',
  'user.viewed' => 'Hesaba baxıldı',
  'user.blocked' => 'Hesab bloklandı',
  'user.unblocked' => 'Blok açıldı',
  'support.viewed' => 'Dəstək yazışmasına baxıldı',
  'support.replied' => 'Dəstəyə cavab verildi',
  'support.closed' => 'Dəstək yazışması bağlandı',
  'content.created' => 'Məzmun yaradıldı',
  'content.saved' => 'Məzmun saxlanıldı',
  'content.approved' => 'Məzmun təsdiqləndi',
  'content.returned' => 'Məzmun geri qaytarıldı',
  'content.published' => 'Məzmun dərc olundu',
  'content.published_unreviewed' => 'Məzmun yoxlamasız dərc olundu',
  'content.sample_published' => 'Nümunə dərc olundu',
  'content.unpublished' => 'Dərcdən çıxarıldı',
  'content.hidden' => 'Məzmun gizlədildi',
  'content.shown' => 'Məzmun göstərildi',
  'content.deleted' => 'Məzmun silindi',
  'content.imported' => 'Məzmun idxal olundu',
  'content.reimported' => 'Məzmun yenidən idxal olundu',
  'content.consent_recorded' => 'Ekspert razılığı qeyd olundu',
  'content.cover_attached' => 'Örtük şəkli əlavə olundu',
  'content.cover_replaced' => 'Örtük şəkli dəyişdirildi',
  'content.video_attached' => 'Video əlavə olundu',
  'content.video_replaced' => 'Video dəyişdirildi',
  'content.kcal_set' => 'Kalori yazıldı',
  'content.ingredients_fixed' => 'Tərkib düzəldildi',
  'content.wording_fixed' => 'Mətnin ifadəsi düzəldildi',
  'media.uploaded' => 'Media yükləndi',
  'media.updated' => 'Media dəyişdirildi',
  'media.deleted' => 'Media silindi',
  'ads.advertiser_saved' => 'Reklamçı saxlanıldı',
  'ads.advertiser_deleted' => 'Reklamçı silindi',
  'ads.campaign_saved' => 'Kampaniya saxlanıldı',
  'ads.campaign_deleted' => 'Kampaniya silindi',
  'ads.report_viewed' => 'Kampaniya hesabatına baxıldı',
  'shop.order_started' => 'Sifariş başladı',
  'shop.paid' => 'Sifariş ödənildi',
  'shop.refunded' => 'Pul qaytarıldı',
  'staff.first_admin' => 'İlk admin',
  'staff.invited' => 'İşçi dəvət olundu',
  'staff.invite_revoked' => 'Dəvət ləğv olundu',
  'staff.joined' => 'İşçi qoşuldu',
  'staff.role_changed' => 'İşçinin rolu dəyişdi',
  'staff.activated' => 'İşçi aktiv edildi',
  'staff.deactivated' => 'İşçi deaktiv edildi',
  'audit.viewed' => 'Audit jurnalına baxıldı',
  _ => action,
};

String _roleLabel(String role) =>
    auditRoles.where((r) => r.$1 == role).firstOrNull?.$2 ?? role;

/// The audit log (admins only): who did what and when, ids only. Read-only:
/// nothing can be changed, deleted or exported here. Opening the log is
/// itself written to the log.
class AuditScreen extends StatefulWidget {
  const AuditScreen({super.key, required this.state});

  final StaffState state;

  @override
  State<AuditScreen> createState() => _AuditScreenState();
}

class _AuditScreenState extends State<AuditScreen> {
  final _object = TextEditingController();
  String _group = '';
  String _role = '';
  DateTimeRange? _range;

  final _rows = <AuditLogEntry>[];
  bool _loading = true;
  bool _more = false;
  Object? _error;

  AdminApi get _api => widget.state.api;

  AuditFilter get _filter => AuditFilter(
    actionPrefix: _group,
    actorRole: _role,
    objectId: _object.text.trim(),
    from: _range?.start,
    to: _range?.end,
  );

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _object.dispose();
    super.dispose();
  }

  Future<void> _load({bool more = false}) async {
    setState(() {
      _loading = true;
      _error = null;
      if (!more) _rows.clear();
    });
    try {
      final page = await _api.listAudit(
        _filter,
        beforeId: more && _rows.isNotEmpty ? _rows.last.id : null,
      );
      if (!mounted) return;
      setState(() {
        _rows.addAll(page);
        _more = page.length >= 100;
      });
    } on Object catch (e) {
      if (mounted) setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      initialDateRange: _range,
    );
    if (range == null) return;
    setState(() => _range = range);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd.MM.yyyy');
    return AdminPage(
      title: 'Audit jurnalı',
      subtitle:
          'Kim, nə vaxt, nə etdi. Yalnız id-lər saxlanılır: ad, e-poçt və '
          'sağlamlıq məlumatı yoxdur. Qeydləri dəyişmək və ya silmək olmur; '
          'bu səhifəyə baxış da jurnala yazılır.',
      maxWidth: 1100,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 220,
              child: DropdownButtonFormField<String>(
                key: const ValueKey('audit-group'),
                isExpanded: true,
                initialValue: _group,
                decoration: const InputDecoration(labelText: 'Bölmə'),
                items: [
                  for (final (code, label) in auditGroups)
                    DropdownMenuItem(value: code, child: Text(label)),
                ],
                onChanged: (v) {
                  setState(() => _group = v ?? '');
                  _load();
                },
              ),
            ),
            SizedBox(
              width: 160,
              child: DropdownButtonFormField<String>(
                key: const ValueKey('audit-role'),
                isExpanded: true,
                initialValue: _role,
                decoration: const InputDecoration(labelText: 'Kim'),
                items: [
                  for (final (code, label) in auditRoles)
                    DropdownMenuItem(value: code, child: Text(label)),
                ],
                onChanged: (v) {
                  setState(() => _role = v ?? '');
                  _load();
                },
              ),
            ),
            SizedBox(
              width: 240,
              child: TextField(
                key: const ValueKey('audit-object'),
                controller: _object,
                decoration: const InputDecoration(labelText: 'Obyekt id'),
                onSubmitted: (_) => _load(),
              ),
            ),
            OutlinedButton.icon(
              key: const ValueKey('audit-range'),
              onPressed: _pickRange,
              icon: const Icon(Icons.date_range_outlined, size: 18),
              label: Text(
                _range == null
                    ? 'Tarix'
                    : '${date.format(_range!.start)} – '
                          '${date.format(_range!.end)}',
              ),
            ),
            if (_range != null)
              IconButton(
                tooltip: 'Tarixi sil',
                onPressed: () {
                  setState(() => _range = null);
                  _load();
                },
                icon: const Icon(Icons.close),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (_error != null)
          Notice(title: errorText(_error!), tone: NoticeTone.danger)
        else if (_rows.isEmpty && _loading)
          const LoadingBlock()
        else if (_rows.isEmpty)
          const Card(
            child: EmptyState(
              key: ValueKey('audit-empty'),
              title: 'Bu filtrlə qeyd yoxdur.',
              icon: Icons.history_outlined,
            ),
          )
        else ...[
          Card(
            elevation: 0,
            color: AdminColors.white,
            child: Column(
              children: [
                for (final (i, e) in _rows.indexed) ...[
                  if (i > 0) const Divider(height: 1),
                  _AuditRow(entry: e),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (_more)
            Center(
              child: OutlinedButton(
                key: const ValueKey('audit-more'),
                onPressed: _loading ? null : () => _load(more: true),
                child: const Text('Daha çox'),
              ),
            ),
        ],
      ],
    );
  }
}

class _AuditRow extends StatelessWidget {
  const _AuditRow({required this.entry});

  final AuditLogEntry entry;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final when = DateFormat(
      'dd.MM.yyyy HH:mm',
    ).format(entry.createdAt.toLocal());
    final actor = entry.actorId?.toString();
    return Padding(
      key: ValueKey('audit-row-${entry.id}'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Wrap(
        spacing: 16,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(width: 130, child: Text(when, style: text.bodySmall)),
          SizedBox(
            width: 280,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(auditActionLabel(entry.action), style: text.bodyMedium),
                Text(
                  entry.action,
                  style: text.bodySmall?.copyWith(color: AdminColors.subtle),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 200,
            child: Wrap(
              spacing: 6,
              children: [
                Text(_roleLabel(entry.actorRole), style: text.bodySmall),
                if (actor != null) _Id(actor),
              ],
            ),
          ),
          Wrap(
            spacing: 6,
            children: [
              Text(entry.objectType, style: text.bodySmall),
              if (entry.objectId != null) _Id(entry.objectId!),
            ],
          ),
        ],
      ),
    );
  }
}

/// An id shortened to its start; tapping copies the whole id.
class _Id extends StatelessWidget {
  const _Id(this.id);

  final String id;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: id,
    child: InkWell(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: id));
        if (context.mounted) showToast(context, 'Id kopyalandı.');
      },
      child: Text(
        id.length > 8 ? '${id.substring(0, 8)}…' : id,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
      ),
    ),
  );
}
