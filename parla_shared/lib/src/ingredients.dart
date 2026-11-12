/// Ingredient statuses from the EU cosmetics regulation (EC 1223/2009),
/// as published in the European Commission's CosIng database.
///
/// Rules (product decision): statuses are neutral, sourced and dated. The
/// app never calls an ingredient "harmful" or judges a product. A missing
/// entry only means the annexes list nothing for that name.
library;

/// The annexes of Regulation (EC) 1223/2009 that Parla shows.
enum EuAnnex {
  /// Substances prohibited in cosmetic products.
  ii,

  /// Substances allowed only with restrictions (limits, product types,
  /// warnings).
  iii,

  /// Allowed colorants.
  iv,

  /// Allowed preservatives.
  v,

  /// Allowed UV filters.
  vi;

  /// Roman numeral as written in the regulation.
  String get roman => switch (this) {
    EuAnnex.ii => 'II',
    EuAnnex.iii => 'III',
    EuAnnex.iv => 'IV',
    EuAnnex.v => 'V',
    EuAnnex.vi => 'VI',
  };

  static EuAnnex? fromRoman(String value) {
    final v = value.trim().toUpperCase();
    for (final annex in EuAnnex.values) {
      if (annex.roman == v) return annex;
    }
    return null;
  }
}

/// One annex entry for an ingredient.
class IngredientRule {
  const IngredientRule({
    required this.annex,
    required this.reference,
    this.conditions,
  });

  final EuAnnex annex;

  /// The entry's reference number in the annex, e.g. "98".
  final String reference;

  /// Official conditions of use and warnings, in the original English
  /// wording (never paraphrased, so nothing is lost or changed).
  final String? conditions;
}

/// What the dataset holds about one INCI name.
class IngredientEntry {
  const IngredientEntry({required this.inci, required this.rules});

  final String inci;
  final List<IngredientRule> rules;
}

/// A CosIng export converted by `tool/import_cosing.dart`.
class IngredientDataset {
  IngredientDataset({
    required this.source,
    required this.exportedOn,
    required List<IngredientEntry> entries,
  }) : _byName = {for (final e in entries) normaliseInci(e.inci): e};

  /// Where the data comes from, e.g. "CosIng".
  final String source;

  /// The date of the official export, `null` when there is no data yet.
  final String? exportedOn;

  final Map<String, IngredientEntry> _byName;

  bool get isEmpty => _byName.isEmpty;
  int get length => _byName.length;

  IngredientEntry? lookup(String name) => _byName[normaliseInci(name)];
}

/// Upper case, single spaces, without footnote marks such as `*` or `°`.
String normaliseInci(String name) => name
    .replaceAll(RegExp(r'[*°†‡]'), '')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim()
    .toUpperCase();

/// Splits an ingredient list into names: on commas and semicolons outside
/// brackets, without a leading "Ingredients:" label or a trailing full stop.
List<String> splitIngredients(String text) {
  var rest = text.trim();
  final label = RegExp(
    r'^(ingredients?|inci|состав|tərkib|içindekiler)\s*:\s*',
    caseSensitive: false,
  );
  rest = rest.replaceFirst(label, '');
  final names = <String>[];
  final current = StringBuffer();
  var depth = 0;
  for (final ch in rest.split('')) {
    if (ch == '(' || ch == '[') depth++;
    if ((ch == ')' || ch == ']') && depth > 0) depth--;
    if ((ch == ',' || ch == ';') && depth == 0) {
      names.add(current.toString());
      current.clear();
    } else {
      current.write(ch);
    }
  }
  names.add(current.toString());
  return [
    for (final n in names)
      if (n.trim().replaceAll(RegExp(r'\.$'), '').trim().isNotEmpty)
        n.trim().replaceAll(RegExp(r'\.$'), '').trim(),
  ];
}

/// One ingredient of a product with what the dataset says about it.
class IngredientMatch {
  const IngredientMatch({required this.name, required this.entry});

  /// The name as written on the product.
  final String name;

  /// The dataset entry, or `null` when the annexes list nothing for it.
  final IngredientEntry? entry;
}

/// Looks every ingredient up. Alternative names written as "Aqua/Water" or
/// "Aqua (Water)" are tried one by one.
List<IngredientMatch> analyseIngredients(
  String text,
  IngredientDataset dataset,
) => [
  for (final name in splitIngredients(text))
    IngredientMatch(name: name, entry: _find(name, dataset)),
];

IngredientEntry? _find(String name, IngredientDataset dataset) {
  final direct = dataset.lookup(name);
  if (direct != null) return direct;
  final candidates = <String>{
    ...name.split('/'),
    name.replaceAll(RegExp(r'\s*\([^)]*\)'), ''),
    ...RegExp(r'\(([^)]*)\)').allMatches(name).map((m) => m.group(1)!),
  };
  for (final candidate in candidates) {
    if (candidate.trim().isEmpty) continue;
    final hit = dataset.lookup(candidate);
    if (hit != null) return hit;
  }
  return null;
}
