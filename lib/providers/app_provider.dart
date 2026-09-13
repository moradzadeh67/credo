import 'package:flutter/material.dart';

import '../models/credits_info.dart';
import '../models/key_info.dart';
import '../models/key_type.dart';
import '../services/openrouter_service.dart';
import '../services/secure_storage_service.dart';

class AppProvider extends ChangeNotifier {
  final OpenRouterService _apiService = OpenRouterService();
  final SecureStorageService _storageService = SecureStorageService();

  KeyInfo? _keyInfo;
  CreditsInfo? _creditsInfo;
  KeyType _keyType = KeyType.inference;
  bool _isLoading = false;
  bool _isInitialLoading = true;
  String? _errorMessage;
  bool _isKeySaved = false;
  DateTime? _lastUpdated;

  KeyInfo? get keyInfo => _keyInfo;
  CreditsInfo? get creditsInfo => _creditsInfo;
  KeyType get keyType => _keyType;
  bool get isLoading => _isLoading;
  bool get isInitialLoading => _isInitialLoading;
  String? get errorMessage => _errorMessage;
  bool get isKeySaved => _isKeySaved;
  DateTime? get lastUpdated => _lastUpdated;
  SecureStorageService get storageService => _storageService;

  /// True when we have a key but could not read the account balance.
  bool get creditsUnavailable => _isKeySaved && _creditsInfo == null;

  /// Explains why the balance is missing, for display in the UI.
  String get creditsUnavailableHint => _keyType == KeyType.management
      ? 'Could not read the account balance. Check your Management key permissions.'
      : 'Add a Management Key in Settings to see your account balance.';

  AppProvider() {
    _checkInitialState();
  }

  Future<void> _checkInitialState() async {
    _keyType = await _storageService.getKeyType();
    _isKeySaved = await _storageService.hasApiKey();
    if (_isKeySaved) {
      // Auto-fetch data if a key was previously saved.
      await refreshData();
    }
    _isInitialLoading = false;
    notifyListeners();
  }

  /// Tests the connection with a new [apiKey] without saving it yet.
  ///
  /// Validation depends on [type]: management keys are verified against the
  /// credits endpoint, inference keys against the key endpoint.
  Future<bool> testConnection(String apiKey, KeyType type) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (type == KeyType.management) {
        // The balance is the whole point of a management key, so require it.
        _creditsInfo = await _apiService.getCredits(apiKey);
        try {
          _keyInfo = await _apiService.getKeyInfo(apiKey);
        } catch (_) {
          _keyInfo = null;
        }
      } else {
        _keyInfo = await _apiService.getKeyInfo(apiKey);
        try {
          _creditsInfo = await _apiService.getCredits(apiKey);
        } catch (_) {
          _creditsInfo = null;
        }
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      _keyInfo = null;
      _creditsInfo = null;
      notifyListeners();
      return false;
    }
  }

  /// Saves the [apiKey] and its [type] securely, then fetches data.
  Future<void> saveKey(String apiKey, KeyType type) async {
    await _storageService.saveApiKey(apiKey);
    await _storageService.saveKeyType(type);
    _keyType = type;
    _isKeySaved = true;
    await refreshData(saveKey: false);
  }

  /// Changes the stored key type and re-fetches data accordingly.
  Future<void> setKeyType(KeyType type) async {
    if (_keyType == type) return;
    _keyType = type;
    await _storageService.saveKeyType(type);
    notifyListeners();
    await refreshData();
  }

  /// Fetches the latest key info and credit balance using the saved key.
  Future<void> refreshData({bool showError = true, bool saveKey = true}) async {
    final apiKey = await _storageService.getApiKey();
    if (apiKey == null) {
      _isKeySaved = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = showError ? null : _errorMessage;
    if (showError) notifyListeners();

    _keyInfo = null;
    _creditsInfo = null;

    Object? keyError;
    Object? creditsError;

    try {
      _keyInfo = await _apiService.getKeyInfo(apiKey);
    } catch (e) {
      keyError = e;
    }

    try {
      _creditsInfo = await _apiService.getCredits(apiKey);
    } catch (e) {
      creditsError = e;
    }

    _isLoading = false;

    // The request only truly failed when neither endpoint responded.
    if (_keyInfo == null && _creditsInfo == null) {
      final failure = keyError ?? creditsError;
      _errorMessage = showError
          ? (failure?.toString().replaceAll('Exception: ', '') ??
                'Unable to load data. Please try again.')
          : _errorMessage;
      notifyListeners();
      return;
    }

    _errorMessage = null;
    _lastUpdated = DateTime.now();
    if (saveKey) _isKeySaved = true;
    notifyListeners();
  }

  /// Clears the saved key and resets state.
  Future<void> logout() async {
    await _storageService.deleteApiKey();
    _isKeySaved = false;
    _keyInfo = null;
    _creditsInfo = null;
    _keyType = KeyType.inference;
    _lastUpdated = null;
    _errorMessage = null;
    notifyListeners();
  }
}
