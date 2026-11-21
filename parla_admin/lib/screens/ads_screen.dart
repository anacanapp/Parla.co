import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../ads/ad_report_files.dart';
import '../ads/save_file.dart';
import '../api/admin_api.dart';
import '../staff_session.dart';
import '../ui/texts.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';

String _today() {
  final t = DateTime.now();
  String two(int v) => v.toString().padLeft(2, '0');
  return '${t.year}-${two(t.month)}-${two(t.day)}';
}

/// Where a campaign stands today.
(String, PillTone) campaignState(AdCampaign c, String today) {
  if (today.compareTo(c.startsOn) < 0) return ('gələcək', reviewTone);
  if (today.compareTo(c.endsOn) > 0) return ('bitib', neutralTone);
  return ('davam edir', liveTone);
}

/// Advertisers and their campaigns, with a report per campaign (admins
/// only). The banners themselves are written under Content → Banners and
/// joined to a campaign there.
class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key, required this.state});

  final StaffState state;

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  List<Advertiser>? _advertisers;
  List<AdCampaign> _campaigns = const [];
  Object? _error;
  int _tab = 0;

  AdminApi get _api => widget.state.api;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final advertisers = await _api.advertisers();
      final campaigns = await _api.adCampaigns();
      if (!mounted) return;
      setState(() {
        _advertisers = advertisers;
        _campaigns = campaigns;
        _error = null;
      });
    } on Object catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _act(Future<void> Function() call, String done) async {
    try {
      await call();
      if (mounted) showToast(context, done);
      await _load();
    } on Object catch (e) {
      if (mounted) showToast(context, errorText(e));
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

  Future<void> _editAdvertiser([Advertiser? a]) async {
    final now = DateTime.now();
    final result = await showDialog<Advertiser>(
      context: context,
      builder: (context) => _AdvertiserDialog(
        initial: a ?? Advertiser(company: '', createdAt: now, updatedAt: now),
      ),
    );
    if (result != null) {
      await _act(() => _api.saveAdvertiser(result), 'Yadda saxlanıldı.');
    }
  }

  Future<void> _editCampaign([AdCampaign? c]) async {
    final advertisers = _advertisers ?? const [];
    if (advertisers.isEmpty) {
      showToast(context, 'Əvvəlcə reklamçı əlavə edin.');
      return;
    }
    final now = DateTime.now();
    final result = await showDialog<AdCampaign>(
      context: context,
      builder: (context) => _CampaignDialog(
        advertisers: advertisers,
        initial:
            c ??
            AdCampaign(
              advertiserId: advertisers.first.id!,
              title: '',
              startsOn: '',
              endsOn: '',
              createdAt: now,
              updatedAt: now,
            ),
      ),
    );
    if (result != null) {
      await _act(() => _api.saveAdCampaign(result), 'Yadda saxlanıldı.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final advertisers = _advertisers;
    final names = {for (final a in advertisers ?? const []) a.id: a.company};
    final today = _today();
    return AdminPage(
      title: 'Reklam',
      subtitle:
          'Reklamçılar, kampaniyalar və hesabatlar. Bannerin özü Məzmun → '
          'Bannerlər bölməsində yazılır və orada kampaniyaya bağlanır; brend '
          'bannerini ekspert təsdiqləyir. Hədəf yalnız dil, ölkə və yazının '
          'mövzusudur, istifadəçi haqqında heç nə istifadə olunmur.',
      maxWidth: 1000,
      actions: [
        if (_tab == 0)
          FilledButton.icon(
            key: const ValueKey('campaign-new'),
            onPressed: () => _editCampaign(),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Yeni kampaniya'),
          )
        else
          FilledButton.icon(
            key: const ValueKey('advertiser-new'),
            onPressed: () => _editAdvertiser(),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Yeni reklamçı'),
          ),
      ],
      children: [
        PillTabs(
          labels: const ['Kampaniyalar', 'Reklamçılar'],
          keys: const [
            ValueKey('ads-tab-campaigns'),
            ValueKey('ads-tab-advertisers'),
          ],
          selected: _tab,
          onSelected: (i) => setState(() => _tab = i),
        ),
        const SizedBox(height: 16),
        if (_error != null)
          Notice(
            tone: NoticeTone.danger,
            icon: Icons.error_outline,
            title: errorText(_error!),
          ),
        if (advertisers == null && _error == null) const LoadingBlock(),
        if (advertisers != null && _tab == 0)
          Card(
            child: _campaigns.isEmpty
                ? EmptyState(
                    icon: Icons.campaign_outlined,
                    title: 'Hələ kampaniya yoxdur',
                    body: advertisers.isEmpty
                        ? 'Əvvəlcə "Reklamçılar" bölməsində brendi əlavə edin.'
                        : 'Kampaniya yaradın, sonra bannerləri ona bağlayın.',
                  )
                : Column(
                    children: [
                      for (final c in _campaigns)
                        ListTile(
                          key: ValueKey('campaign-${c.id}'),
                          title: Text(c.title),
                          subtitle: Text(
                            '${names[c.advertiserId] ?? ''} · '
                            '${c.startsOn} – ${c.endsOn}'
                            '${c.priceNote == null ? '' : ' · ${c.priceNote}'}',
                          ),
                          leading: const Icon(Icons.campaign_outlined),
                          onTap: () => context.go('/ads/${c.id}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Builder(
                                builder: (_) {
                                  final (label, tone) = campaignState(c, today);
                                  return Pill(label, tone: tone);
                                },
                              ),
                              PopupMenuButton<String>(
                                key: ValueKey('campaign-menu-${c.id}'),
                                tooltip: 'Əməliyyatlar',
                                onSelected: (v) async {
                                  switch (v) {
                                    case 'report':
                                      context.go('/ads/${c.id}');
                                    case 'edit':
                                      await _editCampaign(c);
                                    case 'delete':
                                      if (await _confirm(
                                        '"${c.title}" kampaniyası silinsin? '
                                        'Bannerləri olan kampaniya silinmir.',
                                      )) {
                                        await _act(
                                          () => _api.deleteAdCampaign(c.id!),
                                          'Silindi.',
                                        );
                                      }
                                  }
                                },
                                itemBuilder: (_) => const [
                                  PopupMenuItem(
                                    value: 'report',
                                    child: Text('Hesabat'),
                                  ),
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Redaktə et'),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Sil'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        if (advertisers != null && _tab == 1) ...[
          const Notice(
            tone: NoticeTone.info,
            icon: Icons.shield_outlined,
            title: 'Yalnız şirkət məlumatı',
            body:
                'Şirkətin adı, ümumi e-poçtu və müqavilə məlumatı saxlanılır. '
                'Əlaqə şəxsinin adı və telefonu burada saxlanılmır, müqavilədə '
                'qalır.',
          ),
          const SizedBox(height: 12),
          Card(
            child: advertisers.isEmpty
                ? const EmptyState(
                    icon: Icons.storefront_outlined,
                    title: 'Hələ reklamçı yoxdur',
                  )
                : Column(
                    children: [
                      for (final a in advertisers)
                        ListTile(
                          key: ValueKey('advertiser-${a.id}'),
                          leading: const Icon(Icons.storefront_outlined),
                          title: Text(a.company, style: text.titleSmall),
                          subtitle: Text(
                            [
                              ?a.email,
                              if (a.contractNumber != null)
                                'Müqavilə ${a.contractNumber}',
                              if (a.contractStart != null ||
                                  a.contractEnd != null)
                                '${a.contractStart ?? '…'} – '
                                    '${a.contractEnd ?? '…'}',
                            ].join(' · '),
                          ),
                          onTap: () => _editAdvertiser(a),
                          trailing: IconButton(
                            key: ValueKey('advertiser-delete-${a.id}'),
                            tooltip: 'Sil',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              if (await _confirm(
                                '${a.company} silinsin? Kampaniyası olan '
                                'reklamçı silinmir.',
                              )) {
                                await _act(
                                  () => _api.deleteAdvertiser(a.id!),
                                  'Silindi.',
                                );
                              }
                            },
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

InputDecoration _field(String label, {String? help}) =>
    InputDecoration(labelText: label, helperText: help, helperMaxLines: 2);

const _dayHelp = 'YYYY-AA-GG';

class _AdvertiserDialog extends StatefulWidget {
  const _AdvertiserDialog({required this.initial});

  final Advertiser initial;

  @override
  State<_AdvertiserDialog> createState() => _AdvertiserDialogState();
}

class _AdvertiserDialogState extends State<_AdvertiserDialog> {
  late final _company = TextEditingController(text: widget.initial.company);
  late final _email = TextEditingController(text: widget.initial.email);
  late final _number = TextEditingController(
    text: widget.initial.contractNumber,
  );
  late final _start = TextEditingController(text: widget.initial.contractStart);
  late final _end = TextEditingController(text: widget.initial.contractEnd);
  late final _note = TextEditingController(text: widget.initial.note);

  @override
  void dispose() {
    for (final c in [_company, _email, _number, _start, _end, _note]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _v(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.initial.id == null ? 'Yeni reklamçı' : 'Reklamçı'),
    content: SizedBox(
      width: 420,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const ValueKey('advertiser-company'),
              controller: _company,
              decoration: _field('Şirkət / brend'),
            ),
            TextField(
              key: const ValueKey('advertiser-email'),
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: _field(
                'Ümumi e-poçt (istəyə görə)',
                help: 'Məs. info@brand.az. Şəxsi ünvan yazmayın.',
              ),
            ),
            TextField(
              key: const ValueKey('advertiser-contract'),
              controller: _number,
              decoration: _field('Müqavilə nömrəsi (istəyə görə)'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const ValueKey('advertiser-start'),
                    controller: _start,
                    decoration: _field('Müqavilə başlanğıcı', help: _dayHelp),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    key: const ValueKey('advertiser-end'),
                    controller: _end,
                    decoration: _field('Müqavilə sonu', help: _dayHelp),
                  ),
                ),
              ],
            ),
            TextField(
              key: const ValueKey('advertiser-note'),
              controller: _note,
              maxLines: 3,
              decoration: _field('Qeyd (istəyə görə)'),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Ləğv et'),
      ),
      FilledButton(
        key: const ValueKey('advertiser-save'),
        onPressed: () => Navigator.pop(
          context,
          widget.initial.copyWith(
            company: _company.text.trim(),
            email: _v(_email),
            contractNumber: _v(_number),
            contractStart: _v(_start),
            contractEnd: _v(_end),
            note: _v(_note),
          ),
        ),
        child: const Text('Yadda saxla'),
      ),
    ],
  );
}

class _CampaignDialog extends StatefulWidget {
  const _CampaignDialog({required this.initial, required this.advertisers});

  final AdCampaign initial;
  final List<Advertiser> advertisers;

  @override
  State<_CampaignDialog> createState() => _CampaignDialogState();
}

class _CampaignDialogState extends State<_CampaignDialog> {
  late int _advertiser = widget.initial.advertiserId;
  late final _title = TextEditingController(text: widget.initial.title);
  late final _start = TextEditingController(text: widget.initial.startsOn);
  late final _end = TextEditingController(text: widget.initial.endsOn);
  late final _price = TextEditingController(text: widget.initial.priceNote);

  @override
  void dispose() {
    for (final c in [_title, _start, _end, _price]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.initial.id == null ? 'Yeni kampaniya' : 'Kampaniya'),
    content: SizedBox(
      width: 420,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              key: const ValueKey('campaign-advertiser'),
              initialValue: _advertiser,
              isExpanded: true,
              decoration: _field('Reklamçı'),
              items: [
                for (final a in widget.advertisers)
                  DropdownMenuItem(value: a.id, child: Text(a.company)),
              ],
              onChanged: widget.initial.id == null
                  ? (v) => setState(() => _advertiser = v!)
                  : null,
            ),
            TextField(
              key: const ValueKey('campaign-title'),
              controller: _title,
              decoration: _field('Kampaniyanın adı'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const ValueKey('campaign-start'),
                    controller: _start,
                    decoration: _field('Başlama', help: _dayHelp),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    key: const ValueKey('campaign-end'),
                    controller: _end,
                    decoration: _field('Bitmə', help: _dayHelp),
                  ),
                ),
              ],
            ),
            TextField(
              key: const ValueKey('campaign-price'),
              controller: _price,
              decoration: _field(
                'Qiymət və ya büdcə (istəyə görə)',
                help: 'Yalnız komanda üçün qeyd; tətbiqdə görünmür.',
              ),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Ləğv et'),
      ),
      FilledButton(
        key: const ValueKey('campaign-save'),
        onPressed: () => Navigator.pop(
          context,
          widget.initial.copyWith(
            advertiserId: _advertiser,
            title: _title.text.trim(),
            startsOn: _start.text.trim(),
            endsOn: _end.text.trim(),
            priceNote: _price.text.trim().isEmpty ? null : _price.text.trim(),
          ),
        ),
        child: const Text('Yadda saxla'),
      ),
    ],
  );
}

/// One campaign's report with CSV and PDF downloads for the advertiser.
class AdReportScreen extends StatefulWidget {
  const AdReportScreen({super.key, required this.state, required this.id});

  final StaffState state;
  final int id;

  @override
  State<AdReportScreen> createState() => _AdReportScreenState();
}

class _AdReportScreenState extends State<AdReportScreen> {
  AdReport? _report;
  Object? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final r = await widget.state.api.adReport(widget.id);
      if (mounted) setState(() => _report = r);
    } on Object catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  void _csv(AdReport r) =>
      saveFile('${reportFileName(r)}.csv', adReportCsv(r), 'text/csv');

  Future<void> _pdf(AdReport r) async {
    setState(() => _busy = true);
    try {
      final bytes = await adReportPdf(
        r,
        regular: await rootBundle.load('assets/fonts/Onest-Regular.ttf'),
        bold: await rootBundle.load('assets/fonts/Onest-Bold.ttf'),
      );
      saveFile('${reportFileName(r)}.pdf', bytes, 'application/pdf');
    } on Object {
      if (mounted) showToast(context, 'PDF hazırlanmadı. Yenidən cəhd edin.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _table(String first, List<AdReportRow> rows, String keyPrefix) =>
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text(first)),
            const DataColumn(label: Text('Göstərilmə'), numeric: true),
            const DataColumn(label: Text('Klik'), numeric: true),
            const DataColumn(label: Text('Klik faizi'), numeric: true),
          ],
          rows: [
            for (final (i, row) in rows.indexed)
              DataRow(
                key: ValueKey('$keyPrefix-$i'),
                cells: [
                  DataCell(Text(row.label)),
                  DataCell(Text(countText(row.views))),
                  DataCell(Text(countText(row.taps))),
                  DataCell(Text(rateText(row.views, row.taps))),
                ],
              ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final r = _report;
    final back = IconButton(
      tooltip: 'Geri',
      onPressed: () => context.go('/ads'),
      icon: const Icon(Icons.arrow_back),
    );
    if (_error != null || r == null) {
      return AdminPage(
        title: 'Hesabat',
        leading: back,
        children: [
          if (_error != null)
            Notice(
              tone: NoticeTone.danger,
              icon: Icons.error_outline,
              title: errorText(_error!),
            )
          else
            const LoadingBlock(),
        ],
      );
    }
    return AdminPage(
      title: r.campaign,
      subtitle:
          '${r.advertiser} · ${r.startsOn} – ${r.endsOn} · sayılıb: '
          '${r.countedTo}-dək',
      leading: back,
      maxWidth: 1000,
      actions: [
        OutlinedButton.icon(
          key: const ValueKey('report-csv'),
          onPressed: () => _csv(r),
          icon: const Icon(Icons.table_chart_outlined, size: 18),
          label: const Text('CSV yüklə'),
        ),
        FilledButton.icon(
          key: const ValueKey('report-pdf'),
          onPressed: _busy ? null : () => _pdf(r),
          icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
          label: const Text('PDF yüklə'),
        ),
      ],
      children: [
        const Notice(
          tone: NoticeTone.info,
          icon: Icons.shield_outlined,
          title: 'Reklamçıya yalnız cəm rəqəmlər verilir',
          body: reportNote,
        ),
        const SizedBox(height: 16),
        ResponsiveGrid(
          children: [
            StatCard(
              label: 'Göstərilmə',
              value: countText(r.views),
              valueKey: const ValueKey('report-views'),
            ),
            StatCard(
              label: 'Klik',
              value: countText(r.taps),
              valueKey: const ValueKey('report-taps'),
            ),
            StatCard(label: 'Klik faizi', value: rateText(r.views, r.taps)),
          ],
        ),
        const SizedBox(height: 20),
        SectionCard(
          title: 'Bannerlər üzrə',
          child: r.banners.isEmpty
              ? const Text(
                  'Bu kampaniyaya hələ banner bağlanmayıb. Məzmun → Bannerlər '
                  'bölməsində bannerdə kampaniyanı seçin.',
                  style: TextStyle(color: AdminColors.muted),
                )
              : _table('Banner', r.banners, 'report-banner'),
        ),
        const SizedBox(height: 16),
        SectionCard(
          title: 'Günlər üzrə',
          child: r.days.isEmpty
              ? const Text(
                  'Kampaniya hələ başlamayıb.',
                  style: TextStyle(color: AdminColors.muted),
                )
              : _table('Gün', r.days, 'report-day'),
        ),
      ],
    );
  }
}
