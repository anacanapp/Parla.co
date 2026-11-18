# Release and test builds

How Parla gets from this repository to testers' phones. App identifier on
both stores: **`com.atlasoon.parla`** (permanent: it can never change after
the first upload).

```
GitHub ──► Codemagic ──► Play internal testing / TestFlight ──► testers
   │                         │ app talks to https://parla.anacan.az/
   │ deploy workflow         ▼
   │      Cloudflare DNS ("DNS only", no proxy)
   │                         ▼
   └──────────► AWS Frankfurt (eu-central-1):
                WAF ──► load balancer (HTTPS, ACM certificate) ──► ECS Fargate server
                          /          → API server (8080)            │  ▲
                          /admin/    → web server (8082): panel     │  │ private
                          /media/*   → web server (8082): images    │  S3 media bucket
                                     RDS PostgreSQL (private) ◄─────┘
                └── sign-in codes by SMTP from info@anacan.az
```

Nothing is tied to AWS. The server is a plain Docker image configured only
by environment variables, so moving to our own servers means running the
same image with new variables. The image also holds the admin panel.

## Privacy and legal checks before opening sign-ups

The environment is called **prod** and is meant for real users (beta).
Sign-ups stay closed until these are done:

- The lawyer's privacy policy and terms, and the final consent texts (a new
  version in `parla_shared`; the current ones are drafts).
- The lawyer's answer on data localisation: health data of Azerbaijani
  citizens stored in Frankfurt.
- The expert reviews (dermatologist, dietitian, trainer); see "Not done
  yet" in `docs/ARCHITECTURE.md`.

What the setup already does:

- Everything runs in AWS **eu-central-1 (Frankfurt)**: server, database,
  backups (14 days, point-in-time restore), images, secrets and logs (30
  days). The database, its backups, the secrets and the logs are encrypted
  with one KMS key that AWS rotates yearly; health data keys are wrapped by
  a second KMS key. The database and the media bucket have no public
  access.
- HTTPS ends at the load balancer in Frankfurt. Cloudflare only answers DNS
  ("DNS only"), so it never sees the traffic. HSTS, `nosniff` and
  `X-Frame-Options: DENY` are on every response; the panel has a strict
  content security policy (`connect-src 'self'`) and `noindex`.
- AWS WAF blocks known bad addresses and common attacks and limits sign-in
  requests per IP address (protects the info@anacan.az mailbox). No WAF or
  load balancer access logs are kept, because they would store visitors' IP
  addresses; only counts in CloudWatch metrics.
- AWS's data processing addendum (GDPR DPA) is part of the AWS Service
  Terms and applies automatically; keep a copy for the processor list
  (AWS Artifact → Agreements).
- Cloudflare (DNS only) is not a processor of users' data, but list it with
  the domain setup.
- The anacan.az mailbox provider processes users' email addresses: note
  which provider it is and where it stores mail.
- Open for the lawyer: whether `ITSAppUsesNonExemptEncryption = false` is
  right (the app itself only uses HTTPS and the phone's secure storage).

## 1. AWS: infrastructure (once)

Everything is described in Terraform in `deploy/aws/prod`: network, KMS
keys, RDS PostgreSQL 16, Secrets Manager secrets, the private media
bucket, ECR, ECS Fargate, the public load balancer with its certificate,
WAF and the GitHub deploy role. It costs roughly 85–90 USD a month (load
balancer ~22, public IPv4 addresses ~11, server ~20, database ~18, WAF
~10–12, the rest small); with `db_multi_az=true` about 105.

Production choices (variables in `variables.tf`):

| Setting | Value | Why |
| --- | --- | --- |
| `db_multi_az` | `false` | Beta size; an in-place change later |
| `db_backup_days` | `14` | Point-in-time restore for two weeks |
| Deletion protection | on (database and load balancer) | No accidental `destroy` |
| `task_cpu` / `task_memory` | 512 / 1024 | The server also serves the panel and images |
| `enable_waf` | `true` | See above |

1. Sign in to the Anacan App AWS account with a user that may create IAM
   roles, switch the region to **Europe (Frankfurt) eu-central-1** and open
   **CloudShell** (the terminal icon in the top bar).
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
3. Create the state bucket (if missing) and initialise:
   ```bash
   deploy/aws/init-prod.sh
   ```
4. **First the certificate.** It needs a DNS record at Cloudflare before
   the rest can be created:
   ```bash
   terraform -chdir=deploy/aws/prod apply -target=aws_acm_certificate.main
   ```
   ```bash
   terraform -chdir=deploy/aws/prod output certificate_validation_record
   ```
   In Cloudflare → anacan.az → DNS, add that record: type `CNAME`, the
   `name` and `value` exactly as printed (Cloudflare may shorten the name
   to the part before `.anacan.az`), proxy status **DNS only** (grey
   cloud). Keep it for good: ACM uses it for every renewal.
5. **Then everything else**, with the first admin's email (not secret):
   ```bash
   terraform -chdir=deploy/aws/prod apply -var='staff_bootstrap_email=you@example.com'
   ```
   It waits until ACM has validated the certificate, then takes 15–20
   minutes (the database is slow to create). At the end it prints the
   outputs; `terraform -chdir=deploy/aws/prod output` shows them again.
6. In Cloudflare add `parla` as `CNAME` → `load_balancer_dns_name`, **DNS
   only**. Cloudflare's proxy must stay off: it would end TLS outside AWS.

The server task keeps failing until steps 2 and 3 have run: there is no
image and no secret yet.

## 2. Secrets (once)

In the same CloudShell:

```bash
deploy/aws/put-prod-secrets.sh
```

It generates new keys (JWT, peppers, the health data key) and asks for the
SMTP settings without showing them. With `--smtp-from-staging` it copies
the SMTP settings from the old `parla-staging/app` secret instead, without
showing them. The database password is never asked for: RDS created it and
keeps it in Secrets Manager. The script refuses to overwrite an existing
value, because a new health data key would make every stored health
answer unreadable.

SMTP for info@anacan.az: from the anacan.az mail provider you need the SMTP
host, port (587 or 465) and a password. With Google Workspace use
`smtp.gmail.com`, port 587 and an **app password** (Google account →
Security → 2-Step Verification → App passwords), not the normal password.

Push notifications (later): `deploy/aws/put-prod-fcm-secret.sh` with the
Firebase service account file, then `terraform apply` with
`-var=enable_push=true`.

## 3. Deploys from GitHub

1. GitHub → the repository → Settings → Environments → **New environment**
   named `production`. Under *Deployment protection rules* require your
   own approval for each deploy.
2. In that environment add the **variable** (not a secret)
   `AWS_DEPLOY_ROLE_ARN` = `deploy_role_arn` from step 1.5.
3. Actions → **Deploy production server** → *Run workflow* (branch
   `main`). It builds the image (server and admin panel), pushes it,
   restarts the server and checks `/readyz`, `/admin/` and the security
   headers. On first start the server creates its tables
   (`--apply-migrations`). The service is away for about two minutes
   during a deploy (never two servers at once), so deploy at quiet hours.
4. Logs: CloudWatch → Log groups → `/parla-prod/server`.

Later deploys are just step 3.3. Changes to `deploy/aws/prod` need
`terraform apply` again (steps 1.2, 1.3 and 1.5 in a new CloudShell
session).

### The first admin

1. Open `https://parla.anacan.az/admin/`, choose *Hesabım yoxdur:
   qeydiyyat*, register with the `staff_bootstrap_email` address and a
   password of at least 12 characters, and enter the code from the email.
2. Choose *İlk admin kimi qoşul*. There is no second factor; the panel
   asks for the password again every 12 hours.
3. Invite the rest of the team from *İşçilər*.
4. Run `terraform apply` again **without** `staff_bootstrap_email`, so
   nobody else can claim the first admin role.

### Content images

Images uploaded in the panel are kept in the private media bucket; the
server reads it with its task role (no access key exists) and serves the
images of published content at `https://parla.anacan.az/media/<id>.jpg`.
Unpublished images are never reachable.

## 4. Codemagic (once)

1. Sign in at codemagic.io with GitHub and add `anacanapp/Parla.co`. The
   builds are defined in `codemagic.yaml` and started by hand.
2. **Android upload key.** Team settings (on a personal account: Settings) → Code signing identities →
   Android keystores → *Generate keystore* (or upload one), reference name
   **`parla_upload`**. Download a backup and keep it with the passwords: a
   lost upload key needs a reset request to Google.
3. **App Store Connect API key.** In App Store Connect → Users and Access →
   Integrations → App Store Connect API, create a key with the **App
   Manager** role. Note the Issuer ID and Key ID and download the `.p8`
   file (Apple allows the download only once). Keep the file in your
   password manager; never send it in chat or commit it.
4. **Certificate key.** The iOS build creates the Apple Distribution
   certificate itself and needs a private RSA key for it, made once on any
   computer with a terminal (Mac, Linux, or AWS CloudShell in the browser):
   ```bash
   ssh-keygen -t rsa -b 2048 -m PEM -f parla_cert_key -q -N ""
   ```
   ```bash
   cat parla_cert_key
   ```
   Copy the whole output (with the `BEGIN`/`END` lines) into
   `CERTIFICATE_PRIVATE_KEY` below, keep a copy in your password manager,
   then delete both files (`rm parla_cert_key parla_cert_key.pub`). The same
   key must be kept: a new one would create a new certificate, and Apple
   allows only a few.
5. **Environment variable groups:**
   - `parla_prod`: `SERVER_URL` = `https://parla.anacan.az/` (with the
     trailing `/`).
   - `google_play`: `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS` (secure) = the
     JSON key from step 6.3.
   - `app_store`, for iOS. Works on a personal Codemagic account; no
     Integrations or Code signing menus are needed:
     - `APP_STORE_CONNECT_ISSUER_ID` = Issuer ID from step 4.3
     - `APP_STORE_CONNECT_KEY_IDENTIFIER` = Key ID from step 4.3
     - `APP_STORE_CONNECT_PRIVATE_KEY` (secure) = the whole text of the
       `.p8` file
     - `CERTIFICATE_PRIVATE_KEY` (secure) = the key from step 4.4

## Android test APK (quickest way onto a phone)

Needs only step 4.2 (keystore `parla_upload`) and the `parla_prod`
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

## App Store listing (texts and screenshots)

The store texts (Turkish only: App Store Connect has no Azerbaijani) and
screenshots live in `parla_flutter/ios/fastlane/`; see its `README.md`.
Codemagic → **Start new build** → `main` → **iOS → App Store listing**
uploads them to the version being prepared, using the `app_store` group.
It never submits for review.

Still done by hand in App Store Connect: primary language Turkish (App
Information), App Privacy answers, age rating, price and availability,
and the privacy policy and support URLs once the pages are public.

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
`runmode=production`, set the `SERVERPOD_*` variables and
`SERVERPOD_PASSWORD_*` secrets listed in `deploy/aws/prod/ecs.tf` and
`secrets.tf`, point it at any PostgreSQL 16+ (a `pg_dump` from RDS moves the
data; keep the same `healthKek`, or health answers become unreadable), and
change `SERVER_URL` in Codemagic.
