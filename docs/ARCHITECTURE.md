# Architecture and privacy decisions

This file records decisions that a new contributor must not undo by accident.
The product requirements, data map, privacy checklist and screen list live in
the team's shared documents; ids such as `M-08` (screen), `CON-3` (privacy
checklist item) and `US-02` (user story) refer to them.

## Stack

| Layer | Choice | Why |
| --- | --- | --- |
| Apps | Flutter (iOS, Android, web) | One codebase for the user app; the admin/CMS app will be a separate Flutter web app so admin code never ships inside the user app |
| Backend | Serverpod 4 (Dart) on PostgreSQL | Self-hostable in any data centre, which data localisation rules may require; shares the language and models with the apps |
| Shared rules | `parla_shared` | The age gate, open markets and consent texts must be identical on both sides |

Serverpod Cloud is **not** used: hosting and the hosted email service would
move personal data to a provider and country that the legal review has not
approved. The template's Serverpod Cloud deploy workflow, cloud storage and
cloud email sender were removed.

**Test environment (staging).** The server runs as a Docker container on
Google Cloud Run in Frankfurt with a Supabase PostgreSQL database in
Frankfurt. Sign-in codes go out by SMTP from info@anacan.az
(`SmtpCodeSender`). The image is configured only by environment variables,
so it can move to our own servers unchanged. Setup and store steps are in
`docs/RELEASE.md`; builds run on Codemagic (`codemagic.yaml`).

## Data rules in code

- **Minimisation.** Only the birth year is stored, never a full date. No
  name, phone, location or advertising id. `parla_server/test/unit/data_minimisation_test.dart`
  fails if a model declares a field from the do-not-collect list (RES-3).
- **Age gate (US-02).** `checkAge` in `parla_shared` runs in the app (M-03)
  and again on the server when the profile is created. Someone who turns 18
  this year is asked whether the birthday has passed. Minors get no account
  and nothing they entered is stored.
- **Consent (CON-1 to CON-3).** Three separate consents, all off by default.
  `consent_record` is append-only: a change is a new row. Each row stores the
  text version and the SHA-256 of the exact text shown in the user's language.
  Granting is only possible for the current text version; withdrawing always
  works. `hasConsent()` is the server-side guard for future health endpoints
  (CON-2).
- **Audit log (AUD-1, AUD-3).** Profile creation and every consent decision
  write an `audit_log` row with ids only.
- **Email.** Sign-in uses one-time codes. `VerificationCodeSender` is our own
  interface: development logs the code (without the email address), and
  staging/production refuse to start until an approved provider is added.
- **Secrets.** `config/passwords.yaml` is git-ignored. Locally it is created by
  `tool/create_local_passwords.sh`; deployments use `SERVERPOD_PASSWORD_*`
  environment variables. CI runs gitleaks.

## Health data (sprint 2)

- **Envelope encryption (ENC-3).** Health answers (diagnoses, allergies,
  pregnancy, medicine categories) are stored in `health_record`, encrypted
  with AES-256-GCM under a per-user data key. The data key is stored only
  wrapped by the key-encryption key (KEK) in `health_key`; the user id is
  bound in as associated data, so a row copied to another user does not
  decrypt. The KEK is `healthKek` in `passwords.yaml` / `SERVERPOD_PASSWORD_healthKek`
  for now; production needs a KMS in the data region (`HealthCrypto` is the
  only place to change).
- **Consent guard (CON-2).** `quiz.saveAnswers` refuses health answers
  unless the health consent is granted; `myAnswers` returns them only while
  it is.
- **Withdrawal (CON-6).** Withdrawing the health consent deletes the health
  record and the data key in the same transaction (crypto-shredding) and
  writes a `health.erased` audit row.
- **Warning signs stay on the device.** The warning-sign question only
  decides whether the "see a doctor" screen (M-12) appears; the server
  refuses to store it. Legal review should confirm this local-only
  processing.
- **Quiz content and routine rules** (`parla_shared/lib/src/quiz.dart`,
  `routine_rules.dart`) are sample content with `approved: false`. The
  rules are conservative: a missing or declined safety answer (pregnancy,
  medication) leaves retinol out instead of guessing.
- **No admin web app.** Until there is an approval tool, expert content
  lives in code and changes go through pull requests.

## Privacy rights (sprint 3)

- **Export (EXP-1).** `account.exportMyData` returns everything stored about
  the user as JSON (`parla-export-v1`), health answers decrypted. The app
  hands it to the system share sheet; the file is never stored on the
  server. This replaces the planned 7-day download link (EXP-2), which
  would have kept a copy on the server.
- **Deletion (DEL-1, DEL-2).** `account.deleteAccount` deletes, in one
  transaction and immediately: health data and its key, quiz answers,
  profile, and the sign-in account with its sessions and refresh tokens.
  Short-lived access tokens expire on their own. Immediate deletion is
  stricter than the 30 days in the data map.
- **Pseudonymisation, the one exception to append-only.** On deletion the
  user id in `consent_record` and `audit_log` is replaced by an HMAC
  pseudonym (`pseudonymPepper` secret). This is the only update ever made
  to those tables. A `deleted_account` row holds the pseudonym and date.
- **Retention (RET-1, RET-2, AUD-4).** A daily timer (`scheduleDailyRetention`)
  deletes audit rows older than 1 year and the consent records of accounts
  deleted more than 3 years ago. Periods are proposals pending legal
  review. Pregnancy re-asking after 12 months is not implemented yet.
- **Privacy centre (M-25 to M-34).** Reached from the Profile tab and the
  profile button: consents with a confirmation before the health consent is
  withdrawn, data download, legal documents, sign-out and account deletion
  with a typed confirmation word.

## Habits (sprint 4)

- **On the device only.** Water, sleep, movement and ticked routine steps
  (M-17, M-18) never reach the server. They are kept with
  `flutter_secure_storage` (iOS Keychain; on Android, encrypted with an
  Android Keystore key) under one entry per account, so a second person on
  a shared phone does not see them. Signing out keeps them for the next
  sign-in of the same account. iOS keeps Keychain items after the app is
  removed, so the first start of a fresh installation deletes any habit
  entries left behind (`SecureHabitStore.forgetAfterReinstall`).
- **Minimal history.** Only days with an entry are kept, and none older than
  90 days (`HabitLog.keepDays`). The habits tab shows the last 7 days.
- **Rights.** The data export adds the device entries (`deviceHabits`) to
  the server data before the file is shared. Account deletion deletes them
  on this phone, and the privacy centre can delete them on their own. Other
  phones the user signed in on keep their own entries until the app is
  removed there; the account deletion text says "on this phone".
- **No judging.** Plain counts and averages only. There is no sleep target,
  no score and no streak that can be lost. The water goal of 8 glasses and
  all habit wording need the expert review before launch.

## Reminders

- **Local notifications only** (`flutter_local_notifications`). The phone
  schedules them itself; there is no push service, so no device token goes
  to Google or to our server.
- **Opt-in.** Morning routine (08:00), evening routine (21:30) and sleep
  entry (09:00) are all off until the user turns one on, and the
  notification permission is asked only then. Times change in 15-minute
  steps.
- **Neutral texts.** They show on the lock screen, so they never mention
  skin conditions or other health information.
- **Per account.** Settings (on/off and time only) are kept in the app
  preferences per account. Sign-out cancels the notifications; the same
  account signing in again gets them back. Account deletion cancels them
  and deletes the settings. The data export includes them
  (`deviceReminders`).
- **Android.** Inexact scheduling (`inexactAllowWhileIdle`): no exact-alarm
  permission, which Google Play reserves for alarm and calendar apps, so a
  reminder may come a few minutes late. Reminders are restored after a
  reboot. Android and iOS only; the web build hides them.

## App UI rules

- **Brand.** Colours, type and the Smile Curve follow the Parla Sun brand
  guidelines v2.0 (`parla_flutter/lib/ui/brand.dart`). Commissioner and
  Fraunces are bundled (SIL OFL 1.1, licences in `assets/fonts/`); no font is
  fetched from Google at runtime, which would send users' IP addresses to a
  third party. Fraunces has no Cyrillic, so Russian accent lines use
  Commissioner.
- **Accessibility.** Every text is at least 18 px, text colours pass WCAG AA,
  touch targets are at least 48 px and icons always come with a text label.
  `home_screen_test.dart` checks the 18 px rule and overflow on a 390 px
  phone in az, ru and en, with the real fonts loaded.
- **Navigation.** Four tabs (Today, Scan, Habits, Profile). Five did not fit
  at 18 px in Russian; the routine lives on the Today tab.
- **Expert badge.** The "approved by a dermatologist" badge only shows for
  content marked approved. The current routine steps
  (`lib/home/routine.dart`) are sample content and never show it.
- **Habit data** is stored on the device only; see "Habits (sprint 4)".

## Not done yet (tracked, not forgotten)

| Item | Checklist | Planned |
| --- | --- | --- |
| KMS for the health KEK in the production data region | ENC-3 | With the production hosting decision |
| Database-level append-only enforcement for `consent_record` and `audit_log` (restricted DB role) | AUD-2 | With the production database setup |
| Re-ask the pregnancy question after 12 months | RET-2 | With habit and health data history |
| Privacy policy and terms texts | — | Lawyer |
| Apple and Google sign-in | US-01 | Needs the Apple and Google developer accounts (company registration) |
| Production hosting, email provider and data region (staging uses Cloud Run, Supabase and SMTP via info@anacan.az, all in or through the EU) | RES-1, RES-5 | After the lawyer answers the localisation questions |
| Admin/CMS app | M8 | Dropped: expert content lives in code and is reviewed in pull requests |
| Real-device test of reminders (Android 13+ permission, reboot, iOS foreground) | M7 | Before the beta |

## Known environment issue

Serverpod 4.1.1 binds its servers to the IPv6 wildcard address. Machines
without IPv6 support (some containers) cannot run the server tests; CI
runners and normal developer machines can.
