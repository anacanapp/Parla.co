/// Product preferences for "Yoxla": the user picks what she wants to avoid
/// and the check compares a product's ingredient list with her picks.
///
/// Rules (product decision):
/// - The result is neutral and about her own preferences only: "matches"
///   or "contains X". No score, no risk label, nothing called harmful.
/// - A preference is an ingredient rule kept in code and changed by pull
///   request, so every change is reviewed. New options are added here.
/// - "Vegan" can only say that no known animal-derived ingredient was
///   found: many names (glycerin, squalane, stearic acid) can come from
///   plants or animals, and the list does not say which.
/// - "Allergy-linked preservatives" flags preservatives most often linked
///   to contact allergy; preservatives keep products safe, the wording
///   stays neutral.
///
/// EXPERT REVIEW PENDING: the ingredient lists below are drafts.
library;

import 'ingredients.dart';

/// One preference and the ingredient names that do not fit it.
class ProductPreference {
  const ProductPreference({
    required this.id,
    this.exact = const {},
    this.contains = const {},
    this.endsWith = const {},
    this.except = const {},
    this.cautious = false,
  });

  /// Stable id, stored with the user's picks.
  final String id;

  /// Lower-case INCI names that conflict.
  final Set<String> exact;

  /// Substrings of a normalised name that conflict ("paraben").
  final Set<String> contains;

  /// Endings of a normalised name that conflict ("siloxane").
  final Set<String> endsWith;

  /// Normalised names that never conflict even if a pattern matches
  /// (fatty alcohols for "alcohol free").
  final Set<String> except;

  /// The answer can only be "nothing known found" (vegan).
  final bool cautious;

  /// Whether the lower-case ingredient [name] conflicts with this
  /// preference.
  bool conflictsWith(String name) {
    if (except.contains(name)) return false;
    if (exact.contains(name)) return true;
    if (contains.any(name.contains)) return true;
    return endsWith.any(name.endsWith);
  }
}

/// The preferences offered in this version, in display order. From the
/// content sheet ("yoxla_secimleri"), drafts until a cosmetic chemist
/// reviews them; "paraben_free" is kept from the first version.
const productPreferences = <ProductPreference>[
  ProductPreference(
    id: 'fragrance_free',
    exact: {
      "parfum",
      "fragrance",
      "aroma",
      "flavor",
      "limonene",
      "linalool",
      "citronellol",
      "geraniol",
      "citral",
      "eugenol",
      "isoeugenol",
      "cinnamal",
      "cinnamyl alcohol",
      "coumarin",
      "farnesol",
      "hydroxycitronellal",
      "amyl cinnamal",
      "amylcinnamyl alcohol",
      "anise alcohol",
      "benzyl benzoate",
      "benzyl cinnamate",
      "benzyl salicylate",
      "hexyl cinnamal",
      "alpha-isomethyl ionone",
      "evernia prunastri extract",
      "evernia furfuracea extract",
      "methyl 2-octynoate",
    },
  ),
  ProductPreference(
    id: 'essential_oil_free',
    exact: {
      "lavandula angustifolia oil",
      "citrus aurantium dulcis peel oil",
      "citrus limon peel oil",
      "citrus aurantium bergamia peel oil",
      "citrus paradisi peel oil",
      "mentha piperita oil",
      "eucalyptus globulus leaf oil",
      "melaleuca alternifolia leaf oil",
      "rosmarinus officinalis leaf oil",
      "rosa damascena flower oil",
      "pelargonium graveolens oil",
      "cymbopogon schoenanthus oil",
      "cananga odorata flower oil",
      "salvia sclarea oil",
      "cinnamomum zeylanicum bark oil",
    },
  ),
  ProductPreference(
    id: 'alcohol_free',
    except: {
      'cetyl alcohol',
      'cetearyl alcohol',
      'stearyl alcohol',
      'behenyl alcohol',
      'myristyl alcohol',
      'lauryl alcohol',
      'arachidyl alcohol',
      'benzyl alcohol',
    },
    exact: {
      "alcohol",
      "alcohol denat",
      "ethanol",
      "isopropyl alcohol",
      "sd alcohol 40",
      "sd alcohol 40-b",
      "methanol",
    },
  ),
  ProductPreference(
    id: 'vegan',
    cautious: true,
    exact: {
      "carmine",
      "ci 75470",
      "lanolin",
      "lanolin alcohol",
      "cera alba",
      "beeswax",
      "mel",
      "honey",
      "propolis extract",
      "royal jelly",
      "snail secretion filtrate",
      "collagen",
      "hydrolyzed collagen",
      "elastin",
      "keratin",
      "hydrolyzed keratin",
      "guanine",
      "milk protein",
      "lactis proteinum",
      "sericin",
      "squalene",
    },
  ),
  ProductPreference(
    id: 'silicone_free',
    endsWith: {'methicone', 'siloxane', 'siloxysilicate'},
    exact: {
      "dimethicone",
      "dimethiconol",
      "amodimethicone",
      "cyclomethicone",
      "cyclopentasiloxane",
      "cyclohexasiloxane",
      "phenyl trimethicone",
      "trimethylsiloxysilicate",
      "cetyl dimethicone",
      "peg-10 dimethicone",
      "bis-aminopropyl dimethicone",
      "dimethicone crosspolymer",
    },
  ),
  ProductPreference(
    id: 'sulfate_free',
    exact: {
      "sodium lauryl sulfate",
      "sodium laureth sulfate",
      "ammonium lauryl sulfate",
      "ammonium laureth sulfate",
      "sodium coco-sulfate",
      "sodium myreth sulfate",
      "tea-lauryl sulfate",
      "magnesium laureth sulfate",
    },
  ),
  ProductPreference(
    id: 'retinoid_free',
    exact: {
      "retinol",
      "retinal",
      "retinyl palmitate",
      "retinyl acetate",
      "retinyl propionate",
      "retinyl linoleate",
      "retinyl retinoate",
      "hydroxypinacolone retinoate",
      "tretinoin",
      "adapalene",
      "tazarotene",
    },
  ),
  ProductPreference(
    id: 'preservative_alert',
    exact: {
      "methylisothiazolinone",
      "methylchloroisothiazolinone",
      "dmdm hydantoin",
      "imidazolidinyl urea",
      "diazolidinyl urea",
      "quaternium-15",
      "sodium hydroxymethylglycinate",
      "2-bromo-2-nitropropane-1,3-diol",
    },
  ),
  ProductPreference(
    id: 'lanolin_free',
    exact: {
      "lanolin",
      "lanolin alcohol",
      "lanolin oil",
      "hydrogenated lanolin",
      "acetylated lanolin",
      "lanolin cera",
      "peg-75 lanolin",
      "isopropyl lanolate",
    },
  ),
  // Kept from the first version (not in the content sheet).
  ProductPreference(id: 'paraben_free', contains: {'paraben'}),
];

/// The preference with [id], or `null` for an id this version does not
/// know (dropped from stored picks).
ProductPreference? productPreference(String id) {
  for (final p in productPreferences) {
    if (p.id == id) return p;
  }
  return null;
}

enum PreferenceOutcome {
  /// Nothing in the list conflicts (for a cautious preference: nothing
  /// known found).
  fits,

  /// At least one ingredient conflicts; see [PreferenceResult.found].
  conflicts,

  /// The product has no ingredient list.
  unknown,
}

class PreferenceResult {
  const PreferenceResult(this.preference, this.outcome, this.found);

  final ProductPreference preference;
  final PreferenceOutcome outcome;

  /// The ingredient names as written on the product that conflict.
  final List<String> found;
}

/// Compares [ingredientsText] with the user's [picked] preference ids, in
/// display order. Unknown ids are ignored.
List<PreferenceResult> checkPreferences(
  String? ingredientsText,
  Iterable<String> picked,
) {
  final names = ingredientsText == null
      ? const <String>[]
      : splitIngredients(ingredientsText);
  final chosen = picked.toSet();
  return [
    for (final p in productPreferences)
      if (chosen.contains(p.id))
        if (names.isEmpty)
          PreferenceResult(p, PreferenceOutcome.unknown, const [])
        else
          _result(p, names),
  ];
}

PreferenceResult _result(ProductPreference p, List<String> names) {
  final found = [
    for (final n in names)
      if (_candidates(n).any(p.conflictsWith)) n,
  ];
  return PreferenceResult(
    p,
    found.isEmpty ? PreferenceOutcome.fits : PreferenceOutcome.conflicts,
    found,
  );
}

/// The lower-case name, plus each part of "a/b" names, the name without a
/// bracket ("parfum (fragrance)") and the bracket's content.
Iterable<String> _candidates(String name) sync* {
  final base = _norm(name);
  yield base;
  final noBracket = _norm(name.replaceAll(RegExp(r'\(.*?\)'), ''));
  if (noBracket != base) yield noBracket;
  final inBracket = RegExp(r'\((.*?)\)').firstMatch(name)?.group(1);
  if (inBracket != null) yield _norm(inBracket);
  if (name.contains('/')) {
    for (final part in name.split('/')) {
      yield _norm(part);
    }
  }
}

String _norm(String name) =>
    normaliseInci(name).toLowerCase().replaceAll(RegExp(r'\.+$'), '').trim();
