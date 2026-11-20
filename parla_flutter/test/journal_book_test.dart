import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:parla/habits/habit_store.dart';
import 'package:parla/journal/journal_book.dart';

void main() {
  late MemoryHabitStore store;
  late JournalBook book;
  var now = DateTime(2026, 11, 20, 9);

  setUp(() {
    store = MemoryHabitStore();
    now = DateTime(2026, 11, 20, 9);
    book = JournalBook(store: store, clock: () => now);
  });

  test('entries are kept per account, newest first', () async {
    await book.attach('a');
    await book.save(text: '  first  ');
    now = now.add(const Duration(hours: 2));
    await book.save(text: 'second');
    expect(book.entries.map((e) => e.text), ['second', 'first']);

    await book.attach('b');
    expect(book.entries, isEmpty);
    await book.attach('a');
    expect(book.entries, hasLength(2));
    expect(jsonDecode(store.data['a']!)['entries'], hasLength(2));
    expect(store.data.containsKey('b'), isFalse);
  });

  test('editing keeps the date; blank text deletes; text is capped', () async {
    await book.attach('a');
    await book.save(text: 'hello');
    final id = book.entries.single.id;
    now = now.add(const Duration(days: 1));
    await book.save(id: id, text: 'hello again');
    final e = book.find(id)!;
    expect(e.text, 'hello again');
    expect(e.createdAt, DateTime(2026, 11, 20, 9));
    expect(e.updatedAt, now);

    await book.save(text: 'x' * (JournalRules.maxLength + 50));
    expect(book.entries.first.text.length, JournalRules.maxLength);

    await book.save(id: id, text: '   ');
    expect(book.find(id), isNull);
    expect(await book.save(text: ''), isTrue);
    expect(book.entries, hasLength(1));
  });

  test('a full journal refuses new entries', () async {
    store.data['a'] = jsonEncode({
      'format': 1,
      'entries': [
        for (var i = 0; i < JournalRules.maxEntries; i++)
          {
            'id': 'id$i',
            'createdAt': '2026-01-01T00:00:00.000',
            'updatedAt': '2026-01-01T00:00:00.000',
            'text': 't',
          },
      ],
    });
    await book.attach('a');
    expect(await book.save(text: 'one more'), isFalse);
    expect(await book.save(id: 'id3', text: 'edited'), isTrue);
  });

  test('erase removes the stored entries; detach forgets them', () async {
    await book.attach('a');
    await book.save(text: 'secret');
    book.detach();
    expect(book.entries, isEmpty);
    await book.attach('a');
    expect(book.entries, hasLength(1));
    await book.erase();
    expect(store.data.containsKey('a'), isFalse);
    expect(book.exportJson()['entries'], isEmpty);
  });
}
