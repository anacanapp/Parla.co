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
import 'package:parla_server/src/generated/protocol.dart' as _i19kjxmt;
import 'package:serverpod/serverpod.dart' as _is;
import '../stats/stats_count.dart' as _i62qlqsa;

/// A named statistic: its buckets and, for shares, the total they are out
/// of (null when suppressed).
abstract class StatsGroup
    implements _is.SerializableModel, _is.ProtocolSerialization {
  StatsGroup._({
    required this.metric,
    required this.counts,
    this.total,
  });

  factory StatsGroup({
    required String metric,
    required List<_i62qlqsa.StatsCount> counts,
    int? total,
  }) = _StatsGroupImpl;

  factory StatsGroup.fromJson(Map<String, dynamic> jsonSerialization) {
    return StatsGroup(
      metric: jsonSerialization['metric'] as String,
      counts: _i19kjxmt.Protocol().deserialize<List<_i62qlqsa.StatsCount>>(
        jsonSerialization['counts'],
      ),
      total: jsonSerialization['total'] as int?,
    );
  }

  String metric;

  List<_i62qlqsa.StatsCount> counts;

  int? total;

  /// Returns a shallow copy of this [StatsGroup]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StatsGroup copyWith({
    String? metric,
    List<_i62qlqsa.StatsCount>? counts,
    int? total,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StatsGroup',
      'metric': metric,
      'counts': counts.toJson(valueToJson: (v) => v.toJson()),
      if (total != null) 'total': total,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StatsGroup',
      'metric': metric,
      'counts': counts.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (total != null) 'total': total,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StatsGroupImpl extends StatsGroup {
  _StatsGroupImpl({
    required String metric,
    required List<_i62qlqsa.StatsCount> counts,
    int? total,
  }) : super._(
         metric: metric,
         counts: counts,
         total: total,
       );

  /// Returns a shallow copy of this [StatsGroup]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StatsGroup copyWith({
    String? metric,
    List<_i62qlqsa.StatsCount>? counts,
    Object? total = _Undefined,
  }) {
    return StatsGroup(
      metric: metric ?? this.metric,
      counts: counts ?? this.counts.map((e0) => e0.copyWith()).toList(),
      total: total is int? ? total : this.total,
    );
  }
}
