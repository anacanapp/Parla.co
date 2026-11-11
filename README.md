# Parla

A personal beauty and care guide for women aged 18+: routines for skin, hair
and body, product ingredient explanations with official sources, and habit
tracking. Launch market: Azerbaijan, then Türkiye, Kazakhstan and Uzbekistan.
Languages: Azerbaijani, Russian, English.

Parla processes health-related data. Read [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
before changing anything that stores or sends personal data.

## Repository layout

| Package | What it is |
| --- | --- |
| `parla_flutter` | User app: iOS, Android and web (Flutter) |
| `parla_server` | Backend (Serverpod, PostgreSQL) |
| `parla_client` | Generated client for the server. Do not edit by hand |
| `parla_shared` | Pure Dart rules used by both sides: age gate, markets, consent texts |

## Status

Sprint 1 (foundation) covers screens M-01 to M-08 of the screen list:
language, welcome, age gate, sign-in with an emailed one-time code, country
and consents. The home screen (M-14) and product search (M-20) are
placeholders.

**No real user data may be collected yet.** The company is not registered,
the legal review is open and the production data region is undecided
(roadmap gate A).

## Getting started

Requirements: Flutter 3.47 or later, the Serverpod CLI 4.1.1
(`dart pub global activate serverpod_cli 4.1.1`) and OpenSSL. Docker is not
needed: development and tests use an embedded PostgreSQL that Serverpod
manages. The embedded database refuses to run as root.

```bash
flutter pub get
./tool/create_local_passwords.sh
cd parla_server && serverpod start
```

`serverpod start` runs the server, applies migrations and launches the app.
In development, sign-in codes are written to the server log instead of being
emailed.

## Tests

```bash
(cd parla_shared && dart test)
(cd parla_server && dart test)
(cd parla_flutter && flutter test)
```

CI runs the same tests plus analysis, formatting, a check that generated code
is up to date, and a secret scan.
