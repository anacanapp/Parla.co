import 'dart:convert';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../api/admin_api.dart';

/// A count as the report shows it: hidden counts (under 10) as "<10".
String countText(int? n) => n == null ? '<10' : '$n';

/// Taps per view in percent with one decimal, or "–" when a count is
/// hidden or there are no views.
String rateText(int? views, int? taps) {
  if (views == null || taps == null || views == 0) return '–';
  return '${(taps * 100 / views).toStringAsFixed(1)}%';
}

/// The report's file name without extension, e.g.
/// `parla-reklam-brand-x-yaz-2026-12-01`.
String reportFileName(AdReport r) {
  String slug(String v) => v
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
  final parts = [
    'parla-reklam',
    slug(r.advertiser),
    slug(r.campaign),
    r.startsOn,
  ].where((p) => p.isNotEmpty);
  return parts.join('-');
}

const reportNote =
    'Rəqəmlər yalnız tətbiqdə analitika razılığı verən istifadəçiləri əhatə '
    'edir və cəm saylardır: heç bir istifadəçi haqqında məlumat yoxdur. '
    '10-dan az say "<10" kimi göstərilir.';

/// The report as CSV for spreadsheets (semicolons and a UTF-8 mark, as
/// Excel expects in Azerbaijan and Russia).
Uint8List adReportCsv(AdReport r) {
  String cell(String v) {
    // A cell starting with these could run as a formula in a spreadsheet.
    final safe = RegExp(r'^[=+\-@\t\r]').hasMatch(v) ? "'$v" : v;
    return safe.contains(RegExp(r'[;"\n\r]'))
        ? '"${safe.replaceAll('"', '""')}"'
        : safe;
  }

  final lines = <List<String>>[
    ['Reklamçı', r.advertiser],
    ['Kampaniya', r.campaign],
    ['Dövr', '${r.startsOn} – ${r.endsOn}'],
    ['Sayılıb', r.countedTo],
    [],
    ['', 'Göstərilmə', 'Klik', 'Klik faizi'],
    ['Cəmi', countText(r.views), countText(r.taps), rateText(r.views, r.taps)],
    [],
    ['Banner', 'Göstərilmə', 'Klik', 'Klik faizi'],
    for (final b in r.banners)
      [
        b.label,
        countText(b.views),
        countText(b.taps),
        rateText(b.views, b.taps),
      ],
    [],
    ['Gün', 'Göstərilmə', 'Klik', 'Klik faizi'],
    for (final d in r.days)
      [
        d.label,
        countText(d.views),
        countText(d.taps),
        rateText(d.views, d.taps),
      ],
    [],
    [reportNote],
  ];
  final text = lines.map((l) => l.map(cell).join(';')).join('\r\n');
  return Uint8List.fromList([0xEF, 0xBB, 0xBF, ...utf8.encode('$text\r\n')]);
}

/// The report as an A4 PDF, in the panel's own font (Onest covers the
/// Azerbaijani and Russian letters). [regular] and [bold] are its TTF
/// files.
Future<Uint8List> adReportPdf(
  AdReport r, {
  required ByteData regular,
  required ByteData bold,
  DateTime? made,
}) {
  final theme = pw.ThemeData.withFont(
    base: pw.Font.ttf(regular),
    bold: pw.Font.ttf(bold),
  );
  const ink = PdfColor.fromInt(0xFF1F1A17);
  const muted = PdfColor.fromInt(0xFF6B625C);
  const line = PdfColor.fromInt(0xFFE6DED6);
  final when = (made ?? DateTime.now()).toLocal();
  String two(int v) => v.toString().padLeft(2, '0');
  final madeText = '${two(when.day)}.${two(when.month)}.${when.year}';

  pw.Widget table(String first, List<AdReportRow> rows) =>
      pw.TableHelper.fromTextArray(
        headers: [first, 'Göstərilmə', 'Klik', 'Klik faizi'],
        data: [
          for (final row in rows)
            [
              row.label,
              countText(row.views),
              countText(row.taps),
              rateText(row.views, row.taps),
            ],
        ],
        border: const pw.TableBorder(
          horizontalInside: pw.BorderSide(color: line, width: .5),
          bottom: pw.BorderSide(color: line, width: .5),
        ),
        headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
        cellStyle: const pw.TextStyle(fontSize: 9),
        headerDecoration: const pw.BoxDecoration(
          color: PdfColor.fromInt(0xFFF6F1EB),
        ),
        cellAlignments: {
          1: pw.Alignment.centerRight,
          2: pw.Alignment.centerRight,
          3: pw.Alignment.centerRight,
        },
        columnWidths: {
          0: const pw.FlexColumnWidth(3),
          1: const pw.FlexColumnWidth(1.2),
          2: const pw.FlexColumnWidth(1),
          3: const pw.FlexColumnWidth(1.1),
        },
      );

  pw.Widget stat(String label, String value) => pw.Expanded(
    child: pw.Container(
      padding: const pw.EdgeInsets.all(10),
      margin: const pw.EdgeInsets.only(right: 8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: line),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(label, style: const pw.TextStyle(fontSize: 9, color: muted)),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    ),
  );

  final doc = pw.Document(
    theme: theme,
    title: 'Parla reklam hesabatı',
    author: 'Parla',
    creator: 'Parla',
    producer: 'Parla',
  );
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(36),
      footer: (context) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Parla · $madeText',
            style: const pw.TextStyle(fontSize: 8, color: muted),
          ),
          pw.Text(
            '${context.pageNumber} / ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8, color: muted),
          ),
        ],
      ),
      build: (context) => [
        pw.Text(
          'Reklam hesabatı',
          style: pw.TextStyle(
            fontSize: 22,
            fontWeight: pw.FontWeight.bold,
            color: ink,
          ),
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          '${r.advertiser} · ${r.campaign}',
          style: const pw.TextStyle(fontSize: 12),
        ),
        pw.Text(
          'Dövr: ${r.startsOn} – ${r.endsOn} · sayılıb: ${r.countedTo}-dək',
          style: const pw.TextStyle(fontSize: 10, color: muted),
        ),
        pw.SizedBox(height: 16),
        pw.Row(
          children: [
            stat('Göstərilmə', countText(r.views)),
            stat('Klik', countText(r.taps)),
            stat('Klik faizi', rateText(r.views, r.taps)),
          ],
        ),
        pw.SizedBox(height: 18),
        pw.Text(
          'Bannerlər üzrə',
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        table('Banner', r.banners),
        pw.SizedBox(height: 18),
        pw.Text(
          'Günlər üzrə',
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        table('Gün', r.days),
        pw.SizedBox(height: 16),
        pw.Text(
          reportNote,
          style: const pw.TextStyle(fontSize: 8, color: muted),
        ),
      ],
    ),
  );
  return doc.save();
}
