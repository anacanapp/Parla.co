# Release and test builds

How Parla gets from this repository to testers' phones. App identifier on
both stores: **`com.atlasoon.parla`** (permanent: it can never change after
the first upload).

```
GitHub ──► Codemagic ──► Play internal testing / TestFlight ──► testers
                             │ app talks to
                             ▼
              Cloud Run (parla-staging, Frankfurt) ──► Supabase Postgres (Frankfurt)
                             └── sign-in codes by SMTP from info@anacan.az
```

Nothing is tied to these vendors. The server is a plain Docker image
configured only by environment variables, so moving to our own servers means
running the same image with new variables.

## Privacy and legal checks before inviting testers

- Testers are real people and may enter real health answers. Staging is
  therefore treated like production for data protection.
- Supabase project in **EU (Frankfurt)**, Cloud Run in **europe-west3
  (Frankfurt)**. Sign the Supabase and Google Cloud data processing
  agreements (both offer one).
- The anacan.az mailbox provider processes testers' email addresses: note
  which provider it is and where it stores mail.
- Tell testers it is a test version and their data may be deleted.
- Open for the lawyer: Azerbaijani data localisation (testers in AZ, data in
  Germany), and whether `ITSAppUsesNonExemptEncryption = false` is right
  (the app itself only uses HTTPS and the phone's secure storage).

## 1. Database: Supabase (once)

1. Create a project in region **Central EU (Frankfurt)**. Keep the database
   password in your password manager.
2. Project settings → Database → Connection string → **Session pooler**.
   Note the host (e.g. `aws-0-eu-central-1.pooler.supabase.com`) and the
   user (`postgres.<project-ref>`). The session pooler is used because the
   direct connection is IPv6 only and the transaction pooler breaks
   prepared statements.
3. Nothing else: the server creates its tables on first start
   (`--apply-migrations`).

## 2. Email: info@anacan.az (once)

The server sends sign-in codes by SMTP. From the anacan.az mail provider you
need: SMTP host, port (587 or 465) and a password for info@anacan.az. With
Google Workspace, use `smtp.gmail.com`, port 587 and an **app password**
(Google account → Security → 2-Step Verification → App passwords), not the
normal password.

## 3. Server: Google Cloud Run (once, then one command per deploy)

1. Create a Google Cloud project with billing, then:
   ```bash
   gcloud config set project <project-id>
   gcloud services enable run.googleapis.com cloudbuild.googleapis.com artifactregistry.googleapis.com secretmanager.googleapis.com
   gcloud artifacts repositories create parla --repository-format=docker --location=europe-west3
   ```
2. Create the secrets. Random keys are generated; the script asks for the
   Supabase password and SMTP settings without showing them:
   ```bash
   deploy/create-staging-secrets.sh <project-id>
   ```
3. Let Cloud Build and Cloud Run read the secrets and deploy: grant the
   Cloud Build service account the roles *Cloud Run Admin*, *Service Account
   User* and *Artifact Registry Writer*, and the Cloud Run runtime service
   account *Secret Manager Secret Accessor*.
4. In `deploy/cloudbuild-staging.yaml` set `_DB_HOST` and `_DB_USER` from
   step 1.2. Deploy:
   ```bash
   gcloud builds submit --config deploy/cloudbuild-staging.yaml .
   ```
5. The first deploy prints the service URL
   (`https://parla-staging-….europe-west3.run.app`). Put its host into
   `_PUBLIC_HOST` and deploy once more. The URL with a trailing `/` is the
   app's `SERVER_URL`.

The service runs one always-on instance (the daily retention timer needs
it), roughly 10–15 USD a month.

## 4. Codemagic (once)

1. Sign in at codemagic.io with GitHub and add `anacanapp/Parla.co`. The
   builds are defined in `codemagic.yaml` and started by hand.
2. **Android upload key.** Team settings → Code signing identities →
   Android keystores → *Generate keystore* (or upload one), reference name
   **`parla_upload`**. Download a backup and keep it with the passwords: a
   lost upload key needs a reset request to Google.
3. **App Store Connect API key.** In App Store Connect → Users and Access →
   Integrations → App Store Connect API, create a key with the **App
   Manager** role. In Codemagic: Team settings → Integrations → Developer
   Portal → add it with the name **`Parla ASC`** (Issuer ID, Key ID, .p8
   file). Enter it only there, never in chat or in the repository.
4. **iOS certificate.** Team settings → Code signing identities → iOS
   certificates → generate an *Apple Distribution* certificate with that
   key. Codemagic then creates the App Store profile for
   `com.atlasoon.parla` itself.
5. **Environment variable groups:**
   - `parla_staging`: `SERVER_URL` = the Cloud Run URL from step 3.5.
   - `google_play`: `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS` (secure) = the
     JSON key from step 6.3.

## 5. App Store (Anacan App's account)

1. Certificates, Identifiers & Profiles → Identifiers → register the App ID
   **`com.atlasoon.parla`**.
2. App Store Connect → Apps → **+** → New App: iOS, name "Parla" (if taken,
   for example "Parla: Beauty Guide"), primary language, bundle ID
   `com.atlasoon.parla`, any SKU (e.g. `parla-ios`).
3. Run the **iOS → TestFlight** workflow in Codemagic. After Apple
   processes the build (10–30 minutes), add internal testers in TestFlight
   (up to 100 people from the account's team; no Apple review needed).
4. Before a public release (not needed for internal testing):
   App Privacy answers, privacy policy URL, age rating questionnaire,
   availability (Azerbaijan first), screenshots. In-app account deletion,
   which Apple requires, is already done.

## 6. Google Play (Anacan App's account)

1. Play Console → Create app: name "Parla", app, free. Accept the
   declarations.
2. Run the **Android → Play internal testing** workflow once. Publishing
   fails the first time (Google requires the first upload by hand):
   download the `.aab` from the build's artifacts and upload it in Testing
   → Internal testing → Create release. Play App Signing is switched on in
   that step: Google keeps the app signing key, our key is only the upload
   key.
3. Automatic uploads: Google Cloud console → IAM → Service accounts →
   create one, add a JSON key; Play Console → Users and permissions →
   invite the service account's email with release permissions for Parla.
   Put the JSON into Codemagic (step 4.5). Later builds then go to internal
   testing as drafts.
4. Testing → Internal testing → Testers: create an email list. Testers join
   through the opt-in link.
5. Before a public release (not needed for internal testing):
   - Data safety form.
   - Health apps declaration.
   - Target audience 18+.
   - Content rating (IARC).
   - Privacy policy URL.
   - **Account deletion URL**: a simple public page that explains how to
     delete the account in the app and gives a contact email.
   - Countries: Azerbaijan first.

## Real-device checklist for the first build

1. Sign in with an email code; the email comes from info@anacan.az.
2. Onboarding, quiz with and without the health consent, home, habits.
3. Reminders (see PR "Habit reminders"): permission, firing time, reboot.
4. Privacy centre: export file, delete habit entries, delete account.
5. Text at 18 px and nothing cut off on a small phone, in az, ru and en.

## Moving to our own servers later

Run the same Docker image (`parla_server/Dockerfile`) with
`runmode=staging` or `production`, set the `SERVERPOD_*` variables and
`SERVERPOD_PASSWORD_*` secrets listed in `deploy/cloudbuild-staging.yaml`,
point it at any PostgreSQL 16+ (a `pg_dump` from Supabase moves the data),
and change `SERVER_URL` in Codemagic.
