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

/// How far a push campaign has got, for the admin panel.
abstract class PushJobView
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PushJobView._({
    required this.status,
    required this.sent,
    this.finishedAt,
  });

  factory PushJobView({
    required String status,
    required int sent,
    DateTime? finishedAt,
  }) = _PushJobViewImpl;

  factory PushJobView.fromJson(Map<String, dynamic> jsonSerialization) {
    return PushJobView(
      status: jsonSerialization['status'] as String,
      sent: jsonSerialization['sent'] as int,
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['finishedAt'],
            ),
    );
  }

  String status;

  int sent;

  DateTime? finishedAt;

  /// Returns a shallow copy of this [PushJobView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PushJobView copyWith({
    String? status,
    int? sent,
    DateTime? finishedAt = const _isc.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PushJobView',
      'status': status,
      'sent': sent,
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PushJobView',
      'status': status,
      'sent': sent,
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _PushJobViewImpl extends PushJobView {
  _PushJobViewImpl({
    required String status,
    required int sent,
    DateTime? finishedAt,
  }) : super._(
         status: status,
         sent: sent,
         finishedAt: finishedAt,
       );

  /// Returns a shallow copy of this [PushJobView]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PushJobView copyWith({
    String? status,
    int? sent,
    DateTime? finishedAt = const _isc.$UndefinedDateTime(),
  }) {
    return PushJobView(
      status: status ?? this.status,
      sent: sent ?? this.sent,
      finishedAt: finishedAt is _isc.UndefinedSentinel
          ? this.finishedAt
          : finishedAt,
    );
  }
}
