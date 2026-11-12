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

## Not done yet (tracked, not forgotten)

| Item | Checklist | Planned |
| --- | --- | --- |
| Health data tables with per-user envelope encryption and crypto-shredding | ENC-3, CON-6 | Sprint 2, with the skin test |
| Database-level append-only enforcement for `consent_record` and `audit_log` (restricted DB role) | AUD-2 | With the production database setup |
| Data export and account deletion | EXP-*, DEL-* | Sprint 3 |
| Retention jobs | RET-* | Sprint 3 |
| Apple and Google sign-in | US-01 | Needs the Apple and Google developer accounts (company registration) |
| Production email provider and data region | RES-1, RES-5 | After the lawyer answers the localisation questions |
| Admin/CMS app | M8 | Sprint 2 |

## Known environment issue

Serverpod 4.1.1 binds its servers to the IPv6 wildcard address. Machines
without IPv6 support (some containers) cannot run the server tests; CI
runners and normal developer machines can.
