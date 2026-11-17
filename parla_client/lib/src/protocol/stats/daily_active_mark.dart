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

/// Today's "this account opened the app" marks. [mark] is a keyed hash of
/// the day and the account id, never the id itself; the nightly job turns
/// the marks of past days into one number ([DailyActiveCount]) and deletes
/// them, so no mark is older than about two days.
abstract class DailyActiveMark
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DailyActiveMark._({
    this.id,
    required this.day,
    required this.mark,
  });

  factory DailyActiveMark({
    int? id,
    required String day,
    required String mark,
  }) = _DailyActiveMarkImpl;

  factory DailyActiveMark.fromJson(Map<String, dynamic> jsonSerialization) {
    return DailyActiveMark(
      id: jsonSerialization['id'] as int?,
      day: jsonSerialization['day'] as String,
      mark: jsonSerialization['mark'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String day;

  String mark;

  /// Returns a shallow copy of this [DailyActiveMark]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DailyActiveMark copyWith({
    int? id,
    String? day,
    String? mark,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DailyActiveMark',
      if (id != null) 'id': id,
      'day': day,
      'mark': mark,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DailyActiveMark',
      if (id != null) 'id': id,
      'day': day,
      'mark': mark,
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
  }) : super._(
         id: id,
         day: day,
         mark: mark,
       );

  /// Returns a shallow copy of this [DailyActiveMark]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DailyActiveMark copyWith({
    Object? id = _Undefined,
    String? day,
    String? mark,
  }) {
    return DailyActiveMark(
      id: id is int? ? id : this.id,
      day: day ?? this.day,
      mark: mark ?? this.mark,
    );
  }
}
