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
import 'dart:async' as _ida;
import 'package:http/http.dart' as _i85jenna;
import 'package:parla_client/src/protocol/consent/consent_state.dart'
    as _iflgmsvc;
import 'package:parla_client/src/protocol/consent/consent_type.dart'
    as _ibhb6xek;
import 'package:parla_client/src/protocol/content/content_admin_item.dart'
    as _i9q5wd3k;
import 'package:parla_client/src/protocol/content/public_content.dart'
    as _iryaqqq7;
import 'package:parla_client/src/protocol/products/product_summary.dart'
    as _isvy2zc1;
import 'package:parla_client/src/protocol/profile/member_profile.dart'
    as _isrsmpwu;
import 'package:parla_client/src/protocol/quiz/quiz_answer_input.dart'
    as _ikoicjb8;
import 'package:parla_client/src/protocol/staff/staff_invite_summary.dart'
    as _ivj2ydpk;
import 'package:parla_client/src/protocol/staff/staff_me.dart' as _i7hd0p59;
import 'package:parla_client/src/protocol/staff/staff_role.dart' as _ibknl9pl;
import 'package:parla_client/src/protocol/staff/staff_summary.dart'
    as _i48vujj3;
import 'package:parla_client/src/protocol/staff/totp_enrollment.dart'
    as _i8ipqfqe;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// The user's rights over their own data (privacy centre, M-27 to M-33).
/// {@category Endpoint}
class EndpointAccount extends _isc.EndpointRef {
  EndpointAccount(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'account';

  /// Everything Parla stores about the caller, as JSON (GDPR Art. 15 and 20,
  /// checklist EXP-1). Health answers are decrypted for the export.
  ///
  /// The file is built on request and returned directly; it is never stored
  /// on the server.
  _ida.Future<String> exportMyData() => caller.callServerEndpoint<String>(
    'account',
    'exportMyData',
    {},
  );

  /// Deletes the caller's account (checklist DEL-1, DEL-2).
  ///
  /// In one transaction: health data, own routines, care list, sport
  /// document and their key
  /// (crypto-shredding), quiz
  /// answers, profile and the sign-in account with its sessions and tokens
  /// are deleted. Consent records and audit rows are kept as proof but
  /// their user id is replaced by a pseudonym.
  _ida.Future<void> deleteAccount() => caller.callServerEndpoint<void>(
    'account',
    'deleteAccount',
    {},
  );
}

/// By extending [EmailOtpIdpBaseEndpoint], the email identity provider
/// endpoints, including the passwordless sign-in with one-time passwords, are
/// made available on the server and enable the corresponding sign-in widget on
/// the client.
///
/// Extend [EmailIdpBaseEndpoint] instead for the password based sign-in only.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailOtpIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Starts a passwordless login by sending a one-time password to [email].
  ///
  /// The code is sent whether or not an account is registered for the email.
  /// If none is, verifying the code lets the user create a new account.
  ///
  /// Always returns a login request ID, which must be passed to
  /// [verifyOtpLoginCode] together with the one-time password.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the email is
  ///   not valid.
  /// - [EmailAccountRequestExceptionReason.tooManyAttempts] if too many
  ///   one-time passwords have been requested for the email.
  @override
  _ida.Future<_isc.UuidValue> startOtpLogin({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startOtpLogin',
        {'email': email},
      );

  /// Verifies a one-time password and returns a token to complete the login.
  ///
  /// If [EmailAccountOtpVerificationResult.accountExists] is `true`, pass the
  /// token to [finishOtpLogin] to sign in. Otherwise, have the user accept the
  /// terms (and optionally set a password if
  /// [EmailAccountOtpVerificationResult.allowPassword] is `true`) and pass it
  /// to [finishOtpRegistration] to create the account.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the login request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts to verify the code.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists for
  ///   the given [otpLoginRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<_iaic.EmailAccountOtpVerificationResult> verifyOtpLoginCode({
    required _isc.UuidValue otpLoginRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<_iaic.EmailAccountOtpVerificationResult>(
    'emailIdp',
    'verifyOtpLoginCode',
    {
      'otpLoginRequestId': otpLoginRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a passwordless login for an existing account and returns a new
  /// session.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the login request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [otpLoginToken] is
  ///   invalid or no account exists for the email.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> finishOtpLogin({
    required String otpLoginToken,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishOtpLogin',
    {'otpLoginToken': otpLoginToken},
  );

  /// Completes a passwordless login for an email without an account, by
  /// creating a new auth user with a profile and attaching the verified email
  /// to it.
  ///
  /// Must only be called after the user accepted the terms. The [password] is
  /// optional, and may only be set if
  /// [EmailAccountOtpVerificationResult.allowPassword] was `true`.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the login request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if a password is
  ///   given but not allowed, or it does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [otpLoginToken] is
  ///   invalid or an account already exists for the email.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishOtpRegistration({
    required String otpLoginToken,
    String? password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishOtpRegistration',
    {
      'otpLoginToken': otpLoginToken,
      'password': password,
    },
  );

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// Grants and withdraws the three consents (screens M-08, M-28).
///
/// Every decision is a new [ConsentRecord] row; nothing is updated in place.
/// {@category Endpoint}
class EndpointConsent extends _isc.EndpointRef {
  EndpointConsent(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'consent';

  /// The latest decision for every consent type. Defaults to not granted
  /// (checklist CON-1).
  _ida.Future<List<_iflgmsvc.ConsentState>> current() =>
      caller.callServerEndpoint<List<_iflgmsvc.ConsentState>>(
        'consent',
        'current',
        {},
      );

  /// Records a decision for [consentType] about the text [textVersion] that
  /// the user saw in [language].
  ///
  /// Granting is only possible for the current text version. Withdrawing is
  /// always possible.
  _ida.Future<_iflgmsvc.ConsentState> decide({
    required _ibhb6xek.ConsentType consentType,
    required bool granted,
    required String textVersion,
    required String language,
    required String source,
  }) => caller.callServerEndpoint<_iflgmsvc.ConsentState>(
    'consent',
    'decide',
    {
      'consentType': consentType,
      'granted': granted,
      'textVersion': textVersion,
      'language': language,
      'source': source,
    },
  );
}

/// Writing, reviewing and publishing content in the admin panel.
///
/// Flow: an editor saves a draft and sends it for review; an expert
/// approves it or returns it with a note; an editor or admin publishes the
/// approved copy. Expert profiles need no review but need the expert's
/// written consent recorded by an admin. Every step is audited.
/// {@category Endpoint}
class EndpointContentAdmin extends _isc.EndpointRef {
  EndpointContentAdmin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'contentAdmin';

  _ida.Future<List<_i9q5wd3k.ContentAdminItem>> list(String kind) =>
      caller.callServerEndpoint<List<_i9q5wd3k.ContentAdminItem>>(
        'contentAdmin',
        'list',
        {'kind': kind},
      );

  _ida.Future<_i9q5wd3k.ContentAdminItem> create(
    String kind,
    String slug,
    String category,
  ) => caller.callServerEndpoint<_i9q5wd3k.ContentAdminItem>(
    'contentAdmin',
    'create',
    {
      'kind': kind,
      'slug': slug,
      'category': category,
    },
  );

  /// Saves the working copy. Changing an item in review or approved sends
  /// it back to draft: the next version needs its own review.
  _ida.Future<_i9q5wd3k.ContentAdminItem> saveDraft(
    int id,
    String json,
    String category,
  ) => caller.callServerEndpoint<_i9q5wd3k.ContentAdminItem>(
    'contentAdmin',
    'saveDraft',
    {
      'id': id,
      'json': json,
      'category': category,
    },
  );

  _ida.Future<_i9q5wd3k.ContentAdminItem> submitForReview(int id) =>
      caller.callServerEndpoint<_i9q5wd3k.ContentAdminItem>(
        'contentAdmin',
        'submitForReview',
        {'id': id},
      );

  /// An expert approves the working copy as it is now.
  _ida.Future<_i9q5wd3k.ContentAdminItem> approve(int id) =>
      caller.callServerEndpoint<_i9q5wd3k.ContentAdminItem>(
        'contentAdmin',
        'approve',
        {'id': id},
      );

  /// An expert sends it back to the writer with a note.
  _ida.Future<_i9q5wd3k.ContentAdminItem> returnToWriter(
    int id,
    String note,
  ) => caller.callServerEndpoint<_i9q5wd3k.ContentAdminItem>(
    'contentAdmin',
    'returnToWriter',
    {
      'id': id,
      'note': note,
    },
  );

  /// Records that the expert gave written consent to be listed, with a
  /// reference to where the signed document is kept.
  _ida.Future<_i9q5wd3k.ContentAdminItem> recordConsent(
    int id,
    String reference,
  ) => caller.callServerEndpoint<_i9q5wd3k.ContentAdminItem>(
    'contentAdmin',
    'recordConsent',
    {
      'id': id,
      'reference': reference,
    },
  );

  /// Makes the working copy live. Articles and recipes must be approved by
  /// an expert; expert profiles need the recorded consent.
  _ida.Future<_i9q5wd3k.ContentAdminItem> publish(int id) =>
      caller.callServerEndpoint<_i9q5wd3k.ContentAdminItem>(
        'contentAdmin',
        'publish',
        {'id': id},
      );

  _ida.Future<_i9q5wd3k.ContentAdminItem> unpublish(int id) =>
      caller.callServerEndpoint<_i9q5wd3k.ContentAdminItem>(
        'contentAdmin',
        'unpublish',
        {'id': id},
      );

  /// Deletes an item that is not live (admins only).
  _ida.Future<void> delete(int id) => caller.callServerEndpoint<void>(
    'contentAdmin',
    'delete',
    {'id': id},
  );
}

/// Published content for the app. No sign-in needed and nothing personal:
/// articles, recipes and expert profiles the team has published.
/// {@category Endpoint}
class EndpointContent extends _isc.EndpointRef {
  EndpointContent(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'content';

  /// Published items of [kind] (a ContentKind name), newest first.
  _ida.Future<List<_iryaqqq7.PublicContent>> published(String kind) =>
      caller.callServerEndpoint<List<_iryaqqq7.PublicContent>>(
        'content',
        'published',
        {'kind': kind},
      );
}

/// Product search (M-20). Signed-in users only for now, which also limits
/// load on Open Beauty Facts; guests get it with the guest flow.
/// {@category Endpoint}
class EndpointProduct extends _isc.EndpointRef {
  EndpointProduct(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'product';

  /// Products whose name or brand matches [query] (2 to 80 characters).
  _ida.Future<List<_isvy2zc1.ProductSummary>> search(String query) =>
      caller.callServerEndpoint<List<_isvy2zc1.ProductSummary>>(
        'product',
        'search',
        {'query': query},
      );
}

/// Creates and reads the signed-in user's core profile (screens M-03, M-07).
/// {@category Endpoint}
class EndpointProfile extends _isc.EndpointRef {
  EndpointProfile(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'profile';

  /// The caller's profile, or `null` before onboarding.
  _ida.Future<_isrsmpwu.MemberProfile?> me() =>
      caller.callServerEndpoint<_isrsmpwu.MemberProfile?>(
        'profile',
        'me',
        {},
      );

  /// Creates the profile once, after the age gate and country choice.
  ///
  /// The age rule is checked again here: the app's check can be bypassed.
  _ida.Future<_isrsmpwu.MemberProfile> create({
    required int birthYear,
    bool? birthdayPassedThisYear,
    required String countryCode,
    required String language,
  }) => caller.callServerEndpoint<_isrsmpwu.MemberProfile>(
    'profile',
    'create',
    {
      'birthYear': birthYear,
      'birthdayPassedThisYear': birthdayPassedThisYear,
      'countryCode': countryCode,
      'language': language,
    },
  );
}

/// Saves and returns the user's onboarding quiz answers (M-09 to M-13).
///
/// Non-health answers go to `quiz_answer`; health answers are encrypted in
/// `health_record` and only accepted with the health consent (CON-2).
/// Warning-sign answers are refused outright: they never leave the device.
/// {@category Endpoint}
class EndpointQuiz extends _isc.EndpointRef {
  EndpointQuiz(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'quiz';

  /// Saves [answers], replacing earlier answers to the same questions.
  _ida.Future<void> saveAnswers(List<_ikoicjb8.QuizAnswerInput> answers) =>
      caller.callServerEndpoint<void>(
        'quiz',
        'saveAnswers',
        {'answers': answers},
      );

  /// The user's saved answers. Health answers are included only while the
  /// health consent is granted.
  _ida.Future<List<_ikoicjb8.QuizAnswerInput>> myAnswers() =>
      caller.callServerEndpoint<List<_ikoicjb8.QuizAnswerInput>>(
        'quiz',
        'myAnswers',
        {},
      );
}

/// The user's product preferences, recently checked products and shopping
/// list ("Yoxla"), kept encrypted in `care_list_record` and only with a
/// health consent whose text covers them ([healthVersionsCoveringCareList]):
/// the shopping list is free text that may hold health details. The server
/// never reads the content beyond checking it against [CareListRules].
///
/// Saves are not written to the audit log, like own routines: the user
/// changes her own data often and nobody else can read it.
/// {@category Endpoint}
class EndpointCareList extends _isc.EndpointRef {
  EndpointCareList(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'careList';

  /// The stored care list as JSON, or `null` when there is none or the
  /// covering health consent is not granted.
  _ida.Future<String?> myCareList() => caller.callServerEndpoint<String?>(
    'careList',
    'myCareList',
    {},
  );

  /// Replaces the stored care list with [json].
  _ida.Future<void> saveCareList(String json) =>
      caller.callServerEndpoint<void>(
        'careList',
        'saveCareList',
        {'json': json},
      );
}

/// The user's daily plate entries (which food groups each day; no
/// calories or amounts), kept encrypted in `nutrition_record` and only with
/// a health consent whose text covers them
/// ([healthVersionsCoveringNutrition]).
///
/// Saves are not written to the audit log, like own routines.
/// {@category Endpoint}
class EndpointNutrition extends _isc.EndpointRef {
  EndpointNutrition(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'nutrition';

  /// The stored plate entries as JSON, or `null` when there are none or
  /// the covering health consent is not granted.
  _ida.Future<String?> myNutrition() => caller.callServerEndpoint<String?>(
    'nutrition',
    'myNutrition',
    {},
  );

  /// Replaces the stored plate entries with [json].
  _ida.Future<void> saveNutrition(String json) =>
      caller.callServerEndpoint<void>(
        'nutrition',
        'saveNutrition',
        {'json': json},
      );
}

/// The user's own routines and their daily ticks, kept encrypted in
/// `custom_routine_record` and only with a health consent whose text covers
/// them ([healthVersionsCoveringOwnRoutines]): the names and steps are free
/// text that may hold health details. The server never reads
/// the content beyond checking it against [CustomRoutineRules].
///
/// Saves are not written to the audit log: the user changes her own data
/// many times a day (every tick), and nobody else can read it.
/// {@category Endpoint}
class EndpointRoutine extends _isc.EndpointRef {
  EndpointRoutine(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'routine';

  /// The stored routines as JSON, or `null` when there are none or the
  /// health consent is not granted.
  _ida.Future<String?> myRoutines() => caller.callServerEndpoint<String?>(
    'routine',
    'myRoutines',
    {},
  );

  /// Replaces the stored routines with [json]. Ticks older than
  /// [CustomRoutineRules.keepTickDays] are dropped.
  _ida.Future<void> saveRoutines(String json) =>
      caller.callServerEndpoint<void>(
        'routine',
        'saveRoutines',
        {'json': json},
      );
}

/// The user's sport answers (goals, areas, pregnancy, injuries, a doctor's
/// limit) and the log of finished workouts, kept encrypted in
/// `sport_record` and only with a health consent whose text covers them
/// ([healthVersionsCoveringSport]). The server never reads the content
/// beyond checking it against [SportRules].
///
/// Saves are not written to the audit log, like own routines: the user
/// changes her own data often and nobody else can read it.
/// {@category Endpoint}
class EndpointSport extends _isc.EndpointRef {
  EndpointSport(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'sport';

  /// The stored sport document as JSON, or `null` when there is none or
  /// the covering health consent is not granted.
  _ida.Future<String?> mySport() => caller.callServerEndpoint<String?>(
    'sport',
    'mySport',
    {},
  );

  /// Replaces the stored sport document with [json]. Log entries older
  /// than [SportRules.keepLogDays] are the app's to drop; the size limit
  /// keeps the document small.
  _ida.Future<void> saveSport(String json) => caller.callServerEndpoint<void>(
    'sport',
    'saveSport',
    {'json': json},
  );
}

/// Staff accounts, for admins only (second factor required).
/// {@category Endpoint}
class EndpointStaffAdmin extends _isc.EndpointRef {
  EndpointStaffAdmin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'staffAdmin';

  _ida.Future<List<_i48vujj3.StaffSummary>> listStaff() =>
      caller.callServerEndpoint<List<_i48vujj3.StaffSummary>>(
        'staffAdmin',
        'listStaff',
        {},
      );

  _ida.Future<List<_ivj2ydpk.StaffInviteSummary>> listInvites() =>
      caller.callServerEndpoint<List<_ivj2ydpk.StaffInviteSummary>>(
        'staffAdmin',
        'listInvites',
        {},
      );

  /// Emails a one-time code that lets [email] join with [role].
  _ida.Future<void> invite(
    String email,
    _ibknl9pl.StaffRole role,
  ) => caller.callServerEndpoint<void>(
    'staffAdmin',
    'invite',
    {
      'email': email,
      'role': role,
    },
  );

  _ida.Future<void> revokeInvite(int inviteId) =>
      caller.callServerEndpoint<void>(
        'staffAdmin',
        'revokeInvite',
        {'inviteId': inviteId},
      );

  _ida.Future<void> setRole(
    _isc.UuidValue authUserId,
    _ibknl9pl.StaffRole role,
  ) => caller.callServerEndpoint<void>(
    'staffAdmin',
    'setRole',
    {
      'authUserId': authUserId,
      'role': role,
    },
  );

  _ida.Future<void> setActive(
    _isc.UuidValue authUserId,
    bool active,
  ) => caller.callServerEndpoint<void>(
    'staffAdmin',
    'setActive',
    {
      'authUserId': authUserId,
      'active': active,
    },
  );

  /// Clears the authenticator of a staff member who lost their phone; they
  /// set it up again at the next sign-in.
  _ida.Future<void> resetTotp(_isc.UuidValue authUserId) =>
      caller.callServerEndpoint<void>(
        'staffAdmin',
        'resetTotp',
        {'authUserId': authUserId},
      );
}

/// Joining the admin panel and the second factor. Any signed-in account
/// can call these; they only ever act on the caller's own staff row.
/// {@category Endpoint}
class EndpointStaff extends _isc.EndpointRef {
  EndpointStaff(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'staff';

  /// The caller's staff state, or `null` for someone who is not staff.
  _ida.Future<_i7hd0p59.StaffMe?> me() =>
      caller.callServerEndpoint<_i7hd0p59.StaffMe?>(
        'staff',
        'me',
        {},
      );

  /// Turns an invitation for the caller's email into a staff role.
  _ida.Future<_i7hd0p59.StaffMe> acceptInvite(String code) =>
      caller.callServerEndpoint<_i7hd0p59.StaffMe>(
        'staff',
        'acceptInvite',
        {'code': code},
      );

  /// The first admin: allowed only while there is no staff at all, and
  /// only for the email in the `staffBootstrapEmail` password.
  _ida.Future<_i7hd0p59.StaffMe> claimFirstAdmin() =>
      caller.callServerEndpoint<_i7hd0p59.StaffMe>(
        'staff',
        'claimFirstAdmin',
        {},
      );

  /// Starts setting up the authenticator app. Replaces an unconfirmed
  /// secret; refused once a secret is confirmed (an admin resets it).
  _ida.Future<_i8ipqfqe.TotpEnrollment> startTotp() =>
      caller.callServerEndpoint<_i8ipqfqe.TotpEnrollment>(
        'staff',
        'startTotp',
        {},
      );

  /// Confirms the authenticator app with a first code and verifies this
  /// sign-in session.
  _ida.Future<_i7hd0p59.StaffMe> confirmTotp(String code) =>
      caller.callServerEndpoint<_i7hd0p59.StaffMe>(
        'staff',
        'confirmTotp',
        {'code': code},
      );

  /// The second factor for this sign-in session.
  _ida.Future<_i7hd0p59.StaffMe> verifyTotp(String code) =>
      caller.callServerEndpoint<_i7hd0p59.StaffMe>(
        'staff',
        'verifyTotp',
        {'code': code},
      );

  /// Ends the second-factor check of this sign-in session.
  _ida.Future<void> endSession() => caller.callServerEndpoint<void>(
    'staff',
    'endSession',
    {},
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    account = EndpointAccount(this);
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    consent = EndpointConsent(this);
    contentAdmin = EndpointContentAdmin(this);
    content = EndpointContent(this);
    product = EndpointProduct(this);
    profile = EndpointProfile(this);
    quiz = EndpointQuiz(this);
    careList = EndpointCareList(this);
    nutrition = EndpointNutrition(this);
    routine = EndpointRoutine(this);
    sport = EndpointSport(this);
    staffAdmin = EndpointStaffAdmin(this);
    staff = EndpointStaff(this);
    modules = Modules(this);
  }

  late final EndpointAccount account;

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointConsent consent;

  late final EndpointContentAdmin contentAdmin;

  late final EndpointContent content;

  late final EndpointProduct product;

  late final EndpointProfile profile;

  late final EndpointQuiz quiz;

  late final EndpointCareList careList;

  late final EndpointNutrition nutrition;

  late final EndpointRoutine routine;

  late final EndpointSport sport;

  late final EndpointStaffAdmin staffAdmin;

  late final EndpointStaff staff;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'account': account,
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'consent': consent,
    'contentAdmin': contentAdmin,
    'content': content,
    'product': product,
    'profile': profile,
    'quiz': quiz,
    'careList': careList,
    'nutrition': nutrition,
    'routine': routine,
    'sport': sport,
    'staffAdmin': staffAdmin,
    'staff': staff,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
