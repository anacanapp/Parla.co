/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// How many accounts opened the app on [day] (UTC, yyyy-mm-dd), and in the
/// 7 and 30 days up to it. Only totals are kept.
abstract class DailyActiveCount
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DailyActiveCount._({
    this.id,
    required this.day,
    required this.accounts,
    this.weekly,
    this.monthly,
    this.ios,
    this.android,
  });

  factory DailyActiveCount({
    int? id,
    required String day,
    required int accounts,
    int? weekly,
    int? monthly,
    int? ios,
    int? android,
  }) = _DailyActiveCountImpl;

  factory DailyActiveCount.fromJson(Map<String, dynamic> jsonSerialization) {
    return DailyActiveCount(
      id: jsonSerialization['id'] as int?,
      day: jsonSerialization['day'] as String,
      accounts: jsonSerialization['accounts'] as int,
      weekly: jsonSerialization['weekly'] as int?,
      monthly: jsonSerialization['monthly'] as int?,
      ios: jsonSerialization['ios'] as int?,
      android: jsonSerialization['android'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String day;

  int accounts;

  /// Accounts active in the 7 days up to [day].
  int? weekly;

  /// Accounts active in the 30 days up to [day].
  int? monthly;

  /// Of [accounts], how many on iOS and on Android.
  int? ios;

  int? android;

  /// Returns a shallow copy of this [DailyActiveCount]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DailyActiveCount copyWith({
    int? id,
    String? day,
    int? accounts,
    int? weekly,
    int? monthly,
    int? ios,
    int? android,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DailyActiveCount',
      if (id != null) 'id': id,
      'day': day,
      'accounts': accounts,
      if (weekly != null) 'weekly': weekly,
      if (monthly != null) 'monthly': monthly,
      if (ios != null) 'ios': ios,
      if (android != null) 'android': android,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DailyActiveCount',
      if (id != null) 'id': id,
      'day': day,
      'accounts': accounts,
      if (weekly != null) 'weekly': weekly,
      if (monthly != null) 'monthly': monthly,
      if (ios != null) 'ios': ios,
      if (android != null) 'android': android,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DailyActiveCountImpl extends DailyActiveCount {
  _DailyActiveCountImpl({
    int? id,
    required String day,
    required int accounts,
    int? weekly,
    int? monthly,
    int? ios,
    int? android,
  }) : super._(
         id: id,
         day: day,
         accounts: accounts,
         weekly: weekly,
         monthly: monthly,
         ios: ios,
         android: android,
       );

  /// Returns a shallow copy of this [DailyActiveCount]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DailyActiveCount copyWith({
    Object? id = _Undefined,
    String? day,
    int? accounts,
    Object? weekly = _Undefined,
    Object? monthly = _Undefined,
    Object? ios = _Undefined,
    Object? android = _Undefined,
  }) {
    return DailyActiveCount(
      id: id is int? ? id : this.id,
      day: day ?? this.day,
      accounts: accounts ?? this.accounts,
      weekly: weekly is int? ? weekly : this.weekly,
      monthly: monthly is int? ? monthly : this.monthly,
      ios: ios is int? ? ios : this.ios,
      android: android is int? ? android : this.android,
    );
  }
}
