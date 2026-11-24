import 'dart:convert';

import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';
import 'content_import.dart' show taskAdmin;

/// Approximate kcal per serving of the published recipes, estimated on
/// 2026-11-24 from their ingredients and amounts (standard food tables,
/// rounded to 10). NOT REVIEWED by a dietitian yet; the app shows them as
/// estimates.
const recipeKcal = <String, int>{
  'ajapsandal': 210,
  'almond-trout': 340,
  'apple-almond-butter': 210,
  'azerbaijani-cheese-board': 370,
  'baba-ganoush': 90,
  'baked-apple': 160,
  'baked-fish-veg': 320,
  'baked-herb-chicken-kofta': 220,
  'baked-sea-bass': 320,
  'banana-bread-chocolate': 260,
  'banana-bread-classic': 220,
  'banana-bread-oat-walnut': 230,
  'banana-oat-cocoa-smoothie': 300,
  'banana-oat-cookies': 70,
  'beet-carpaccio': 270,
  'beet-walnut-salad': 130,
  'berry-oats': 360,
  'berry-yoghurt-smoothie': 260,
  'buckwheat-mushrooms': 390,
  'buckwheat-risotto': 470,
  'bulgur-chickpea-salad': 360,
  'bulgur-stuffed-peppers': 260,
  'carrot-cake-light': 350,
  'carrot-cake-muffins': 160,
  'cheese-herb-toast': 310,
  'chicken-durum': 400,
  'chicken-veg-pan': 250,
  'chickpea-veg-stew': 270,
  'choban-salad': 150,
  'cinnamon-roll-apple': 260,
  'cinnamon-roll-classic': 310,
  'cinnamon-roll-yoghurt-quick': 190,
  'classic-cheese-board': 370,
  'cucumber-yoghurt': 100,
  'dark-choc-chip-cookies': 130,
  'dark-chocolate-strawberries': 300,
  'date-energy-balls': 90,
  'date-night-cheese-plate': 450,
  'dovga': 210,
  'frozen-yoghurt-bark': 100,
  'garlic-prawn-pasta': 540,
  'ginger-cinnamon-cookies': 100,
  'greek-salad': 260,
  'green-beans-eggs': 210,
  'green-kiwi-smoothie': 160,
  'herb-kuku': 180,
  'herb-qutab': 250,
  'hummus-veg': 280,
  'lamb-chops-pomegranate': 510,
  'lentil-pumpkin-feta-salad': 350,
  'light-caesar': 360,
  'mango-turmeric-smoothie': 240,
  'mezze-platter': 240,
  'nuts-dried-fruit': 180,
  'pomegranate-beet-smoothie': 200,
  'pomegranate-parfait': 300,
  'pumpkin-veloute': 140,
  'quinoa-avocado-salad': 380,
  'red-lentil-curry': 280,
  'red-lentil-soup': 220,
  'roasted-chickpeas': 170,
  'saffron-chicken-plov': 560,
  'salmon-papillote': 400,
  'salmon-pea-puree': 530,
  'spinach-apple-smoothie': 310,
  'steak-chimichurri': 470,
  'stuffed-courgettes': 300,
  'tahini-almond-cookies': 120,
  'thyme-chicken-celeriac': 540,
  'tomato-bruschetta': 200,
  'tomato-eggs': 290,
  'tuna-bean-bowl': 280,
  'turkey-meatballs-tomato': 270,
  'veg-chips': 90,
  'vegetarian-yarpaq-dolma': 160,
  'yoghurt-chicken-skewers': 230,
};

/// Fixes to the ingredients of three published recipes whose amounts were
/// missing (owner 2026-11-24): `add` appends an ingredient, `amount`
/// replaces the amount of the ingredient with that English name. Applied
/// once: an ingredient already added, or an amount already set, is left.
const recipeIngredientFixes = <String, List<Map<String, Object?>>>{
  'herb-qutab': [
    {
      'add': {
        'name': {
          'az': 'Kərə yağı (üstünə sürtmək üçün)',
          'ru': 'Сливочное масло (для смазывания)',
          'en': 'Butter (for brushing)',
        },
        'amount': {'az': '1 xörək qaşığı', 'ru': '1 ст. ложка', 'en': '1 tbsp'},
      },
    },
  ],
  'hummus-veg': [
    {
      'amount': 'Carrot, cucumber, pepper',
      'to': {
        'az': '250 q, çubuq şəklində',
        'ru': '250 г, соломкой',
        'en': '250 g, cut into sticks',
      },
    },
  ],
  'steak-chimichurri': [
    {
      'amount': 'Olive oil',
      'to': {
        'az': '3 xörək qaşığı (sous və tərəvəz üçün)',
        'ru': '3 ст. л. (для соуса и овощей)',
        'en': '3 tbsp (sauce and vegetables)',
      },
    },
  ],
};

/// [json] with the [fixes] applied; the same map when nothing changes.
Map<String, Object?> applyIngredientFixes(
  Map<String, Object?> json,
  List<Map<String, Object?>> fixes,
) {
  final items = [
    for (final i in (json['ingredients'] as List? ?? const []))
      Map<String, Object?>.from(i as Map),
  ];
  var changed = false;
  String en(Map<String, Object?> i) => '${(i['name'] as Map?)?['en']}';
  for (final fix in fixes) {
    if (fix['add'] case final Map<String, Object?> add) {
      if (!items.any((i) => en(i) == en(add))) {
        items.add(add);
        changed = true;
      }
    } else if (fix['amount'] case final String name) {
      for (final i in items) {
        if (en(i) == name &&
            '${(i['amount'] as Map?)?['en']}' != (fix['to']! as Map)['en']) {
          i['amount'] = fix['to'];
          changed = true;
        }
      }
    }
  }
  return changed ? {...json, 'ingredients': items} : json;
}

/// The one-off task `PARLA_TASK=set-recipe-kcal`: writes [recipeKcal] into
/// the working and the published copy of each recipe that has no
/// `kcal` yet (a value set in the panel wins). Status and review stay as they are;
/// audited as `content.kcal_set` with the admin [email] as the actor.
Future<String> runSetRecipeKcalTask(
  Session session,
  String email, {
  Map<String, int> values = recipeKcal,
  Map<String, List<Map<String, Object?>>> fixes = recipeIngredientFixes,
}) async {
  final staff = await taskAdmin(session, email);
  final rows = await ContentItem.db.find(
    session,
    where: (t) => t.kind.equals(ContentKind.recipe.name),
  );
  var set = 0;
  var fixed = 0;
  final skipped = <String>[];
  for (var row in rows) {
    final kcal = values[row.slug];
    final fix = fixes[row.slug];
    if (kcal == null && fix == null) continue;
    var draft = jsonDecode(row.draftJson) as Map<String, Object?>;
    var published = row.publishedJson == null
        ? null
        : jsonDecode(row.publishedJson!) as Map<String, Object?>;
    var fixedHere = false;
    if (fix != null) {
      final d = applyIngredientFixes(draft, fix);
      final p = published == null ? null : applyIngredientFixes(published, fix);
      fixedHere = !identical(d, draft) || !identical(p, published);
      (draft, published) = (d, p);
    }
    var kcalHere = false;
    if (kcal != null) {
      if (draft['kcal'] != null || published?['kcal'] != null) {
        skipped.add('${row.slug} (has kcal)');
      } else {
        draft = {...draft, 'kcal': kcal};
        published = published == null ? null : {...published, 'kcal': kcal};
        kcalHere = true;
      }
    }
    if (!fixedHere && !kcalHere) continue;
    row = await ContentItem.db.updateRow(
      session,
      row.copyWith(
        draftJson: jsonEncode(draft),
        publishedJson: published == null ? null : jsonEncode(published),
        updatedBy: staff.authUserId,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    for (final (done, action) in [
      (kcalHere, 'content.kcal_set'),
      (fixedHere, 'content.ingredients_fixed'),
    ]) {
      if (!done) continue;
      await writeAudit(
        session,
        actorId: staff.authUserId,
        actorRole: AuditActor.staff,
        action: action,
        objectType: 'content_item',
        objectId: row.id.toString(),
      );
    }
    if (kcalHere) set++;
    if (fixedHere) fixed++;
  }
  final missing = {
    ...values.keys,
    ...fixes.keys,
  }.where((s) => !rows.any((r) => r.slug == s));
  return [
    'Set kcal on $set recipes; fixed ingredients of $fixed.',
    if (skipped.isNotEmpty) 'Skipped: ${skipped.join('; ')}.',
    if (missing.isNotEmpty) 'No item: ${missing.join(', ')}.',
  ].join(' ');
}
