import 'package:flutter/widgets.dart';
import 'package:parla_shared/parla_shared.dart';

/// A rule violation reported by the server, identified by a stable [code]
/// such as `age.minor`. Screens translate it with `errorMessage`.
class ApiError implements Exception {
  const ApiError(this.code);

  final String code;

  @override
  String toString() => 'ApiError($code)';
}

/// The part of a profile the app needs.
class ProfileSummary {
  const ProfileSummary({required this.countryCode, required this.language});

  final String countryCode;
  final String language;
}

/// A product found by search (M-20, M-21). Public data only.
class ProductResult {
  const ProductResult({
    required this.source,
    required this.code,
    required this.name,
    this.brand,
    this.ingredientsText,
    this.sourceUrl,
  });

  /// "parla" (our catalogue) or "openbeautyfacts".
  final String source;
  final String code;
  final String name;
  final String? brand;
  final String? ingredientsText;
  final String? sourceUrl;
}

/// A published article, recipe or expert profile.
/// A published image: where to load it and its alt text per language.
class ContentImageRef {
  const ContentImageRef({
    required this.url,
    required this.width,
    required this.height,
    required this.alt,
  });

  factory ContentImageRef.fromJson(Map<String, Object?> json) =>
      ContentImageRef(
        url: json['url']! as String,
        width: (json['width']! as num).toInt(),
        height: (json['height']! as num).toInt(),
        alt: (json['alt']! as Map).cast<String, Object?>(),
      );

  final String url;
  final int width;
  final int height;
  final Map<String, Object?> alt;

  double get aspectRatio => height == 0 ? 1 : width / height;

  Map<String, Object?> toJson() => {
    'url': url,
    'width': width,
    'height': height,
    'alt': alt,
  };
}

class PublishedItem {
  const PublishedItem({
    required this.id,
    required this.kind,
    required this.slug,
    required this.category,
    required this.data,
    required this.publishedAt,
    this.reviewedAt,
    this.image,
    this.hidden = false,
  });

  factory PublishedItem.fromJson(Map<String, Object?> json) => PublishedItem(
    id: (json['id']! as num).toInt(),
    kind: json['kind']! as String,
    slug: json['slug']! as String,
    category: json['category']! as String,
    data: (json['data']! as Map).cast<String, Object?>(),
    publishedAt: DateTime.parse(json['publishedAt']! as String),
    reviewedAt: json['reviewedAt'] == null
        ? null
        : DateTime.parse(json['reviewedAt']! as String),
    image: json['image'] is Map
        ? ContentImageRef.fromJson(
            (json['image']! as Map).cast<String, Object?>(),
          )
        : null,
    hidden: json['hidden'] == true,
  );

  final int id;
  final String kind;
  final String slug;
  final String category;
  final Map<String, Object?> data;
  final DateTime publishedAt;

  /// When an expert reviewed it, or `null` (expert profiles).
  final DateTime? reviewedAt;

  /// The published image, or `null`.
  final ContentImageRef? image;

  /// Catalogue items the team hid: the app does not offer them.
  final bool hidden;

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind,
    'slug': slug,
    'category': category,
    'data': data,
    'publishedAt': publishedAt.toIso8601String(),
    if (reviewedAt != null) 'reviewedAt': reviewedAt!.toIso8601String(),
    if (image != null) 'image': image!.toJson(),
    if (hidden) 'hidden': true,
  };

  /// A localized text field in [language] (Azerbaijani as fallback).
  String text(String key, String language) =>
      ContentRules.pick(data[key], language);

  /// A localized list field in [language].
  List<String> lines(String key, String language) => [
    for (final e in (data[key] as List? ?? const []))
      ContentRules.pick(e, language),
  ];
}

/// Everything the screens need from the backend.
///
/// Screens depend on this interface, not on the generated Serverpod client,
/// so widget tests can run without a server.
abstract interface class ParlaApi {
  bool get isSignedIn;

  /// A stable id of the signed-in account, used only to keep each account's
  /// on-device data (habits) apart. `null` when signed out.
  String? get accountId;

  /// The signed-in user's profile, or `null` before onboarding is finished.
  Future<ProfileSummary?> myProfile();

  /// Creates the profile. Throws [ApiError] when a rule is broken.
  Future<void> createProfile({
    required int birthYear,
    bool? birthdayPassedThisYear,
    required String countryCode,
    required String language,
  });

  /// Records a consent decision about the text version the user saw.
  Future<void> decideConsent({
    required ConsentKind kind,
    required bool granted,
    required String textVersion,
    required String language,
  });

  /// Whether the health consent is currently granted.
  Future<bool> hasHealthConsent();

  /// Saves quiz answers. Only questions with `stored: true` are sent; health
  /// answers only when the health consent is granted.
  Future<void> saveQuizAnswers(QuizAnswers answers);

  /// The saved quiz answers, or `null` when the quiz was never taken.
  Future<QuizAnswers?> myQuizAnswers();

  /// The user's own routines and ticks as JSON (see `CustomRoutineRules`),
  /// or `null` when none are stored or the health consent is not granted.
  Future<String?> myRoutines();

  /// Replaces the stored own routines. Needs the health consent.
  Future<void> saveRoutines(String json);

  /// The "Yoxla" preferences, checked products and shopping list as JSON
  /// (see `CareListRules`), or `null` when none or not covered by the
  /// health consent.
  Future<String?> myCareList();

  /// Replaces the stored care list. Needs the health consent.
  Future<void> saveCareList(String json);

  /// The sport answers and workout log as JSON (see `SportRules`), or
  /// `null` when none or not covered by the health consent.
  Future<String?> mySport();

  /// Replaces the stored sport document. Needs the health consent.
  Future<void> saveSport(String json);

  /// Published content of [kind] (no sign-in needed).
  Future<List<PublishedItem>> publishedContent(String kind);

  /// The daily plate entries as JSON (see `NutritionRules`), or `null`.
  Future<String?> myNutrition();

  /// Replaces the stored plate entries. Needs the health consent.
  Future<void> saveNutrition(String json);

  /// The current decision for every consent (M-28).
  Future<Map<ConsentKind, bool>> consentStates();

  /// Everything stored about the user, as JSON (M-31).
  Future<String> exportMyData();

  /// Deletes the account and signs out on this device (M-32).
  Future<void> deleteAccount();

  /// Products whose name or brand matches [query]. Throws [ApiError] with
  /// `product.query_invalid` or `product.source_unavailable`.
  Future<List<ProductResult>> searchProducts(String query);

  /// Signs out on this device.
  Future<void> signOut();

  /// The sign-in UI (screens M-05 and M-06).
  Widget buildSignIn(
    BuildContext context, {
    required VoidCallback onSignedIn,
    required ValueChanged<Object> onError,
  });
}
