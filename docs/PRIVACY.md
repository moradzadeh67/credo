# Credo — Privacy

Credo is built so that **your OpenRouter API key never leaves your own devices**.

## What Credo stores, and where

| Data | Where it lives | Notes |
|---|---|---|
| OpenRouter API key | System secure storage: **macOS/iOS Keychain**, **Android Keystore** (via `flutter_secure_storage`) | Never written to a plain file, never logged, never committed |
| Credit / usage snapshots (cached for display) | App memory; exported to JSON only when **you** tap export | The export file is written wherever you choose |
| App settings (theme, alert thresholds) | Local app preferences | No account, no sync |

## What Credo sends, and to whom

Credo talks to **exactly one service: the OpenRouter API** that you configure.

- `GET /api/v1/key` — key validity, limits and usage
- `GET /api/v1/credits` — remaining credits

Requests go over HTTPS directly from your device to `openrouter.ai`. The key is sent as the
`Authorization` header, exactly as the OpenRouter documentation requires, because that is what makes
the request work.

## What Credo does **not** do

- No backend, no proxy, no telemetry, no analytics, no crash reporting.
- No ads and no accounts.
- No data is sent to the author or to any third party other than OpenRouter.
- No API keys, tokens or secrets are stored in this repository.

## Web build caveat

The web build (`/app/` on the project site, or `flutter build web`) runs in a browser. Browser storage
is **not** a hardware-backed vault: `flutter_secure_storage` on the web encrypts values with WebCrypto
and keeps them in the browser's local storage, which is weaker than the Keychain / Keystore.
**Prefer the native builds on your own machines**; use the web build for a quick look.

## Revoking access

Delete the key in your [OpenRouter dashboard](https://openrouter.ai/keys) at any time — that
invalidates it everywhere, including in Credo. You can also remove it inside the app's Settings screen.

## Reporting a problem

Open an issue on [GitHub](https://github.com/moradzadeh67/credo/issues). Please never paste a real API
key into an issue, a log or a screenshot.
