/// Rules for the content the team writes in the admin panel: articles
/// (blog), recipes and expert profiles. The panel checks before saving,
/// the server before storing, the app before showing.
///
/// Every text a user reads exists in az, ru and en. Content is stored as
/// JSON per kind; only the fields below are allowed.
library;

import 'dart:convert';

import 'markets.dart';
import 'product_preferences.dart';
import 'routine_rules.dart';
import 'sport_rules.dart';
import 'texts/exercise_draft_texts.dart';
import 'texts/exercise_sheet_texts.dart';
import 'texts/preference_texts.dart';
import 'texts/routine_step_texts.dart';

enum ContentKind {
  article,
  recipe,
  expert,

  /// Texts of the app's own catalogues (B2b-2). The items, their logic and
  /// their safety rules stay in code; the panel edits only the texts, the
  /// exercise image and video and whether the app shows the item.
  preference,
  exercise,
  step,

  /// A card on the Today or Discover screen (admin phase D1). With a
  /// `sponsor` it is a brand's paid campaign, always labelled as an ad.
  banner,

  /// An announcement from the team in the app's Messages (phase D2).
  message,

  /// A push notification campaign (phase D3), sent once on publishing to
  /// accounts with the marketing consent.
  push;

  bool get isCatalogue =>
      this == preference || this == exercise || this == step;
}

abstract final class ContentRules {
  static const languages = ['az', 'ru', 'en'];

  static const articleCategories = [
    'care',
    'beauty',
    'fashion',
    'hair',
    'body',
  ];
  static const recipeMeals = ['breakfast', 'lunch', 'dinner', 'snack'];
  static const plateGroups = [
    'vegetables',
    'fruit',
    'protein',
    'whole_grain',
    'healthy_fat',
    'dairy',
  ];

  /// The 14 allergens food labels must name in the EU (Regulation
  /// 1169/2011, Annex II). A recipe lists the ones it contains; an empty
  /// list means "none of these" and must be chosen explicitly.
  static const recipeAllergens = [
    'gluten',
    'crustaceans',
    'egg',
    'fish',
    'peanuts',
    'soy',
    'milk',
    'nuts',
    'celery',
    'mustard',
    'sesame',
    'sulphites',
    'lupin',
    'molluscs',
  ];

  /// Starts the writing plan put into imported article drafts. An article
  /// that still contains it cannot go to review.
  static const planMarker = '[Yazı planı';

  static const maxSources = 10;

  /// Hashtags per language on an article (stored without "#").
  static const maxTags = 10;
  static final _tag = RegExp(r'^[\p{L}\p{N}_]{1,30}$', unicode: true);

  /// Normalises a typed hashtag: drops "#" and spaces; `null` if invalid.
  static String? cleanTag(String raw) {
    final t = raw.trim().replaceFirst(RegExp(r'^#+'), '').replaceAll(' ', '');
    return _tag.hasMatch(t) ? t : null;
  }

  /// Markdown links and images: `[text](target)` / `![alt](target)`.
  static final _markdownLink = RegExp(r'(!?)\[[^\]]*\]\(([^)\s]*)[^)]*\)');

  /// An image uploaded in the panel, used inside an article body.
  static final _mediaRef = RegExp(r'^media:([1-9][0-9]{0,9})$');

  /// Ids of images used inside article bodies (`![alt](media:12)`).
  static Set<int> inlineImageIds(Map<String, Object?> json) {
    final out = <int>{};
    final body = json['body'];
    if (body is! Map) return out;
    for (final v in body.values) {
      if (v is! String) continue;
      for (final m in _markdownLink.allMatches(v)) {
        final ref = _mediaRef.firstMatch(m.group(2)!.trim());
        if (ref != null) out.add(int.parse(ref.group(1)!));
      }
    }
    return out;
  }

  static final _source = RegExp(r'^https://[^\s]{4,500}$');

  static const expertSpecialties = [
    'dermatologist',
    'cosmetologist',
    'trainer',
    'dietitian',
    'trichologist',
  ];

  static const maxTitle = 120;
  static const maxSummary = 300;
  static const maxBody = 12000;
  static const maxItem = 200;
  static const maxItems = 30;
  static const maxBytes = 200 * 1024;

  static final _slug = RegExp(r'^[a-z0-9]+(-[a-z0-9]+)*$');
  static final _phone = RegExp(r'^\+[1-9][0-9]{7,14}$');
  static final _instagram = RegExp(r'^[A-Za-z0-9._]{1,30}$');

  static bool isSlug(String value) =>
      value.length <= 80 && _slug.hasMatch(value);

  /// Where a banner shows (its category).
  static const bannerPlacements = ['today', 'discover'];

  /// In-app places a banner may open.
  static const bannerScreens = [
    'home',
    'routine',
    'check',
    'sport',
    'discover',
    'blog',
    'nutrition',
    'experts',
    'messages',
  ];

  static final _day = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  /// Whether [link] is an allowed banner target: a screen, or
  /// `article:<slug>` / `recipe:<slug>`. No outside web links.
  static bool isBannerLink(String link) {
    if (bannerScreens.contains(link)) return true;
    final i = link.indexOf(':');
    if (i < 0) return false;
    final kind = link.substring(0, i);
    return (kind == 'article' || kind == 'recipe') &&
        isSlug(link.substring(i + 1));
  }

  /// A paid brand campaign (shown with an "Ad" label).
  static bool isSponsored(Map<String, Object?> json) {
    final s = json['sponsor'];
    return s is String && s.trim().isNotEmpty;
  }

  /// Which staff role approves [kind]: brand campaigns and all other
  /// content are approved by an expert; the team's own banners by an admin.
  static String reviewerRole(ContentKind kind, Map<String, Object?> json) =>
      adminPublishesDirectly(kind, json) ? 'admin' : 'expert';

  /// Whether an admin may publish without a separate approval: only the
  /// team's own (not sponsored) banners.
  static bool adminPublishesDirectly(
    ContentKind kind,
    Map<String, Object?> json,
  ) =>
      kind == ContentKind.message ||
      kind == ContentKind.push ||
      (kind == ContentKind.banner && !isSponsored(json));

  /// Whether a published banner shows today for [language] and [country]
  /// (`null` when unknown: then only banners for every country show).
  /// Targeting happens on the phone; nothing about the user is sent.
  static bool bannerVisible(
    Map<String, Object?> json,
    DateTime today, {
    required String language,
    String? country,
  }) {
    final day =
        '${today.year.toString().padLeft(4, '0')}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';
    final starts = json['startsOn'];
    final ends = json['endsOn'];
    if (starts is! String || ends is! String) return false;
    if (day.compareTo(starts) < 0 || day.compareTo(ends) > 0) return false;
    final languages = (json['languages'] as List?)?.cast<String>() ?? const [];
    if (languages.isNotEmpty && !languages.contains(language)) return false;
    final countries = (json['countries'] as List?)?.cast<String>() ?? const [];
    if (countries.isNotEmpty &&
        (country == null || !countries.contains(country))) {
      return false;
    }
    return true;
  }

  /// The single category of catalogue texts.
  static const catalogueCategory = 'catalogue';

  /// Every id of a catalogue kind, as defined in code.
  static List<String> catalogueIds(ContentKind kind) => switch (kind) {
    ContentKind.preference => [for (final p in productPreferences) p.id],
    ContentKind.exercise => [for (final e in exerciseCatalogue) e.id],
    ContentKind.step => [for (final s in routineStepCatalogue) s.id],
    _ => const [],
  };

  /// Whether [slug] may name an item of [kind]: a known id for catalogue
  /// kinds, a well-formed slug otherwise.
  static bool isValidSlug(ContentKind kind, String slug) =>
      kind.isCatalogue ? catalogueIds(kind).contains(slug) : isSlug(slug);

  /// The texts the app ships with for a catalogue item, in the content
  /// format (the panel's starting point).
  static Map<String, Object?> catalogueDefaults(ContentKind kind, String id) {
    Map<String, String>? three(List<String>? v) => v == null
        ? null
        : {
            for (var i = 0; i < languages.length && i < v.length; i++)
              if (v[i].trim().isNotEmpty) languages[i]: v[i],
          };
    switch (kind) {
      case ContentKind.preference:
        final t = preferenceTexts[id];
        if (t == null) return {};
        return {'name': ?three(t[0]), 'hint': ?three(t[1])};
      case ContentKind.exercise:
        final t = exerciseSheetTexts[id];
        if (t != null) {
          final caution = three(t[2]);
          return {
            'name': ?three(t[0]),
            'how': ?three(t[1]),
            if (caution != null && caution.isNotEmpty) 'caution': caution,
          };
        }
        final draft = {
          for (final l in languages) l: ?exerciseDraftTexts[l]?[id],
        };
        if (draft.isEmpty) return {};
        return {
          'name': {for (final e in draft.entries) e.key: e.value[0]},
          'how': {for (final e in draft.entries) e.key: e.value[1]},
        };
      case ContentKind.step:
        final t = routineStepTexts[id];
        if (t == null) return {};
        final tip = three(t[2]);
        return {
          'title': ?three(t[0]),
          'how': ?three(t[1]),
          if (tip != null && tip.isNotEmpty) 'tip': tip,
        };
      default:
        return {};
    }
  }

  /// The categories allowed for [kind].
  static List<String> categoriesFor(ContentKind kind) => switch (kind) {
    ContentKind.article => articleCategories,
    ContentKind.recipe => recipeMeals,
    ContentKind.expert => expertSpecialties,
    ContentKind.preference ||
    ContentKind.exercise ||
    ContentKind.step => const [catalogueCategory],
    ContentKind.banner => bannerPlacements,
    ContentKind.message => const ['announcement'],
    ContentKind.push => const ['marketing'],
  };

  /// Problems with [encoded] as content of [kind]; empty when it is valid.
  /// With [complete], every user-facing text must exist in all three
  /// languages (required before review and publishing); drafts may be
  /// partial.
  static List<String> problems(
    ContentKind kind,
    String encoded, {
    bool complete = false,
  }) {
    final out = <String>[];
    if (utf8.encode(encoded).length > maxBytes) return ['too_large'];
    final Object? decoded;
    try {
      decoded = jsonDecode(encoded);
    } on FormatException {
      return ['not_json'];
    }
    if (decoded is! Map<String, Object?>) return ['not_object'];
    final json = decoded;

    void text(String key, int max, {bool required = true}) {
      final v = json[key];
      if (v == null) {
        if (required && complete) out.add('$key.missing');
        return;
      }
      _localized(v, max, complete, key, out);
    }

    void list(String key, int max, {bool required = true}) {
      final v = json[key];
      if (v == null) {
        if (required && complete) out.add('$key.missing');
        return;
      }
      if (v is! List || v.length > maxItems) {
        out.add('$key.invalid');
        return;
      }
      if (complete && required && v.isEmpty) out.add('$key.missing');
      for (var i = 0; i < v.length; i++) {
        _localized(v[i], max, complete, '$key.$i', out);
      }
    }

    void number(String key, int min, int max) {
      final v = json[key];
      if (v == null) {
        if (complete) out.add('$key.missing');
        return;
      }
      if (v is! int || v < min || v > max) out.add('$key.invalid');
    }

    void only(Set<String> keys) {
      for (final k in json.keys) {
        if (!keys.contains(k)) out.add('$k.unknown');
      }
    }

    final image = json['image'];
    if (image != null && (image is! int || image < 1)) out.add('image.invalid');
    final video = json['video'];
    if (video != null && (video is! int || video < 1)) out.add('video.invalid');

    switch (kind) {
      case ContentKind.article:
        only({
          'title',
          'summary',
          'body',
          'minutes',
          'tips',
          'sources',
          'image',
          'tags',
        });
        text('title', maxTitle);
        text('summary', maxSummary);
        text('body', maxBody);
        number('minutes', 1, 60);
        list('tips', maxItem, required: false);
        final body = json['body'];
        if (complete &&
            body is Map &&
            body.values.any((v) => v is String && v.contains(planMarker))) {
          out.add('body.plan_left');
        }
        if (body is Map) {
          for (final e in body.entries) {
            final v = e.value;
            if (v is! String) continue;
            for (final m in _markdownLink.allMatches(v)) {
              final isImage = m.group(1) == '!';
              final target = m.group(2)!.trim();
              if (isImage && !_mediaRef.hasMatch(target)) {
                out.add('body.${e.key}.image_invalid');
              } else if (!isImage &&
                  !target.startsWith('https://') &&
                  !_mediaRef.hasMatch(target)) {
                out.add('body.${e.key}.link_invalid');
              }
            }
          }
        }
        final tags = json['tags'];
        if (tags != null) {
          if (tags is! Map) {
            out.add('tags.invalid');
          } else {
            for (final e in tags.entries) {
              final v = e.value;
              if (!languages.contains(e.key) ||
                  v is! List ||
                  v.length > maxTags ||
                  !v.every((t) => t is String && _tag.hasMatch(t))) {
                out.add('tags.${e.key}.invalid');
              }
            }
          }
        }
        final sources = json['sources'];
        if (sources != null &&
            (sources is! List ||
                sources.length > maxSources ||
                !sources.every((s) => s is String && _source.hasMatch(s)))) {
          out.add('sources.invalid');
        }
      case ContentKind.recipe:
        only({
          'title',
          'minutes',
          'servings',
          'groups',
          'ingredients',
          'steps',
          'note',
          'allergens',
          'image',
        });
        text('title', maxTitle);
        number('minutes', 1, 240);
        number('servings', 1, 24);
        final groups = json['groups'];
        if (groups == null) {
          if (complete) out.add('groups.missing');
        } else if (groups is! List ||
            // Empty is allowed: sweets fill no plate group.
            !groups.every(plateGroups.contains) ||
            groups.toSet().length != groups.length) {
          out.add('groups.invalid');
        }
        final ingredients = json['ingredients'];
        if (ingredients == null) {
          if (complete) out.add('ingredients.missing');
        } else if (ingredients is! List || ingredients.length > maxItems) {
          out.add('ingredients.invalid');
        } else {
          if (complete && ingredients.isEmpty) out.add('ingredients.missing');
          for (var i = 0; i < ingredients.length; i++) {
            final item = ingredients[i];
            if (item is! Map<String, Object?> ||
                !item.keys.every({'name', 'amount'}.contains)) {
              out.add('ingredients.$i.invalid');
              continue;
            }
            _localized(item['name'], 80, complete, 'ingredients.$i.name', out);
            _localized(
              item['amount'],
              40,
              complete,
              'ingredients.$i.amount',
              out,
            );
          }
        }
        list('steps', maxItem);
        text('note', maxSummary, required: false);
        final allergens = json['allergens'];
        if (allergens == null) {
          if (complete) out.add('allergens.missing');
        } else if (allergens is! List ||
            !allergens.every(recipeAllergens.contains) ||
            allergens.toSet().length != allergens.length) {
          out.add('allergens.invalid');
        }
      case ContentKind.preference:
        only({'name', 'hint'});
        text('name', 80);
        text('hint', 400);
      case ContentKind.exercise:
        only({'name', 'how', 'caution', 'image', 'video'});
        text('name', 80);
        text('how', 600);
        text('caution', 400, required: false);
      case ContentKind.step:
        only({'title', 'how', 'tip'});
        text('title', 80);
        text('how', 600);
        text('tip', 400, required: false);
      case ContentKind.banner:
        only({
          'title',
          'body',
          'image',
          'link',
          'sponsor',
          'startsOn',
          'endsOn',
          'languages',
          'countries',
        });
        text('title', 80);
        text('body', 200, required: false);
        final sponsor = json['sponsor'];
        if (sponsor != null &&
            (sponsor is! String ||
                sponsor.trim().isEmpty ||
                sponsor.length > 60)) {
          out.add('sponsor.invalid');
        }
        _schedule(json, complete, out);
      case ContentKind.push:
        only({'title', 'body', 'link', 'languages', 'countries'});
        text('title', 60);
        text('body', 180);
        final pushLink = json['link'];
        if (pushLink != null &&
            (pushLink is! String || !isBannerLink(pushLink))) {
          out.add('link.invalid');
        }
        final langs = json['languages'];
        if (langs != null &&
            (langs is! List || !langs.every(languages.contains))) {
          out.add('languages.invalid');
        }
        final countries = json['countries'];
        if (countries != null &&
            (countries is! List ||
                !countries.every(
                  (c) => c is String && markets.any((m) => m.countryCode == c),
                ))) {
          out.add('countries.invalid');
        }
      case ContentKind.message:
        only({
          'title',
          'body',
          'link',
          'startsOn',
          'endsOn',
          'languages',
          'countries',
        });
        text('title', 80);
        text('body', 2000);
        _schedule(json, complete, out);
      case ContentKind.expert:
        only({
          'name',
          'workplace',
          'city',
          'years',
          'bio',
          'phone',
          'whatsapp',
          'instagram',
          'image',
          'sample',
        });
        final name = json['name'];
        if (name == null) {
          if (complete) out.add('name.missing');
        } else if (name is! String || name.trim().isEmpty || name.length > 80) {
          out.add('name.invalid');
        }
        text('workplace', 120);
        text('city', 60);
        text('bio', maxSummary, required: false);
        number('years', 0, 60);
        for (final key in ['phone', 'whatsapp']) {
          final v = json[key];
          if (v != null && (v is! String || !_phone.hasMatch(v))) {
            out.add('$key.invalid');
          }
        }
        final ig = json['instagram'];
        if (ig != null && (ig is! String || !_instagram.hasMatch(ig))) {
          out.add('instagram.invalid');
        }
        if (complete &&
            json['phone'] == null &&
            json['whatsapp'] == null &&
            json['instagram'] == null) {
          out.add('contact.missing');
        }
        if (json.containsKey('sample')) {
          final sample = json['sample'];
          if (sample != true) {
            out.add('sample.invalid');
          } else {
            // A sample may never look like, or reach, a real person.
            if (name is! String || !name.startsWith(samplePrefix)) {
              out.add('sample.name');
            }
            if (json['instagram'] != null) out.add('sample.instagram');
            for (final key in ['phone', 'whatsapp']) {
              final v = json[key];
              if (v is String && !v.startsWith(sampleNumberPrefix)) {
                out.add('sample.$key');
              }
            }
          }
        }
    }
    return out;
  }

  /// Sample expert profiles (owner's request, 2026-11-20) show the format
  /// in the app before real experts sign up. Their names start with
  /// [samplePrefix], their numbers with [sampleNumberPrefix] (no Azerbaijani
  /// operator uses it) and they have no Instagram. They may be published
  /// without a recorded consent because they are no one; remove them all
  /// before opening registration.
  static const samplePrefix = 'Nümunə';
  static const sampleNumberPrefix = '+99400000';

  /// Whether [json] is a sample expert profile.
  static bool isSampleExpert(Map<String, Object?> json) =>
      json['sample'] == true;

  /// Link, dates, languages and countries of banners and messages.
  static void _schedule(
    Map<String, Object?> json,
    bool complete,
    List<String> out,
  ) {
    final link = json['link'];
    if (link != null && (link is! String || !isBannerLink(link))) {
      out.add('link.invalid');
    }
    final starts = json['startsOn'];
    final ends = json['endsOn'];
    for (final (key, v) in [('startsOn', starts), ('endsOn', ends)]) {
      if (v == null) {
        if (complete) out.add('$key.missing');
      } else if (v is! String || !_day.hasMatch(v)) {
        out.add('$key.invalid');
      }
    }
    if (starts is String &&
        ends is String &&
        _day.hasMatch(starts) &&
        _day.hasMatch(ends) &&
        ends.compareTo(starts) < 0) {
      out.add('endsOn.before_start');
    }
    final langs = json['languages'];
    if (langs != null && (langs is! List || !langs.every(languages.contains))) {
      out.add('languages.invalid');
    }
    final countries = json['countries'];
    if (countries != null &&
        (countries is! List ||
            !countries.every(
              (c) => c is String && markets.any((m) => m.countryCode == c),
            ))) {
      out.add('countries.invalid');
    }
  }

  static void _localized(
    Object? value,
    int max,
    bool complete,
    String key,
    List<String> out,
  ) {
    if (value is! Map<String, Object?>) {
      out.add('$key.invalid');
      return;
    }
    for (final k in value.keys) {
      if (!languages.contains(k)) out.add('$key.$k.unknown');
    }
    for (final lang in languages) {
      final v = value[lang];
      if (v == null || (v is String && v.trim().isEmpty)) {
        if (complete) out.add('$key.$lang.missing');
      } else if (v is! String || v.length > max) {
        out.add('$key.$lang.invalid');
      }
    }
  }

  /// [value] in [language], falling back to Azerbaijani.
  static String pick(Object? value, String language) {
    if (value is String) return value;
    if (value is! Map) return '';
    final v = value[language] ?? value['az'];
    return v is String ? v : '';
  }
}
