import 'dart:convert';

import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'health_crypto.dart';

/// Reads, writes and erases a user's encrypted health answers and own
/// routines. Both are sealed with the user's data key.
///
/// Callers must check the health consent first (checklist CON-2); this
/// class only stores what it is given.
class HealthStore {
  HealthStore(this._crypto);

  /// The store for the running server, keyed from `passwords.yaml`.
  factory HealthStore.of(Session session) =>
      HealthStore(HealthCrypto.fromBase64(session.passwords['healthKek']));

  final HealthCrypto _crypto;

  /// The user's health answers by question id, or empty when there are none.
  Future<Map<String, QuizAnswerInput>> read(
    Session session,
    UuidValue userId, {
    Transaction? transaction,
  }) async {
    final key = await HealthKey.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
      transaction: transaction,
    );
    final record = await HealthRecord.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
      transaction: transaction,
    );
    if (key == null || record == null) return {};

    final dataKey = await _crypto.unwrap(
      Sealed(ciphertext: key.wrappedKey, nonce: key.nonce),
    );
    final json = await _crypto.open(
      dataKey,
      Sealed(ciphertext: record.ciphertext, nonce: record.nonce),
      userId.toString(),
    );
    final list = (jsonDecode(json) as Map<String, dynamic>)['answers'] as List;
    return {
      for (final item in list.cast<Map<String, dynamic>>())
        item['q'] as String: QuizAnswerInput(
          questionId: item['q'] as String,
          optionIds: (item['o'] as List).cast<String>(),
          declined: item['d'] as bool,
        ),
    };
  }

  /// Replaces the user's health answers with [answers].
  Future<void> write(
    Session session,
    UuidValue userId,
    Iterable<QuizAnswerInput> answers, {
    required Transaction transaction,
  }) async {
    final dataKey = await _dataKey(session, userId, transaction);

    final json = jsonEncode({
      'answers': [
        for (final a in answers)
          {'q': a.questionId, 'o': a.optionIds, 'd': a.declined},
      ],
    });
    final sealed = await _crypto.seal(dataKey, json, userId.toString());

    final existing = await HealthRecord.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
      transaction: transaction,
    );
    final now = DateTime.now().toUtc();
    if (existing == null) {
      await HealthRecord.db.insertRow(
        session,
        HealthRecord(
          authUserId: userId,
          ciphertext: sealed.ciphertext,
          nonce: sealed.nonce,
          contentVersion: quizContentVersion,
          updatedAt: now,
        ),
        transaction: transaction,
      );
    } else {
      await HealthRecord.db.updateRow(
        session,
        existing.copyWith(
          ciphertext: sealed.ciphertext,
          nonce: sealed.nonce,
          contentVersion: quizContentVersion,
          updatedAt: now,
        ),
        transaction: transaction,
      );
    }
  }

  /// Deletes the user's health answers, own routines and data key (CON-6).
  /// Returns whether anything was deleted.
  Future<bool> erase(
    Session session,
    UuidValue userId, {
    required Transaction transaction,
  }) async {
    final records = await HealthRecord.db.deleteWhere(
      session,
      where: (t) => t.authUserId.equals(userId),
      transaction: transaction,
    );
    final routines = await CustomRoutineRecord.db.deleteWhere(
      session,
      where: (t) => t.authUserId.equals(userId),
      transaction: transaction,
    );
    final keys = await HealthKey.db.deleteWhere(
      session,
      where: (t) => t.authUserId.equals(userId),
      transaction: transaction,
    );
    return records.isNotEmpty || routines.isNotEmpty || keys.isNotEmpty;
  }

  /// The user's own routines as the JSON the app sent, or `null`.
  Future<String?> readRoutines(
    Session session,
    UuidValue userId, {
    Transaction? transaction,
  }) async {
    final record = await CustomRoutineRecord.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
      transaction: transaction,
    );
    if (record == null) return null;
    final key = await HealthKey.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
      transaction: transaction,
    );
    if (key == null) return null;
    final dataKey = await _crypto.unwrap(
      Sealed(ciphertext: key.wrappedKey, nonce: key.nonce),
    );
    return _crypto.open(
      dataKey,
      Sealed(ciphertext: record.ciphertext, nonce: record.nonce),
      userId.toString(),
    );
  }

  /// Replaces the user's own routines with [json] (already validated).
  Future<void> writeRoutines(
    Session session,
    UuidValue userId,
    String json, {
    required Transaction transaction,
  }) async {
    final dataKey = await _dataKey(session, userId, transaction);
    final sealed = await _crypto.seal(dataKey, json, userId.toString());
    final existing = await CustomRoutineRecord.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
      transaction: transaction,
    );
    final now = DateTime.now().toUtc();
    if (existing == null) {
      await CustomRoutineRecord.db.insertRow(
        session,
        CustomRoutineRecord(
          authUserId: userId,
          ciphertext: sealed.ciphertext,
          nonce: sealed.nonce,
          format: CustomRoutineRules.format,
          updatedAt: now,
        ),
        transaction: transaction,
      );
    } else {
      await CustomRoutineRecord.db.updateRow(
        session,
        existing.copyWith(
          ciphertext: sealed.ciphertext,
          nonce: sealed.nonce,
          format: CustomRoutineRules.format,
          updatedAt: now,
        ),
        transaction: transaction,
      );
    }
  }

  /// The user's data key, created and stored wrapped on first use.
  Future<List<int>> _dataKey(
    Session session,
    UuidValue userId,
    Transaction transaction,
  ) async {
    final key = await HealthKey.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
      transaction: transaction,
    );
    if (key != null) {
      return _crypto.unwrap(
        Sealed(ciphertext: key.wrappedKey, nonce: key.nonce),
      );
    }
    final created = await _crypto.newDataKey();
    await HealthKey.db.insertRow(
      session,
      HealthKey(
        authUserId: userId,
        wrappedKey: created.wrapped.ciphertext,
        nonce: created.wrapped.nonce,
        kekVersion: _crypto.kekVersion,
        createdAt: DateTime.now().toUtc(),
      ),
      transaction: transaction,
    );
    return created.dataKey;
  }
}
