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
AWS ECS Fargate in Frankfurt with an RDS PostgreSQL database in Frankfurt,
behind CloudFront (HTTPS) and an internal load balancer; the database,
secrets and logs are encrypted with a KMS key (`deploy/aws/staging`, in
Terraform). Sign-in codes go out by SMTP from info@anacan.az
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
- **Quiz content and routine rules** come from the content sheet
  (`test_suallari`, `rutin_addimlari`, `rutin_qaydalari`): 19 questions
  with "why we ask" texts plus our own warning-signs question, 34 care
  steps and 47 rules (`quiz.dart`, `routine_content.dart`; the engine is
  `buildRoutine` in `routine_rules.dart`). All drafts with
  `approved: false`. The sheet's age question is left out, because the
  birth year is already known and the app is 18+ only. Its under-18 rule is
  dropped for the same reason. Pregnancy, medications and allergies are the
  health questions. The engine is conservative: removing always wins over
  adding; a step marked unsafe in pregnancy is left out unless the answer
  is "no" (so a skipped answer also leaves it out); an unanswered
  medication question leaves out the actives a prescription would rule
  out; and steps not suited to sensitive skin are left out when the skin
  reacts often. The rules' notes are shown on the quiz result. The Check
  filters the rules suggest (`RoutineResult.preferences`) are not used in
  the app yet.
- **Content in code for now.** Expert content lives in code and changes
  go through pull requests until the admin panel's content phase (B)
  moves it to the server with an expert approval step; see "Admin panel".

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

## Products and ingredients (M5, M6)

Search by name or brand through our server (Open Beauty Facts and our own
catalogue); the app never calls third parties directly and searches are not
stored. Ingredient statuses are the EU annexes from an official CosIng
export, imported by a tool, shown neutrally with source and date. Details,
wording rules and open legal questions: `docs/INGREDIENTS.md`.

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

## Care routines and own routines (redesign step 2)

- **Areas and slots.** The Routine tab shows face, hair and body routines,
  each with morning, evening and weekly steps. The plans come from the quiz
  answers through `planArea` in `parla_shared` (no answers: a basic plan).
  Hair and body texts in `lib/home/routine.dart` are drafts by us, marked
  as sample content, and need the dermatologist review like the face texts.
- **Weekly steps** count as done for the whole week (Monday to Sunday) once
  ticked on any day; they are kept in the same on-device habit log
  (`weeklyDone`).
- **Own routines** (name, area, every day or one weekday, up to 12 steps of
  free text) and their daily ticks are kept **on the server, encrypted**,
  in `custom_routine_record` (one row per user, AES-256-GCM under the same
  data key as the health answers, so deleting `health_key` makes them
  unreadable). The free text may hold health details, so the server keeps
  them only with a health consent whose text covers them
  (`healthVersionsCoveringOwnRoutines`, from `health-2026-11-draft2`) and
  checks every save against `CustomRoutineRules` in `parla_shared` (known
  fields only, limits, at most 20 routines, 64 KB, ticks pruned after 90
  days). Saves are not audited: the user edits her own data many times a
  day and nobody else can read it.
- **On the phone** an encrypted copy (`SecureHabitStore.routines`) lets the
  app work offline; changes made offline are sent on the next start
  (`pendingUpload`, a local-only flag). Without the covering consent the
  routines stay on the phone only. Routines and ticks from step 2 (phone
  only, ticks in the habit log) move to the server on the first start
  with the consent.
- **Rights.** The server export includes them (`customRoutines`), the app
  export also adds the phone copy (`deviceRoutines`). Withdrawing the
  health consent deletes the server copy (the phone copy stays); account
  deletion deletes both. Reminders for own routines are not built yet.
- **Today** shows the face steps for the part of the day, then a short list
  of the other routines due today (hair, body, open weekly steps, own
  routines), each opening the Routine tab.

## Check, preferences and shopping list (redesign step 3)

- **Preferences** come from the content sheet "Parla — Məzmun"
  (`yoxla_secimleri`): fragrance-free (with the labelled fragrance
  allergens), essential-oil-free, alcohol-free (fatty alcohols excluded),
  vegan, silicone-free, sulfate-free, retinoid-free, allergy-linked
  preservatives and lanolin-free, plus paraben-free from the first
  version. Names and explanations are in `lib/check/preference_texts.dart`;
  the ingredient rules are in `parla_shared`
  (`product_preferences.dart`). New options are added there by pull
  request, not in an admin panel, so every rule is reviewed. The result is
  about the user's own picks only: "fits" or "contains X". There is no
  score, no risk label and no warning colour, and nothing is called
  harmful. "Vegan" can only say that no known animal-derived ingredient was
  found, because names like glycerin can come from plants or animals. The
  ingredient lists are drafts and need the expert review.
- **Stored** like own routines: preferences, the last 20 checked products
  and the shopping list (at most 100 items) form one JSON document. The
  server keeps it encrypted in `care_list_record` under the user's data
  key, only with a health consent that covers it
  (`healthVersionsCoveringCareList`, from `health-2026-11-draft3`), and
  checks it against `CareListRules`. Without that consent it stays on the
  phone. The phone always keeps an encrypted copy (`SecureHabitStore.careList`)
  for offline use (`SyncedDocument`).
- **Rights.** The server export has `careList` and the app adds
  `deviceCareList`. Withdrawing the health consent deletes the server copy,
  and account deletion deletes both copies.
- **Shop.** "Parla Mağaza" is an information screen only. It has no
  sign-up for news, which would need the marketing consent.
- **Barcode scanning** is shown as "coming soon". Searches still go through
  our server only.

## Fitness (redesign step 4)

- **Questions**: one or two goals (tone, muscle, flexibility, posture,
  endurance, unwind), focus areas, workout types (fitness, pilates, wall
  pilates, stretching, low-impact cardio), level, days per week, minutes,
  dumbbells, and safety questions (pregnancy or the six months after
  birth, pain or injury, a doctor's limit).
- **Plan** (`planSport` in `parla_shared`): one workout per day, with the
  types rotating and the chosen areas first. Sets, repetitions and rests
  follow the main goal and the level. The safety answers remove exercises:
  pregnancy and after birth give a gentle, beginner-level plan with a note
  to ask the doctor, and a doctor's limit builds no plan at all. Goals
  speak of tone and strength, never of slimming one body part, because
  spot reduction is not possible and the app says so.
- **Content**: 45 exercises with names and how-tos in az/ru/en
  (`lib/sport/exercise_text.dart`). They are drafts, marked as not
  reviewed by a trainer or physiotherapist. Each move shows a coloured
  card until licensed photos arrive.
- **Workout**: a guided run with sets, a timer for holds and timed moves,
  and rests. Music plays from the user's own music app; Parla only gives a
  short signal (sound and vibration, or vibration only). A finished
  workout is logged and its minutes are added to today's movement entry.
- **Stored** like the other documents: the answers, the workout log (90
  days) and the sound setting. The server keeps them encrypted in
  `sport_record`, only with a health consent that covers them
  (`healthVersionsCoveringSport`, from `health-2026-11-draft4`), and checks
  them against `SportRules`. Without that consent they stay on the phone,
  and the phone always keeps an encrypted copy. The export, consent
  withdrawal and account deletion work as for own routines (`sport`,
  `deviceSport`).

## Admin panel (`parla_admin`)

The decision of 2026-11-16 replaces "no admin app": a Flutter web panel for
the Parla team, built in phases. Phase A (this part) is sign-in, roles and
staff accounts; content (B), users and statistics (C), and banners,
messages and push notifications (D) follow.

- **Who.** Roles `admin` (everything, including staff accounts), `editor`
  (writes content) and `expert` (reviews and approves content in their
  field). There is no open sign-up for the panel. An admin invites an email
  address; the invitation code (only its SHA-256 is stored, single use, 72
  hours) arrives by email. The first admin is the address in the
  `staffBootstrapEmail` setting, and only while there is no staff at all.
  The last active admin cannot be removed.
- **Sign-in.** Email and password (at least 12 characters, enforced on the
  server), then a TOTP code from an authenticator app in every sign-in
  session. The check lasts 8 hours (`staff_session`). The TOTP secret is
  sealed with a key derived from the server KEK by HKDF with its own label.
  A used code is refused, and five wrong codes lock the account for 15
  minutes. An admin can reset a lost authenticator. Sign-in errors do not
  say whether the email exists.
- **Every admin endpoint** starts with `requireStaff`, which checks the
  role, that the member is active and that the second factor was passed in
  this sign-in session. Every staff action goes to the audit log with ids
  only. Deleting a staff member's account removes their panel access.
- **No health data.** The panel never shows users' health answers,
  routines, lists or fitness data. These are encrypted with per-user keys
  that the panel has no way to use. User management (phase C) shows account
  data only.
- **Content (phase B1).** Articles, recipes and expert profiles live in
  `content_item`, written in az, ru and en (`ContentRules` in
  `parla_shared`: known fields only, all three languages before review).
  Each item has a working copy and a separate published copy. Editors
  write and send for review; an expert approves or returns it with a note;
  an editor or admin publishes the approved copy. Editing a live item
  never changes what the app shows until the new version is reviewed and
  published. Expert profiles need no review, but an admin must record
  where the expert's signed consent is kept before they can be published.
  The app reads published items from `content.published` (no sign-in,
  nothing personal). Every step is audited.
- **Hosting.** A static build in a private S3 bucket behind its own
  CloudFront address (`deploy/aws/staging/admin.tf`) with a strict content
  security policy, `noindex`, and CanvasKit bundled so nothing loads from
  Google. It is deployed by the *Deploy staging admin panel* workflow. The
  panel is in Azerbaijani only, as it is for the team.

## Nutrition (plate)

- The daily plate records which food groups the user had each day
  (vegetables, fruit, protein, whole grain, healthy fat, dairy). There are
  no calories, weights or amounts. It is stored like the other documents,
  encrypted in `nutrition_record`, only with a health consent that covers
  it (`healthVersionsCoveringNutrition`, from `health-2026-11-draft5`), and
  checked against `NutritionRules` (90 days).
- **Screens (B2a).** The nutrition tool shows today's plate (six groups),
  today's water from the habits, a daily skin tip and the published
  recipes. The tips in `lib/discover/skin_tips.dart` are sample content
  that needs the expert review. A recipe's ingredients can be added to the
  shopping list (origin `recipe`). The tool says that it is general
  information, not a diet or medical advice.

## Content from the sheet

The team's content sheet "Parla — Məzmun" is the source for the drafts
below. Every row is still marked `qaralama`, so all of it is shown as
draft content until the named expert reviews it.

- C1 (done): Yoxla preferences, explanations of 99 ingredients on the
  product page (`lib/check/ingredient_texts.dart`), 32 nutrition tips, and
  the names, how-tos and cautions of the exercises
  (`lib/sport/exercise_sheet_texts.dart`, which wins over the first
  drafts). Six exercises were added to the catalogue (side lunge, step-up,
  bicycle crunch, mountain climber, jumping jack, high knees). The band row
  is left out because the questions do not ask about a band.
- C2 (done): the quiz, the routine steps and the rules (see "Quiz
  content and routine rules"). Step texts are in
  `lib/home/routine_step_texts.dart`.
- C3 (done): the 12 blog articles and 20 recipes are in
  `parla_server/lib/src/content/content_seed.dart`, generated from the
  sheet. An admin imports them with **Cədvəldən idxal et** in the panel
  (`contentAdmin.importSheet`).
  - Everything arrives as a **draft** and nothing is published.
  - Existing slugs are skipped, so running it again never overwrites edits.
    Each added item is audited (`content.imported`).
  - Article bodies are empty in the sheet. The Azerbaijani body gets the
    "Yazı planı" (main message, ## sections, cautions, reviewer, word
    count) behind the marker `[Yazı planı`. An article cannot go to review
    while the marker is still in the text (`body.plan_left`).
  - The sheet's source links become the article field `sources` (https
    only, at most 10), shown at the end of the article. A body paragraph
    starting with `## ` is shown as a heading.
  - Recipes get the new field `allergens`: ids from the EU list of 14
    allergens (Regulation 1169/2011, Annex II). Review needs it, and an
    empty list ("none of the 14") has to be chosen on purpose. The app
    shows "Contains: …". The sheet's legumes and fish count as protein on
    the plate.
  - Articles have the new category `body`. The expert placeholders in the
    sheet are not imported: they have no real data or consent yet.

## Content images (B2b-1)

Article covers, recipe photos and expert photos are uploaded in the admin
panel (`parla_admin/lib/media/`) and stored by the server
(`parla_server/lib/src/media/`).

- **Upload:**
  - The panel shrinks the image to 1600 px as a JPEG of at most 1 MiB.
  - The server checks the file type by its first bytes (JPEG, PNG, WebP),
    decodes it and encodes a new JPEG from the pixels only. No EXIF, GPS,
    camera or date metadata and no file name is kept.
  - Requests may be up to 1.5 MiB (`maxRequestSize`) for this.
- **Details:** every image needs a licence or permission note. Its alt text
  must exist in az, ru and en before content that uses it can be published
  (`content.image_incomplete`).
- **Storage:**
  - A private S3 bucket (`deploy/aws/staging/media.tf`). The server uses
    the ECS task role, with no access keys, and its own SigV4 signer tested
    against AWS's examples.
  - Uploads stay under `uploads/`. `syncPublicMedia` copies an image to
    `public/` only while published content uses it, and removes the copy
    when nothing published does.
  - CloudFront serves `public/` only. Local development and tests keep
    images in memory.
- **App:** `PublicContent.image` gives the URL, size and alt text. The app
  shows it with the alt text as its screen-reader label, and shows nothing
  if it fails to load. Images come from AWS like the API does; no new
  processor is involved.
- **Deletion:** only admins can delete an image, and only if no draft or
  published content uses it. Uploads, edits and deletions are audited.
- **People in images:** expert photos are the expert's personal data. The
  written consent must cover the photo (lawyer to confirm the form). Images
  showing anyone else need their written permission, noted as the licence.

## Catalogue texts in the admin panel (B2b-2)

The texts of product preferences, exercises and routine steps can be
edited in the panel (tabs **Seçimlər**, **Məşqlər**, **Addımlar**). They
are content items of the kinds `preference`, `exercise` and `step`, whose
slug is the catalogue id from code.

- **What the panel changes:**
  - Preferences: name and hint.
  - Exercises: name, how-to, caution and one image.
  - Steps: title, how-to and tip.
- **What stays in code:** which items exist, ingredient lists, rule
  conditions, doses and safety flags (pregnancy, sensitivity, injuries).
  These change only through a PR with tests (`ContentRules` refuses other
  fields).
- **Starting point:** an item opened for the first time starts from the
  app's own texts, which now live in `parla_shared/lib/src/texts/` so the
  panel can read them.
- **Review:** texts go through the normal review: an expert approves, then
  they are published. The app uses the published texts and falls back to
  its own when there are none or it is offline. It keeps the last copy.
- **Hiding:** *Tətbiqdə gizlət* takes effect at once and needs no review.
  Hidden preferences are not offered and not applied, but stay saved for
  the user. Hidden steps leave the routine and the builder suggestions.
  Hidden exercises are never put into a plan (`planSport(exclude:)`).
- **Loading:** the app loads catalogue texts at start
  (`ContentLibrary.loadCatalogue`). This is public content and nothing
  personal is sent.

## Users and statistics (admin phase C)

**Users** (`userAdmin`, admins only)
- **Look-up:** by the exact email address only. There is no list and no
  partial search. Every look-up is audited (`user.viewed`, ids only).
- **What is shown:** email, registration date, country, language, blocked
  state and the latest consent decisions. Never health data, quiz answers
  or the birth year.
- **Block / unblock:** sign-in stops and refresh tokens are revoked.
  Nothing is deleted. Staff accounts are managed in the staff section.
- **Delete on request:** for a user who asks by email. It runs the same
  `eraseAccount` as deletion in the app, and the admin has to type the
  email again. It is audited as `account.deleted_on_request` with the
  pseudonym. Deletion now also pseudonymises audit rows that name the
  account as their object (for example look-ups).

**Statistics** (`statsAdmin`, admins and editors; not experts)
- **Anonymous counts only:** any bucket or total under 10 is reported as
  "<10" (`minGroupSize`).
- **What is counted:**
  - Accounts, sign-ups per week, age band, country, language, and deleted
    accounts per month.
  - Latest consent decisions.
  - The answers to quiz questions that are not health data (health
    answers are encrypted and never counted).
  - How many accounts keep each tool on the server. Users without the
    health consent keep their tools on the phone only, so they are not in
    this count.
- **Not yet done:** there is no complementary suppression (no protection
  against differencing two totals). Acceptable at this size; review before
  sharing figures outside the team.

**Daily active count**
- Once a day the app calls `activity.markActive`. The server stores a mark
  only with the **analytics consent**.
- The mark is an HMAC of the day and the account id with the pseudonym
  pepper (`daily_active_mark`), never the id itself.
- The nightly job (`rollUpActivity`) turns past days into a total
  (`daily_active_count`) and deletes the marks, so a mark lives at most
  about two days. Account deletion also removes today's and yesterday's
  marks.

## Banners and campaigns (admin phase D1)

Banners are content items of the kind `banner`. The category is where the
card shows: `today` (home) or `discover`.

- **Fields:** title, short text, image, an in-app link (a screen, or
  `article:slug` / `recipe:slug`; never an outside web link), start and end
  date, and optionally languages and countries.
- **Brand campaigns:** a banner with a `sponsor` is a paid brand campaign.
  The app always shows it with an **"Ad · <brand>"** label.
- **Approval** (`ContentRules.reviewerRole`):
  - The team's own banners: an admin publishes directly. An editor's
    banner needs an admin's approval.
  - Brand campaigns: always an expert's approval (no "harmful" wording, no
    scores, no health promises); an admin cannot skip it.
  - All other content is unchanged (expert approval).
- **Targeting on the phone:** the server sends every published banner the
  same way. The app decides by date, language and country
  (`ContentRules.bannerVisible`). Nothing about the user is sent for this.
  Health and quiz answers can never be used for targeting: the model has
  no such fields. Taps are not tracked.

## Messages and support (admin phase D2)

**Announcements** are content items of the kind `message`.
- Fields: title, text, an optional in-app link, and dates, languages and
  countries, as for banners.
- An admin publishes directly; an editor's message needs an admin's
  approval.
- The app shows them under **Messages** (envelope button on Today) and
  decides visibility on the phone. Read state is not sent anywhere.

**Two-way support**
- **Conversation:** one per account (`support_thread`, `support_message`).
- **Encryption:** each message is sealed with AES-GCM under a key derived
  from the server KEK (HKDF label `support-messages-v1`) and bound to the
  account. It is not the health data key, so withdrawing the health
  consent does not delete support messages.
- **Who reads:** the new staff role **support** and admins. The panel list
  shows no message text. Opening, replying and closing are audited with
  ids only.
- **The app says:** messages are stored encrypted and deleted 12 months
  after the last one, and the team gives no medical advice.
- **Retention:** conversations are deleted 12 months after the last
  message (`expireSupport`, nightly) and with the account. They are in the
  user's data export.

## Push notifications (admin phase D3)

**Provider**
- Firebase Cloud Messaging (FCM): a new processor, Google. The server
  sends with the HTTP v1 API and a service account kept in AWS Secrets
  Manager (`parla-staging/fcm`, stored by
  `deploy/aws/put-staging-fcm-secret.sh`).
- The server reads the secret only with `var.enable_push`.
- The app gets its Firebase settings from build defines (`FIREBASE_*`,
  Codemagic). Without them the build has no push and initialises nothing.

**Opt-in**
- The phone's permission is asked only when the user turns
  **Bildirişlər** on in Messages. The token (`device_token`) is stored
  only then.
- The token is deleted when the user turns notifications off, on sign-out,
  with the account, when FCM reports it gone, and after 90 days unseen.

**What is sent**
- **Service notice:** when the team replies in support, the phone gets
  "The Parla team replied", never the reply's text.
- **Campaigns:** content items of the kind `push` (title ≤ 60, text ≤ 180,
  in-app link, languages, countries). Sending is publishing, and it
  happens **once**.
  - Recipients: only accounts that currently grant the **marketing
    consent** and whose profile language and country match. Never chosen
    by health or quiz answers.
  - An admin sends directly after a confirmation; an editor's campaign
    needs an admin's approval.
- **No personal data** in any title or text.

**Not yet done**
- Sending is synchronous and one by one. Fine for the beta; move to a
  queue before large audiences.

## Discover (B2a)

- Blogs (with category filter), the article (with "reviewed by an expert"
  and the date when an expert approved it), experts (with specialty
  filter) and nutrition all read the published content
  (`ContentLibrary`). The last copy is kept in the app preferences, so it
  shows offline; it is public content, nothing personal.
- Experts: *Call*, *WhatsApp* and *Instagram* open the phone's own apps
  (`url_launcher`). Parla only introduces experts, does not see the
  conversation and says so on the screen.

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

- **Brand.** Colours and the Smile Curve follow the Parla Sun brand
  guidelines v2.0 (`parla_flutter/lib/ui/brand.dart`); the type and the
  compact layout follow the 2026-11 redesign (design canvas "Parla yeni
  dizayn"). Plus Jakarta Sans is the interface font, Onest its fallback for
  Cyrillic (Plus Jakarta Sans has none) and Playfair Display Italic the
  accent; all three cover Azerbaijani ə/Ə and are bundled (SIL OFL 1.1,
  licences in `assets/fonts/`). No font is fetched from Google at runtime,
  which would send users' IP addresses to a third party (`google_fonts` is
  only a transitive dependency of the Serverpod sign-in package and is never
  called).
- **Accessibility.** Body text is 15–16 px and nothing is under 12 px
  (`kMinTextSize`) before the user's own system text size, which the app
  follows everywhere (Apple and Google guidance). Text colours pass WCAG AA,
  touch targets are at least 44 px and nav icons always come with a text
  label. `navigation_and_scaling_test.dart` checks the minimum size on the
  tabs and onboarding and that no screen overflows at 200 % system text
  size, in az, ru and en with the real fonts loaded; the feature tests check
  the minimum size on their own screens.
- **Navigation.** Five tabs: Today, Routine, Check, Fitness, Discover
  (`ParlaTab`). Profile and privacy open from the avatar on Today. Blogs,
  experts and nutrition in Discover show what is coming until redesign
  step 5 lands.
- **Expert badge.** The "approved by a dermatologist" badge only shows for
  content marked approved. The current routine steps
  (`lib/home/routine.dart`) are sample content and never show it.
- **Habit data** is stored on the device only, own routines on the server
  with the health consent; see "Habits (sprint 4)" and "Care routines and
  own routines".

## Health data keys in KMS (ENC-3)

Each user's data key (DEK) is wrapped by the AWS KMS key `alias/<name>-health`
when the server has `PARLA_HEALTH_KMS_KEY_ID` (`kekVersion` 2). The key
material never leaves KMS.
- **Account binding:** every call passes the encryption context
  `parla:user = <account id>`, and the task role may use the key only with
  that context.
- **Caching:** unwrapped keys stay in memory for at most 5 minutes to limit
  KMS calls.
- **Older keys:** keys wrapped by the KEK from the secrets (`kekVersion` 1)
  are moved to KMS the first time they are used.
- **Deletion:** deleting the `health_key` row still shreds a user's health
  data.
- **The KEK in the secrets is still needed:** for `kekVersion` 1 keys not
  used since, and for the HKDF-derived keys of staff TOTP secrets and
  support messages. Moving those to KMS as well is a follow-up.
- **Local development and tests** keep the KEK.

## Append-only consent and audit tables (AUD-2)

At start-up the server installs PostgreSQL triggers (`append_only.dart`,
idempotent).
- **audit_log:** only `actorId` / `objectId` may change (a deleted
  account's pseudonym), and only rows older than 365 days may be deleted.
- **consent_record:** only `authUserId` may change (pseudonym), and only
  rows of accounts deleted more than 3 years ago may be deleted.
- **Everything else:** every other `UPDATE` or `DELETE` is refused by the
  database itself, whatever the application does.
- **Times:** the triggers use the database clock. A separate restricted
  database role for the server is still open for production.

## Not done yet (tracked, not forgotten)

| Item | Checklist | Planned |
| --- | --- | --- |
| Re-ask the pregnancy question after 12 months | RET-2 | With habit and health data history |
| Privacy policy and terms texts | — | Lawyer |
| Apple and Google sign-in | US-01 | Needs the Apple and Google developer accounts (company registration) |
| Production hosting, email provider and data region (staging uses AWS in Frankfurt and SMTP via info@anacan.az) | RES-1, RES-5 | After the lawyer answers the localisation questions |
| Push setup: Firebase project, APNs key in Firebase, Push Notifications capability for the App ID, Codemagic FIREBASE_* variables, the FCM secret and `enable_push` | — | You, before testing push |
| Privacy policy and processor list: Firebase (Google) for push, the marketing push under the marketing consent | — | Lawyer, before push is used |
| Privacy policy: support conversations (purpose, encryption, 12-month retention, support role), announcements | — | Lawyer, before the beta |
| Advertising law check for brand campaigns (Azerbaijan "Reklam haqqında" law; labelling, cosmetics claims) | — | Lawyer, before the first brand campaign |
| Privacy policy: the daily active count under the analytics consent, staff look-ups of accounts, deletion on request | — | Lawyer, before the beta |
| Privacy policy text for staff access, the admin panel and push notifications | — | Lawyer, before phase D |
| Real-device test of reminders (Android 13+ permission, reboot, iOS foreground) | M7 | Before the beta |
| Ask people who agreed to an older health consent text to agree to the current one (own routines, preferences and the shopping list stay on the phone until then) | CON-3 | Before launch, if anyone agreed to `health-2026-11-draft1` to `draft4` |
| Expert review of the preference ingredient lists (`product_preferences.dart`) | — | Before launch |
| Dietitian check of the imported recipes, their plate groups and allergens; dermatologist writing/review of the imported articles | — | Before publishing them |
| Trainer or physiotherapist review of the exercises, numbers and safety rules (`sport_rules.dart`, `exercise_text.dart`) | — | Before launch |
| Licensed exercise photos (shown by exercise id) | — | When the photos arrive |
| Optional on-device photo skin analysis (kept on branch `skin-photo`, not merged) | — | Postponed; needs lawyer approval and a DPIA, plus dermatologist review, before it returns |
| Expert consent form to cover the profile photo; permission wording for people shown in content images | — | Lawyer, before publishing expert photos |
| Restricted database role for the server (no DDL; triggers stay owned by an admin role) | AUD-2 | With the production database setup |
| Move the HKDF-derived keys (staff TOTP, support messages) to KMS and retire the KEK once all health keys are on KMS | ENC-3 | After all `kekVersion` 1 keys have moved |
| Barcode scanning | — | Later step |

## Known environment issue

Serverpod 4.1.1 binds its servers to the IPv6 wildcard address. Machines
without IPv6 support (some containers) cannot run the server tests; CI
runners and normal developer machines can.
