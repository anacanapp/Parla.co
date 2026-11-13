# Release and test builds

How Parla gets from this repository to testers' phones. App identifier on
both stores: **`com.atlasoon.parla`** (permanent: it can never change after
the first upload).

```
GitHub ──► Codemagic ──► Play internal testing / TestFlight ──► testers
   │                         │ app talks to
   │ deploy workflow         ▼
   └──────────► AWS Frankfurt (eu-central-1):
                CloudFront (HTTPS) ──► internal load balancer ──► ECS Fargate server
                                                                   │
                                     RDS PostgreSQL (private) ◄────┘
                └── sign-in codes by SMTP from info@anacan.az
```

Nothing is tied to AWS. The server is a plain Docker image configured only
by environment variables, so moving to our own servers means running the
same image with new variables.

## Privacy and legal checks before inviting testers

- Testers are real people and may enter real health answers. Staging is
  therefore treated like production for data protection.
- Everything runs in AWS **eu-central-1 (Frankfurt)**: server, database,
  backups (7 days), secrets and logs (30 days). The database, its backups,
  the secrets and the logs are encrypted with one KMS key that AWS rotates
  yearly. The database has no public address; the load balancer is
  internal and only CloudFront reaches it, over AWS's own network.
- AWS's data processing addendum (GDPR DPA) is part of the AWS Service
  Terms and applies automatically; keep a copy for the processor list
  (AWS Artifact → Agreements).
- CloudFront serves the HTTPS address from AWS edge locations; requests
  pass through them but nothing is cached (caching is off).
- The anacan.az mailbox provider processes testers' email addresses: note
  which provider it is and where it stores mail.
- Tell testers it is a test version and their data may be deleted.
- Open for the lawyer: Azerbaijani data localisation (testers in AZ, data in
  Germany), and whether `ITSAppUsesNonExemptEncryption = false` is right
  (the app itself only uses HTTPS and the phone's secure storage).
- Update the processor list in the privacy policy draft: AWS instead of
  Google Cloud and Supabase.

## 1. AWS: infrastructure (once)

Everything is described in Terraform in `deploy/aws/staging`: network,
KMS key, RDS PostgreSQL 16, Secrets Manager secret, ECR, ECS Fargate,
internal load balancer, CloudFront and the GitHub deploy role. Running it
creates paid resources, roughly 45–55 USD a month (load balancer ~18,
database ~15, server ~10, rest small).

1. Sign in to the Anacan App AWS account with a user that may create IAM
   roles, switch the region to **Europe (Frankfurt) eu-central-1** and open
   **CloudShell** (the terminal icon in the top bar). No AWS key is needed
   on your own computer.
2. Install Terraform and get the code:
   ```bash
   sudo yum install -y yum-utils
   ```
   ```bash
   sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
   ```
   ```bash
   sudo yum -y install terraform
   ```
   ```bash
   git clone https://github.com/anacanapp/Parla.co.git && cd Parla.co
   ```
3. Check whether the account already has a GitHub identity provider (IAM →
   Identity providers → `token.actions.githubusercontent.com`). If it does,
   add `-var create_github_oidc_provider=false` to both commands in step 4.
4. Create the state bucket and the infrastructure:
   ```bash
   deploy/aws/init-staging.sh
   ```
   ```bash
   terraform -chdir=deploy/aws/staging apply
   ```
   Read the plan, answer `yes`. It takes 15–20 minutes (the database and
   CloudFront are slow to create). At the end it prints `server_url`,
   `deploy_role_arn` and the other outputs; `terraform -chdir=deploy/aws/staging output`
   shows them again. The server task keeps failing until steps 2 and 3
   have run: there is no image and no secret yet.

## 2. Secrets (once)

In the same CloudShell:

```bash
deploy/aws/put-staging-secrets.sh
```

It generates the keys (JWT, peppers, the health data key) and asks for the
SMTP settings without showing them. The database password is never asked
for: RDS created it and keeps it in Secrets Manager. The script refuses to
overwrite an existing value, because a new health data key would make
every stored health answer unreadable.

SMTP for info@anacan.az: from the anacan.az mail provider you need the SMTP
host, port (587 or 465) and a password. With Google Workspace use
`smtp.gmail.com`, port 587 and an **app password** (Google account →
Security → 2-Step Verification → App passwords), not the normal password.

## 3. Deploys from GitHub

1. GitHub → the repository → Settings → Environments → **New environment**
   named `staging`. Under *Deployment protection rules* you can require your
   own approval for each deploy.
2. In that environment add the **variables** (not secrets; neither is
   sensitive):
   - `AWS_DEPLOY_ROLE_ARN` = `deploy_role_arn` from step 1.4.
   - `STAGING_SERVER_URL` = `server_url` from step 1.4.
3. Actions → **Deploy staging server** → *Run workflow* (branch `main`). It
   builds the image, pushes it, restarts the server and checks that
   `server_url` + `readyz` answers. On first start the server creates its
   tables (`--apply-migrations`).
4. Logs: CloudWatch → Log groups → `/parla-staging/server`.

Later deploys are just step 3.3. Changes to `deploy/aws/staging` need
`terraform apply` again (steps 1.2 and 1.4 in a new CloudShell session).

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
   - `parla_staging`: `SERVER_URL` = `server_url` from step 1.4 (with the
     trailing `/`).
   - `google_play`: `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS` (secure) = the
     JSON key from step 6.3.

## Android test APK (quickest way onto a phone)

Needs only step 4.2 (keystore `parla_upload`) and the `parla_staging`
group with `SERVER_URL`; no Play Console.

1. Codemagic → Parla → **Start new build** → branch `main`, workflow
   **Android → test APK (direct install)**.
2. When it finishes (about 15–20 minutes), open the build on the phone and
   download `app-release.apk` from *Artifacts*.
3. Install it: Android asks once to allow installs from the browser or
   Files app. Testers outside the team get the APK file from you; Play
   internal testing (section 6) replaces this once the Play app exists.

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
`SERVERPOD_PASSWORD_*` secrets listed in `deploy/aws/staging/ecs.tf` and
`secrets.tf`, point it at any PostgreSQL 16+ (a `pg_dump` from RDS moves the
data; keep the same `healthKek`, or health answers become unreadable), and
change `SERVER_URL` in Codemagic.
