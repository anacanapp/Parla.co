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

/// Anonymous usage totals: how often [event] with [target] happened on
/// [day] (UTC) in [country] on [platform]. Counted only with the analytics
/// consent; there is no row per account. Kept for UsageRules.keepMonths.
abstract class UsageDaily
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UsageDaily._({
    this.id,
    required this.day,
    required this.country,
    required this.platform,
    required this.event,
    required this.target,
    required this.times,
  });

  factory UsageDaily({
    int? id,
    required String day,
    required String country,
    required String platform,
    required String event,
    required String target,
    required int times,
  }) = _UsageDailyImpl;

  factory UsageDaily.fromJson(Map<String, dynamic> jsonSerialization) {
    return UsageDaily(
      id: jsonSerialization['id'] as int?,
      day: jsonSerialization['day'] as String,
      country: jsonSerialization['country'] as String,
      platform: jsonSerialization['platform'] as String,
      event: jsonSerialization['event'] as String,
      target: jsonSerialization['target'] as String,
      times: jsonSerialization['times'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String day;

  /// ISO country of the accounts' profiles, or "--" when unknown.
  String country;

  /// UsagePlatform name.
  String platform;

  /// UsageEvent name.
  String event;

  /// Tool name, slug, banner id or app version (see UsageRules).
  String target;

  int times;

  /// Returns a shallow copy of this [UsageDaily]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UsageDaily copyWith({
    int? id,
    String? day,
    String? country,
    String? platform,
    String? event,
    String? target,
    int? times,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UsageDaily',
      if (id != null) 'id': id,
      'day': day,
      'country': country,
      'platform': platform,
      'event': event,
      'target': target,
      'times': times,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UsageDaily',
      if (id != null) 'id': id,
      'day': day,
      'country': country,
      'platform': platform,
      'event': event,
      'target': target,
      'times': times,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UsageDailyImpl extends UsageDaily {
  _UsageDailyImpl({
    int? id,
    required String day,
    required String country,
    required String platform,
    required String event,
    required String target,
    required int times,
  }) : super._(
         id: id,
         day: day,
         country: country,
         platform: platform,
         event: event,
         target: target,
         times: times,
       );

  /// Returns a shallow copy of this [UsageDaily]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UsageDaily copyWith({
    Object? id = _Undefined,
    String? day,
    String? country,
    String? platform,
    String? event,
    String? target,
    int? times,
  }) {
    return UsageDaily(
      id: id is int? ? id : this.id,
      day: day ?? this.day,
      country: country ?? this.country,
      platform: platform ?? this.platform,
      event: event ?? this.event,
      target: target ?? this.target,
      times: times ?? this.times,
    );
  }
}
