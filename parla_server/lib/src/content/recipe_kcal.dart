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
  'herb-qutab': 220,
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

/// The one-off task `PARLA_TASK=set-recipe-kcal`: writes [recipeKcal] into
/// the working and the published copy of each recipe that has no
/// `kcal` yet (a value set in the panel wins). Status and review stay as they are;
/// audited as `content.kcal_set` with the admin [email] as the actor.
Future<String> runSetRecipeKcalTask(
  Session session,
  String email, {
  Map<String, int> values = recipeKcal,
}) async {
  final staff = await taskAdmin(session, email);
  final rows = await ContentItem.db.find(
    session,
    where: (t) => t.kind.equals(ContentKind.recipe.name),
  );
  var set = 0;
  final skipped = <String>[];
  for (var row in rows) {
    final kcal = values[row.slug];
    if (kcal == null) continue;
    final draft = jsonDecode(row.draftJson) as Map<String, Object?>;
    final published = row.publishedJson == null
        ? null
        : jsonDecode(row.publishedJson!) as Map<String, Object?>;
    if (draft['kcal'] != null || published?['kcal'] != null) {
      skipped.add('${row.slug} (has kcal)');
      continue;
    }
    row = await ContentItem.db.updateRow(
      session,
      row.copyWith(
        draftJson: jsonEncode({...draft, 'kcal': kcal}),
        publishedJson: published == null
            ? null
            : jsonEncode({...published, 'kcal': kcal}),
        updatedBy: staff.authUserId,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
    await writeAudit(
      session,
      actorId: staff.authUserId,
      actorRole: AuditActor.staff,
      action: 'content.kcal_set',
      objectType: 'content_item',
      objectId: row.id.toString(),
    );
    set++;
  }
  final missing = values.keys.where((s) => !rows.any((r) => r.slug == s));
  return [
    'Set kcal on $set recipes.',
    if (skipped.isNotEmpty) 'Skipped: ${skipped.join('; ')}.',
    if (missing.isNotEmpty) 'No item: ${missing.join(', ')}.',
  ].join(' ');
}
