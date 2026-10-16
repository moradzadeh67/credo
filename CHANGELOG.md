# Changelog

All notable changes to Credo are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project uses
[Semantic Versioning](https://semver.org/).

## [1.0.2] — 2026-10-16

### Added
- **Signed Android release builds**: `android/app/build.gradle.kts` now reads `android/key.properties`
  (git-ignored) and signs with the project upload key, falling back to the debug key when the file is
  absent. APK + AAB are attached to the release, with a `sha256` checksum.
- **GitHub Actions CI** (`ci.yml`): `flutter analyze` + `flutter test` on every push and PR to `master`.
- **Website** (`deploy-web.yml` + `landing/`): a crawlable landing page at `/` and the Flutter web app at
  `/app/` on GitHub Pages, with `robots.txt`, `sitemap.xml` and JSON-LD metadata.
- **Docs**: `docs/ARCHITECTURE.md`, `docs/PRIVACY.md`, `docs/RELEASE.md`, `SECURITY.md`, this changelog.
- **Demo GIF** in the README, captured from the running macOS app.

### Changed
- ⚠️ **Application id changed**: `com.example.credo` → **`com.moradzadeh67.credo`** (Android, iOS and
  macOS). Devices and the Keychain treat it as a **new app**: uninstall the old build and re-enter your
  OpenRouter key once.
- Display name is now **Credo** on every platform (`android:label`, `CFBundleName`, `PRODUCT_NAME`).
- Web `index.html`/`manifest.json` no longer use the Flutter template text (title, description, theme
  colour, app name).
- `flutter_launcher_icons` moved from `dependencies` to `dev_dependencies`.
- README restructured (badges, What is Credo?, Key Dependencies, Privacy, Release Signing, CI/CD,
  Known Limitations, FAQ, accurate development-environment versions).

## [1.0.1] — 2026-09-22

### Added
- Low-balance warning banners (20% and 5% thresholds).
- Burn-rate estimation ("days left at the current rate").
- JSON export of credit snapshots and key metadata.

### Fixed
- Dark/light theme consistency across the home and settings screens.

## [1.0.0] — 2026-09-22

First stable release.

### Added
- Secure API key storage (`flutter_secure_storage` — Keychain / Android Keystore).
- Real-time credit balance and daily / weekly / monthly / all-time usage.
- Material 3 theming with dark, light and system modes.
- Centralized `AppTheme` and a layered `models/ providers/ screens/ services/ theme/ utils/` structure.
- Android, iOS, macOS and Web targets.
