/// Rules for the content the team writes in the admin panel: articles
/// (blog), recipes and expert profiles. The panel checks before saving,
/// the server before storing, the app before showing.
///
/// Every text a user reads exists in az, ru and en. Content is stored as
/// JSON per kind; only the fields below are allowed.
library;

import 'dart:convert';

enum ContentKind { article, recipe, expert }

abstract final class ContentRules {
  static const languages = ['az', 'ru', 'en'];

  static const articleCategories = ['care', 'beauty', 'fashion', 'hair'];
  static const recipeMeals = ['breakfast', 'lunch', 'dinner', 'snack'];
  static const plateGroups = [
    'vegetables',
    'fruit',
    'protein',
    'whole_grain',
    'healthy_fat',
    'dairy',
  ];
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

  /// The categories allowed for [kind].
  static List<String> categoriesFor(ContentKind kind) => switch (kind) {
    ContentKind.article => articleCategories,
    ContentKind.recipe => recipeMeals,
    ContentKind.expert => expertSpecialties,
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

    switch (kind) {
      case ContentKind.article:
        only({'title', 'summary', 'body', 'minutes', 'tips'});
        text('title', maxTitle);
        text('summary', maxSummary);
        text('body', maxBody);
        number('minutes', 1, 60);
        list('tips', maxItem, required: false);
      case ContentKind.recipe:
        only({
          'title',
          'minutes',
          'servings',
          'groups',
          'ingredients',
          'steps',
          'note',
        });
        text('title', maxTitle);
        number('minutes', 1, 240);
        number('servings', 1, 12);
        final groups = json['groups'];
        if (groups == null) {
          if (complete) out.add('groups.missing');
        } else if (groups is! List ||
            groups.isEmpty && complete ||
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
    }
    return out;
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
