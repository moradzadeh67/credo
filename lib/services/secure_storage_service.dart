import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/key_type.dart';

class SecureStorageService {
  // In flutter_secure_storage v11+, AndroidOptions uses strong AES-GCM
  // encryption with RSA-OAEP key wrapping by default, so no extra flags
  // are needed (the old `encryptedSharedPreferences` option was removed).
  //
  // On macOS the plugin defaults to the Data Protection Keychain, which requires
  // the app to be signed with a real Team ID (entitlement). For local ad-hoc
  // signed builds it would fail with `errSecMissingEntitlement (-34018)`, so we
  // opt into the legacy file-based keychain instead.
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    mOptions: MacOsOptions(usesDataProtectionKeychain: false),
  );

  static const String _keyApiKey = 'openrouter_api_key';
  static const String _keyKeyType = 'openrouter_key_type';
  static const String _keyThemeMode = 'theme_mode';

  /// Saves the API key securely.
  Future<void> saveApiKey(String apiKey) async {
    await _storage.write(key: _keyApiKey, value: apiKey);
  }

  /// Retrieves the API key securely.
  Future<String?> getApiKey() async {
    return await _storage.read(key: _keyApiKey);
  }

  /// Saves the type of the stored key (inference or management).
  Future<void> saveKeyType(KeyType type) async {
    await _storage.write(key: _keyKeyType, value: type.storageValue);
  }

  /// Reads the stored key type, defaulting to [KeyType.inference].
  Future<KeyType> getKeyType() async {
    final value = await _storage.read(key: _keyKeyType);
    return KeyType.fromStorage(value);
  }

  /// Saves the preferred theme mode ('system', 'light' or 'dark').
  /// It is intentionally independent of the API key and survives logout.
  Future<void> saveThemeMode(String mode) async {
    await _storage.write(key: _keyThemeMode, value: mode);
  }

  /// Reads the stored theme mode, or null when it was never set.
  Future<String?> getThemeMode() async {
    return await _storage.read(key: _keyThemeMode);
  }

  /// Deletes the API key (and its stored type) from storage.
  Future<void> deleteApiKey() async {
    await _storage.delete(key: _keyApiKey);
    await _storage.delete(key: _keyKeyType);
  }

  /// Checks if an API key exists in storage.
  Future<bool> hasApiKey() async {
    final key = await getApiKey();
    return key != null && key.isNotEmpty;
  }
}
