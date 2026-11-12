// Checklist RES-3: fields on the "do not collect" list must never appear in a
// data model. Adding one should be a deliberate decision that changes this
// list, the data map and the privacy review together.
import 'dart:io';

import 'package:test/test.dart';

const _forbiddenFieldNames = {
  'firstname',
  'lastname',
  'fullname',
  'name',
  'phone',
  'phonenumber',
  'dateofbirth',
  'birthdate',
  'latitude',
  'longitude',
  'location',
  'gps',
  'advertisingid',
  'idfa',
  'aaid',
  'photo',
  'weight',
  'height',
};

void main() {
  test('no data model declares a field from the do-not-collect list', () {
    final models = Directory('lib/src')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.spy.yaml'));
    expect(models, isNotEmpty);

    final fieldLine = RegExp(r'^  ([A-Za-z0-9_]+):');
    final violations = <String>[];
    for (final model in models) {
      var inFields = false;
      for (final line in model.readAsLinesSync()) {
        if (!line.startsWith(' ')) inFields = line.startsWith('fields:');
        final match = fieldLine.firstMatch(line);
        if (!inFields || match == null) continue;
        final field = match.group(1)!;
        if (_forbiddenFieldNames.contains(field.toLowerCase())) {
          violations.add('${model.path}: $field');
        }
      }
    }
    expect(violations, isEmpty);
  });
}
