# Security Policy

Credo stores a **high-value credential** (your OpenRouter API key), so security reports are especially
welcome.

## Reporting a vulnerability

Please **do not** open a public issue for a security problem. Instead:

- Use GitHub's private reporting: **Security → Advisories → Report a vulnerability** on
  <https://github.com/moradzadeh67/credo/security/advisories>, or
- contact the author through <https://github.com/moradzadeh67> if that is unavailable.

Include what you can: affected version/platform, steps to reproduce, and the impact you see. You will
get an acknowledgement as soon as possible.

## Please never

- Paste a real API key, token or keychain dump into an issue, a screenshot or a log.
- Test against someone else's account or key.

## Scope notes

- Keys are stored with `flutter_secure_storage` (macOS/iOS Keychain, Android Keystore). The **web build**
  is the known weak spot: browser storage is not a hardware-backed vault (see
  [docs/PRIVACY.md](docs/PRIVACY.md)).
- Credo has no backend: the only network destination is the OpenRouter API you configure.
