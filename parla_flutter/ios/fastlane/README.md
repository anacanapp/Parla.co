# App Store listing

- `metadata/tr/`: store texts. The listing is Turkish only: App Store
  Connect has no Azerbaijani localisation, and Turkish is the closest.
  Limits: name and subtitle 30 characters, keywords 100 (comma separated,
  no spaces after commas), promotional text 170, description 4000.
- `metadata/tr/privacy_url.txt` and `support_url.txt` are still missing on
  purpose: add them once the pages are public. Apple requires both before
  a review can be submitted.
- `screenshots/tr/`: 1320×2868 (iPhone 6.9"), rendered from the real
  screens in Azerbaijani with invented data by
  `test/store_screenshots_test.dart`:
  ```bash
  flutter test test/store_screenshots_test.dart --dart-define=STORE_SCREENSHOTS=true
  ```
- Wording rules (product decision and EU MDR): no "harmful", no promise to
  treat, diagnose or cure; ingredient information stays neutral. Texts must
  be checked by the lawyer before the first public release.

Upload: Codemagic workflow **iOS → App Store listing**. It changes only the
listing of the version being prepared; submitting for review stays a
manual step in App Store Connect.
