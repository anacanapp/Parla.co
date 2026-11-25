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
import 'package:parla_server/src/generated/ads/ad_campaign.dart' as _io8rol46;
import 'package:parla_server/src/generated/ads/ad_campaign_option.dart'
    as _ixfd2xet;
import 'package:parla_server/src/generated/ads/advertiser.dart' as _iau35hq5;
import 'package:parla_server/src/generated/audit/audit_log_entry.dart'
    as _ixhbanhz;
import 'package:parla_server/src/generated/consent/consent_state.dart'
    as _ianfun2u;
import 'package:parla_server/src/generated/content/content_admin_item.dart'
    as _itdeiy4d;
import 'package:parla_server/src/generated/content/public_content.dart'
    as _ixzwgpmi;
import 'package:parla_server/src/generated/media/media_admin_item.dart'
    as _i0szydc4;
import 'package:parla_server/src/generated/products/product_summary.dart'
    as _ivq5jofi;
import 'package:parla_server/src/generated/quiz/quiz_answer_input.dart'
    as _iak2pevv;
import 'package:parla_server/src/generated/shop/shop_order_view.dart'
    as _i5cj9omj;
import 'package:parla_server/src/generated/staff/staff_invite_summary.dart'
    as _ioscq55w;
import 'package:parla_server/src/generated/staff/staff_summary.dart'
    as _i0twq8uu;
import 'package:parla_server/src/generated/support/support_entry.dart'
    as _iexc7wsp;
import 'package:parla_server/src/generated/support/support_thread_summary.dart'
    as _i41nkhg5;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'account/deleted_account.dart' as _ioqa84oy;
import 'ads/ad_campaign.dart' as _ia3hy79f;
import 'ads/ad_campaign_option.dart' as _i26gm73h;
import 'ads/ad_report.dart' as _iubkydyh;
import 'ads/ad_report_row.dart' as _iohwiajb;
import 'ads/advertiser.dart' as _icstda9z;
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
import 'push/device_token.dart' as _iqu8ign5;
import 'quiz/quiz_answer.dart' as _ih1qnypb;
import 'quiz/quiz_answer_input.dart' as _ilw6ope9;
import 'shop/shop_checkout.dart' as _ijilqnse;
import 'shop/shop_order.dart' as _iebtnvku;
import 'shop/shop_order_status.dart' as _ik5inhen;
import 'shop/shop_order_view.dart' as _ibk2dfia;
import 'staff/staff_invite.dart' as _ig710w64;
import 'staff/staff_invite_summary.dart' as _igjtjhuj;
import 'staff/staff_me.dart' as _i0yb5pr1;
import 'staff/staff_member.dart' as _ihm1xmqc;
import 'staff/staff_role.dart' as _imtqbwe6;
import 'staff/staff_summary.dart' as _iminry28;
import 'stats/daily_active_count.dart' as _iphzj4es;
import 'stats/daily_active_mark.dart' as _ipxxg0d2;
import 'stats/dashboard_report.dart' as _igkrtb48;
import 'stats/stats_count.dart' as _iu0qh84b;
import 'stats/stats_group.dart' as _imrurtjq;
import 'stats/stats_report.dart' as _i9vgpxbr;
import 'stats/usage_daily.dart' as _i5155cwu;
import 'stats/usage_report.dart' as _ijn07asl;
import 'support/support_entry.dart' as _iaeay4r3;
import 'support/support_message.dart' as _izh8ly96;
import 'support/support_thread.dart' as _iq87yxf7;
import 'support/support_thread_summary.dart' as _idy4xhr0;
import 'users/user_admin_view.dart' as _i06wcc3f;
export 'account/deleted_account.dart';
export 'ads/ad_campaign.dart';
export 'ads/ad_campaign_option.dart';
export 'ads/ad_report.dart';
export 'ads/ad_report_row.dart';
export 'ads/advertiser.dart';
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
export 'push/device_token.dart';
export 'quiz/quiz_answer.dart';
export 'quiz/quiz_answer_input.dart';
export 'shop/shop_checkout.dart';
export 'shop/shop_order.dart';
export 'shop/shop_order_status.dart';
export 'shop/shop_order_view.dart';
export 'staff/staff_invite.dart';
export 'staff/staff_invite_summary.dart';
export 'staff/staff_me.dart';
export 'staff/staff_member.dart';
export 'staff/staff_role.dart';
export 'staff/staff_summary.dart';
export 'stats/daily_active_count.dart';
export 'stats/daily_active_mark.dart';
export 'stats/dashboard_report.dart';
export 'stats/stats_count.dart';
export 'stats/stats_group.dart';
export 'stats/stats_report.dart';
export 'stats/usage_daily.dart';
export 'stats/usage_report.dart';
export 'support/support_entry.dart';
export 'support/support_message.dart';
export 'support/support_thread.dart';
export 'support/support_thread_summary.dart';
export 'users/user_admin_view.dart';

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
          _is.getType<_ia3hy79f.AdCampaign>,
          _is.getType<_i26gm73h.AdCampaignOption>,
          _is.getType<_iubkydyh.AdReport>,
          _is.getType<_iohwiajb.AdReportRow>,
          _is.getType<_icstda9z.Advertiser>,
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
          _is.getType<_if8q33w5.MediaAdminItem>,
          _is.getType<_ijjfwapm.MediaAsset>,
          _is.getType<_ig6ant5g.PublicImage>,
          _is.getType<_ikmk0g5q.ProductSummary>,
          _is.getType<_i1iocmvy.MemberProfile>,
          _is.getType<_iqu8ign5.DeviceToken>,
          _is.getType<_ih1qnypb.QuizAnswer>,
          _is.getType<_ilw6ope9.QuizAnswerInput>,
          _is.getType<_ijilqnse.ShopCheckout>,
          _is.getType<_iebtnvku.ShopOrder>,
          _is.getType<_ik5inhen.ShopOrderStatus>,
          _is.getType<_ibk2dfia.ShopOrderView>,
          _is.getType<_ig710w64.StaffInvite>,
          _is.getType<_igjtjhuj.StaffInviteSummary>,
          _is.getType<_i0yb5pr1.StaffMe>,
          _is.getType<_ihm1xmqc.StaffMember>,
          _is.getType<_imtqbwe6.StaffRole>,
          _is.getType<_iminry28.StaffSummary>,
          _is.getType<_iphzj4es.DailyActiveCount>,
          _is.getType<_ipxxg0d2.DailyActiveMark>,
          _is.getType<_igkrtb48.DashboardReport>,
          _is.getType<_iu0qh84b.StatsCount>,
          _is.getType<_imrurtjq.StatsGroup>,
          _is.getType<_i9vgpxbr.StatsReport>,
          _is.getType<_i5155cwu.UsageDaily>,
          _is.getType<_ijn07asl.UsageReport>,
          _is.getType<_iaeay4r3.SupportEntry>,
          _is.getType<_izh8ly96.SupportMessage>,
          _is.getType<_iq87yxf7.SupportThread>,
          _is.getType<_idy4xhr0.SupportThreadSummary>,
          _is.getType<_i06wcc3f.UserAdminView>,
          _is.getType<_ioqa84oy.DeletedAccount?>,
          _is.getType<_ia3hy79f.AdCampaign?>,
          _is.getType<_i26gm73h.AdCampaignOption?>,
          _is.getType<_iubkydyh.AdReport?>,
          _is.getType<_iohwiajb.AdReportRow?>,
          _is.getType<_icstda9z.Advertiser?>,
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
          _is.getType<_if8q33w5.MediaAdminItem?>,
          _is.getType<_ijjfwapm.MediaAsset?>,
          _is.getType<_ig6ant5g.PublicImage?>,
          _is.getType<_ikmk0g5q.ProductSummary?>,
          _is.getType<_i1iocmvy.MemberProfile?>,
          _is.getType<_iqu8ign5.DeviceToken?>,
          _is.getType<_ih1qnypb.QuizAnswer?>,
          _is.getType<_ilw6ope9.QuizAnswerInput?>,
          _is.getType<_ijilqnse.ShopCheckout?>,
          _is.getType<_iebtnvku.ShopOrder?>,
          _is.getType<_ik5inhen.ShopOrderStatus?>,
          _is.getType<_ibk2dfia.ShopOrderView?>,
          _is.getType<_ig710w64.StaffInvite?>,
          _is.getType<_igjtjhuj.StaffInviteSummary?>,
          _is.getType<_i0yb5pr1.StaffMe?>,
          _is.getType<_ihm1xmqc.StaffMember?>,
          _is.getType<_imtqbwe6.StaffRole?>,
          _is.getType<_iminry28.StaffSummary?>,
          _is.getType<_iphzj4es.DailyActiveCount?>,
          _is.getType<_ipxxg0d2.DailyActiveMark?>,
          _is.getType<_igkrtb48.DashboardReport?>,
          _is.getType<_iu0qh84b.StatsCount?>,
          _is.getType<_imrurtjq.StatsGroup?>,
          _is.getType<_i9vgpxbr.StatsReport?>,
          _is.getType<_i5155cwu.UsageDaily?>,
          _is.getType<_ijn07asl.UsageReport?>,
          _is.getType<_iaeay4r3.SupportEntry?>,
          _is.getType<_izh8ly96.SupportMessage?>,
          _is.getType<_iq87yxf7.SupportThread?>,
          _is.getType<_idy4xhr0.SupportThreadSummary?>,
          _is.getType<_i06wcc3f.UserAdminView?>,
          _is.getType<List<_iohwiajb.AdReportRow>>,
          _is.getType<List<_ig6ant5g.PublicImage>>,
          _is.getType<List<_ig6ant5g.PublicImage>?>,
          _is.getType<List<String>>,
          _is.getType<List<_iu0qh84b.StatsCount>>,
          _is.getType<List<_imrurtjq.StatsGroup>>,
          _is.getType<Map<String, int>>,
          _is.getType<List<_icra10er.ConsentState>>,
          _is.getType<List<_iau35hq5.Advertiser>>,
          _is.getType<List<_io8rol46.AdCampaign>>,
          _is.getType<List<_ixfd2xet.AdCampaignOption>>,
          _is.getType<List<_ixhbanhz.AuditLogEntry>>,
          _is.getType<List<_ianfun2u.ConsentState>>,
          _is.getType<List<_itdeiy4d.ContentAdminItem>>,
          _is.getType<List<_ixzwgpmi.PublicContent>>,
          _is.getType<List<_i0szydc4.MediaAdminItem>>,
          _is.getType<List<_ivq5jofi.ProductSummary>>,
          _is.getType<List<_iak2pevv.QuizAnswerInput>>,
          _is.getType<List<_i5cj9omj.ShopOrderView>>,
          _is.getType<List<_i0twq8uu.StaffSummary>>,
          _is.getType<List<_ioscq55w.StaffInviteSummary>>,
          _is.getType<List<_i41nkhg5.SupportThreadSummary>>,
          _is.getType<List<_iexc7wsp.SupportEntry>>,
        ],
        modules: const [
          _iais.Protocol.new,
          _iacs.Protocol.new,
          _isp.Protocol.new,
        ],
        classNames: const [
          'DeletedAccount',
          'AdCampaign',
          'AdCampaignOption',
          'AdReport',
          'AdReportRow',
          'Advertiser',
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
          'DeviceToken',
          'QuizAnswer',
          'QuizAnswerInput',
          'ShopCheckout',
          'ShopOrder',
          'ShopOrderStatus',
          'ShopOrderView',
          'StaffInvite',
          'StaffInviteSummary',
          'StaffMe',
          'StaffMember',
          'StaffRole',
          'StaffSummary',
          'DailyActiveCount',
          'DailyActiveMark',
          'DashboardReport',
          'StatsCount',
          'StatsGroup',
          'StatsReport',
          'UsageDaily',
          'UsageReport',
          'SupportEntry',
          'SupportMessage',
          'SupportThread',
          'SupportThreadSummary',
          'UserAdminView',
        ],
      );

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'ad_campaign',
      dartName: 'AdCampaign',
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
          name: 'advertiserId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'startsOn',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'endsOn',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'priceNote',
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
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'ad_campaign_fk_0',
          columns: ['advertiserId'],
          referenceTable: 'advertiser',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'ad_campaign_advertiser_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'advertiserId',
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
      name: 'advertiser',
      dartName: 'Advertiser',
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
          name: 'company',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'contractNumber',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'contractStart',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'contractEnd',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'note',
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
          indexName: 'advertiser_name_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'company',
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
        _isp.ColumnDefinition(
          name: 'hidden',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
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
      name: 'daily_active_count',
      dartName: 'DailyActiveCount',
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
          name: 'day',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'accounts',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'weekly',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'monthly',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'ios',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'android',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'daily_active_count_day_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'day',
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
      name: 'daily_active_mark',
      dartName: 'DailyActiveMark',
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
          name: 'day',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'mark',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'platform',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'daily_active_mark_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'day',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'mark',
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
      name: 'device_token',
      dartName: 'DeviceToken',
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
          name: 'token',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'platform',
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
        _isp.ColumnDefinition(
          name: 'lastSeenAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'device_token_token_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'token',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'device_token_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
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
      name: 'media_asset',
      dartName: 'MediaAsset',
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
          name: 'key',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'mediaType',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'image\'',
        ),
        _isp.ColumnDefinition(
          name: 'durationMs',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'pixelWidth',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'pixelHeight',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'bytes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'license',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'source',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'altJson',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'public',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'createdBy',
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
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'media_asset_key_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'key',
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
      name: 'shop_order',
      dartName: 'ShopOrder',
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
          name: 'number',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'productId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'productSlug',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'productTitle',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'brand',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'seller',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'quantity',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'unitQepik',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'totalQepik',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ShopOrderStatus',
        ),
        _isp.ColumnDefinition(
          name: 'transaction',
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
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'paidAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'shop_order_number_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'number',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'shop_order_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
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
      name: 'support_message',
      dartName: 'SupportMessage',
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
          name: 'threadId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'fromStaff',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'staffId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
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
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'support_message_thread_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'threadId',
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
      name: 'support_thread',
      dartName: 'SupportThread',
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
          name: 'open',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'unreadByStaff',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'unreadByUser',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'lastMessageAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'support_thread_user_idx',
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
      name: 'usage_daily',
      dartName: 'UsageDaily',
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
          name: 'day',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'country',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'platform',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'event',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'target',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'times',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'usage_daily_key_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'day',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'country',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'platform',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'event',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'target',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'usage_daily_day_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'day',
            ),
          ],
          type: 'btree',
          isUnique: false,
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
    if (t == _ia3hy79f.AdCampaign) {
      return _ia3hy79f.AdCampaign.fromJson(data) as T;
    }
    if (t == _i26gm73h.AdCampaignOption) {
      return _i26gm73h.AdCampaignOption.fromJson(data) as T;
    }
    if (t == _iubkydyh.AdReport) {
      return _iubkydyh.AdReport.fromJson(data) as T;
    }
    if (t == _iohwiajb.AdReportRow) {
      return _iohwiajb.AdReportRow.fromJson(data) as T;
    }
    if (t == _icstda9z.Advertiser) {
      return _icstda9z.Advertiser.fromJson(data) as T;
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
    if (t == _iqu8ign5.DeviceToken) {
      return _iqu8ign5.DeviceToken.fromJson(data) as T;
    }
    if (t == _ih1qnypb.QuizAnswer) {
      return _ih1qnypb.QuizAnswer.fromJson(data) as T;
    }
    if (t == _ilw6ope9.QuizAnswerInput) {
      return _ilw6ope9.QuizAnswerInput.fromJson(data) as T;
    }
    if (t == _ijilqnse.ShopCheckout) {
      return _ijilqnse.ShopCheckout.fromJson(data) as T;
    }
    if (t == _iebtnvku.ShopOrder) {
      return _iebtnvku.ShopOrder.fromJson(data) as T;
    }
    if (t == _ik5inhen.ShopOrderStatus) {
      return _ik5inhen.ShopOrderStatus.fromJson(data) as T;
    }
    if (t == _ibk2dfia.ShopOrderView) {
      return _ibk2dfia.ShopOrderView.fromJson(data) as T;
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
    if (t == _iminry28.StaffSummary) {
      return _iminry28.StaffSummary.fromJson(data) as T;
    }
    if (t == _iphzj4es.DailyActiveCount) {
      return _iphzj4es.DailyActiveCount.fromJson(data) as T;
    }
    if (t == _ipxxg0d2.DailyActiveMark) {
      return _ipxxg0d2.DailyActiveMark.fromJson(data) as T;
    }
    if (t == _igkrtb48.DashboardReport) {
      return _igkrtb48.DashboardReport.fromJson(data) as T;
    }
    if (t == _iu0qh84b.StatsCount) {
      return _iu0qh84b.StatsCount.fromJson(data) as T;
    }
    if (t == _imrurtjq.StatsGroup) {
      return _imrurtjq.StatsGroup.fromJson(data) as T;
    }
    if (t == _i9vgpxbr.StatsReport) {
      return _i9vgpxbr.StatsReport.fromJson(data) as T;
    }
    if (t == _i5155cwu.UsageDaily) {
      return _i5155cwu.UsageDaily.fromJson(data) as T;
    }
    if (t == _ijn07asl.UsageReport) {
      return _ijn07asl.UsageReport.fromJson(data) as T;
    }
    if (t == _iaeay4r3.SupportEntry) {
      return _iaeay4r3.SupportEntry.fromJson(data) as T;
    }
    if (t == _izh8ly96.SupportMessage) {
      return _izh8ly96.SupportMessage.fromJson(data) as T;
    }
    if (t == _iq87yxf7.SupportThread) {
      return _iq87yxf7.SupportThread.fromJson(data) as T;
    }
    if (t == _idy4xhr0.SupportThreadSummary) {
      return _idy4xhr0.SupportThreadSummary.fromJson(data) as T;
    }
    if (t == _i06wcc3f.UserAdminView) {
      return _i06wcc3f.UserAdminView.fromJson(data) as T;
    }
    if (t == _is.getType<_ioqa84oy.DeletedAccount?>()) {
      return (data != null ? _ioqa84oy.DeletedAccount.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ia3hy79f.AdCampaign?>()) {
      return (data != null ? _ia3hy79f.AdCampaign.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i26gm73h.AdCampaignOption?>()) {
      return (data != null ? _i26gm73h.AdCampaignOption.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iubkydyh.AdReport?>()) {
      return (data != null ? _iubkydyh.AdReport.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iohwiajb.AdReportRow?>()) {
      return (data != null ? _iohwiajb.AdReportRow.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_icstda9z.Advertiser?>()) {
      return (data != null ? _icstda9z.Advertiser.fromJson(data) : null) as T;
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
    if (t == _is.getType<_if8q33w5.MediaAdminItem?>()) {
      return (data != null ? _if8q33w5.MediaAdminItem.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ijjfwapm.MediaAsset?>()) {
      return (data != null ? _ijjfwapm.MediaAsset.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ig6ant5g.PublicImage?>()) {
      return (data != null ? _ig6ant5g.PublicImage.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ikmk0g5q.ProductSummary?>()) {
      return (data != null ? _ikmk0g5q.ProductSummary.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i1iocmvy.MemberProfile?>()) {
      return (data != null ? _i1iocmvy.MemberProfile.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iqu8ign5.DeviceToken?>()) {
      return (data != null ? _iqu8ign5.DeviceToken.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ih1qnypb.QuizAnswer?>()) {
      return (data != null ? _ih1qnypb.QuizAnswer.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ilw6ope9.QuizAnswerInput?>()) {
      return (data != null ? _ilw6ope9.QuizAnswerInput.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ijilqnse.ShopCheckout?>()) {
      return (data != null ? _ijilqnse.ShopCheckout.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iebtnvku.ShopOrder?>()) {
      return (data != null ? _iebtnvku.ShopOrder.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ik5inhen.ShopOrderStatus?>()) {
      return (data != null ? _ik5inhen.ShopOrderStatus.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ibk2dfia.ShopOrderView?>()) {
      return (data != null ? _ibk2dfia.ShopOrderView.fromJson(data) : null)
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
    if (t == _is.getType<_iminry28.StaffSummary?>()) {
      return (data != null ? _iminry28.StaffSummary.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iphzj4es.DailyActiveCount?>()) {
      return (data != null ? _iphzj4es.DailyActiveCount.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ipxxg0d2.DailyActiveMark?>()) {
      return (data != null ? _ipxxg0d2.DailyActiveMark.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_igkrtb48.DashboardReport?>()) {
      return (data != null ? _igkrtb48.DashboardReport.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iu0qh84b.StatsCount?>()) {
      return (data != null ? _iu0qh84b.StatsCount.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_imrurtjq.StatsGroup?>()) {
      return (data != null ? _imrurtjq.StatsGroup.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i9vgpxbr.StatsReport?>()) {
      return (data != null ? _i9vgpxbr.StatsReport.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i5155cwu.UsageDaily?>()) {
      return (data != null ? _i5155cwu.UsageDaily.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ijn07asl.UsageReport?>()) {
      return (data != null ? _ijn07asl.UsageReport.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iaeay4r3.SupportEntry?>()) {
      return (data != null ? _iaeay4r3.SupportEntry.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_izh8ly96.SupportMessage?>()) {
      return (data != null ? _izh8ly96.SupportMessage.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iq87yxf7.SupportThread?>()) {
      return (data != null ? _iq87yxf7.SupportThread.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_idy4xhr0.SupportThreadSummary?>()) {
      return (data != null
              ? _idy4xhr0.SupportThreadSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i06wcc3f.UserAdminView?>()) {
      return (data != null ? _i06wcc3f.UserAdminView.fromJson(data) : null)
          as T;
    }
    if (t == List<_iohwiajb.AdReportRow>) {
      return (data as List)
              .map((e) => deserialize<_iohwiajb.AdReportRow>(e))
              .toList()
          as T;
    }
    if (t == List<_ig6ant5g.PublicImage>) {
      return (data as List)
              .map((e) => deserialize<_ig6ant5g.PublicImage>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_ig6ant5g.PublicImage>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ig6ant5g.PublicImage>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_iu0qh84b.StatsCount>) {
      return (data as List)
              .map((e) => deserialize<_iu0qh84b.StatsCount>(e))
              .toList()
          as T;
    }
    if (t == List<_imrurtjq.StatsGroup>) {
      return (data as List)
              .map((e) => deserialize<_imrurtjq.StatsGroup>(e))
              .toList()
          as T;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)),
          )
          as T;
    }
    if (t == List<_icra10er.ConsentState>) {
      return (data as List)
              .map((e) => deserialize<_icra10er.ConsentState>(e))
              .toList()
          as T;
    }
    if (t == List<_iau35hq5.Advertiser>) {
      return (data as List)
              .map((e) => deserialize<_iau35hq5.Advertiser>(e))
              .toList()
          as T;
    }
    if (t == List<_io8rol46.AdCampaign>) {
      return (data as List)
              .map((e) => deserialize<_io8rol46.AdCampaign>(e))
              .toList()
          as T;
    }
    if (t == List<_ixfd2xet.AdCampaignOption>) {
      return (data as List)
              .map((e) => deserialize<_ixfd2xet.AdCampaignOption>(e))
              .toList()
          as T;
    }
    if (t == List<_ixhbanhz.AuditLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_ixhbanhz.AuditLogEntry>(e))
              .toList()
          as T;
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
    if (t == List<_i0szydc4.MediaAdminItem>) {
      return (data as List)
              .map((e) => deserialize<_i0szydc4.MediaAdminItem>(e))
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
    if (t == List<_i5cj9omj.ShopOrderView>) {
      return (data as List)
              .map((e) => deserialize<_i5cj9omj.ShopOrderView>(e))
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
    if (t == List<_i41nkhg5.SupportThreadSummary>) {
      return (data as List)
              .map((e) => deserialize<_i41nkhg5.SupportThreadSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_iexc7wsp.SupportEntry>) {
      return (data as List)
              .map((e) => deserialize<_iexc7wsp.SupportEntry>(e))
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
      _ia3hy79f.AdCampaign => 'AdCampaign',
      _i26gm73h.AdCampaignOption => 'AdCampaignOption',
      _iubkydyh.AdReport => 'AdReport',
      _iohwiajb.AdReportRow => 'AdReportRow',
      _icstda9z.Advertiser => 'Advertiser',
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
      _iqu8ign5.DeviceToken => 'DeviceToken',
      _ih1qnypb.QuizAnswer => 'QuizAnswer',
      _ilw6ope9.QuizAnswerInput => 'QuizAnswerInput',
      _ijilqnse.ShopCheckout => 'ShopCheckout',
      _iebtnvku.ShopOrder => 'ShopOrder',
      _ik5inhen.ShopOrderStatus => 'ShopOrderStatus',
      _ibk2dfia.ShopOrderView => 'ShopOrderView',
      _ig710w64.StaffInvite => 'StaffInvite',
      _igjtjhuj.StaffInviteSummary => 'StaffInviteSummary',
      _i0yb5pr1.StaffMe => 'StaffMe',
      _ihm1xmqc.StaffMember => 'StaffMember',
      _imtqbwe6.StaffRole => 'StaffRole',
      _iminry28.StaffSummary => 'StaffSummary',
      _iphzj4es.DailyActiveCount => 'DailyActiveCount',
      _ipxxg0d2.DailyActiveMark => 'DailyActiveMark',
      _igkrtb48.DashboardReport => 'DashboardReport',
      _iu0qh84b.StatsCount => 'StatsCount',
      _imrurtjq.StatsGroup => 'StatsGroup',
      _i9vgpxbr.StatsReport => 'StatsReport',
      _i5155cwu.UsageDaily => 'UsageDaily',
      _ijn07asl.UsageReport => 'UsageReport',
      _iaeay4r3.SupportEntry => 'SupportEntry',
      _izh8ly96.SupportMessage => 'SupportMessage',
      _iq87yxf7.SupportThread => 'SupportThread',
      _idy4xhr0.SupportThreadSummary => 'SupportThreadSummary',
      _i06wcc3f.UserAdminView => 'UserAdminView',
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
      case _ia3hy79f.AdCampaign():
        return 'AdCampaign';
      case _i26gm73h.AdCampaignOption():
        return 'AdCampaignOption';
      case _iubkydyh.AdReport():
        return 'AdReport';
      case _iohwiajb.AdReportRow():
        return 'AdReportRow';
      case _icstda9z.Advertiser():
        return 'Advertiser';
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
      case _iqu8ign5.DeviceToken():
        return 'DeviceToken';
      case _ih1qnypb.QuizAnswer():
        return 'QuizAnswer';
      case _ilw6ope9.QuizAnswerInput():
        return 'QuizAnswerInput';
      case _ijilqnse.ShopCheckout():
        return 'ShopCheckout';
      case _iebtnvku.ShopOrder():
        return 'ShopOrder';
      case _ik5inhen.ShopOrderStatus():
        return 'ShopOrderStatus';
      case _ibk2dfia.ShopOrderView():
        return 'ShopOrderView';
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
      case _iminry28.StaffSummary():
        return 'StaffSummary';
      case _iphzj4es.DailyActiveCount():
        return 'DailyActiveCount';
      case _ipxxg0d2.DailyActiveMark():
        return 'DailyActiveMark';
      case _igkrtb48.DashboardReport():
        return 'DashboardReport';
      case _iu0qh84b.StatsCount():
        return 'StatsCount';
      case _imrurtjq.StatsGroup():
        return 'StatsGroup';
      case _i9vgpxbr.StatsReport():
        return 'StatsReport';
      case _i5155cwu.UsageDaily():
        return 'UsageDaily';
      case _ijn07asl.UsageReport():
        return 'UsageReport';
      case _iaeay4r3.SupportEntry():
        return 'SupportEntry';
      case _izh8ly96.SupportMessage():
        return 'SupportMessage';
      case _iq87yxf7.SupportThread():
        return 'SupportThread';
      case _idy4xhr0.SupportThreadSummary():
        return 'SupportThreadSummary';
      case _i06wcc3f.UserAdminView():
        return 'UserAdminView';
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
    if (dataClassName == 'AdCampaign') {
      return deserialize<_ia3hy79f.AdCampaign>(data['data']);
    }
    if (dataClassName == 'AdCampaignOption') {
      return deserialize<_i26gm73h.AdCampaignOption>(data['data']);
    }
    if (dataClassName == 'AdReport') {
      return deserialize<_iubkydyh.AdReport>(data['data']);
    }
    if (dataClassName == 'AdReportRow') {
      return deserialize<_iohwiajb.AdReportRow>(data['data']);
    }
    if (dataClassName == 'Advertiser') {
      return deserialize<_icstda9z.Advertiser>(data['data']);
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
    if (dataClassName == 'DeviceToken') {
      return deserialize<_iqu8ign5.DeviceToken>(data['data']);
    }
    if (dataClassName == 'QuizAnswer') {
      return deserialize<_ih1qnypb.QuizAnswer>(data['data']);
    }
    if (dataClassName == 'QuizAnswerInput') {
      return deserialize<_ilw6ope9.QuizAnswerInput>(data['data']);
    }
    if (dataClassName == 'ShopCheckout') {
      return deserialize<_ijilqnse.ShopCheckout>(data['data']);
    }
    if (dataClassName == 'ShopOrder') {
      return deserialize<_iebtnvku.ShopOrder>(data['data']);
    }
    if (dataClassName == 'ShopOrderStatus') {
      return deserialize<_ik5inhen.ShopOrderStatus>(data['data']);
    }
    if (dataClassName == 'ShopOrderView') {
      return deserialize<_ibk2dfia.ShopOrderView>(data['data']);
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
    if (dataClassName == 'StaffSummary') {
      return deserialize<_iminry28.StaffSummary>(data['data']);
    }
    if (dataClassName == 'DailyActiveCount') {
      return deserialize<_iphzj4es.DailyActiveCount>(data['data']);
    }
    if (dataClassName == 'DailyActiveMark') {
      return deserialize<_ipxxg0d2.DailyActiveMark>(data['data']);
    }
    if (dataClassName == 'DashboardReport') {
      return deserialize<_igkrtb48.DashboardReport>(data['data']);
    }
    if (dataClassName == 'StatsCount') {
      return deserialize<_iu0qh84b.StatsCount>(data['data']);
    }
    if (dataClassName == 'StatsGroup') {
      return deserialize<_imrurtjq.StatsGroup>(data['data']);
    }
    if (dataClassName == 'StatsReport') {
      return deserialize<_i9vgpxbr.StatsReport>(data['data']);
    }
    if (dataClassName == 'UsageDaily') {
      return deserialize<_i5155cwu.UsageDaily>(data['data']);
    }
    if (dataClassName == 'UsageReport') {
      return deserialize<_ijn07asl.UsageReport>(data['data']);
    }
    if (dataClassName == 'SupportEntry') {
      return deserialize<_iaeay4r3.SupportEntry>(data['data']);
    }
    if (dataClassName == 'SupportMessage') {
      return deserialize<_izh8ly96.SupportMessage>(data['data']);
    }
    if (dataClassName == 'SupportThread') {
      return deserialize<_iq87yxf7.SupportThread>(data['data']);
    }
    if (dataClassName == 'SupportThreadSummary') {
      return deserialize<_idy4xhr0.SupportThreadSummary>(data['data']);
    }
    if (dataClassName == 'UserAdminView') {
      return deserialize<_i06wcc3f.UserAdminView>(data['data']);
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
      case _ia3hy79f.AdCampaign:
        return _ia3hy79f.AdCampaign.t;
      case _icstda9z.Advertiser:
        return _icstda9z.Advertiser.t;
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
      case _ijjfwapm.MediaAsset:
        return _ijjfwapm.MediaAsset.t;
      case _i1iocmvy.MemberProfile:
        return _i1iocmvy.MemberProfile.t;
      case _iqu8ign5.DeviceToken:
        return _iqu8ign5.DeviceToken.t;
      case _ih1qnypb.QuizAnswer:
        return _ih1qnypb.QuizAnswer.t;
      case _iebtnvku.ShopOrder:
        return _iebtnvku.ShopOrder.t;
      case _ig710w64.StaffInvite:
        return _ig710w64.StaffInvite.t;
      case _ihm1xmqc.StaffMember:
        return _ihm1xmqc.StaffMember.t;
      case _iphzj4es.DailyActiveCount:
        return _iphzj4es.DailyActiveCount.t;
      case _ipxxg0d2.DailyActiveMark:
        return _ipxxg0d2.DailyActiveMark.t;
      case _i5155cwu.UsageDaily:
        return _i5155cwu.UsageDaily.t;
      case _izh8ly96.SupportMessage:
        return _izh8ly96.SupportMessage.t;
      case _iq87yxf7.SupportThread:
        return _iq87yxf7.SupportThread.t;
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
