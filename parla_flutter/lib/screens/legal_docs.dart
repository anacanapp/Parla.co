import 'package:flutter/services.dart';

/// The privacy policy and the terms of use, shipped as Markdown in
/// `assets/legal/<doc>.<language>.md`.
///
/// They are drafts until the company's details are filled in and the
/// lawyer has signed them off. A document is shown only when it is
/// [isReady]: no draft banner, no open lawyer question (⚖️) and no
/// placeholder left. Until then the app keeps saying the documents are
/// being prepared.
enum LegalDoc {
  privacy,
  terms;

  /// The placeholders the drafts use for the company's details.
  static const placeholders = [
    '[ŞİRKƏTİN HÜQUQİ ADI]',
    '[VÖEN]',
    '[HÜQUQİ ÜNVAN]',
    '[ƏLAQƏ E-POÇTU]',
    '[MƏLUMAT QORUNMASI ÜZRƏ MƏSUL ŞƏXS / DPO]',
    '[QÜVVƏYƏ MİNMƏ TARİXİ]',
  ];

  /// Whether [markdown] may be shown to users.
  static bool isReady(String markdown) =>
      markdown.trim().isNotEmpty &&
      !markdown.contains('QARALAMA') &&
      !markdown.contains('DRAFT') &&
      !markdown.contains('⚖️') &&
      !placeholders.any(markdown.contains);

  /// Reads an asset; replaced in tests.
  static Future<String> Function(String path) read = rootBundle.loadString;

  /// The document in [language], else in Azerbaijani (the governing text;
  /// Russian follows after the lawyer's edits), or `null` when none is
  /// ready.
  Future<String?> load(String language) async {
    for (final l in {language, 'az'}) {
      try {
        final text = await read('assets/legal/$name.$l.md');
        if (isReady(text)) return text;
      } on Object {
        // No file in this language.
      }
    }
    return null;
  }
}
