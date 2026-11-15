import 'dart:convert';

import 'package:parla_shared/parla_shared.dart';
import 'package:test/test.dart';

Map<String, Object?> _book({
  List<Map<String, Object?>>? routines,
  Map<String, Object?>? ticks,
}) => {
  'format': 1,
  'routines':
      routines ??
      [
        {
          'id': 'r1',
          'name': 'Spa',
          'area': 'hair',
          'weekday': 7,
          'steps': [
            {'id': 's1', 'title': 'Oil the ends'},
          ],
        },
      ],
  'ticks':
      ticks ??
      {
        '2026-11-12': ['s1'],
      },
};

bool _ok(Object? json) => CustomRoutineRules.isValid(jsonEncode(json));

void main() {
  test('a normal book is valid, an empty one too', () {
    expect(_ok(_book()), isTrue);
    expect(_ok({'format': 1}), isTrue);
  });

  test('unknown format, fields or areas are refused', () {
    expect(_ok({..._book(), 'format': 2}), isFalse);
    expect(_ok({..._book(), 'email': 'a@b.c'}), isFalse);
    expect(
      _ok(
        _book(
          routines: [
            {'id': 'r1', 'name': 'x', 'area': 'nails', 'steps': []},
          ],
        ),
      ),
      isFalse,
    );
    expect(
      _ok(
        _book(
          routines: [
            {'id': 'r1', 'name': 'x', 'area': 'face', 'photo': 'base64'},
          ],
        ),
      ),
      isFalse,
    );
    expect(CustomRoutineRules.isValid('not json'), isFalse);
  });

  test('limits are enforced', () {
    expect(
      _ok(
        _book(
          routines: [
            {'id': 'r1', 'name': 'x' * 41, 'area': 'face'},
          ],
        ),
      ),
      isFalse,
    );
    expect(
      _ok(
        _book(
          routines: [
            {'id': 'r1', 'name': '  ', 'area': 'face'},
          ],
        ),
      ),
      isFalse,
    );
    expect(
      _ok(
        _book(
          routines: [
            {
              'id': 'r1',
              'name': 'x',
              'area': 'face',
              'steps': [
                for (var i = 0; i < 13; i++) {'id': 's$i', 'title': 't'},
              ],
            },
          ],
        ),
      ),
      isFalse,
    );
    expect(
      _ok(
        _book(
          routines: [
            for (var i = 0; i < 21; i++)
              {'id': 'r$i', 'name': 'x', 'area': 'face'},
          ],
        ),
      ),
      isFalse,
    );
    expect(
      _ok(
        _book(
          routines: [
            {'id': 'r1', 'name': 'x', 'area': 'face', 'weekday': 8},
          ],
        ),
      ),
      isFalse,
    );
  });

  test('duplicate ids and bad tick dates are refused', () {
    expect(
      _ok(
        _book(
          routines: [
            {'id': 'r1', 'name': 'x', 'area': 'face'},
            {'id': 'r1', 'name': 'y', 'area': 'face'},
          ],
        ),
      ),
      isFalse,
    );
    expect(
      _ok(
        _book(
          ticks: {
            '12.11.2026': ['s1'],
          },
        ),
      ),
      isFalse,
    );
    expect(
      _ok(
        _book(
          ticks: {
            '2026-11-12': ['S 1'],
          },
        ),
      ),
      isFalse,
    );
  });

  test('old ticks are pruned after 90 days', () {
    final pruned = CustomRoutineRules.pruneTicks(
      jsonEncode(
        _book(
          ticks: {
            '2026-08-13': ['s1'],
            '2026-08-14': ['s1'],
            '2026-11-12': ['s1'],
          },
        ),
      ),
      DateTime.utc(2026, 11, 12),
    );
    expect((jsonDecode(pruned) as Map)['ticks'], {
      '2026-08-14': ['s1'],
      '2026-11-12': ['s1'],
    });
  });
}
