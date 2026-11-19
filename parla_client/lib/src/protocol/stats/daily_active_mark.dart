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

/// "This account opened the app on [day]" marks, kept for the weekly and
/// monthly active totals. [mark] is a keyed hash of the account id (HMAC
/// with the pseudonym pepper), never the id itself, so it cannot be linked
/// to an account without the server's secret. Only stored with the
/// analytics consent; marks older than UsageRules.markDays are deleted by
/// the nightly job, and account deletion removes all of the account's.
abstract class DailyActiveMark
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DailyActiveMark._({
    this.id,
    required this.day,
    required this.mark,
    this.platform,
  });

  factory DailyActiveMark({
    int? id,
    required String day,
    required String mark,
    String? platform,
  }) = _DailyActiveMarkImpl;

  factory DailyActiveMark.fromJson(Map<String, dynamic> jsonSerialization) {
    return DailyActiveMark(
      id: jsonSerialization['id'] as int?,
      day: jsonSerialization['day'] as String,
      mark: jsonSerialization['mark'] as String,
      platform: jsonSerialization['platform'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String day;

  String mark;

  /// UsagePlatform name (ios, android, other), when the app sent it.
  String? platform;

  /// Returns a shallow copy of this [DailyActiveMark]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DailyActiveMark copyWith({
    int? id,
    String? day,
    String? mark,
    String? platform,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DailyActiveMark',
      if (id != null) 'id': id,
      'day': day,
      'mark': mark,
      if (platform != null) 'platform': platform,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DailyActiveMark',
      if (id != null) 'id': id,
      'day': day,
      'mark': mark,
      if (platform != null) 'platform': platform,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DailyActiveMarkImpl extends DailyActiveMark {
  _DailyActiveMarkImpl({
    int? id,
    required String day,
    required String mark,
    String? platform,
  }) : super._(
         id: id,
         day: day,
         mark: mark,
         platform: platform,
       );

  /// Returns a shallow copy of this [DailyActiveMark]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DailyActiveMark copyWith({
    Object? id = _Undefined,
    String? day,
    String? mark,
    Object? platform = _Undefined,
  }) {
    return DailyActiveMark(
      id: id is int? ? id : this.id,
      day: day ?? this.day,
      mark: mark ?? this.mark,
      platform: platform is String? ? platform : this.platform,
    );
  }
}
