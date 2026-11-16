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
import 'package:parla_server/src/generated/consent/consent_state.dart'
    as _ianfun2u;
import 'package:parla_server/src/generated/content/content_admin_item.dart'
    as _itdeiy4d;
import 'package:parla_server/src/generated/content/public_content.dart'
    as _ixzwgpmi;
import 'package:parla_server/src/generated/products/product_summary.dart'
    as _ivq5jofi;
import 'package:parla_server/src/generated/quiz/quiz_answer_input.dart'
    as _iak2pevv;
import 'package:parla_server/src/generated/staff/staff_invite_summary.dart'
    as _ioscq55w;
import 'package:parla_server/src/generated/staff/staff_summary.dart'
    as _i0twq8uu;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
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

class Protocol extends _is.DatabaseSerializationManager
    implements _is.DatabaseProtocolDeserializationProvider {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  @override
  _is.ProtocolDeserialization get deserializationMetadata =>
      _is.ProtocolDeserialization.cached(
        this,
        types: const [
          _is.getType<_ioqa84oy.DeletedAccount>,
          _is.getType<_ioa77d8b.AuditLogEntry>,
          _is.getType<_iv1d8f8b.ParlaException>,
          _is.getType<_it7bphsc.ConsentRecord>,
          _is.getType<_icra10er.ConsentState>,
          _is.getType<_i40db2a8.ConsentType>,
          _is.getType<_i37db98a.ContentAdminItem>,
          _is.getType<_ima46zjc.ContentItem>,
          _is.getType<_i5g0eai8.ContentStatus>,
          _is.getType<_ikwk39jh.PublicContent>,
          _is.getType<_iopyqj70.CareListRecord>,
          _is.getType<_idmfi0v2.CustomRoutineRecord>,
          _is.getType<_ipdtgm1c.HealthKey>,
          _is.getType<_ioxvgdwn.HealthRecord>,
          _is.getType<_in188bse.NutritionRecord>,
          _is.getType<_izi2p90l.SportRecord>,
          _is.getType<_ikmk0g5q.ProductSummary>,
          _is.getType<_i1iocmvy.MemberProfile>,
          _is.getType<_ih1qnypb.QuizAnswer>,
          _is.getType<_ilw6ope9.QuizAnswerInput>,
          _is.getType<_ig710w64.StaffInvite>,
          _is.getType<_igjtjhuj.StaffInviteSummary>,
          _is.getType<_i0yb5pr1.StaffMe>,
          _is.getType<_ihm1xmqc.StaffMember>,
          _is.getType<_imtqbwe6.StaffRole>,
          _is.getType<_igu3u6o0.StaffSession>,
          _is.getType<_iminry28.StaffSummary>,
          _is.getType<_ieq44cuc.TotpEnrollment>,
          _is.getType<_ioqa84oy.DeletedAccount?>,
          _is.getType<_ioa77d8b.AuditLogEntry?>,
          _is.getType<_iv1d8f8b.ParlaException?>,
          _is.getType<_it7bphsc.ConsentRecord?>,
          _is.getType<_icra10er.ConsentState?>,
          _is.getType<_i40db2a8.ConsentType?>,
          _is.getType<_i37db98a.ContentAdminItem?>,
          _is.getType<_ima46zjc.ContentItem?>,
          _is.getType<_i5g0eai8.ContentStatus?>,
          _is.getType<_ikwk39jh.PublicContent?>,
          _is.getType<_iopyqj70.CareListRecord?>,
          _is.getType<_idmfi0v2.CustomRoutineRecord?>,
          _is.getType<_ipdtgm1c.HealthKey?>,
          _is.getType<_ioxvgdwn.HealthRecord?>,
          _is.getType<_in188bse.NutritionRecord?>,
          _is.getType<_izi2p90l.SportRecord?>,
          _is.getType<_ikmk0g5q.ProductSummary?>,
          _is.getType<_i1iocmvy.MemberProfile?>,
          _is.getType<_ih1qnypb.QuizAnswer?>,
          _is.getType<_ilw6ope9.QuizAnswerInput?>,
          _is.getType<_ig710w64.StaffInvite?>,
          _is.getType<_igjtjhuj.StaffInviteSummary?>,
          _is.getType<_i0yb5pr1.StaffMe?>,
          _is.getType<_ihm1xmqc.StaffMember?>,
          _is.getType<_imtqbwe6.StaffRole?>,
          _is.getType<_igu3u6o0.StaffSession?>,
          _is.getType<_iminry28.StaffSummary?>,
          _is.getType<_ieq44cuc.TotpEnrollment?>,
          _is.getType<List<String>>,
          _is.getType<List<_ianfun2u.ConsentState>>,
          _is.getType<List<_itdeiy4d.ContentAdminItem>>,
          _is.getType<List<_ixzwgpmi.PublicContent>>,
          _is.getType<List<_ivq5jofi.ProductSummary>>,
          _is.getType<List<_iak2pevv.QuizAnswerInput>>,
          _is.getType<List<_i0twq8uu.StaffSummary>>,
          _is.getType<List<_ioscq55w.StaffInviteSummary>>,
        ],
        modules: const [
          _iais.Protocol.new,
          _iacs.Protocol.new,
          _isp.Protocol.new,
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

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'audit_log',
      dartName: 'AuditLogEntry',
      schema: 'public',
      module: 'parla',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'actorId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'actorRole',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'action',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'objectType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'objectId',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'audit_log_created_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'care_list_record',
      dartName: 'CareListRecord',
      schema: 'public',
      module: 'parla',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'ciphertext',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'nonce',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'format',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'care_list_record_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'consent_record',
      dartName: 'ConsentRecord',
      schema: 'public',
      module: 'parla',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'consentType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ConsentType',
        ),
        _isp.ColumnDefinition(
          name: 'granted',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'textVersion',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'textHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'language',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'source',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'consent_record_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'consentType',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'content_item',
      dartName: 'ContentItem',
      schema: 'public',
      module: 'parla',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'kind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'slug',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'category',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ContentStatus',
        ),
        _isp.ColumnDefinition(
          name: 'draftJson',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'publishedJson',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'reviewedBy',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'reviewedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'reviewNote',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'publishedReviewedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'consentRecordedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'consentNote',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdBy',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'updatedBy',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'publishedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'content_item_slug_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'kind',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'slug',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'custom_routine_record',
      dartName: 'CustomRoutineRecord',
      schema: 'public',
      module: 'parla',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'ciphertext',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'nonce',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'format',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'custom_routine_record_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'deleted_account',
      dartName: 'DeletedAccount',
      schema: 'public',
      module: 'parla',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'pseudonym',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'deletedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'deleted_account_pseudonym_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'pseudonym',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'health_key',
      dartName: 'HealthKey',
      schema: 'public',
      module: 'parla',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'wrappedKey',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'nonce',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'kekVersion',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'health_key_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'health_record',
      dartName: 'HealthRecord',
      schema: 'public',
      module: 'parla',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'ciphertext',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'nonce',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'contentVersion',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'health_record_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'member_profile',
      dartName: 'MemberProfile',
      schema: 'public',
      module: 'parla',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'birthYear',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'countryCode',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'language',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'member_profile_auth_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'nutrition_record',
      dartName: 'NutritionRecord',
      schema: 'public',
      module: 'parla',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'ciphertext',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'nonce',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'format',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'nutrition_record_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'quiz_answer',
      dartName: 'QuizAnswer',
      schema: 'public',
      module: 'parla',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'questionId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'optionIds',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'contentVersion',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'answeredAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'quiz_answer_user_question_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'questionId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'sport_record',
      dartName: 'SportRecord',
      schema: 'public',
      module: 'parla',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'ciphertext',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'nonce',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'format',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'sport_record_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'staff_invite',
      dartName: 'StaffInvite',
      schema: 'public',
      module: 'parla',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:StaffRole',
        ),
        _isp.ColumnDefinition(
          name: 'codeHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'invitedBy',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'expiresAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'usedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'staff_invite_email_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'email',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'staff_member',
      dartName: 'StaffMember',
      schema: 'public',
      module: 'parla',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:StaffRole',
        ),
        _isp.ColumnDefinition(
          name: 'active',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'totpSecret',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'totpNonce',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'totpConfirmedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'lastTotpStep',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'failedTotp',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'lockedUntil',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'invitedBy',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'staff_member_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'staff_session',
      dartName: 'StaffSession',
      schema: 'public',
      module: 'parla',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'authId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'verifiedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'expiresAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'staff_session_auth_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) =>
      _is.ProtocolDeserialization.readClassName(data);

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    final rawDataClassName = _is.ProtocolDeserialization.readClassName(data);
    final dataClassName = rawDataClassName;
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
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
    if (t == _is.getType<_ioqa84oy.DeletedAccount?>()) {
      return (data != null ? _ioqa84oy.DeletedAccount.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ioa77d8b.AuditLogEntry?>()) {
      return (data != null ? _ioa77d8b.AuditLogEntry.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iv1d8f8b.ParlaException?>()) {
      return (data != null ? _iv1d8f8b.ParlaException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_it7bphsc.ConsentRecord?>()) {
      return (data != null ? _it7bphsc.ConsentRecord.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_icra10er.ConsentState?>()) {
      return (data != null ? _icra10er.ConsentState.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i40db2a8.ConsentType?>()) {
      return (data != null ? _i40db2a8.ConsentType.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i37db98a.ContentAdminItem?>()) {
      return (data != null ? _i37db98a.ContentAdminItem.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ima46zjc.ContentItem?>()) {
      return (data != null ? _ima46zjc.ContentItem.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i5g0eai8.ContentStatus?>()) {
      return (data != null ? _i5g0eai8.ContentStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ikwk39jh.PublicContent?>()) {
      return (data != null ? _ikwk39jh.PublicContent.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iopyqj70.CareListRecord?>()) {
      return (data != null ? _iopyqj70.CareListRecord.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_idmfi0v2.CustomRoutineRecord?>()) {
      return (data != null
              ? _idmfi0v2.CustomRoutineRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ipdtgm1c.HealthKey?>()) {
      return (data != null ? _ipdtgm1c.HealthKey.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ioxvgdwn.HealthRecord?>()) {
      return (data != null ? _ioxvgdwn.HealthRecord.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_in188bse.NutritionRecord?>()) {
      return (data != null ? _in188bse.NutritionRecord.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_izi2p90l.SportRecord?>()) {
      return (data != null ? _izi2p90l.SportRecord.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ikmk0g5q.ProductSummary?>()) {
      return (data != null ? _ikmk0g5q.ProductSummary.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i1iocmvy.MemberProfile?>()) {
      return (data != null ? _i1iocmvy.MemberProfile.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ih1qnypb.QuizAnswer?>()) {
      return (data != null ? _ih1qnypb.QuizAnswer.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ilw6ope9.QuizAnswerInput?>()) {
      return (data != null ? _ilw6ope9.QuizAnswerInput.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ig710w64.StaffInvite?>()) {
      return (data != null ? _ig710w64.StaffInvite.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_igjtjhuj.StaffInviteSummary?>()) {
      return (data != null ? _igjtjhuj.StaffInviteSummary.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i0yb5pr1.StaffMe?>()) {
      return (data != null ? _i0yb5pr1.StaffMe.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ihm1xmqc.StaffMember?>()) {
      return (data != null ? _ihm1xmqc.StaffMember.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_imtqbwe6.StaffRole?>()) {
      return (data != null ? _imtqbwe6.StaffRole.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_igu3u6o0.StaffSession?>()) {
      return (data != null ? _igu3u6o0.StaffSession.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iminry28.StaffSummary?>()) {
      return (data != null ? _iminry28.StaffSummary.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ieq44cuc.TotpEnrollment?>()) {
      return (data != null ? _ieq44cuc.TotpEnrollment.fromJson(data) : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_ianfun2u.ConsentState>) {
      return (data as List)
              .map((e) => deserialize<_ianfun2u.ConsentState>(e))
              .toList()
          as T;
    }
    if (t == List<_itdeiy4d.ContentAdminItem>) {
      return (data as List)
              .map((e) => deserialize<_itdeiy4d.ContentAdminItem>(e))
              .toList()
          as T;
    }
    if (t == List<_ixzwgpmi.PublicContent>) {
      return (data as List)
              .map((e) => deserialize<_ixzwgpmi.PublicContent>(e))
              .toList()
          as T;
    }
    if (t == List<_ivq5jofi.ProductSummary>) {
      return (data as List)
              .map((e) => deserialize<_ivq5jofi.ProductSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_iak2pevv.QuizAnswerInput>) {
      return (data as List)
              .map((e) => deserialize<_iak2pevv.QuizAnswerInput>(e))
              .toList()
          as T;
    }
    if (t == List<_i0twq8uu.StaffSummary>) {
      return (data as List)
              .map((e) => deserialize<_i0twq8uu.StaffSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_ioscq55w.StaffInviteSummary>) {
      return (data as List)
              .map((e) => deserialize<_ioscq55w.StaffInviteSummary>(e))
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
      } on _is.DeserializationTypeNotFoundException catch (_) {}
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
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
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
      return _iais.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(19),
      });
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      return _iacs.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(20),
      });
    }
    if (dataClassName.startsWith('serverpod.')) {
      return _isp.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(10),
      });
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('parla', this);
    _iacs.Protocol().registerHostProtocol('parla', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _ioqa84oy.DeletedAccount:
        return _ioqa84oy.DeletedAccount.t;
      case _ioa77d8b.AuditLogEntry:
        return _ioa77d8b.AuditLogEntry.t;
      case _it7bphsc.ConsentRecord:
        return _it7bphsc.ConsentRecord.t;
      case _ima46zjc.ContentItem:
        return _ima46zjc.ContentItem.t;
      case _iopyqj70.CareListRecord:
        return _iopyqj70.CareListRecord.t;
      case _idmfi0v2.CustomRoutineRecord:
        return _idmfi0v2.CustomRoutineRecord.t;
      case _ipdtgm1c.HealthKey:
        return _ipdtgm1c.HealthKey.t;
      case _ioxvgdwn.HealthRecord:
        return _ioxvgdwn.HealthRecord.t;
      case _in188bse.NutritionRecord:
        return _in188bse.NutritionRecord.t;
      case _izi2p90l.SportRecord:
        return _izi2p90l.SportRecord.t;
      case _i1iocmvy.MemberProfile:
        return _i1iocmvy.MemberProfile.t;
      case _ih1qnypb.QuizAnswer:
        return _ih1qnypb.QuizAnswer.t;
      case _ig710w64.StaffInvite:
        return _ig710w64.StaffInvite.t;
      case _ihm1xmqc.StaffMember:
        return _ihm1xmqc.StaffMember.t;
      case _igu3u6o0.StaffSession:
        return _igu3u6o0.StaffSession.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

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
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
