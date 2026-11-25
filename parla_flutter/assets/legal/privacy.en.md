# Parla — Privacy policy

- Effective date: {{effectiveDate}}
- Document version: 2

*This is a translation of the Azerbaijani text.*

## 1. Who we are

The Parla app ("Parla", "we") is provided by the company below.

- Company: {{legalName}}
- Tax ID (VÖEN): {{taxId}}
- Registered address: {{address}}
- Contact email: {{email}}
- Data protection officer: {{dpo}}

We decide the purposes and means of the processing of personal data
described in this policy.

This policy is based on the Law of the Republic of Azerbaijan "On Personal
Data". We also follow the European Union's General Data Protection
Regulation (GDPR) as a high standard.

## 2. In short

- Parla is a beauty and care guide for women aged 18 and over. It gives no
  medical advice, makes no diagnosis, offers no treatment and does not
  replace a doctor.
- We keep only what is needed: the sign-in email, birth year, country and
  language.
- Health-related answers are stored on the server only with a separate,
  explicit health consent, and only encrypted.
- Habit logs (water, sleep, movement, routine ticks) and the journal are
  never sent to the server; they stay on your phone only.
- The three consents (health, analytics, marketing) are separate and all are
  off by default. You can withdraw them at any time.
- We do not sell your personal data and do not give it to advertisers.
- You can download your data from the app and delete your account
  immediately.

## 3. Data we never collect

Parla does not ask for or store:

- your name;
- your phone number;
- your full date of birth (only the birth year is stored);
- your location;
- an advertising identifier;
- your photos (users never upload photos to the app);
- your weight or height.

## 4. What data we process

### 4.1. Account data

- **Email address** — to sign in.
- **Birth year** — for the 18+ age check and an age-appropriate routine. The
  full date of birth is not stored. Someone who turns 18 this year is asked
  whether the birthday has passed; only the birth year is stored. No account
  is created for a person under 18, and nothing they entered is stored.
- **Country** — to determine the market where the service is open. Only
  Azerbaijan is open today.
- **Interface language** — Azerbaijani, Russian or English.
- **Registration date.**

### 4.2. Sign-in data

To sign in, a one-time code is sent to your email from info@anacan.az by
SMTP. The sign-in session and the tokens that renew it are kept on the
server; short-lived access tokens expire on their own.

### 4.3. Consent records

Each consent decision (given or withdrawn) is stored as a separate record:
the type of consent, the decision, the version of the text shown, the
SHA-256 hash of the exact text in your language, the language, where the
decision was made (app or web) and the time. These records are never
changed; every change is added as a new record.

### 4.4. Non-health quiz answers

Answers in the care quiz about skin and hair type, goals and habits are
stored on the server, linked to your account. They are used to build your
personal routine.

### 4.5. Data stored with the health consent

Stored on the server, encrypted, only if you give the health consent:

- the health answers in the quiz: skin conditions (diagnoses), allergies,
  pregnancy and the categories of medicines you take;
- the routines you create and their daily ticks (free text may contain
  health details);
- your product preferences, the last 20 products you checked and your
  shopping list (at most 100 items);
- your answers to the fitness questions (goals, level, pregnancy or the six
  months after birth, pain or injury, a doctor's limit), the workout log
  (90 days) and the sound setting;
- daily plate entries: which food groups you had each day (no calories,
  weights or amounts; 90 days).

Without the consent this data stays on your phone only (see section 8).

### 4.6. Support conversations

The messages you send from the "Support" section of the app and the team's
replies (see section 12).

### 4.7. Notification token

Your phone's push token and platform (iOS or Android) are stored only if you
turn "Notifications" on yourself (see section 12).

### 4.8. Usage statistics

Only with the analytics consent (see section 9).

### 4.9. Orders

Orders you place once in-app sales are opened (see section 11).

### 4.10. Product search

A search by product name or brand goes through our server. The server
searches Parla's own catalogue and the open database Open Beauty Facts. The
app never contacts Open Beauty Facts directly, so your IP address does not
reach it. Search words are not stored, not logged and not linked to you; the
server keeps a 10-minute cache keyed by the query text only.

### 4.11. Technical data

The app talks to our server over HTTPS. Your IP address is processed
technically for this. The firewall (AWS WAF) limits the number of sign-in
requests from one IP address. No access logs (with IP addresses) of the load
balancer or the WAF are kept; only overall counts remain. Server logs are
kept for 30 days.

## 5. Purposes and legal bases

| Purpose | Data | Proposed legal basis |
| --- | --- | --- |
| Creating the account, signing in, managing the account | email, sign-in codes and sessions, country, language | performance of the contract (GDPR Art. 6(1)(b)) |
| 18+ age check | birth year | performance of the contract; legitimate interest (GDPR Art. 6(1)(f)) |
| Personal care routine | non-health quiz answers | performance of the contract |
| Personal care, workout and nutrition plan using health data | section 4.5 | explicit consent (GDPR Art. 9(2)(a) and Art. 6(1)(a)) |
| Proof of consents | consent records | legal obligation (GDPR Art. 7(1)); legitimate interest |
| Security, preventing misuse, audit | audit log (ids only), IP address (transient), blocking an account | legitimate interest; legal obligation (GDPR Art. 32) |
| Answering support requests | support conversations | performance of the contract; legitimate interest |
| Service notification about a support reply | push token | your turning notifications on (consent) |
| Marketing notifications | push token, profile language and country | marketing consent |
| Usage statistics | section 9 | analytics consent |
| General anonymous statistics (counts of accounts, sign-ups, age bands, country and language, consent decisions, non-health quiz answers) | account data, non-health quiz answers | legitimate interest |
| Orders, payment, refunds and accounting | order data | performance of the contract; legal obligation |
| Responding to legal requirements, defending rights | as needed | legal obligation; legitimate interest |

## 6. Consents

Parla asks for three separate consents. All are off by default and none is
required to use the app. A consent can be given only for its current text
version; withdrawing always works. Withdrawing a consent does not affect the
lawfulness of processing before it.

You manage consents in Profile → Privacy centre → Consents.

### 6.1. Health consent

Current text (version `health-2026-11-draft5`):

> "I give explicit consent to the processing of my answers about skin
> conditions, allergies, pregnancy and the categories of medicines I take,
> of the routines I create and their daily ticks, of my product preferences,
> the products I check and my shopping list, of my answers to the fitness
> questions (pregnancy, injuries, goals) and the workouts I do, and of my
> daily plate entries, solely to build and keep a personal and safe care,
> workout and nutrition plan. This data is stored encrypted, is not shared
> with third parties and is not used for analytics. I can withdraw consent
> at any time in Settings → Privacy; the data is then deleted from the
> server within 24 hours."

Earlier versions covered less data. If you agreed to an older version, the
old consent stays valid for what it covered; data it does not cover stays
on your phone only. The app shows you the new text and you can choose
"I agree" or "Not now". The old record is not changed.

**When you withdraw it:** the server copy of your health answers, own
routines, product preferences and shopping list, fitness and plate data,
and their encryption key, are deleted immediately, in one transaction. The
copies on the phone stay. The routine is built more cautiously. You can
give the consent again later.

### 6.2. Analytics consent

Current text (version `analytics-2026-11-draft1`):

> "I agree to the collection of usage statistics (screens opened, features
> used) under an identifier that does not directly reveal who I am, to
> understand how the app is used. My health answers are never sent to
> analytics."

**When you withdraw it:** the app stops counting and sending, and your
account's daily activity marks are deleted (see section 9).

### 6.3. Marketing consent

Current text (version `marketing-2026-11-draft1`):

> "I agree to receive emails with Parla news and tips. I can unsubscribe via
> the link in any email."

With this consent, and if you have turned notifications on, you may also
receive push notifications about Parla news (see section 12).

**When you withdraw it:** no marketing notifications or emails are sent to
you.

## 7. How we protect health data

- Health data is encrypted with a separate key for each user (AES-256-GCM).
  That key is itself protected by an AWS KMS key and bound to your account:
  a record copied to another account does not decrypt.
- When you withdraw the consent or delete the account, the key is deleted
  and the data on the server becomes unreadable.
- The Parla team, admins included, cannot see your health answers,
  routines, lists, fitness or nutrition data in the admin panel.
- Health data is not used for analytics, advertising, choosing banners or
  products, or choosing the recipients of marketing notifications.
- The answer to the "warning signs" question only decides whether the "see a
  doctor" screen is shown. It stays on the phone; the server does not accept
  it.

## 8. Data that stays only on your phone

The following is not sent to our server, and we do not process it:

- **Habit logs:** water, sleep, movement and routine step ticks, weekly
  steps. Only days with an entry are kept; entries older than 90 days are
  deleted automatically. They stay on the phone even if you give the health
  consent.
- **Journal:** the text you write in the Journal is never sent to the
  server, not even with the health consent. It is kept only on your phone,
  encrypted; Parla does not process it and the Parla team cannot see it. If
  you lose the phone or remove the app, the journal is lost too. An entry
  may be up to 4,000 characters, with at most 1,500 entries.
- **Reminders:** the phone itself schedules reminders for the morning and
  evening routine and the sleep entry. The settings (on/off and time only)
  are kept on the phone. Reminder texts are neutral and show no health
  information on the lock screen.
- **Without the health consent:** your own routines, product preferences,
  shopping list, fitness and plate data.
- So that the app works offline, the phone also keeps an encrypted copy of
  the documents stored on the server.

This data is kept in the phone's secure storage (iOS Keychain; on Android,
encrypted with an Android Keystore key), separately for each account;
another person using the same phone does not see it. Signing out keeps it
for the next sign-in of the same account. After the app is reinstalled, old
entries are deleted on the first start. If you have signed in on other
phones, the entries there stay until the app is removed there.

You can delete this data from the Privacy centre or add it to your data file
(see section 17).

## 9. Usage statistics (only with the analytics consent)

Without the consent the app counts and sends nothing.

**What is counted:** app opens and the app version, tool screens opened,
articles, recipes and products opened, banners shown and tapped, taps on
product buttons. Health or quiz answers, search words, product names and the
journal's content are never counted (for the journal only the opening of the
screen is counted).

**How:** counts wait in the app's memory and are sent in small batches with
the platform (iOS/Android) only.

**What the server keeps:**

- Daily totals: day, country (from the profile, not the device), platform,
  event and target. There is no row per account. These totals are kept for
  **24 months**.
- To count active accounts, one mark per day: an HMAC of the account id with
  a secret key, never the id itself. Marks are kept for **30 days**, then
  turned into daily, weekly and monthly totals and deleted.
- Withdrawing the analytics consent or deleting the account removes all of
  the account's marks.

The admin panel shows totals only; in breakdowns any count under 10 is shown
as "<10". Nothing about a single user is shown.

## 10. Advertising, banners and brand websites

- The app may show Parla's own banners and brands' paid campaigns. Paid
  campaigns are always labelled "Ad · brand name".
- **Banners are not chosen with data about you.** The server sends every
  published banner to everyone in the same way. The phone itself decides
  which banner to show by the date, the language, the country in your
  profile and the topic of the page you opened (for example the category of
  an article). Nothing about you is sent for this. Health, quiz and journal
  answers can never be used for targeting.
- **Brand websites:** when you tap such a banner, the app first asks you and
  shows the site's name. Only Parla's campaign tags are added to the link
  (`utm_source=parla`, `utm_medium=app`, `utm_campaign=parla-<number>`). No
  user or device id is added. On the brand's site, the brand's own privacy
  rules apply.
- **Reports to advertisers:** advertisers receive only totals (views, taps,
  tap rate, by day and by banner). Counts under 10 are hidden. These counts
  are collected only from users who gave the analytics consent.
- **Advertisers' data:** the admin panel keeps the advertiser company's name,
  its general email (optional), and the contract number and dates. A contact
  person's name and phone are not entered in the panel; they stay in the
  signed contract.

## 11. Shop

### 11.1. Partner products

"Parla Mağaza" (the Parla Shop) shows partners' products. The purchase
happens on the partner's website. Parla passes nothing about you to the
partner; only Parla's campaign tags are added to the link. The partner's own
terms and privacy rules apply on its site. Products are not chosen by your
routine, health, quiz or journal answers; the list is the same for everyone,
filtered only by the category you pick.

### 11.2. In-app sales (not yet open)

In future some products may be sold in the app. The seller is either Parla
or the brand (the brand sells and Parla takes the payment); the seller is
shown before payment.

- **Payment:** is made on Epoint's payment page. Your card details are
  entered only on Epoint's page and never reach Parla. The payment
  description holds only the order number. The cardholder's name, card mask
  and bank references in Epoint's report are not stored or logged.
- **An order holds:** the order number, account, product, its name at the
  time, brand, seller, quantity, amounts, status and Epoint's transaction id.
  No card or delivery details are stored.
- **Delivery details** will be added in a later step: stored encrypted and
  deleted after delivery.
- **When the account is deleted** orders are kept for accounting, with the
  account id replaced by a pseudonym.
- In the admin panel orders are handled without showing the buyer's account.

## 12. Messages, support and notifications

### 12.1. Announcements

The Parla team's announcements are shown under "Messages". The phone itself
decides which ones to show (date, language, country). Read state is not
sent anywhere.

### 12.2. Support conversations

- **Purpose:** to answer your questions.
- **Encryption:** each message is encrypted on the server (AES-GCM) with a
  key bound to your account. This key is separate from the health key, so
  withdrawing the health consent does not delete support conversations.
- **Who reads them:** only staff with the "support" role and admins. The
  panel's list shows no message text. Opening, replying and closing are
  recorded in the audit log with ids only.
- **Retention:** a conversation is deleted **12 months** after the last
  message or when your account is deleted. Conversations are included in
  your data file.
- We give no medical advice. In an urgent or serious case, see a doctor.
  Please do not write health details in support messages that are not
  needed.

### 12.3. Push notifications

- **Provider:** Google's Firebase Cloud Messaging (FCM).
- **Only by your choice:** the phone's permission is asked only when you turn
  "Notifications" on in "Messages"; the token is stored only after that.
- **Service notification:** when the team replies in support, you get "The
  Parla team replied"; the reply's text is not in the notification.
- **Marketing notifications:** sent only to accounts that give the marketing
  consent and whose profile language and country match the campaign.
  Recipients are never chosen by health or quiz answers. Notification texts
  contain no personal data.
- **The token is deleted:** when you turn notifications off, sign out,
  delete the account, when FCM reports the token gone, and after 90 days
  unseen.

## 13. Who has access to your data

### 13.1. The Parla team

The admin panel is for invited staff only. Roles:

- **admin** — everything, including staff accounts;
- **editor** — writes content;
- **expert** — reviews and approves content in their field;
- **support** — reads and answers support conversations.

Only admins can look up a user account, and **only by the exact email
address** (there is no list and no partial search). The look-up shows only
the email, registration date, country, language, blocked state and the
latest consent decisions. Health data, quiz answers and the birth year are
never shown. Every look-up is recorded in the audit log.

Admins can block an account that breaks the rules (sign-in stops, nothing is
deleted) and can delete the account of a user who asks by email. Every staff
action is recorded in the audit log with ids only.

### 13.2. Processors (service providers)

| Provider | What for | Which data | Where |
| --- | --- | --- | --- |
| Amazon Web Services (AWS) | server, database, backups, images, keys (KMS), secrets, logs, WAF | all data on the server (health data encrypted) | Frankfurt, Germany (eu-central-1) |
| The provider of the anacan.az mailbox | sending sign-in codes from info@anacan.az | email address, sign-in code | to be confirmed |
| Google (Firebase Cloud Messaging) | push notifications (only if turned on) | push token, notification text | to be confirmed |
| Epoint | payment (once in-app sales are open) | order number and amount; you enter card details directly with Epoint | Azerbaijan (to be confirmed) |

**Not processors:**

- **Cloudflare** only answers the domain name (DNS) and does not see the
  traffic.
- **Open Beauty Facts** receives only the search text from our server;
  nothing about you.
- **Apple App Store and Google Play** distribute the app under their own
  rules.
- **Phone, WhatsApp, Instagram:** when you contact an expert from their
  profile with these apps, the conversation happens outside the app,
  directly with the expert; Parla does not see it. Those services' own rules
  apply.
- The app's fonts are bundled in the app; no font is loaded from Google, so
  your IP address does not go there.

### 13.3. Public authorities

We may give data to competent public authorities when the law requires it.

We do not sell your personal data.

## 14. Where data is stored and cross-border transfer

Our servers, database, backups, images, keys and logs are in AWS's Frankfurt
region (Germany, European Union). This means the data of users in
Azerbaijan, including encrypted health data, is transferred outside
Azerbaijan.

## 15. Retention periods

| Data | Period |
| --- | --- |
| Account data (email, birth year, country, language), non-health quiz answers | while the account exists; deleted immediately when it is deleted |
| Sign-in sessions and refresh tokens | deleted immediately with the account; short-lived tokens expire on their own |
| Data kept on the server with the health consent (section 4.5) | while the consent is in force; deleted immediately on withdrawal or account deletion |
| Own routine ticks, workout log, plate entries | at most 90 days |
| Consent records | while the account exists; **3 years** after account deletion, under a pseudonym |
| Audit log (ids only) | **1 year**; on account deletion the id is replaced by a pseudonym |
| Support conversations | **12 months** after the last message, or on account deletion |
| Push token | until notifications are turned off, sign-out or account deletion; deleted after 90 days unseen |
| Daily activity marks (HMAC) | **30 days** |
| Daily usage totals (not per account) | **24 months** |
| Orders | as long as needed for accounting; under a pseudonym after account deletion |
| Delivery details (future) | until delivery, encrypted |
| Product search cache (text only, not linked to you) | 10 minutes |
| Server logs | 30 days |
| Database backups | 14 days |
| On the phone: habit logs | 90 days; deleted on reinstall or account deletion |
| On the phone: journal, reminder settings, document copies | until you delete them, the account is deleted or the app is reinstalled |

The pregnancy answer is asked again after a while: in the skin quiz,
"pregnant", "breastfeeding" and "planning a pregnancy" after 12 months; in the
sport questions, "pregnant" after 12 months and "the six months after birth"
after 6 months. The month of the answer is kept inside the encrypted data.
Until you confirm, change or delete the answer, a reminder shows on the home
screen and the old answer keeps applying as the careful choice; nothing is
deleted automatically.

## 16. Security

- All traffic uses HTTPS; HTTPS ends at the load balancer in Frankfurt, and
  no third-party CDN is used.
- The database, its backups, the secrets and the logs are encrypted with a
  KMS key. Health data is additionally encrypted with a separate key per
  user.
- The database and the image storage are not reachable from the public
  internet.
- The WAF blocks known bad addresses and limits sign-in requests.
- Consent and audit records can only be added; the database itself refuses
  other changes.
- Staff access is limited by roles, every action is audited and a panel
  session lasts at most 12 hours.

## 17. Your rights

You have the right to:

- **Information and access:** know which data about you we process.
- **A copy of your data and portability:** Profile → Privacy centre →
  "Download my data". The file (JSON) contains everything we keep on the
  server (health answers decrypted, support conversations included), plus
  the habit logs, own routines, lists, fitness data, journal and reminder
  settings on this phone. The file is created at that moment, handed to you
  through the phone's share menu and not stored on our server.
- **Rectification:** have wrong data corrected.
- **Erasure:** you can delete your account in the app at any time (section
  18). You can delete the habit logs on the phone separately.
- **Withdraw consent:** in the Privacy centre, at any time.
- **Restriction and objection:** object to processing based on legitimate
  interest.
- **Complaint:** complain to the competent supervisory authority.

For requests that cannot be done in the app, write to {{email}}.
Please send your request from the email address you registered with, so we
can check that the account is yours.

## 18. Deleting your account

Profile → Privacy centre → "Delete account". You type the word "SİL" to
confirm. You can download your data before deleting.

**Deleted immediately, in one transaction:** your profile, quiz answers,
health data and its encryption key, own routines, product preferences and
lists, fitness and plate data, support conversations, push token, activity
marks, your sign-in account, sessions and refresh tokens. **On this phone**
the habit logs, journal, copy of own routines and reminder settings are also
deleted, and reminders are cancelled.

**Kept without your name or email, under a pseudonym:** the consent history
(3 years), security (audit) records (1 year) and in-app orders (for
accounting). The pseudonym is an HMAC of the account id with a secret key.

**Please note:** if you signed in on other phones, the phone data there stays
until the app is removed from those phones.

You can also have your account deleted by asking us by email. An admin runs
the same deletion.

## 19. Age limit

Parla is only for people aged 18 and over. Age is checked both in the app and
on the server. No account is created for a person under 18, and nothing they
entered is stored. If you know that data of a person under 18 has reached
us, write to {{email}}.

## 20. Automated decisions

The care routine, workout plan and suggested product preferences are built
from your quiz answers with fixed rules. The rules are cautious: for
example, a step not suited to pregnancy is left out unless the answer is
"no". These suggestions have no legal effect on you and are not medical
decisions. You are not obliged to accept a suggestion. Profiling is not used
for advertising or marketing.

## 21. Experts and other people

The profiles of experts shown in the app (name, specialty, contact, photo)
are published with the experts' signed consent. Other people shown in content
images need to have given written permission. These people's data is
governed by separate consent documents.

## 22. Changes to this policy

When we change the policy, we publish the new version in the app and update
its date. We tell you about important changes in the app. When a consent text
changes, the old text is never edited; a new version is added and your
consent is asked again.

## 23. Contact

- Company: {{legalName}}
- Registered address: {{address}}
- Email: {{email}}
- Data protection officer: {{dpo}}
