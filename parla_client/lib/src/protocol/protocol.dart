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
import 'package:parla_client/src/protocol/content/content_admin_item.dart'
    as _i9q5wd3k;
import 'package:parla_client/src/protocol/content/public_content.dart'
    as _iryaqqq7;
import 'package:parla_client/src/protocol/media/media_admin_item.dart'
    as _izgab4v7;
import 'package:parla_client/src/protocol/products/product_summary.dart'
    as _isvy2zc1;
import 'package:parla_client/src/protocol/quiz/quiz_answer_input.dart'
    as _ikoicjb8;
import 'package:parla_client/src/protocol/staff/staff_invite_summary.dart'
    as _ivj2ydpk;
import 'package:parla_client/src/protocol/staff/staff_summary.dart'
    as _i48vujj3;
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
import 'content/content_admin_item.dart' as _i37db98a;
import 'content/content_item.dart' as _ima46zjc;
import 'content/content_status.dart' as _i5g0eai8;
import 'content/public_content.dart' as _ikwk39jh;
import 'health/care_list_record.dart' as _iopyqj70;
import 'health/custom_routine_record.dart' as _idmfi0v2;
import 'health/health_key.dart' as _ipdtgm1c;
import 'health/health_record.dart' as _ioxvgdwn;
import 'health/nutrition_record.dart' as _in188bse;
import 'health/sport_record.dart' as _izi2p90l;
import 'media/media_admin_item.dart' as _if8q33w5;
import 'media/media_asset.dart' as _ijjfwapm;
import 'media/public_image.dart' as _ig6ant5g;
import 'products/product_summary.dart' as _ikmk0g5q;
import 'profile/member_profile.dart' as _i1iocmvy;
import 'quiz/quiz_answer.dart' as _ih1qnypb;
import 'quiz/quiz_answer_input.dart' as _ilw6ope9;
import 'staff/staff_invite.dart' as _ig710w64;
import 'staff/staff_invite_summary.dart' as _igjtjhuj;
import 'staff/staff_me.dart' as _i0yb5pr1;
import 'staff/staff_member.dart' as _ihm1xmqc;
import 'staff/staff_role.dart' as _imtqbwe6;
import 'staff/staff_session.dart' as _igu3u6o0;
import 'staff/staff_summary.dart' as _iminry28;
import 'staff/totp_enrollment.dart' as _ieq44cuc;
export 'account/deleted_account.dart';
export 'audit/audit_log_entry.dart';
export 'common/parla_exception.dart';
export 'consent/consent_record.dart';
export 'consent/consent_state.dart';
export 'consent/consent_type.dart';
export 'content/content_admin_item.dart';
export 'content/content_item.dart';
export 'content/content_status.dart';
export 'content/public_content.dart';
export 'health/care_list_record.dart';
export 'health/custom_routine_record.dart';
export 'health/health_key.dart';
export 'health/health_record.dart';
export 'health/nutrition_record.dart';
export 'health/sport_record.dart';
export 'media/media_admin_item.dart';
export 'media/media_asset.dart';
export 'media/public_image.dart';
export 'products/product_summary.dart';
export 'profile/member_profile.dart';
export 'quiz/quiz_answer.dart';
export 'quiz/quiz_answer_input.dart';
export 'staff/staff_invite.dart';
export 'staff/staff_invite_summary.dart';
export 'staff/staff_me.dart';
export 'staff/staff_member.dart';
export 'staff/staff_role.dart';
export 'staff/staff_session.dart';
export 'staff/staff_summary.dart';
export 'staff/totp_enrollment.dart';
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
          _isc.getType<_i37db98a.ContentAdminItem>,
          _isc.getType<_ima46zjc.ContentItem>,
          _isc.getType<_i5g0eai8.ContentStatus>,
          _isc.getType<_ikwk39jh.PublicContent>,
          _isc.getType<_iopyqj70.CareListRecord>,
          _isc.getType<_idmfi0v2.CustomRoutineRecord>,
          _isc.getType<_ipdtgm1c.HealthKey>,
          _isc.getType<_ioxvgdwn.HealthRecord>,
          _isc.getType<_in188bse.NutritionRecord>,
          _isc.getType<_izi2p90l.SportRecord>,
          _isc.getType<_if8q33w5.MediaAdminItem>,
          _isc.getType<_ijjfwapm.MediaAsset>,
          _isc.getType<_ig6ant5g.PublicImage>,
          _isc.getType<_ikmk0g5q.ProductSummary>,
          _isc.getType<_i1iocmvy.MemberProfile>,
          _isc.getType<_ih1qnypb.QuizAnswer>,
          _isc.getType<_ilw6ope9.QuizAnswerInput>,
          _isc.getType<_ig710w64.StaffInvite>,
          _isc.getType<_igjtjhuj.StaffInviteSummary>,
          _isc.getType<_i0yb5pr1.StaffMe>,
          _isc.getType<_ihm1xmqc.StaffMember>,
          _isc.getType<_imtqbwe6.StaffRole>,
          _isc.getType<_igu3u6o0.StaffSession>,
          _isc.getType<_iminry28.StaffSummary>,
          _isc.getType<_ieq44cuc.TotpEnrollment>,
          _isc.getType<_ioqa84oy.DeletedAccount?>,
          _isc.getType<_ioa77d8b.AuditLogEntry?>,
          _isc.getType<_iv1d8f8b.ParlaException?>,
          _isc.getType<_it7bphsc.ConsentRecord?>,
          _isc.getType<_icra10er.ConsentState?>,
          _isc.getType<_i40db2a8.ConsentType?>,
          _isc.getType<_i37db98a.ContentAdminItem?>,
          _isc.getType<_ima46zjc.ContentItem?>,
          _isc.getType<_i5g0eai8.ContentStatus?>,
          _isc.getType<_ikwk39jh.PublicContent?>,
          _isc.getType<_iopyqj70.CareListRecord?>,
          _isc.getType<_idmfi0v2.CustomRoutineRecord?>,
          _isc.getType<_ipdtgm1c.HealthKey?>,
          _isc.getType<_ioxvgdwn.HealthRecord?>,
          _isc.getType<_in188bse.NutritionRecord?>,
          _isc.getType<_izi2p90l.SportRecord?>,
          _isc.getType<_if8q33w5.MediaAdminItem?>,
          _isc.getType<_ijjfwapm.MediaAsset?>,
          _isc.getType<_ig6ant5g.PublicImage?>,
          _isc.getType<_ikmk0g5q.ProductSummary?>,
          _isc.getType<_i1iocmvy.MemberProfile?>,
          _isc.getType<_ih1qnypb.QuizAnswer?>,
          _isc.getType<_ilw6ope9.QuizAnswerInput?>,
          _isc.getType<_ig710w64.StaffInvite?>,
          _isc.getType<_igjtjhuj.StaffInviteSummary?>,
          _isc.getType<_i0yb5pr1.StaffMe?>,
          _isc.getType<_ihm1xmqc.StaffMember?>,
          _isc.getType<_imtqbwe6.StaffRole?>,
          _isc.getType<_igu3u6o0.StaffSession?>,
          _isc.getType<_iminry28.StaffSummary?>,
          _isc.getType<_ieq44cuc.TotpEnrollment?>,
          _isc.getType<List<String>>,
          _isc.getType<List<_iflgmsvc.ConsentState>>,
          _isc.getType<List<_i9q5wd3k.ContentAdminItem>>,
          _isc.getType<List<_iryaqqq7.PublicContent>>,
          _isc.getType<List<_izgab4v7.MediaAdminItem>>,
          _isc.getType<List<_isvy2zc1.ProductSummary>>,
          _isc.getType<List<_ikoicjb8.QuizAnswerInput>>,
          _isc.getType<List<_i48vujj3.StaffSummary>>,
          _isc.getType<List<_ivj2ydpk.StaffInviteSummary>>,
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
          'ContentAdminItem',
          'ContentItem',
          'ContentStatus',
          'PublicContent',
          'CareListRecord',
          'CustomRoutineRecord',
          'HealthKey',
          'HealthRecord',
          'NutritionRecord',
          'SportRecord',
          'MediaAdminItem',
          'MediaAsset',
          'PublicImage',
          'ProductSummary',
          'MemberProfile',
          'QuizAnswer',
          'QuizAnswerInput',
          'StaffInvite',
          'StaffInviteSummary',
          'StaffMe',
          'StaffMember',
          'StaffRole',
          'StaffSession',
          'StaffSummary',
          'TotpEnrollment',
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
    if (t == _i37db98a.ContentAdminItem) {
      return _i37db98a.ContentAdminItem.fromJson(data) as T;
    }
    if (t == _ima46zjc.ContentItem) {
      return _ima46zjc.ContentItem.fromJson(data) as T;
    }
    if (t == _i5g0eai8.ContentStatus) {
      return _i5g0eai8.ContentStatus.fromJson(data) as T;
    }
    if (t == _ikwk39jh.PublicContent) {
      return _ikwk39jh.PublicContent.fromJson(data) as T;
    }
    if (t == _iopyqj70.CareListRecord) {
      return _iopyqj70.CareListRecord.fromJson(data) as T;
    }
    if (t == _idmfi0v2.CustomRoutineRecord) {
      return _idmfi0v2.CustomRoutineRecord.fromJson(data) as T;
    }
    if (t == _ipdtgm1c.HealthKey) {
      return _ipdtgm1c.HealthKey.fromJson(data) as T;
    }
    if (t == _ioxvgdwn.HealthRecord) {
      return _ioxvgdwn.HealthRecord.fromJson(data) as T;
    }
    if (t == _in188bse.NutritionRecord) {
      return _in188bse.NutritionRecord.fromJson(data) as T;
    }
    if (t == _izi2p90l.SportRecord) {
      return _izi2p90l.SportRecord.fromJson(data) as T;
    }
    if (t == _if8q33w5.MediaAdminItem) {
      return _if8q33w5.MediaAdminItem.fromJson(data) as T;
    }
    if (t == _ijjfwapm.MediaAsset) {
      return _ijjfwapm.MediaAsset.fromJson(data) as T;
    }
    if (t == _ig6ant5g.PublicImage) {
      return _ig6ant5g.PublicImage.fromJson(data) as T;
    }
    if (t == _ikmk0g5q.ProductSummary) {
      return _ikmk0g5q.ProductSummary.fromJson(data) as T;
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
    if (t == _ig710w64.StaffInvite) {
      return _ig710w64.StaffInvite.fromJson(data) as T;
    }
    if (t == _igjtjhuj.StaffInviteSummary) {
      return _igjtjhuj.StaffInviteSummary.fromJson(data) as T;
    }
    if (t == _i0yb5pr1.StaffMe) {
      return _i0yb5pr1.StaffMe.fromJson(data) as T;
    }
    if (t == _ihm1xmqc.StaffMember) {
      return _ihm1xmqc.StaffMember.fromJson(data) as T;
    }
    if (t == _imtqbwe6.StaffRole) {
      return _imtqbwe6.StaffRole.fromJson(data) as T;
    }
    if (t == _igu3u6o0.StaffSession) {
      return _igu3u6o0.StaffSession.fromJson(data) as T;
    }
    if (t == _iminry28.StaffSummary) {
      return _iminry28.StaffSummary.fromJson(data) as T;
    }
    if (t == _ieq44cuc.TotpEnrollment) {
      return _ieq44cuc.TotpEnrollment.fromJson(data) as T;
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
    if (t == _isc.getType<_i37db98a.ContentAdminItem?>()) {
      return (data != null ? _i37db98a.ContentAdminItem.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ima46zjc.ContentItem?>()) {
      return (data != null ? _ima46zjc.ContentItem.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i5g0eai8.ContentStatus?>()) {
      return (data != null ? _i5g0eai8.ContentStatus.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ikwk39jh.PublicContent?>()) {
      return (data != null ? _ikwk39jh.PublicContent.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iopyqj70.CareListRecord?>()) {
      return (data != null ? _iopyqj70.CareListRecord.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_idmfi0v2.CustomRoutineRecord?>()) {
      return (data != null
              ? _idmfi0v2.CustomRoutineRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ipdtgm1c.HealthKey?>()) {
      return (data != null ? _ipdtgm1c.HealthKey.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ioxvgdwn.HealthRecord?>()) {
      return (data != null ? _ioxvgdwn.HealthRecord.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_in188bse.NutritionRecord?>()) {
      return (data != null ? _in188bse.NutritionRecord.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izi2p90l.SportRecord?>()) {
      return (data != null ? _izi2p90l.SportRecord.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_if8q33w5.MediaAdminItem?>()) {
      return (data != null ? _if8q33w5.MediaAdminItem.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ijjfwapm.MediaAsset?>()) {
      return (data != null ? _ijjfwapm.MediaAsset.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ig6ant5g.PublicImage?>()) {
      return (data != null ? _ig6ant5g.PublicImage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ikmk0g5q.ProductSummary?>()) {
      return (data != null ? _ikmk0g5q.ProductSummary.fromJson(data) : null)
          as T;
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
    if (t == _isc.getType<_ig710w64.StaffInvite?>()) {
      return (data != null ? _ig710w64.StaffInvite.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_igjtjhuj.StaffInviteSummary?>()) {
      return (data != null ? _igjtjhuj.StaffInviteSummary.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i0yb5pr1.StaffMe?>()) {
      return (data != null ? _i0yb5pr1.StaffMe.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ihm1xmqc.StaffMember?>()) {
      return (data != null ? _ihm1xmqc.StaffMember.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_imtqbwe6.StaffRole?>()) {
      return (data != null ? _imtqbwe6.StaffRole.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_igu3u6o0.StaffSession?>()) {
      return (data != null ? _igu3u6o0.StaffSession.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iminry28.StaffSummary?>()) {
      return (data != null ? _iminry28.StaffSummary.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ieq44cuc.TotpEnrollment?>()) {
      return (data != null ? _ieq44cuc.TotpEnrollment.fromJson(data) : null)
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
    if (t == List<_i9q5wd3k.ContentAdminItem>) {
      return (data as List)
              .map((e) => deserialize<_i9q5wd3k.ContentAdminItem>(e))
              .toList()
          as T;
    }
    if (t == List<_iryaqqq7.PublicContent>) {
      return (data as List)
              .map((e) => deserialize<_iryaqqq7.PublicContent>(e))
              .toList()
          as T;
    }
    if (t == List<_izgab4v7.MediaAdminItem>) {
      return (data as List)
              .map((e) => deserialize<_izgab4v7.MediaAdminItem>(e))
              .toList()
          as T;
    }
    if (t == List<_isvy2zc1.ProductSummary>) {
      return (data as List)
              .map((e) => deserialize<_isvy2zc1.ProductSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_ikoicjb8.QuizAnswerInput>) {
      return (data as List)
              .map((e) => deserialize<_ikoicjb8.QuizAnswerInput>(e))
              .toList()
          as T;
    }
    if (t == List<_i48vujj3.StaffSummary>) {
      return (data as List)
              .map((e) => deserialize<_i48vujj3.StaffSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_ivj2ydpk.StaffInviteSummary>) {
      return (data as List)
              .map((e) => deserialize<_ivj2ydpk.StaffInviteSummary>(e))
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
      _i37db98a.ContentAdminItem => 'ContentAdminItem',
      _ima46zjc.ContentItem => 'ContentItem',
      _i5g0eai8.ContentStatus => 'ContentStatus',
      _ikwk39jh.PublicContent => 'PublicContent',
      _iopyqj70.CareListRecord => 'CareListRecord',
      _idmfi0v2.CustomRoutineRecord => 'CustomRoutineRecord',
      _ipdtgm1c.HealthKey => 'HealthKey',
      _ioxvgdwn.HealthRecord => 'HealthRecord',
      _in188bse.NutritionRecord => 'NutritionRecord',
      _izi2p90l.SportRecord => 'SportRecord',
      _if8q33w5.MediaAdminItem => 'MediaAdminItem',
      _ijjfwapm.MediaAsset => 'MediaAsset',
      _ig6ant5g.PublicImage => 'PublicImage',
      _ikmk0g5q.ProductSummary => 'ProductSummary',
      _i1iocmvy.MemberProfile => 'MemberProfile',
      _ih1qnypb.QuizAnswer => 'QuizAnswer',
      _ilw6ope9.QuizAnswerInput => 'QuizAnswerInput',
      _ig710w64.StaffInvite => 'StaffInvite',
      _igjtjhuj.StaffInviteSummary => 'StaffInviteSummary',
      _i0yb5pr1.StaffMe => 'StaffMe',
      _ihm1xmqc.StaffMember => 'StaffMember',
      _imtqbwe6.StaffRole => 'StaffRole',
      _igu3u6o0.StaffSession => 'StaffSession',
      _iminry28.StaffSummary => 'StaffSummary',
      _ieq44cuc.TotpEnrollment => 'TotpEnrollment',
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
      case _i37db98a.ContentAdminItem():
        return 'ContentAdminItem';
      case _ima46zjc.ContentItem():
        return 'ContentItem';
      case _i5g0eai8.ContentStatus():
        return 'ContentStatus';
      case _ikwk39jh.PublicContent():
        return 'PublicContent';
      case _iopyqj70.CareListRecord():
        return 'CareListRecord';
      case _idmfi0v2.CustomRoutineRecord():
        return 'CustomRoutineRecord';
      case _ipdtgm1c.HealthKey():
        return 'HealthKey';
      case _ioxvgdwn.HealthRecord():
        return 'HealthRecord';
      case _in188bse.NutritionRecord():
        return 'NutritionRecord';
      case _izi2p90l.SportRecord():
        return 'SportRecord';
      case _if8q33w5.MediaAdminItem():
        return 'MediaAdminItem';
      case _ijjfwapm.MediaAsset():
        return 'MediaAsset';
      case _ig6ant5g.PublicImage():
        return 'PublicImage';
      case _ikmk0g5q.ProductSummary():
        return 'ProductSummary';
      case _i1iocmvy.MemberProfile():
        return 'MemberProfile';
      case _ih1qnypb.QuizAnswer():
        return 'QuizAnswer';
      case _ilw6ope9.QuizAnswerInput():
        return 'QuizAnswerInput';
      case _ig710w64.StaffInvite():
        return 'StaffInvite';
      case _igjtjhuj.StaffInviteSummary():
        return 'StaffInviteSummary';
      case _i0yb5pr1.StaffMe():
        return 'StaffMe';
      case _ihm1xmqc.StaffMember():
        return 'StaffMember';
      case _imtqbwe6.StaffRole():
        return 'StaffRole';
      case _igu3u6o0.StaffSession():
        return 'StaffSession';
      case _iminry28.StaffSummary():
        return 'StaffSummary';
      case _ieq44cuc.TotpEnrollment():
        return 'TotpEnrollment';
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
    if (dataClassName == 'ContentAdminItem') {
      return deserialize<_i37db98a.ContentAdminItem>(data['data']);
    }
    if (dataClassName == 'ContentItem') {
      return deserialize<_ima46zjc.ContentItem>(data['data']);
    }
    if (dataClassName == 'ContentStatus') {
      return deserialize<_i5g0eai8.ContentStatus>(data['data']);
    }
    if (dataClassName == 'PublicContent') {
      return deserialize<_ikwk39jh.PublicContent>(data['data']);
    }
    if (dataClassName == 'CareListRecord') {
      return deserialize<_iopyqj70.CareListRecord>(data['data']);
    }
    if (dataClassName == 'CustomRoutineRecord') {
      return deserialize<_idmfi0v2.CustomRoutineRecord>(data['data']);
    }
    if (dataClassName == 'HealthKey') {
      return deserialize<_ipdtgm1c.HealthKey>(data['data']);
    }
    if (dataClassName == 'HealthRecord') {
      return deserialize<_ioxvgdwn.HealthRecord>(data['data']);
    }
    if (dataClassName == 'NutritionRecord') {
      return deserialize<_in188bse.NutritionRecord>(data['data']);
    }
    if (dataClassName == 'SportRecord') {
      return deserialize<_izi2p90l.SportRecord>(data['data']);
    }
    if (dataClassName == 'MediaAdminItem') {
      return deserialize<_if8q33w5.MediaAdminItem>(data['data']);
    }
    if (dataClassName == 'MediaAsset') {
      return deserialize<_ijjfwapm.MediaAsset>(data['data']);
    }
    if (dataClassName == 'PublicImage') {
      return deserialize<_ig6ant5g.PublicImage>(data['data']);
    }
    if (dataClassName == 'ProductSummary') {
      return deserialize<_ikmk0g5q.ProductSummary>(data['data']);
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
    if (dataClassName == 'StaffInvite') {
      return deserialize<_ig710w64.StaffInvite>(data['data']);
    }
    if (dataClassName == 'StaffInviteSummary') {
      return deserialize<_igjtjhuj.StaffInviteSummary>(data['data']);
    }
    if (dataClassName == 'StaffMe') {
      return deserialize<_i0yb5pr1.StaffMe>(data['data']);
    }
    if (dataClassName == 'StaffMember') {
      return deserialize<_ihm1xmqc.StaffMember>(data['data']);
    }
    if (dataClassName == 'StaffRole') {
      return deserialize<_imtqbwe6.StaffRole>(data['data']);
    }
    if (dataClassName == 'StaffSession') {
      return deserialize<_igu3u6o0.StaffSession>(data['data']);
    }
    if (dataClassName == 'StaffSummary') {
      return deserialize<_iminry28.StaffSummary>(data['data']);
    }
    if (dataClassName == 'TotpEnrollment') {
      return deserialize<_ieq44cuc.TotpEnrollment>(data['data']);
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
