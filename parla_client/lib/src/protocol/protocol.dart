/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:parla_client/src/protocol/consent/consent_state.dart'
    as _iflgmsvc;
import 'package:parla_client/src/protocol/quiz/quiz_answer_input.dart'
    as _ikoicjb8;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'account/deleted_account.dart' as _ioqa84oy;
import 'audit/audit_log_entry.dart' as _ioa77d8b;
import 'common/parla_exception.dart' as _iv1d8f8b;
import 'consent/consent_record.dart' as _it7bphsc;
import 'consent/consent_state.dart' as _icra10er;
import 'consent/consent_type.dart' as _i40db2a8;
import 'health/health_key.dart' as _ipdtgm1c;
import 'health/health_record.dart' as _ioxvgdwn;
import 'profile/member_profile.dart' as _i1iocmvy;
import 'quiz/quiz_answer.dart' as _ih1qnypb;
import 'quiz/quiz_answer_input.dart' as _ilw6ope9;
export 'account/deleted_account.dart';
export 'audit/audit_log_entry.dart';
export 'common/parla_exception.dart';
export 'consent/consent_record.dart';
export 'consent/consent_state.dart';
export 'consent/consent_type.dart';
export 'health/health_key.dart';
export 'health/health_record.dart';
export 'profile/member_profile.dart';
export 'quiz/quiz_answer.dart';
export 'quiz/quiz_answer_input.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager
    implements _isc.ProtocolDeserializationProvider {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  @override
  _isc.ProtocolDeserialization get deserializationMetadata =>
      _isc.ProtocolDeserialization.cached(
        this,
        types: const [
          _isc.getType<_ioqa84oy.DeletedAccount>,
          _isc.getType<_ioa77d8b.AuditLogEntry>,
          _isc.getType<_iv1d8f8b.ParlaException>,
          _isc.getType<_it7bphsc.ConsentRecord>,
          _isc.getType<_icra10er.ConsentState>,
          _isc.getType<_i40db2a8.ConsentType>,
          _isc.getType<_ipdtgm1c.HealthKey>,
          _isc.getType<_ioxvgdwn.HealthRecord>,
          _isc.getType<_i1iocmvy.MemberProfile>,
          _isc.getType<_ih1qnypb.QuizAnswer>,
          _isc.getType<_ilw6ope9.QuizAnswerInput>,
          _isc.getType<_ioqa84oy.DeletedAccount?>,
          _isc.getType<_ioa77d8b.AuditLogEntry?>,
          _isc.getType<_iv1d8f8b.ParlaException?>,
          _isc.getType<_it7bphsc.ConsentRecord?>,
          _isc.getType<_icra10er.ConsentState?>,
          _isc.getType<_i40db2a8.ConsentType?>,
          _isc.getType<_ipdtgm1c.HealthKey?>,
          _isc.getType<_ioxvgdwn.HealthRecord?>,
          _isc.getType<_i1iocmvy.MemberProfile?>,
          _isc.getType<_ih1qnypb.QuizAnswer?>,
          _isc.getType<_ilw6ope9.QuizAnswerInput?>,
          _isc.getType<List<String>>,
          _isc.getType<List<_iflgmsvc.ConsentState>>,
          _isc.getType<List<_ikoicjb8.QuizAnswerInput>>,
        ],
        modules: const [
          _iaic.Protocol.new,
          _iacc.Protocol.new,
        ],
        classNames: const [
          'DeletedAccount',
          'AuditLogEntry',
          'ParlaException',
          'ConsentRecord',
          'ConsentState',
          'ConsentType',
          'HealthKey',
          'HealthRecord',
          'MemberProfile',
          'QuizAnswer',
          'QuizAnswerInput',
        ],
      );

  static String? getClassNameFromObjectJson(dynamic data) =>
      _isc.ProtocolDeserialization.readClassName(data);

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    final rawDataClassName = _isc.ProtocolDeserialization.readClassName(data);
    final dataClassName = rawDataClassName;
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _ioqa84oy.DeletedAccount) {
      return _ioqa84oy.DeletedAccount.fromJson(data) as T;
    }
    if (t == _ioa77d8b.AuditLogEntry) {
      return _ioa77d8b.AuditLogEntry.fromJson(data) as T;
    }
    if (t == _iv1d8f8b.ParlaException) {
      return _iv1d8f8b.ParlaException.fromJson(data) as T;
    }
    if (t == _it7bphsc.ConsentRecord) {
      return _it7bphsc.ConsentRecord.fromJson(data) as T;
    }
    if (t == _icra10er.ConsentState) {
      return _icra10er.ConsentState.fromJson(data) as T;
    }
    if (t == _i40db2a8.ConsentType) {
      return _i40db2a8.ConsentType.fromJson(data) as T;
    }
    if (t == _ipdtgm1c.HealthKey) {
      return _ipdtgm1c.HealthKey.fromJson(data) as T;
    }
    if (t == _ioxvgdwn.HealthRecord) {
      return _ioxvgdwn.HealthRecord.fromJson(data) as T;
    }
    if (t == _i1iocmvy.MemberProfile) {
      return _i1iocmvy.MemberProfile.fromJson(data) as T;
    }
    if (t == _ih1qnypb.QuizAnswer) {
      return _ih1qnypb.QuizAnswer.fromJson(data) as T;
    }
    if (t == _ilw6ope9.QuizAnswerInput) {
      return _ilw6ope9.QuizAnswerInput.fromJson(data) as T;
    }
    if (t == _isc.getType<_ioqa84oy.DeletedAccount?>()) {
      return (data != null ? _ioqa84oy.DeletedAccount.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ioa77d8b.AuditLogEntry?>()) {
      return (data != null ? _ioa77d8b.AuditLogEntry.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iv1d8f8b.ParlaException?>()) {
      return (data != null ? _iv1d8f8b.ParlaException.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_it7bphsc.ConsentRecord?>()) {
      return (data != null ? _it7bphsc.ConsentRecord.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_icra10er.ConsentState?>()) {
      return (data != null ? _icra10er.ConsentState.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i40db2a8.ConsentType?>()) {
      return (data != null ? _i40db2a8.ConsentType.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ipdtgm1c.HealthKey?>()) {
      return (data != null ? _ipdtgm1c.HealthKey.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ioxvgdwn.HealthRecord?>()) {
      return (data != null ? _ioxvgdwn.HealthRecord.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i1iocmvy.MemberProfile?>()) {
      return (data != null ? _i1iocmvy.MemberProfile.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ih1qnypb.QuizAnswer?>()) {
      return (data != null ? _ih1qnypb.QuizAnswer.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ilw6ope9.QuizAnswerInput?>()) {
      return (data != null ? _ilw6ope9.QuizAnswerInput.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_iflgmsvc.ConsentState>) {
      return (data as List)
              .map((e) => deserialize<_iflgmsvc.ConsentState>(e))
              .toList()
          as T;
    }
    if (t == List<_ikoicjb8.QuizAnswerInput>) {
      return (data as List)
              .map((e) => deserialize<_ikoicjb8.QuizAnswerInput>(e))
              .toList()
          as T;
    }
    final modules = deserializationMetadata.modulesForDeserialization(
      t,
      className: rawDataClassName,
    );
    for (final module in modules) {
      try {
        return module.deserialize<T>(data, t);
      } on _isc.DeserializationTypeNotFoundException catch (_) {}
    }

    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ioqa84oy.DeletedAccount => 'DeletedAccount',
      _ioa77d8b.AuditLogEntry => 'AuditLogEntry',
      _iv1d8f8b.ParlaException => 'ParlaException',
      _it7bphsc.ConsentRecord => 'ConsentRecord',
      _icra10er.ConsentState => 'ConsentState',
      _i40db2a8.ConsentType => 'ConsentType',
      _ipdtgm1c.HealthKey => 'HealthKey',
      _ioxvgdwn.HealthRecord => 'HealthRecord',
      _i1iocmvy.MemberProfile => 'MemberProfile',
      _ih1qnypb.QuizAnswer => 'QuizAnswer',
      _ilw6ope9.QuizAnswerInput => 'QuizAnswerInput',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('parla.', '');
    }

    switch (data) {
      case _ioqa84oy.DeletedAccount():
        return 'DeletedAccount';
      case _ioa77d8b.AuditLogEntry():
        return 'AuditLogEntry';
      case _iv1d8f8b.ParlaException():
        return 'ParlaException';
      case _it7bphsc.ConsentRecord():
        return 'ConsentRecord';
      case _icra10er.ConsentState():
        return 'ConsentState';
      case _i40db2a8.ConsentType():
        return 'ConsentType';
      case _ipdtgm1c.HealthKey():
        return 'HealthKey';
      case _ioxvgdwn.HealthRecord():
        return 'HealthRecord';
      case _i1iocmvy.MemberProfile():
        return 'MemberProfile';
      case _ih1qnypb.QuizAnswer():
        return 'QuizAnswer';
      case _ilw6ope9.QuizAnswerInput():
        return 'QuizAnswerInput';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'DeletedAccount') {
      return deserialize<_ioqa84oy.DeletedAccount>(data['data']);
    }
    if (dataClassName == 'AuditLogEntry') {
      return deserialize<_ioa77d8b.AuditLogEntry>(data['data']);
    }
    if (dataClassName == 'ParlaException') {
      return deserialize<_iv1d8f8b.ParlaException>(data['data']);
    }
    if (dataClassName == 'ConsentRecord') {
      return deserialize<_it7bphsc.ConsentRecord>(data['data']);
    }
    if (dataClassName == 'ConsentState') {
      return deserialize<_icra10er.ConsentState>(data['data']);
    }
    if (dataClassName == 'ConsentType') {
      return deserialize<_i40db2a8.ConsentType>(data['data']);
    }
    if (dataClassName == 'HealthKey') {
      return deserialize<_ipdtgm1c.HealthKey>(data['data']);
    }
    if (dataClassName == 'HealthRecord') {
      return deserialize<_ioxvgdwn.HealthRecord>(data['data']);
    }
    if (dataClassName == 'MemberProfile') {
      return deserialize<_i1iocmvy.MemberProfile>(data['data']);
    }
    if (dataClassName == 'QuizAnswer') {
      return deserialize<_ih1qnypb.QuizAnswer>(data['data']);
    }
    if (dataClassName == 'QuizAnswerInput') {
      return deserialize<_ilw6ope9.QuizAnswerInput>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      return _iaic.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(19),
      });
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      return _iacc.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(20),
      });
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('parla', this);
    _iacc.Protocol().registerHostProtocol('parla', this);
  }

  @override
  String getModuleName() => 'parla';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
