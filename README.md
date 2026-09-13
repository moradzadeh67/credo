# 🔑 Credo

![Credo Logo](assets/images/credo-icon-256.png)

A professional Flutter application for managing OpenRouter API keys and checking account credits.

## 📌 Project Overview

Credo is a Flutter-based desktop and mobile application that allows users to:
- Securely manage OpenRouter API keys
- View account credits and usage information
- Configure application settings
- Store sensitive data using platform-specific secure storage

## ✨ Key Features

- 🔐 **Secure Storage**: API keys are stored securely using platform Keychain/Keystore via `flutter_secure_storage`
- 💳 **Credit Monitoring**: Check your OpenRouter account balance and usage in real-time
- ⚙️ **Settings Management**: Configure your API keys and app preferences
- 🎨 **Modern UI**: Built with Material Design 3 and responsive layouts

## 🎨 Screenshots

### Home Screen - API Key Management
![Home Screen](assets/images/credo-preview.png)

> The app provides a clean, intuitive interface for managing your OpenRouter API keys and monitoring account credits in real-time.

## 🛠️ Tech Stack

- **Flutter & Dart** (3.13.2+)
- **State Management**: [Provider](https://pub.dev/packages/provider) v6.1.1 (`ChangeNotifier` + `Consumer`)
- **Secure Storage**: [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage) (Platform-native Keychain/Keystore)
- **Networking**: [`http`](https://pub.dev/packages/http) (REST API calls to OpenRouter)
- **URL Launcher**: [`url_launcher`](https://pub.dev/packages/url_launcher) (open links)
- **Date Formatting**: [`intl`](https://pub.dev/packages/intl)
- **App Icons**: [`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons)

## 🚀 How to Run

### Prerequisites
- Flutter SDK (3.13.2+)
- Dart 3.x
- Platform-specific requirements:
  - **Android**: Android SDK 21+
  - **iOS**: Xcode 14+
  - **macOS**: Xcode 14+
  - **Web**: Any modern browser
  - **Windows**: Windows 10+ (⚠️ Untested)
  - **Linux**: (⚠️ Untested)

### Installation

```bash
# Get dependencies
flutter pub get

# Run the app
flutter run
```

### Build for Platforms

```bash
# Android
flutter build apk

# iOS
flutter build ios

# macOS
flutter build macos

# Windows
flutter build windows

# Linux
flutter build linux

# Web
flutter build web
```

## 📂 Project Structure

```
lib/
├── models/               # Data models (credits, keys, key types)
│   ├── credits_info.dart
│   ├── key_info.dart
│   └── key_type.dart
├── providers/            # State management
│   └── app_provider.dart
├── screens/              # UI screens
│   ├── home_screen.dart
│   ├── key_setup_screen.dart
│   └── settings_screen.dart
├── services/             # Business logic & API
│   ├── openrouter_service.dart
│   └── secure_storage_service.dart
└── utils/                # Utility helpers
    ├── api_key_mask.dart
    └── url_helper.dart
assets/
└── images/               # App icons and assets
    ├── credo-icon-1024.png
    ├── credo-icon-512.png
    ├── credo-icon-256.png
    ├── credo-icon-128.png
    ├── credo-icon-64.png
    └── credo-icon-32.png
```

## 📱 Supported Platforms

| Platform | Status | Notes |
|---|---|---|
| 🤖 Android | ✅ **Tested** | Working |
| 🍎 iOS | ✅ **Tested** | Working |
| 🖥️ macOS | ✅ **Tested** | Working |
| 🌐 Web | ✅ **Tested** | Working |
| 🪟 Windows | ⚠️ Untested | Build available, needs testing |
| 🐧 Linux | ⚠️ Untested | Build available, needs testing |

> **Note**: Android, iOS, macOS, and Web platforms have been tested and work correctly. Windows and Linux builds are available but have not been tested yet.

## 📝 License

MIT License. See [LICENSE](LICENSE) for details.

**Copyright © 2025 moradzadeh67**

This project is open-source and free to use, modify, and distribute under the MIT License terms.
