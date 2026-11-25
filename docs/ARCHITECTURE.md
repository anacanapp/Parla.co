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

**Production (prod).** One public address, `https://parla.anacan.az/`
(DNS at Cloudflare, "DNS only", so Cloudflare never sees the traffic).
AWS WAF and a public load balancer in Frankfurt end HTTPS with an ACM
certificate and send `/admin` and `/media/*` (images and exercise videos) to the server's web server
and everything else to its API server; both run in one Docker container
on ECS Fargate, with RDS PostgreSQL in private subnets. There is no
CloudFront and no third-party CDN. The database, secrets and logs are
encrypted with a KMS key (`deploy/aws/prod`, in Terraform). Sign-in codes
go out by SMTP from info@anacan.az (`SmtpCodeSender`). The image is
configured only by environment variables, so it can move to our own
servers unchanged. Setup and store steps are in `docs/RELEASE.md`; builds
run on Codemagic (`codemagic.yaml`). Sign-ups stay closed until the legal
and expert checks in `docs/RELEASE.md` are done.

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

- **Sections** (owner, 2026-11-24): İdman has five chips: Fitnes,
  Pilates, Divar pilatesi, Yoqa and Üz yoqası.
  - Fitnes, Pilates and Divar pilatesi each ask their own questions and
    keep their own weekly plan (`SportOptions.sections`).
  - Stretching and low-impact cardio belong to Fitnes.
  - Yoga and face yoga are fixed sessions without questions.
  - Workout ids carry the section: `w1`, `p1`, `v1`
    (`SportOptions.sectionOfWorkout`).
  - The safety answers belong to the person, so saving one section copies
    them into the others (`SportAnswers.withSafetyOf`).
  - A document from before sections that chose pilates or wall pilates
    opens those sections with the same answers.
- **Questions**: one or two goals (tone, muscle, flexibility, posture,
  endurance, unwind), focus areas, workout types (Fitnes only: fitness,
  stretching, low-impact cardio), level, days per week, minutes,
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
  reviewed by a trainer or physiotherapist. Each move shows its video
  (see "Exercise videos"), else its photo, else a coloured card.
- **Workout** (`workout_screen.dart`): a guided run that moves on by
  itself, like other fitness apps.
  - Every set starts with a 3-2-1 countdown and runs on a timer that
    empties as a ring. A move counted in reps gets 3 seconds a rep
    (`WorkoutPace`), and "Next" ends it sooner.
  - Then comes a rest, which shows the next move.
  - Controls: pause, previous move, next, and stop (it asks first and logs
    nothing).
  - The screen stays on while it runs (`wakelock_plus`, no permission).
  - The move's video plays looping with its own sound, which a button
    turns off (kept on the phone with the sport settings); it mixes with
    the user's own music. Videos uploaded before 2026-11-24 have no sound
    (it was stripped) until they are uploaded again. It holds on its first frame during the countdown, while paused,
    and when the phone's "reduce motion" is on (then it plays on a tap).
  - Parla only gives a short signal (sound and vibration, or vibration
    only).
  - A finished workout is logged and its minutes are added to today's
    movement entry.
- **Stored** like the other documents: the fitness answers (`answers`),
  the other sections' answers (`sections`), the workout log (90 days, at
  most 12 a day) and the sound setting. The server keeps them encrypted in
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
- **Overview.** The first page is a guide: one card per section the role
  can open (what it is for, the steps, an "Aç" button), and counts of what
  waits: items whose approval belongs to this role (`ContentRules.reviewerRole`),
  approved items not yet published, drafts, and unread support threads. It
  reads only the existing content and support lists; it shows no user data.
- **Sign-in.** Email and password (at least 12 characters, enforced on
  the server), or a one-time code sent to the staff email (decision of
  2026-11-22 by the product owner). A forgotten password is reset with an
  emailed code; reset codes are sent only to active staff
  (`sendStaffPasswordResetCode`), any other address gets the same answer
  and no email. The code sign-in never creates an account: an email
  without one is refused, and a non-staff account is refused by
  `requireStaff`. Consequence: the staff email mailbox is as strong as the
  password, so staff mailboxes must use two-step verification.
  **There is no second factor: decision of 2026-11-18 by the
  product owner**, replacing the TOTP step of phase A. Consequence: a
  stolen or reused staff password (or a staff mailbox) is enough to look up users' emails,
  delete accounts, read support messages (which may hold health details)
  and send push campaigns. What limits it: the email sign-in allows 5 wrong
  passwords per 5 minutes, WAF limits sign-in requests per IP address,
  every staff action is audited, and a sign-in lasts at most 12 hours
  (`staffSignInLength`): the server compares the age of the sign-in
  session (its refresh token, created by the password or code sign-in) and refuses
  older ones with `staff.sign_in_again`, and the panel then asks for the
  password again. Sign-in errors do not say whether the email exists. The
  lawyer should see this decision when the security measures (GDPR
  Art. 32) are described.
- **Every admin endpoint** starts with `requireStaff`, which checks the
  role, that the member is active and that the password sign-in of this
  session is less than 12 hours old. Every staff action goes to the audit log with ids
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
  - **Sample experts** (owner's request, 2026-11-20): six profiles that
    show the format before real experts sign up. They carry `sample: true`,
    their names start with "Nümunə", their numbers with `+99400000` (no
    Azerbaijani operator) and they have no Instagram
    (`ContentRules.isSampleExpert`). Being no one, they publish without a
    consent; the app marks them "Nümunə" and their buttons dial no one.
    Saving one in the panel drops the mark, so real data needs the consent.
    The one-off task `PARLA_TASK=seed-sample-experts` adds them (audited
    `content.sample_published`). **Delete them all before registration
    opens.**
  The app reads published items from `content.published` (no sign-in,
  nothing personal). Every step is audited.
- **Hosting.** The server serves the panel at `/admin/` from the same
  image (`parla_server/lib/src/web/web_routes.dart`; the Dockerfile
  builds it with `--base-href /admin/`). Same origin as the API, so no
  CORS; the panel finds the API from its own address
  (`sameOriginServerUrl`). Strict content security policy
  (`connect-src 'self'`, `frame-ancestors 'none'`), `noindex`, and
  CanvasKit bundled so nothing loads from Google. The panel is in
  Azerbaijani only, as it is for the team.
- **Look.** Parla Sun brand (`parla_admin/lib/ui/theme.dart`): sun yellow,
  cream, espresso, Plus Jakarta Sans with Onest for Cyrillic and Playfair
  Display Italic, all bundled (SIL OFL 1.1). Shared parts (page header,
  cards, status pills, notices, empty states) are in `lib/ui/widgets.dart`.
  A side navigation on wide screens, a drawer on phones. Status colours
  differ in lightness as well as hue.

## Journal (phone only)

- The journal (Discover → Gündəlik) holds free text the user writes about
  her day. It is **never sent to the server**, not even with the health
  consent, so the team cannot read it (owner's decision, 2026-11-20). It
  is kept only on the phone, encrypted in the platform's secure storage
  (`SecureHabitStore.journal`: iOS Keychain, Android Keystore), one entry
  per account, and is removed after a reinstall like the other phone data.
- Limits (`JournalRules`): 4,000 characters per entry, 1,500 entries.
  No mood, health or other structured fields.
- The data export holds a copy (`deviceJournal`); account deletion erases
  it; signing out keeps it for the next sign-in on this phone. Losing the
  phone or removing the app loses it; the screen says so.
- Usage statistics count only that the journal screen was opened
  (`UsageTool.journal`, with the analytics consent), never its content.
- **Legal review:** the privacy policy needs a sentence on the journal
  (kept on the device, not processed by Parla).

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
- **Recipes (owner 2026-11-24).**
  - **Today's pick:** one recipe a day, chosen by the date (the same all day and on every phone).
  - **Fill your plate:** up to three recipes that add the plate groups not yet ticked today.
  - **Saved recipes:** only the slugs, kept on this phone per account (`savedRecipes:<account>` in the shared preferences). Never sent; part of the data download (`deviceSavedRecipes`) and erased with the account.
  - **Calories:**
    - A recipe may carry `kcal`, an approximate energy of one serving (10–2000, optional), shown on the recipe as an estimate.
    - The plate itself still counts no calories.
    - The 76 values in `recipe_kcal.dart` were estimated from the ingredients and are applied once with `PARLA_TASK=set-recipe-kcal` (only where no `kcal` is set; audited `content.kcal_set`).
    - The same task fills three recipes' missing amounts once (`recipeIngredientFixes`: butter for herb-qutab, the vegetables of hummus-veg, the oil of steak-chimichurri; audited `content.ingredients_fixed`).
    - **Needs a dietitian** to check the values.

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

- C4 (2026-11-20): the 32 full blog articles (az, ru, en) from the Drive
  folder "Parla Bloq" are in `parla_server/lib/src/content/blog_seed.dart`,
  built by `tools/blog_import/build_blog_seed.py` from the docs exported as
  Markdown.
  - **Cədvəldən idxal et** adds the new ones as drafts and fills a first
    sheet draft with the full article only while that draft is exactly
    the imported writing plan (any edit keeps it). Filling is audited as
    `content.reimported`. Nothing is published.
  - Title (az) from the doc's heading; ru/en titles from the first sheet,
    else the doc's SEO title; summary from the meta description; sources
    from "Mənbələr" (https, at most 10). The SEO keywords, cover file
    names, linked routine step and planned dates are not imported.
  - Categories: qulluq, xəbər, trend → care; bədən → body; saç → hair;
    makiyaj, dırnaq → beauty; moda → fashion.
  - Expert review: needed (dermatologist; stylist for the fashion ones).
    By the owner's decision of 2026-11-20, while the app is not public,
    an admin may publish the imported articles without it with
    **İdxal olunanları dərc et** (`contentAdmin.publishImported`).
    Each is audited as `content.published_unreviewed`, keeps no review
    date (the app shows no "reviewed by an expert" line). The panel shows
    no extra mark (owner's decision); the audit log lists them. The
    expert reviews them before launch through the normal flow.
  - The same import and publishing can run without the panel as a
    one-off ECS task: the server image with `PARLA_TASK=publish-imported`
    and `PARLA_TASK_ACTOR=<an active admin's email>`. It runs the same
    code as the buttons, audits with that admin as the actor, logs a
    one-line result and exits; it serves no traffic.
  - `PARLA_TASK_RESTORE=<slug,slug>` (optional) puts the full imported
    article back for those slugs when they are not published, whatever
    their status or panel edits (cover and tags kept, audited as
    `content.reimported`), so they are published in the same run. Used
    once for `sunglasses-hats-uv` (owner's request, 2026-11-20). The
    result line also names items that could not be published and why.
  - `PARLA_TASK=attach-content-images` attaches the covers listed in
    `incoming/content-images/manifest.json` in the private bucket (kind,
    slug, file, three-language alt text; licence: generated with AI for
    our own use). The files wait next to it; each is
    re-encoded like a panel upload, set as the cover of the working and
    the published copy (status and review unchanged: covers need no expert
    review, owner's decision), audited (`media.uploaded`,
    `content.cover_attached`) and then deleted from `incoming/`. An item
    that already has a cover is skipped, so the task is safe to run again,
    unless its entry says `"replace": true`: then the new file takes the
    place of the old one (audited `content.cover_replaced` or
    `content.video_replaced`; the old asset is kept but no longer public).
    Used on 2026-11-24 to bring back the exercise videos' sound.
    The same task attaches exercise videos (`"media": "video"` entries):
    each is re-encoded like a panel video upload (`VideoCleaner`: H.264,
    AAC sound kept, no metadata, longest side 720 px, aspect kept) and set as the
    exercise's video; an exercise without a content item gets one,
    published with the texts the app ships with. The workout player shows
    a video in its own shape (a 3:4 portrait video whole, at most about
    half the screen high).
  - `PARLA_TASK=publish-exercise-drafts` with `PARLA_TASK_SLUGS=<id,id>`
    publishes the complete working copy of those exercises when it is not
    published (audited `content.published_unreviewed`). Used once for
    `squat` and `sumo_squat`, whose panel drafts got their videos from the
    attach task (owner's decision, 2026-11-23).

- C5 (2026-11-20): the 76 recipes of the sheet "Parla — Reseptlər
  (genişləndirilmiş)" are in `recipe_seed.dart`, built by
  `tools/blog_import/build_recipe_seed.py` from its CSV export. The first
  20 are unchanged; 56 are new. **İdxal olunanları dərc et** publishes
  them as for the articles (owner's decision, before expert review).
  - Meals: səhər → breakfast, nahar → lunch, şam → dinner, qəlyanaltı and
    desert → snack (the app has no dessert meal). The sheet's sections
    (smoothies, party table, cheese board…) and difficulty are not used.
  - Plate groups: paxlalı and balıq count as protein; "şirniyyat
    (arabir)" fills no group, so a sweet may have none (rule changed).
  - Servings may be up to 24 (cookie batches; was 12).
  - The sheet's notes are in Azerbaijani only and are not imported. Food
    safety notes the dietitian must put into the recipes (az, ru, en):
    pasteurised cheese in pregnancy (beet-carpaccio, classic-cheese-board,
    azerbaijani-cheese-board), chicken cooked through
    (thyme-chicken-celeriac), cross-contamination with gluten
    (tahini-almond-cookies).

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
  - A private S3 bucket (`deploy/aws/prod/media.tf`). The server uses
    the ECS task role, with no access keys, and its own SigV4 signer tested
    against AWS's examples.
  - Uploads stay under `uploads/`. `syncPublicMedia` copies an image to
    `public/` only while published content uses it, and removes the copy
    when nothing published does.
  - The bucket has no public access at all. The server serves the
    `public/` copies itself at `/media/<id>.jpg` (`PublicMedia`): only
    UUID names, a small in-memory cache that `syncPublicMedia` clears
    when an image is taken off, and a one-hour browser cache, so a
    removed image (for example an expert's photo) disappears within the
    hour. Local development and tests keep images in memory.
- **App:** `PublicContent.image` gives the URL, size and alt text. The app
  shows it with the alt text as its screen-reader label, and shows nothing
  if it fails to load. Images come from our own server like the API; no
  new processor is involved.
- **Deletion:** only admins can delete an image, and only if no draft or
  published content uses it. Uploads, edits and deletions are audited.
- **People in images:** expert photos are the expert's personal data. The
  written consent must cover the photo (lawyer to confirm the form). Images
  showing anyone else need their written permission, noted as the licence.

### Exercise videos

Each exercise can have one short video (`video` in its content, next to
`image`), shown muted and looping in the workout player. Videos follow the
image rules above (`MediaAsset.mediaType = video`, licence, alt text in
three languages, public only while published), with these differences:

- **Upload:** the panel accepts MP4, MOV, WebM or GIF up to 40 MiB and
  sends it in chunks of 768 KiB (`mediaAdmin.uploadVideoChunk`), so
  `maxRequestSize` stays as it is. Chunks wait in the bucket under
  `incoming/<staff id>/<upload id>/`; `finishVideoUpload` joins them and
  always deletes them, and the panel calls `abortVideoUpload` if sending
  fails.
- **Re-encoding** (`video_processing.dart`, ffmpeg in the server image):
  - The file type is checked by its first bytes. ffmpeg may read only the
    local file (`-protocol_whitelist file`), so a playlist cannot make the
    server fetch URLs.
  - Only the first video stream and the first sound stream are kept (the
    sound re-encoded to AAC, 96 kb/s; owner 2026-11-24). No subtitles,
    chapters or metadata (location, camera, title, dates).
  - At most 720 px, 30 fps, 30 s, H.264 MP4 with the index first, and at
    most 12 MiB afterwards.
  - One video at a time, two threads, a three-minute limit.
- **Serving:** `/media/<id>.mp4` with single byte ranges (206), which the
  iOS and Android players need.
- **Types are checked:** `image` must point to an image and `video` to a
  video, when saving and when publishing.
- **Needs people:** a trainer checks each move's form before its video is
  published, and the licence (stock, own filming, AI-generated) must allow
  use in the app. Anyone shown needs written permission.

## Catalogue texts in the admin panel (B2b-2)

The texts of product preferences, exercises and routine steps can be
edited in the panel (tabs **Seçimlər**, **Məşqlər**, **Addımlar**). They
are content items of the kinds `preference`, `exercise` and `step`, whose
slug is the catalogue id from code.

- **What the panel changes:**
  - Preferences: name and hint.
  - Exercises: name, how-to, caution, one image and one video.
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

**Statistics** (`statsAdmin`, admins only; the "Auditoriya" tab of the
dashboard. Editors lost access on 2026-11-19 by the owner's decision)
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

**Dashboard** (`dashboardAdmin`, admins only; decided 2026-11-19)
- **Shows:** accounts, sign-ups per day, daily/weekly/monthly active
  accounts, app opens by country, platform and app version, the most used
  tools (also by country), the most opened articles and recipes, banner
  views, taps and click rate, unread support. Periods: 7, 30 or 90 days.
- **Small numbers:** daily series and headline totals are shown as they
  are; in breakdowns (country, platform, tool, content, banner) any count
  under 10 is "<10".
- Nothing about a single user is ever shown.

**Usage statistics** (only with the **analytics consent**; its text already
names "screens opened, features used")
- **What the app counts** (`UsageRules` in `parla_shared`, `UsageMeter` in
  the app): app opens with the app version, tool screens opened, articles
  and recipes opened (by slug), banners shown (once per app run) and
  tapped. Never health or quiz answers, search words or product names.
- **How:** the app first reads the consent state; without it nothing is
  counted or sent. Counts wait in memory and are sent in small batches
  with the platform only (`activity.report`), when the app goes to the
  background or many counts wait. Each count is capped (50 per batch).
- **What the server keeps:** `usage_daily`, one total per day, country (from
  the profile, not the device), platform, event and target. No row per
  account. Totals are kept for 24 months.

**Active accounts**
- With the analytics consent the server stores a mark per account and day
  (`daily_active_mark`). The mark is an HMAC of the account id with the
  pseudonym pepper, never the id itself. It is the same every day, so an
  account is counted once per week and month.
- Marks are kept for **30 days** (decided 2026-11-19, was about two days),
  then deleted by the nightly job (`rollUpActivity`), which first turns
  each finished day into totals (`daily_active_count`: day, week, month,
  iOS, Android).
- Withdrawing the analytics consent and deleting the account remove all of
  the account's marks.

## Banners and campaigns (admin phase D1)

Banners are content items of the kind `banner`. The category is where the
card shows: `today` (home), `discover`, `blog` (under an article) or
`recipe` (under a recipe; at most one banner under each).

- **Fields:** title, short text, image, start and end date, optionally
  languages and countries, and one of two links:
  - an in-app link (a screen, or `article:slug` / `recipe:slug`);
  - or a brand's website (`url`, https only, no user name, password or
    port: `ContentRules.isAdUrl`).
- **Topics:** under articles and recipes a banner may be limited to some
  article categories or recipe meals (`topics`). This is context only: the
  phone compares it with the category of the page it shows.
- **Brand campaigns:** a banner with a `sponsor` or a `campaign` is a paid
  brand campaign. The app always shows it with an **"Ad · <brand>"**
  label.
- **Approval** (`ContentRules.reviewerRole`):
  - The team's own banners: an admin publishes directly. An editor's
    banner needs an admin's approval.
  - Brand campaigns: always an expert's approval (no "harmful" wording, no
    scores, no health promises); an admin cannot skip it.
  - All other content is unchanged (expert approval).
- **Targeting on the phone:** the server sends every published banner the
  same way. The app decides by date, language, country and the page's
  topic (`ContentRules.bannerVisible`). Nothing about the user is sent for
  this. Health, quiz and journal answers can never be used for targeting:
  the model has no such fields. Views and taps are counted as anonymous
  daily totals, only with the analytics consent (see the dashboard above).
- **Brand websites:** tapping such a banner first asks ("Going to the
  brand's site", with the host name), then opens the browser. The app adds
  only `utm_source=parla`, `utm_medium=app` and `utm_campaign=parla-<id>`
  (`ContentRules.adLink`); tags the brand set itself are kept. No user id,
  device id or anything else about the user is added.

### Ads section (admins only)

The admin panel's **Reklam** section keeps:

- **Advertisers** (`advertiser` table): the company name, its general email
  (optional), contract number and dates, and a note. No contact person's
  name or phone (decision of 2026-11-21): those stay in the signed
  contract.
- **Campaigns** (`ad_campaign` table): advertiser, title, start and end
  date, and a price or budget note for the team (never shown in the app).

A banner joins a campaign in the banner editor (`campaign` in its JSON).
The server then:
- writes the advertiser's company name into `sponsor`, on saving and again
  on publishing, so the label always matches the contract;
- refuses banner dates outside the campaign's (`content.outside_campaign`);
- refuses to delete a campaign that banners name, an advertiser with
  campaigns, or a change of campaign dates that its banners no longer fit.

**Reports** (`AdAdminEndpoint.report`): views, taps and tap rate of a
campaign's banners, by day and by banner, from the anonymous daily usage
totals. Counts under 10 are `null` and show as "<10". The panel downloads
the report as CSV (semicolons, UTF-8 mark, cells that could run as
spreadsheet formulas are escaped) or as an A4 PDF made in the browser with
the panel's own font. Only these totals go to an advertiser. Every change
and every report opened is audited (`ads.*`, ids only).

## Shop (phase 1: catalogue and partner links)

Products are content items of the kind `product`. Their category is a Shop
area: `face`, `hair`, `body`, `makeup` or `other`.

- **Fields:** name and description in three languages, brand, image, price
  in manat (`"12.50"`; `ContentRules.priceQepik`).
- **How it is sold** (`sale`):
  - `redirect`: on a partner's website (`url`, https only, as for
    banners). The app asks before leaving and adds only Parla's campaign
    tags.
  - `own`: sold in the app; the `seller` is `parla` or `brand` (the brand
    sells and Parla takes the payment). The app does not show these until
    in-app payment (phase 2) is switched on.
- **Review:** every product needs an expert's approval, admins included. The
  texts must have no "harmful" wording, no scores and no health promises.
- **Ads:** a product joined to a campaign is shown first, with the
  "Ad · <brand>" label; the server writes the brand from the advertiser
  (a brand typed by hand is dropped). Campaign reports count its opens and
  button taps.
- **Nothing about the user chooses products:** no routine, health, quiz or
  journal answers; the list is the same for everyone, filtered only by the
  category the user picks.
- **Counting:** product opens and button taps (`UsageEvent.product`,
  `productTap`, by slug) as anonymous daily totals under the analytics
  consent; the dashboard shows the top products and taps.

## Shop (phase 2: in-app sales with Epoint)

Products with `sale: own` are sold in the app. Sales stay **closed** until
the server has Epoint's keys (`epointPublicKey`, `epointPrivateKey`) **and**
the `shopSalesOpen` switch is on (Terraform `enable_shop_payments`,
`shop_sales_open`). Until then the app does not offer these products.

- **Paying:** the app asks the user to confirm. The confirmation shows the
  product, the price and the seller (Parla, or the brand with Parla taking
  the payment). The server then:
  - creates the order with the **published** price;
  - asks Epoint for a payment page (`/api/1/request`, signed
    `base64(sha1(key + data + key))`);
  - the app opens that page in the browser.

  The card is entered on Epoint's page only. The payment description holds
  only the order number.
- **Result:** Epoint posts a signed report to `/shop/epoint/result` (the
  load balancer sends `/shop/*` to the web server).
  - A report with a bad signature, an unknown order or a wrong amount
    changes nothing.
  - A success marks the order paid, once.
  - The cardholder's name, card mask and bank references in the report are
    never stored or logged.
  - If a report is lost, "My orders" asks Epoint for the status
    (`/api/1/get-status`).
- **Return page:** `/shop/done` asks the buyer to go back to the app. It
  shows nothing about the order.
- **Orders** (`shop_order`) hold the following, and no card or delivery
  details:
  - number, account, product, its name at the time, brand, seller;
  - quantity, amounts in qəpik, status, Epoint's transaction id.

  Delivery details come in the next step: encrypted and deleted after
  delivery, owner's decision of 2026-11-21, lawyer to confirm.
- **Limits:** at most 10 items per order and 5 orders per account per hour.
- **Admin → Sifarişlər:** admins mark an order shipped or delivered, cancel
  an unpaid order, or refund a paid one through Epoint (`/api/1/reverse`).
  The panel never shows the buyer's account. Every step is audited
  (`shop.*`).
- **Account deletion:** orders are kept for accounting, with the account's
  id replaced by its pseudonym (as for consent records).

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
  Manager (`parla-prod/fcm`, stored by
  `deploy/aws/put-prod-fcm-secret.sh`).
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

## Suggested Check preferences

The routine rules name product preferences for some quiz answers (for
example fragrance-free with sensitive skin, lanolin-free with a lanolin
allergy). The Check screen works them out **on the phone** from the user's
quiz answers (`buildRoutine(answers).preferences`) and shows them as
"Suggested from your quiz". Nothing is turned on by itself: the user adds
each one, and hidden preferences are never suggested.

## Renewing an older health consent (CON-3)
When the granted health consent is an older text version (for example
`health-2026-11-draft1` to `draft4`), Today shows a card. The next screen
shows the current text with **I agree** and **Not now**.
- **Not now** changes nothing. The old consent stays valid for what it
  covered, and data it does not cover stays on the phone (the server's
  coverage sets).
- **I agree** records the current version as a new consent record. The
  old record is kept unchanged (append-only). The app then syncs again, so
  routines, lists, sport and nutrition kept on the phone are sent
  encrypted.

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
  used since, and for the HKDF-derived key of support messages. Moving those to KMS as well is a follow-up.
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

**Audit log view (admin panel, "Audit jurnalı").**
- **Who:** admins only (`AuditAdminEndpoint.list`, `requireStaff` with the
  admin role); editors, experts and support get `staff.forbidden`.
- **What it shows:** newest first, 100 rows a page (cursor `beforeId`).
  Filters: action prefix (`content.`, `consent.` …, where `_` matches
  literally), actor role, object id and a date range.
- **Ids only:** the view shows the stored ids, shortened, and copies the
  whole id on tap. Nothing resolves an id to an email or a name.
- **Read-only:** there is no update, delete or export.
- **Audited itself:** opening the log (its first page) writes
  `audit.viewed`; later pages do not.

## Blog articles: Markdown, Google Docs, images and hashtags

**Text**
- An article's text is Markdown: headings, bold, italic, lists, quotes and
  https links. Raw HTML is never rendered.
- `ContentRules` refuses links that are not https and images that are not
  the team's own uploads (`![alt](media:<id>)`).

**Admin panel**
- The editor has **Google Docs-dan yapışdır**: it reads the clipboard's
  HTML (the browser may ask for permission) and turns it into Markdown
  (`parla_admin/lib/markdown/html_to_markdown.dart`).
  - Kept: headings, bold, italic, lists, links.
  - Unwrapped: Google's link redirect.
  - Dropped: styles, images and unsafe links.
- Every save tidies invisible characters, "●" bullets and extra blank
  lines.
- **Şəkil əlavə et** uploads or picks an image and inserts
  `![](media:<id>)`. Images from Google Docs are not taken over.
- **Önizləmə** shows the result.

**Images and hashtags**
- Inline images follow the same rules as covers: a licence, alt text in
  az/ru/en before publishing, and a public copy only while published
  (`MediaRules.imageIdsOf`). `PublicContent.inlineImages` gives the app
  their URLs.
- Hashtags are per language (`tags: {az: [...], ru: [...]}`, at most 10,
  letters, digits and `_`).
- The app shows the user's language's tags under the title; tapping one
  lists the articles with that tag.

## Not done yet (tracked, not forgotten)

| Item | Checklist | Planned |
| --- | --- | --- |
| Re-ask the pregnancy question after 12 months | RET-2 | With habit and health data history |
| Privacy policy and terms texts: drafts in `parla_flutter/assets/legal/` (az, en; ru after the lawyer's edits). The app shows a document only when it has no draft banner, no ⚖️ lawyer question and no company placeholder (`LegalDoc.isReady`); a test keeps the drafts hidden | — | Lawyer; company details from the owner |
| Apple and Google sign-in | US-01 | Needs the Apple and Google developer accounts (company registration) |
| Data region confirmed by the lawyer (prod runs in AWS Frankfurt, email by SMTP via info@anacan.az) | RES-1, RES-5 | Before sign-ups open |
| Closed beta: sign-ups only with an invite code, until the legal and expert checks are done | — | Before the first beta build |
| Push setup: Firebase project, APNs key in Firebase, Push Notifications capability for the App ID, Codemagic FIREBASE_* variables, the FCM secret and `enable_push` | — | You, before testing push |
| Privacy policy and processor list: Firebase (Google) for push, the marketing push under the marketing consent | — | Lawyer, before push is used |
| Privacy policy: support conversations (purpose, encryption, 12-month retention, support role), announcements | — | Lawyer, before the beta |
| Advertising law check for brand campaigns (Azerbaijan "Reklam haqqında" law; labelling, cosmetics claims) | — | Lawyer, before the first brand campaign |
| Shop in-app sales: sale terms, returns and withdrawal, the seller shown (Parla or the brand with Parla as payment agent), keeping orders under a pseudonym after account deletion (for how long), Epoint as processor | — | Lawyer, before shop_sales_open |
| Shop in-app sales: fiscal receipts (e-kassa) and VAT for Parla's own and brands' sales | — | Accountant, before shop_sales_open |
| Shop: consumer-law texts for partner products (Parla shows, the partner sells), price and stock disclaimers, cosmetics claims in product texts | — | Lawyer, before the Shop is public |
| Privacy policy: ads under articles and recipes chosen by the page's topic (context, not the user), links to brands' websites (asked first; only Parla's campaign tags added; the brand's own privacy rules apply there), campaign reports given to advertisers as totals with counts under 10 hidden, advertisers' company data kept in the panel | — | Lawyer, before the first brand campaign |
| Privacy policy: usage statistics under the analytics consent (what is counted, 30-day activity marks, 24-month daily totals, banner figures shared with advertisers as totals), staff look-ups of accounts, deletion on request | — | Lawyer, before the beta |
| Privacy policy text for staff access, the admin panel and push notifications | — | Lawyer, before phase D |
| Security measures: staff sign-in is a password or an emailed one-time code (no second factor, decisions of 2026-11-18 and 2026-11-22); staff mailboxes need two-step verification | — | Lawyer to note in the GDPR Art. 32 description |
| Real-device test of reminders (Android 13+ permission, reboot, iOS foreground) | M7 | Before the beta |
| Expert review of the preference ingredient lists (`product_preferences.dart`) | — | Before launch |
| Dietitian check of the imported recipes, their plate groups and allergens; dermatologist review of the 32 blog articles (especially retinoid-first-steps, glp1-skin, gel-manicure-safety, exosomes-pdrn, ai-skin-analysis; the FAQ wording "Saç boyası saça zərərlidirmi?" and "Ucuz eynək zərərlidirmi?"), stylist review of the fashion ones | — | Before publishing them |
| Trainer or physiotherapist review of the exercises, numbers and safety rules (`sport_rules.dart`, `exercise_text.dart`) | — | Before launch |
| Licensed exercise photos (shown by exercise id) | — | When the photos arrive |
| Optional on-device photo skin analysis (kept on branch `skin-photo`, not merged) | — | Postponed; needs lawyer approval and a DPIA, plus dermatologist review, before it returns |
| Expert consent form to cover the profile photo; permission wording for people shown in content images | — | Lawyer, before publishing expert photos |
| Restricted database role for the server (no DDL; triggers stay owned by an admin role) | AUD-2 | With the production database setup |
| Move the HKDF-derived key (support messages) to KMS and retire the KEK once all health keys are on KMS | ENC-3 | After all `kekVersion` 1 keys have moved |
| Barcode scanning | — | Later step |

## Known environment issue

Serverpod 4.1.1 binds its servers to the IPv6 wildcard address. Machines
without IPv6 support (some containers) cannot run the server tests; CI
runners and normal developer machines can.
