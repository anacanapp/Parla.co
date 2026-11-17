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

/// One bucket of an anonymous statistic. [count] is null when fewer than
/// the minimum group size (shown as "<10").
abstract class StatsCount
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StatsCount._({
    required this.label,
    this.count,
  });

  factory StatsCount({
    required String label,
    int? count,
  }) = _StatsCountImpl;

  factory StatsCount.fromJson(Map<String, dynamic> jsonSerialization) {
    return StatsCount(
      label: jsonSerialization['label'] as String,
      count: jsonSerialization['count'] as int?,
    );
  }

  String label;

  int? count;

  /// Returns a shallow copy of this [StatsCount]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StatsCount copyWith({
    String? label,
    int? count,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StatsCount',
      'label': label,
      if (count != null) 'count': count,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StatsCount',
      'label': label,
      if (count != null) 'count': count,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StatsCountImpl extends StatsCount {
  _StatsCountImpl({
    required String label,
    int? count,
  }) : super._(
         label: label,
         count: count,
       );

  /// Returns a shallow copy of this [StatsCount]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StatsCount copyWith({
    String? label,
    Object? count = _Undefined,
  }) {
    return StatsCount(
      label: label ?? this.label,
      count: count is int? ? count : this.count,
    );
  }
}
