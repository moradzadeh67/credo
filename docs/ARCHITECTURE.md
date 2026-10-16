# Credo — Architecture

Credo is a single Flutter codebase that ships to **Android, iOS, macOS and the web**. State management
is **Provider**; there is no backend.

## Layers

| Layer | Folder | Responsibility |
|---|---|---|
| UI / presentation | `lib/screens/` | Home, KeySetup, Settings screens built with Material 3 |
| State | `lib/providers/` | `AppProvider` (`ChangeNotifier`) — loads, refreshes and exposes credits/keys; `notifyListeners()` drives rebuilds |
| Services | `lib/services/` | `OpenRouterService` (HTTP), `SecureStorageService` (Keychain / Keystore) |
| Models | `lib/models/` | `CreditsInfo`, `KeyInfo`, `KeyType` — typed data, `fromJson` parsing |
| Theme | `lib/theme/` | `AppTheme` — a single source for colors, elevation and typography |
| Utilities | `lib/utils/` | Pure helpers: key masking, URL handling, JSON export |

## Data flow

```text
main.dart -> runApp()
   |
   v
screens/  (Home / KeySetup / Settings)      <-- reads state
   |
   v
providers/ AppProvider (ChangeNotifier)     --> notifyListeners() rebuilds the UI
   |
   v
services/ OpenRouterService  ->  openrouter.ai/api/v1/{key,credits}
          SecureStorageService -> Keychain / Android Keystore
   |
   v
models/   CreditsInfo, KeyInfo, KeyType
```

## Diagrams

- Project structure — `assets/diagrams/project-structure.png`
- Architecture layers — `assets/diagrams/architecture-layers.png`
- Data flow — `assets/diagrams/data-flow-diagram.png`

## Key decisions

- **Provider over BLoC/Riverpod** — Credo is a focused single-purpose app; a `ChangeNotifier` keeps the
  state layer small and readable with no boilerplate.
- **`flutter_secure_storage` over files/`shared_preferences`** — the API key is a high-value credential
  and belongs in the platform vault (Keychain / Keystore), not in plain storage.
- **`http` over `dio`** — only two REST endpoints are called; the lighter client is enough.
- **Centralized `AppTheme`** — every color, elevation and text style comes from one file, so the whole
  app (and both themes) stays consistent and restyling is a one-file change.
- **Layered folders (`models/ providers/ screens/ services/ theme/ utils/`)** — data, state, UI and
  platform access stay decoupled for readability and testability.

## Testing

`test/` runs fully offline: model parsing, URL helper behaviour and widget rendering. No network or real
keys are required.
