# parla_admin

The Parla admin panel: a Flutter web app for the Parla team only. It talks
to the same Serverpod server as the app. See `docs/ARCHITECTURE.md`,
"Admin panel".

- Sign in with email and password, then the authenticator code (TOTP).
- Roles: admin, editor, expert. Accounts join only by an emailed invitation.
- No user health data is ever shown.

Run locally against the local server:

```bash
flutter run -d chrome
```

Build for staging (no files from Google's CDN):

```bash
flutter build web --release --no-web-resources-cdn --dart-define=SERVER_URL=https://<server>/
```
