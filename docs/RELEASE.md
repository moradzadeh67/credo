# Credo — Release and Distribution

## Status

Active. Credo is distributed through **GitHub**: signed Android APK on the Releases page, and the
**web app + landing page** on GitHub Pages (`https://moradzadeh67.github.io/credo/`). There is no store
listing and none is planned at the moment.

## Where each platform stands

| Platform | Distribution | Signing |
|---|---|---|
| Android | GitHub release, signed `app-release.apk` (+ `.sha256`) | Upload key `Credo-upload.jks` (see below) |
| Web | GitHub Pages: landing at `/`, app at `/app/` | N/A |
| macOS | build from source (`flutter build macos --release`) | Not notarized yet |
| iOS | build from source (`flutter build ios --no-codesign`) | No signing / no TestFlight yet |

## Android release signing (2026-10-16)

- **App id**: `com.moradzadeh67.credo` (was the template `com.example.credo` before 2026-10-16).
- **Upload key**: `Credo-upload.jks` — PKCS12, alias `credo`, RSA 2048, validity 10000 days. It lives
  **outside the repository** at `~/Desktop/Credo-upload-key/Credo-upload.jks` on the author's machine,
  with a complete zipped backup (keystore + `key.properties` + passwords in a README) at
  `~/Desktop/Credo-upload-key.zip`.
- **Certificate** (`apksigner verify --print-certs`):
  `CN=Mohammadreza Moradzadeh, OU=Mobile, O=Credo, C=IR`,
  SHA-256 `8b399cbb6a8ace3429882b6bbd49b45b1b73a50ec6095b66ac93f2c617e75831`.
- **Wiring**: `android/key.properties` (git-ignored) points Gradle at the keystore;
  `android/app/build.gradle.kts` falls back to the **debug** signing config when the file is absent, so
  a fresh clone still builds.
- **Artifacts**: `flutter build appbundle --release` → `build/app/outputs/bundle/release/app-release.aab`
  (~53 MB); `flutter build apk --release` → `build/app/outputs/flutter-apk/app-release.apk` (~54 MB).
- **Never** commit the keystore, `key.properties` or the passwords.

> ⚠️ Changing the app id (done on 2026-10-16) means devices treat Credo as a **new app**: the previously
> installed `com.example.credo` build should be uninstalled, and the OpenRouter key has to be entered
> once again in the new build.

## CI/CD

| Workflow | Trigger | What it does |
|---|---|---|
| `ci.yml` | push / PR to `master` | `flutter analyze` + `flutter test` on Flutter 3.47.2 |
| `deploy-web.yml` | push to `master` | builds the web app (`--base-href /credo/app/`), assembles the landing page + app into the Pages site and deploys it |

## Checklist before every public release

1. `flutter analyze` clean and `flutter test` green.
2. `flutter pub get` resolves; no new secrets in `git status`.
3. Bump `version:` in `pubspec.yaml`; the release **tag must match** (`vX.Y.Z`) — the 1.0.0/1.0.1 tags
   did not match the pubspec at the time, which this checklist now prevents.
4. Build the signed APK + AAB and verify with `apksigner verify --print-certs`.
5. Create the GitHub release with `app-release.apk` and its `.sha256`.
6. Confirm the Pages deploy succeeded (`gh run list`).

## Outstanding

- macOS: code signing + notarization so Gatekeeper stops warning.
- iOS: no distribution (build check only).
- Possible future stores: nothing decided.
