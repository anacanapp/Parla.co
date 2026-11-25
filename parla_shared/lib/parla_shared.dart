/// Rules shared by the Parla server and apps.
library;

import 'src/cosing_data.dart';
import 'src/ingredients.dart';

export 'src/age_policy.dart';
export 'src/care_list_rules.dart';
export 'src/consent_texts.dart';
export 'src/content_rules.dart';
export 'src/cosing_data.dart';
export 'src/custom_routine_rules.dart';
export 'src/ingredients.dart';
export 'src/markets.dart';
export 'src/media_rules.dart';
export 'src/nutrition_rules.dart';
export 'src/pregnancy_recheck.dart';
export 'src/product_preferences.dart';
export 'src/quiz.dart';
export 'src/routine_rules.dart';
export 'src/sport_rules.dart';
export 'src/usage_rules.dart';
export 'src/texts/exercise_draft_texts.dart';
export 'src/texts/exercise_sheet_texts.dart';
export 'src/texts/preference_texts.dart';
export 'src/texts/routine_step_texts.dart';

/// The ingredient statuses shipped with this version.
final euIngredientDataset = IngredientDataset(
  source: 'CosIng',
  exportedOn: cosingExportedOn,
  entries: cosingEntries,
);
