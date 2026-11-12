/// Rules shared by the Parla server and apps.
library;

import 'src/cosing_data.dart';
import 'src/ingredients.dart';

export 'src/age_policy.dart';
export 'src/consent_texts.dart';
export 'src/cosing_data.dart';
export 'src/ingredients.dart';
export 'src/markets.dart';
export 'src/quiz.dart';
export 'src/routine_rules.dart';

/// The ingredient statuses shipped with this version.
final euIngredientDataset = IngredientDataset(
  source: 'CosIng',
  exportedOn: cosingExportedOn,
  entries: cosingEntries,
);
