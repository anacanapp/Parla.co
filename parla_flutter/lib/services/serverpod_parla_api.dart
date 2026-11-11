import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:parla_client/parla_client.dart';
import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'parla_api.dart';

/// [ParlaApi] backed by the Parla Serverpod server.
class ServerpodParlaApi implements ParlaApi {
  ServerpodParlaApi(this._client);

  final Client _client;

  @override
  bool get isSignedIn => _client.auth.isAuthenticated;

  @override
  Future<ProfileSummary?> myProfile() => _guard(() async {
    final profile = await _client.profile.me();
    if (profile == null) return null;
    return ProfileSummary(
      countryCode: profile.countryCode,
      language: profile.language,
    );
  });

  @override
  Future<void> createProfile({
    required int birthYear,
    bool? birthdayPassedThisYear,
    required String countryCode,
    required String language,
  }) => _guard(
    () => _client.profile.create(
      birthYear: birthYear,
      birthdayPassedThisYear: birthdayPassedThisYear,
      countryCode: countryCode,
      language: language,
    ),
  );

  @override
  Future<void> decideConsent({
    required ConsentKind kind,
    required bool granted,
    required String textVersion,
    required String language,
  }) => _guard(
    () => _client.consent.decide(
      consentType: ConsentType.values.byName(kind.name),
      granted: granted,
      textVersion: textVersion,
      language: language,
      source: kIsWeb ? 'web' : 'app',
    ),
  );

  @override
  Widget buildSignIn(
    BuildContext context, {
    required VoidCallback onSignedIn,
    required ValueChanged<Object> onError,
  }) => SignInWidget(
    client: _client,
    onAuthenticated: onSignedIn,
    onError: onError,
    // Only email one-time codes are configured on the server for now.
    // Apple and Google need their developer accounts first.
    disableAnonymousSignInWidget: true,
  );

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on ParlaException catch (e) {
      throw ApiError(e.code);
    }
  }
}
