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
import 'dart:typed_data' as _idt;
import 'package:parla_server/src/generated/consent/consent_type.dart'
    as _i1w7mn9k;
import 'package:parla_server/src/generated/quiz/quiz_answer_input.dart'
    as _iak2pevv;
import 'package:parla_server/src/generated/staff/staff_role.dart' as _i21eo3et;
import 'package:parla_server/src/generated/stats/usage_report.dart'
    as _iw4kyb5s;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../account/account_endpoint.dart' as _it9bm8zx;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../consent/consent_endpoint.dart' as _iu5xf735;
import '../content/content_admin_endpoint.dart' as _if39e6se;
import '../content/content_endpoint.dart' as _ib9irne6;
import '../media/media_admin_endpoint.dart' as _inr2v3fa;
import '../products/product_endpoint.dart' as _i6m7gswv;
import '../profile/profile_endpoint.dart' as _i6ky944g;
import '../push/push_endpoint.dart' as _ii21ahkp;
import '../quiz/quiz_endpoint.dart' as _iskif4sw;
import '../routines/care_list_endpoint.dart' as _itrne0fi;
import '../routines/nutrition_endpoint.dart' as _idep3gni;
import '../routines/routine_endpoint.dart' as _ifrtvzp2;
import '../routines/sport_endpoint.dart' as _iv36jnzl;
import '../staff/staff_admin_endpoint.dart' as _i73k1848;
import '../staff/staff_endpoint.dart' as _ig11nxnn;
import '../stats/activity_endpoint.dart' as _ilkw5wl2;
import '../stats/dashboard_admin_endpoint.dart' as _ixbgr6xu;
import '../stats/stats_admin_endpoint.dart' as _ih5y3t9b;
import '../support/support_admin_endpoint.dart' as _imhcxpvz;
import '../support/support_endpoint.dart' as _iqxms0ns;
import '../users/user_admin_endpoint.dart' as _i20m5nkn;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'account': _it9bm8zx.AccountEndpoint()
        ..initialize(
          server,
          'account',
          null,
        ),
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'consent': _iu5xf735.ConsentEndpoint()
        ..initialize(
          server,
          'consent',
          null,
        ),
      'contentAdmin': _if39e6se.ContentAdminEndpoint()
        ..initialize(
          server,
          'contentAdmin',
          null,
        ),
      'content': _ib9irne6.ContentEndpoint()
        ..initialize(
          server,
          'content',
          null,
        ),
      'mediaAdmin': _inr2v3fa.MediaAdminEndpoint()
        ..initialize(
          server,
          'mediaAdmin',
          null,
        ),
      'product': _i6m7gswv.ProductEndpoint()
        ..initialize(
          server,
          'product',
          null,
        ),
      'profile': _i6ky944g.ProfileEndpoint()
        ..initialize(
          server,
          'profile',
          null,
        ),
      'push': _ii21ahkp.PushEndpoint()
        ..initialize(
          server,
          'push',
          null,
        ),
      'quiz': _iskif4sw.QuizEndpoint()
        ..initialize(
          server,
          'quiz',
          null,
        ),
      'careList': _itrne0fi.CareListEndpoint()
        ..initialize(
          server,
          'careList',
          null,
        ),
      'nutrition': _idep3gni.NutritionEndpoint()
        ..initialize(
          server,
          'nutrition',
          null,
        ),
      'routine': _ifrtvzp2.RoutineEndpoint()
        ..initialize(
          server,
          'routine',
          null,
        ),
      'sport': _iv36jnzl.SportEndpoint()
        ..initialize(
          server,
          'sport',
          null,
        ),
      'staffAdmin': _i73k1848.StaffAdminEndpoint()
        ..initialize(
          server,
          'staffAdmin',
          null,
        ),
      'staff': _ig11nxnn.StaffEndpoint()
        ..initialize(
          server,
          'staff',
          null,
        ),
      'activity': _ilkw5wl2.ActivityEndpoint()
        ..initialize(
          server,
          'activity',
          null,
        ),
      'dashboardAdmin': _ixbgr6xu.DashboardAdminEndpoint()
        ..initialize(
          server,
          'dashboardAdmin',
          null,
        ),
      'statsAdmin': _ih5y3t9b.StatsAdminEndpoint()
        ..initialize(
          server,
          'statsAdmin',
          null,
        ),
      'supportAdmin': _imhcxpvz.SupportAdminEndpoint()
        ..initialize(
          server,
          'supportAdmin',
          null,
        ),
      'support': _iqxms0ns.SupportEndpoint()
        ..initialize(
          server,
          'support',
          null,
        ),
      'userAdmin': _i20m5nkn.UserAdminEndpoint()
        ..initialize(
          server,
          'userAdmin',
          null,
        ),
    };
    connectors['account'] = _is.EndpointConnector(
      name: 'account',
      endpoint: endpoints['account']!,
      methodConnectors: {
        'exportMyData': _is.MethodConnector(
          name: 'exportMyData',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['account'] as _it9bm8zx.AccountEndpoint)
                  .exportMyData(session),
        ),
        'deleteAccount': _is.MethodConnector(
          name: 'deleteAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['account'] as _it9bm8zx.AccountEndpoint)
                  .deleteAccount(session),
        ),
      },
    );
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'startOtpLogin': _is.MethodConnector(
          name: 'startOtpLogin',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startOtpLogin(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyOtpLoginCode': _is.MethodConnector(
          name: 'verifyOtpLoginCode',
          params: {
            'otpLoginRequestId': _is.ParameterDescription(
              name: 'otpLoginRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyOtpLoginCode(
                    session,
                    otpLoginRequestId: params['otpLoginRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishOtpLogin': _is.MethodConnector(
          name: 'finishOtpLogin',
          params: {
            'otpLoginToken': _is.ParameterDescription(
              name: 'otpLoginToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishOtpLogin(
                    session,
                    otpLoginToken: params['otpLoginToken'],
                  ),
        ),
        'finishOtpRegistration': _is.MethodConnector(
          name: 'finishOtpRegistration',
          params: {
            'otpLoginToken': _is.ParameterDescription(
              name: 'otpLoginToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishOtpRegistration(
                    session,
                    otpLoginToken: params['otpLoginToken'],
                    password: params['password'],
                  ),
        ),
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['consent'] = _is.EndpointConnector(
      name: 'consent',
      endpoint: endpoints['consent']!,
      methodConnectors: {
        'current': _is.MethodConnector(
          name: 'current',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['consent'] as _iu5xf735.ConsentEndpoint)
                  .current(session),
        ),
        'decide': _is.MethodConnector(
          name: 'decide',
          params: {
            'consentType': _is.ParameterDescription(
              name: 'consentType',
              type: _is.getType<_i1w7mn9k.ConsentType>(),
              nullable: false,
            ),
            'granted': _is.ParameterDescription(
              name: 'granted',
              type: _is.getType<bool>(),
              nullable: false,
            ),
            'textVersion': _is.ParameterDescription(
              name: 'textVersion',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'language': _is.ParameterDescription(
              name: 'language',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'source': _is.ParameterDescription(
              name: 'source',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['consent'] as _iu5xf735.ConsentEndpoint).decide(
                    session,
                    consentType: params['consentType'],
                    granted: params['granted'],
                    textVersion: params['textVersion'],
                    language: params['language'],
                    source: params['source'],
                  ),
        ),
      },
    );
    connectors['contentAdmin'] = _is.EndpointConnector(
      name: 'contentAdmin',
      endpoint: endpoints['contentAdmin']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'kind': _is.ParameterDescription(
              name: 'kind',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['contentAdmin'] as _if39e6se.ContentAdminEndpoint)
                      .list(
                        session,
                        params['kind'],
                      ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'kind': _is.ParameterDescription(
              name: 'kind',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'slug': _is.ParameterDescription(
              name: 'slug',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['contentAdmin'] as _if39e6se.ContentAdminEndpoint)
                      .create(
                        session,
                        params['kind'],
                        params['slug'],
                        params['category'],
                      ),
        ),
        'saveDraft': _is.MethodConnector(
          name: 'saveDraft',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'json': _is.ParameterDescription(
              name: 'json',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'category': _is.ParameterDescription(
              name: 'category',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['contentAdmin'] as _if39e6se.ContentAdminEndpoint)
                      .saveDraft(
                        session,
                        params['id'],
                        params['json'],
                        params['category'],
                      ),
        ),
        'submitForReview': _is.MethodConnector(
          name: 'submitForReview',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['contentAdmin'] as _if39e6se.ContentAdminEndpoint)
                      .submitForReview(
                        session,
                        params['id'],
                      ),
        ),
        'approve': _is.MethodConnector(
          name: 'approve',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['contentAdmin'] as _if39e6se.ContentAdminEndpoint)
                      .approve(
                        session,
                        params['id'],
                      ),
        ),
        'returnToWriter': _is.MethodConnector(
          name: 'returnToWriter',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['contentAdmin'] as _if39e6se.ContentAdminEndpoint)
                      .returnToWriter(
                        session,
                        params['id'],
                        params['note'],
                      ),
        ),
        'recordConsent': _is.MethodConnector(
          name: 'recordConsent',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'reference': _is.ParameterDescription(
              name: 'reference',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['contentAdmin'] as _if39e6se.ContentAdminEndpoint)
                      .recordConsent(
                        session,
                        params['id'],
                        params['reference'],
                      ),
        ),
        'publish': _is.MethodConnector(
          name: 'publish',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['contentAdmin'] as _if39e6se.ContentAdminEndpoint)
                      .publish(
                        session,
                        params['id'],
                      ),
        ),
        'unpublish': _is.MethodConnector(
          name: 'unpublish',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['contentAdmin'] as _if39e6se.ContentAdminEndpoint)
                      .unpublish(
                        session,
                        params['id'],
                      ),
        ),
        'importSheet': _is.MethodConnector(
          name: 'importSheet',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['contentAdmin'] as _if39e6se.ContentAdminEndpoint)
                      .importSheet(session),
        ),
        'publishImported': _is.MethodConnector(
          name: 'publishImported',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['contentAdmin'] as _if39e6se.ContentAdminEndpoint)
                      .publishImported(session),
        ),
        'setHidden': _is.MethodConnector(
          name: 'setHidden',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'hidden': _is.ParameterDescription(
              name: 'hidden',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['contentAdmin'] as _if39e6se.ContentAdminEndpoint)
                      .setHidden(
                        session,
                        params['id'],
                        params['hidden'],
                      ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['contentAdmin'] as _if39e6se.ContentAdminEndpoint)
                      .delete(
                        session,
                        params['id'],
                      ),
        ),
      },
    );
    connectors['content'] = _is.EndpointConnector(
      name: 'content',
      endpoint: endpoints['content']!,
      methodConnectors: {
        'published': _is.MethodConnector(
          name: 'published',
          params: {
            'kind': _is.ParameterDescription(
              name: 'kind',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['content'] as _ib9irne6.ContentEndpoint).published(
                    session,
                    params['kind'],
                  ),
        ),
      },
    );
    connectors['mediaAdmin'] = _is.EndpointConnector(
      name: 'mediaAdmin',
      endpoint: endpoints['mediaAdmin']!,
      methodConnectors: {
        'upload': _is.MethodConnector(
          name: 'upload',
          params: {
            'data': _is.ParameterDescription(
              name: 'data',
              type: _is.getType<_idt.ByteData>(),
              nullable: false,
            ),
            'license': _is.ParameterDescription(
              name: 'license',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'source': _is.ParameterDescription(
              name: 'source',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'altJson': _is.ParameterDescription(
              name: 'altJson',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mediaAdmin'] as _inr2v3fa.MediaAdminEndpoint)
                      .upload(
                        session,
                        params['data'],
                        params['license'],
                        params['source'],
                        params['altJson'],
                      ),
        ),
        'list': _is.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mediaAdmin'] as _inr2v3fa.MediaAdminEndpoint)
                      .list(session),
        ),
        'preview': _is.MethodConnector(
          name: 'preview',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mediaAdmin'] as _inr2v3fa.MediaAdminEndpoint)
                      .preview(
                        session,
                        params['id'],
                      ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'license': _is.ParameterDescription(
              name: 'license',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'source': _is.ParameterDescription(
              name: 'source',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'altJson': _is.ParameterDescription(
              name: 'altJson',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mediaAdmin'] as _inr2v3fa.MediaAdminEndpoint)
                      .update(
                        session,
                        params['id'],
                        params['license'],
                        params['source'],
                        params['altJson'],
                      ),
        ),
        'delete': _is.MethodConnector(
          name: 'delete',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['mediaAdmin'] as _inr2v3fa.MediaAdminEndpoint)
                      .delete(
                        session,
                        params['id'],
                      ),
        ),
      },
    );
    connectors['product'] = _is.EndpointConnector(
      name: 'product',
      endpoint: endpoints['product']!,
      methodConnectors: {
        'search': _is.MethodConnector(
          name: 'search',
          params: {
            'query': _is.ParameterDescription(
              name: 'query',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i6m7gswv.ProductEndpoint).search(
                    session,
                    params['query'],
                  ),
        ),
      },
    );
    connectors['profile'] = _is.EndpointConnector(
      name: 'profile',
      endpoint: endpoints['profile']!,
      methodConnectors: {
        'me': _is.MethodConnector(
          name: 'me',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profile'] as _i6ky944g.ProfileEndpoint).me(
                session,
              ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'birthYear': _is.ParameterDescription(
              name: 'birthYear',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'birthdayPassedThisYear': _is.ParameterDescription(
              name: 'birthdayPassedThisYear',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
            'countryCode': _is.ParameterDescription(
              name: 'countryCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'language': _is.ParameterDescription(
              name: 'language',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['profile'] as _i6ky944g.ProfileEndpoint).create(
                    session,
                    birthYear: params['birthYear'],
                    birthdayPassedThisYear: params['birthdayPassedThisYear'],
                    countryCode: params['countryCode'],
                    language: params['language'],
                  ),
        ),
      },
    );
    connectors['push'] = _is.EndpointConnector(
      name: 'push',
      endpoint: endpoints['push']!,
      methodConnectors: {
        'register': _is.MethodConnector(
          name: 'register',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'platform': _is.ParameterDescription(
              name: 'platform',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['push'] as _ii21ahkp.PushEndpoint).register(
                session,
                params['token'],
                params['platform'],
              ),
        ),
        'unregister': _is.MethodConnector(
          name: 'unregister',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['push'] as _ii21ahkp.PushEndpoint).unregister(
                    session,
                    params['token'],
                  ),
        ),
      },
    );
    connectors['quiz'] = _is.EndpointConnector(
      name: 'quiz',
      endpoint: endpoints['quiz']!,
      methodConnectors: {
        'saveAnswers': _is.MethodConnector(
          name: 'saveAnswers',
          params: {
            'answers': _is.ParameterDescription(
              name: 'answers',
              type: _is.getType<List<_iak2pevv.QuizAnswerInput>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['quiz'] as _iskif4sw.QuizEndpoint).saveAnswers(
                    session,
                    params['answers'],
                  ),
        ),
        'myAnswers': _is.MethodConnector(
          name: 'myAnswers',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['quiz'] as _iskif4sw.QuizEndpoint)
                  .myAnswers(session),
        ),
      },
    );
    connectors['careList'] = _is.EndpointConnector(
      name: 'careList',
      endpoint: endpoints['careList']!,
      methodConnectors: {
        'myCareList': _is.MethodConnector(
          name: 'myCareList',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['careList'] as _itrne0fi.CareListEndpoint)
                  .myCareList(session),
        ),
        'saveCareList': _is.MethodConnector(
          name: 'saveCareList',
          params: {
            'json': _is.ParameterDescription(
              name: 'json',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['careList'] as _itrne0fi.CareListEndpoint)
                  .saveCareList(
                    session,
                    params['json'],
                  ),
        ),
      },
    );
    connectors['nutrition'] = _is.EndpointConnector(
      name: 'nutrition',
      endpoint: endpoints['nutrition']!,
      methodConnectors: {
        'myNutrition': _is.MethodConnector(
          name: 'myNutrition',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['nutrition'] as _idep3gni.NutritionEndpoint)
                  .myNutrition(session),
        ),
        'saveNutrition': _is.MethodConnector(
          name: 'saveNutrition',
          params: {
            'json': _is.ParameterDescription(
              name: 'json',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['nutrition'] as _idep3gni.NutritionEndpoint)
                  .saveNutrition(
                    session,
                    params['json'],
                  ),
        ),
      },
    );
    connectors['routine'] = _is.EndpointConnector(
      name: 'routine',
      endpoint: endpoints['routine']!,
      methodConnectors: {
        'myRoutines': _is.MethodConnector(
          name: 'myRoutines',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['routine'] as _ifrtvzp2.RoutineEndpoint)
                  .myRoutines(session),
        ),
        'saveRoutines': _is.MethodConnector(
          name: 'saveRoutines',
          params: {
            'json': _is.ParameterDescription(
              name: 'json',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['routine'] as _ifrtvzp2.RoutineEndpoint)
                  .saveRoutines(
                    session,
                    params['json'],
                  ),
        ),
      },
    );
    connectors['sport'] = _is.EndpointConnector(
      name: 'sport',
      endpoint: endpoints['sport']!,
      methodConnectors: {
        'mySport': _is.MethodConnector(
          name: 'mySport',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['sport'] as _iv36jnzl.SportEndpoint)
                  .mySport(session),
        ),
        'saveSport': _is.MethodConnector(
          name: 'saveSport',
          params: {
            'json': _is.ParameterDescription(
              name: 'json',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['sport'] as _iv36jnzl.SportEndpoint).saveSport(
                    session,
                    params['json'],
                  ),
        ),
      },
    );
    connectors['staffAdmin'] = _is.EndpointConnector(
      name: 'staffAdmin',
      endpoint: endpoints['staffAdmin']!,
      methodConnectors: {
        'listStaff': _is.MethodConnector(
          name: 'listStaff',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['staffAdmin'] as _i73k1848.StaffAdminEndpoint)
                      .listStaff(session),
        ),
        'listInvites': _is.MethodConnector(
          name: 'listInvites',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['staffAdmin'] as _i73k1848.StaffAdminEndpoint)
                      .listInvites(session),
        ),
        'invite': _is.MethodConnector(
          name: 'invite',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'role': _is.ParameterDescription(
              name: 'role',
              type: _is.getType<_i21eo3et.StaffRole>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['staffAdmin'] as _i73k1848.StaffAdminEndpoint)
                      .invite(
                        session,
                        params['email'],
                        params['role'],
                      ),
        ),
        'revokeInvite': _is.MethodConnector(
          name: 'revokeInvite',
          params: {
            'inviteId': _is.ParameterDescription(
              name: 'inviteId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['staffAdmin'] as _i73k1848.StaffAdminEndpoint)
                      .revokeInvite(
                        session,
                        params['inviteId'],
                      ),
        ),
        'setRole': _is.MethodConnector(
          name: 'setRole',
          params: {
            'authUserId': _is.ParameterDescription(
              name: 'authUserId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'role': _is.ParameterDescription(
              name: 'role',
              type: _is.getType<_i21eo3et.StaffRole>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['staffAdmin'] as _i73k1848.StaffAdminEndpoint)
                      .setRole(
                        session,
                        params['authUserId'],
                        params['role'],
                      ),
        ),
        'setActive': _is.MethodConnector(
          name: 'setActive',
          params: {
            'authUserId': _is.ParameterDescription(
              name: 'authUserId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'active': _is.ParameterDescription(
              name: 'active',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['staffAdmin'] as _i73k1848.StaffAdminEndpoint)
                      .setActive(
                        session,
                        params['authUserId'],
                        params['active'],
                      ),
        ),
      },
    );
    connectors['staff'] = _is.EndpointConnector(
      name: 'staff',
      endpoint: endpoints['staff']!,
      methodConnectors: {
        'me': _is.MethodConnector(
          name: 'me',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['staff'] as _ig11nxnn.StaffEndpoint).me(session),
        ),
        'acceptInvite': _is.MethodConnector(
          name: 'acceptInvite',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['staff'] as _ig11nxnn.StaffEndpoint).acceptInvite(
                    session,
                    params['code'],
                  ),
        ),
        'claimFirstAdmin': _is.MethodConnector(
          name: 'claimFirstAdmin',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['staff'] as _ig11nxnn.StaffEndpoint)
                  .claimFirstAdmin(session),
        ),
      },
    );
    connectors['activity'] = _is.EndpointConnector(
      name: 'activity',
      endpoint: endpoints['activity']!,
      methodConnectors: {
        'markActive': _is.MethodConnector(
          name: 'markActive',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['activity'] as _ilkw5wl2.ActivityEndpoint)
                  .markActive(session),
        ),
        'report': _is.MethodConnector(
          name: 'report',
          params: {
            'report': _is.ParameterDescription(
              name: 'report',
              type: _is.getType<_iw4kyb5s.UsageReport>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['activity'] as _ilkw5wl2.ActivityEndpoint).report(
                    session,
                    params['report'],
                  ),
        ),
      },
    );
    connectors['dashboardAdmin'] = _is.EndpointConnector(
      name: 'dashboardAdmin',
      endpoint: endpoints['dashboardAdmin']!,
      methodConnectors: {
        'report': _is.MethodConnector(
          name: 'report',
          params: {
            'days': _is.ParameterDescription(
              name: 'days',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['dashboardAdmin']
                          as _ixbgr6xu.DashboardAdminEndpoint)
                      .report(
                        session,
                        params['days'],
                      ),
        ),
      },
    );
    connectors['statsAdmin'] = _is.EndpointConnector(
      name: 'statsAdmin',
      endpoint: endpoints['statsAdmin']!,
      methodConnectors: {
        'report': _is.MethodConnector(
          name: 'report',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['statsAdmin'] as _ih5y3t9b.StatsAdminEndpoint)
                      .report(session),
        ),
      },
    );
    connectors['supportAdmin'] = _is.EndpointConnector(
      name: 'supportAdmin',
      endpoint: endpoints['supportAdmin']!,
      methodConnectors: {
        'threads': _is.MethodConnector(
          name: 'threads',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['supportAdmin'] as _imhcxpvz.SupportAdminEndpoint)
                      .threads(session),
        ),
        'open': _is.MethodConnector(
          name: 'open',
          params: {
            'threadId': _is.ParameterDescription(
              name: 'threadId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['supportAdmin'] as _imhcxpvz.SupportAdminEndpoint)
                      .open(
                        session,
                        params['threadId'],
                      ),
        ),
        'reply': _is.MethodConnector(
          name: 'reply',
          params: {
            'threadId': _is.ParameterDescription(
              name: 'threadId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'text': _is.ParameterDescription(
              name: 'text',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['supportAdmin'] as _imhcxpvz.SupportAdminEndpoint)
                      .reply(
                        session,
                        params['threadId'],
                        params['text'],
                      ),
        ),
        'close': _is.MethodConnector(
          name: 'close',
          params: {
            'threadId': _is.ParameterDescription(
              name: 'threadId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['supportAdmin'] as _imhcxpvz.SupportAdminEndpoint)
                      .close(
                        session,
                        params['threadId'],
                      ),
        ),
      },
    );
    connectors['support'] = _is.EndpointConnector(
      name: 'support',
      endpoint: endpoints['support']!,
      methodConnectors: {
        'myMessages': _is.MethodConnector(
          name: 'myMessages',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['support'] as _iqxms0ns.SupportEndpoint)
                  .myMessages(session),
        ),
        'hasUnreadReply': _is.MethodConnector(
          name: 'hasUnreadReply',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['support'] as _iqxms0ns.SupportEndpoint)
                  .hasUnreadReply(session),
        ),
        'send': _is.MethodConnector(
          name: 'send',
          params: {
            'text': _is.ParameterDescription(
              name: 'text',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['support'] as _iqxms0ns.SupportEndpoint).send(
                    session,
                    params['text'],
                  ),
        ),
      },
    );
    connectors['userAdmin'] = _is.EndpointConnector(
      name: 'userAdmin',
      endpoint: endpoints['userAdmin']!,
      methodConnectors: {
        'find': _is.MethodConnector(
          name: 'find',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['userAdmin'] as _i20m5nkn.UserAdminEndpoint).find(
                    session,
                    params['email'],
                  ),
        ),
        'setBlocked': _is.MethodConnector(
          name: 'setBlocked',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'blocked': _is.ParameterDescription(
              name: 'blocked',
              type: _is.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userAdmin'] as _i20m5nkn.UserAdminEndpoint)
                  .setBlocked(
                    session,
                    params['userId'],
                    params['blocked'],
                  ),
        ),
        'deleteOnRequest': _is.MethodConnector(
          name: 'deleteOnRequest',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'confirmEmail': _is.ParameterDescription(
              name: 'confirmEmail',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userAdmin'] as _i20m5nkn.UserAdminEndpoint)
                  .deleteOnRequest(
                    session,
                    params['userId'],
                    params['confirmEmail'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }
}
