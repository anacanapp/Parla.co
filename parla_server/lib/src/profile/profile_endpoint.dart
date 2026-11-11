import 'package:parla_shared/parla_shared.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../audit/audit.dart';
import '../generated/protocol.dart';

/// Error codes returned by [ProfileEndpoint]. The app translates them.
abstract final class ProfileErrors {
  static const ageInvalid = 'age.invalid';
  static const ageMinor = 'age.minor';
  static const ageNeedsConfirmation = 'age.needs_confirmation';
  static const countryClosed = 'country.closed';
  static const languageUnsupported = 'language.unsupported';
  static const profileExists = 'profile.exists';
}

/// Creates and reads the signed-in user's core profile (screens M-03, M-07).
class ProfileEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The caller's profile, or `null` before onboarding.
  Future<MemberProfile?> me(Session session) {
    final userId = session.authenticated!.authUserId;
    return MemberProfile.db.findFirstRow(
      session,
      where: (t) => t.authUserId.equals(userId),
    );
  }

  /// Creates the profile once, after the age gate and country choice.
  ///
  /// The age rule is checked again here: the app's check can be bypassed.
  Future<MemberProfile> create(
    Session session, {
    required int birthYear,
    bool? birthdayPassedThisYear,
    required String countryCode,
    required String language,
  }) async {
    final userId = session.authenticated!.authUserId;

    switch (checkAge(
      birthYear: birthYear,
      today: DateTime.now().toUtc(),
      birthdayPassedThisYear: birthdayPassedThisYear,
    )) {
      case AgeCheck.adult:
        break;
      case AgeCheck.minor:
        throw ParlaException(code: ProfileErrors.ageMinor);
      case AgeCheck.needsBirthdayConfirmation:
        throw ParlaException(code: ProfileErrors.ageNeedsConfirmation);
      case AgeCheck.invalid:
        throw ParlaException(code: ProfileErrors.ageInvalid);
    }
    if (!isMarketOpen(countryCode)) {
      throw ParlaException(code: ProfileErrors.countryClosed);
    }
    if (!supportedLanguages.contains(language)) {
      throw ParlaException(code: ProfileErrors.languageUnsupported);
    }

    return session.db.transaction((transaction) async {
      final existing = await MemberProfile.db.findFirstRow(
        session,
        where: (t) => t.authUserId.equals(userId),
        transaction: transaction,
      );
      if (existing != null) {
        throw ParlaException(code: ProfileErrors.profileExists);
      }
      final profile = await MemberProfile.db.insertRow(
        session,
        MemberProfile(
          authUserId: userId,
          birthYear: birthYear,
          countryCode: countryCode,
          language: language,
          createdAt: DateTime.now().toUtc(),
        ),
        transaction: transaction,
      );
      await writeAudit(
        session,
        actorId: userId,
        actorRole: AuditActor.user,
        action: 'profile.created',
        objectType: 'member_profile',
        objectId: profile.id.toString(),
        transaction: transaction,
      );
      return profile;
    });
  }
}
