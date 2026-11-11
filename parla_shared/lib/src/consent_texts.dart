/// Consent texts shown on screen M-08 and recorded on the server.
///
/// The app shows exactly these strings and the server stores the version and
/// a SHA-256 hash of the text in the language the person saw (GDPR Art. 7(1),
/// checklist CON-3). Changing a text requires a new [ConsentText.version];
/// the old version stays here so existing records can still be verified.
///
/// LEGAL REVIEW PENDING: these are drafts, not reviewed by a lawyer.
library;

import 'dart:convert';

import 'package:crypto/crypto.dart';

/// The three separate consents (checklist CON-1). Names must match the
/// server's `ConsentType` enum.
enum ConsentKind { health, analytics, marketing }

/// One version of a consent text in every supported language.
class ConsentText {
  const ConsentText({
    required this.kind,
    required this.version,
    required this.bodies,
  });

  final ConsentKind kind;
  final String version;

  /// Text per language code.
  final Map<String, String> bodies;

  /// The text in [language], or `null` if that language is missing.
  String? bodyFor(String language) => bodies[language];

  /// SHA-256 of the text in [language], or `null` if that language is missing.
  String? hashFor(String language) {
    final body = bodyFor(language);
    return body == null ? null : consentTextHash(body);
  }
}

/// Hex SHA-256 of a consent text, as stored with each consent record.
String consentTextHash(String text) =>
    sha256.convert(utf8.encode(text)).toString();

/// All versions ever shown, newest last per kind.
const List<ConsentText> consentTextHistory = [
  ConsentText(
    kind: ConsentKind.health,
    version: 'health-2026-11-draft1',
    bodies: {
      'az':
          'Dəri vəziyyətləri, allergiyalar, hamiləlik və qəbul etdiyim dərman '
          'kateqoriyaları haqqında cavablarımın yalnız mənə fərdi və təhlükəsiz '
          'qulluq rutini qurmaq üçün emal olunmasına açıq razılıq verirəm. Bu '
          'məlumatlar şifrələnmiş saxlanılır, üçüncü tərəflərə verilmir və '
          'analitikada istifadə olunmur. Razılığı istənilən vaxt Parametrlər → '
          'Məxfilik bölməsində geri götürə bilərəm; bu halda həmin məlumatlar 24 '
          'saat ərzində silinir.',
      'ru':
          'Я даю явное согласие на обработку моих ответов о состоянии кожи, '
          'аллергиях, беременности и категориях принимаемых лекарств '
          'исключительно для составления персонального и безопасного ухода. Эти '
          'данные хранятся в зашифрованном виде, не передаются третьим лицам и не '
          'используются в аналитике. Я могу отозвать согласие в любой момент в '
          'разделе Настройки → Конфиденциальность; в этом случае данные '
          'удаляются в течение 24 часов.',
      'en':
          'I give explicit consent to the processing of my answers about skin '
          'conditions, allergies, pregnancy and the categories of medicines I '
          'take, solely to build a personal and safe care routine. This data is '
          'stored encrypted, is not shared with third parties and is not used '
          'for analytics. I can withdraw consent at any time in Settings → '
          'Privacy; the data is then deleted within 24 hours.',
    },
  ),
  ConsentText(
    kind: ConsentKind.analytics,
    version: 'analytics-2026-11-draft1',
    bodies: {
      'az':
          'Tətbiqin necə istifadə olunduğunu anlamaq üçün şəxsiyyətimi birbaşa '
          'göstərməyən identifikatorla istifadə statistikasının (açılan ekranlar, '
          'istifadə olunan funksiyalar) toplanmasına razıyam. Sağlamlıq '
          'cavablarım analitikaya heç vaxt göndərilmir.',
      'ru':
          'Я даю согласие на сбор статистики использования (открытые экраны, '
          'используемые функции) с идентификатором, который не раскрывает мою '
          'личность напрямую, чтобы понять, как используется приложение. Мои '
          'ответы о здоровье никогда не передаются в аналитику.',
      'en':
          'I agree to the collection of usage statistics (screens opened, '
          'features used) under an identifier that does not directly reveal who '
          'I am, to understand how the app is used. My health answers are never '
          'sent to analytics.',
    },
  ),
  ConsentText(
    kind: ConsentKind.marketing,
    version: 'marketing-2026-11-draft1',
    bodies: {
      'az':
          'Parla yenilikləri və məsləhətləri haqqında e-poçt almağa razıyam. '
          'İstənilən məktubdakı linklə abunəlikdən çıxa bilərəm.',
      'ru':
          'Я даю согласие получать по электронной почте новости и советы Parla. '
          'Я могу отписаться по ссылке в любом письме.',
      'en':
          'I agree to receive emails with Parla news and tips. I can unsubscribe '
          'via the link in any email.',
    },
  ),
];

/// The version currently shown for [kind].
ConsentText currentConsentText(ConsentKind kind) =>
    consentTextHistory.lastWhere((t) => t.kind == kind);

/// Looks up a specific version, or `null` if it does not exist.
ConsentText? consentTextByVersion(ConsentKind kind, String version) {
  for (final text in consentTextHistory) {
    if (text.kind == kind && text.version == version) return text;
  }
  return null;
}
