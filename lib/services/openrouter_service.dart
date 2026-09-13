import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/credits_info.dart';
import '../models/key_info.dart';

/// Thrown when an endpoint requires a Management key but an inference key
/// was supplied (OpenRouter responds with HTTP 403).
class ManagementKeyRequiredException implements Exception {
  const ManagementKeyRequiredException();

  @override
  String toString() =>
      'This operation requires a Management Key. Create one in the OpenRouter dashboard.';
}

class OpenRouterService {
  static const String _baseUrl = 'https://openrouter.ai/api/v1';

  /// Fetches key information using the provided [apiKey].
  Future<KeyInfo> getKeyInfo(String apiKey) async {
    final response = await _get('$_baseUrl/key', apiKey);
    return KeyInfo.fromJson(response);
  }

  /// Fetches the account credit balance (purchased credits and usage).
  /// Requires a Management key.
  Future<CreditsInfo> getCredits(String apiKey) async {
    final response = await _get('$_baseUrl/credits', apiKey);
    return CreditsInfo.fromJson(response);
  }

  /// Performs a GET request and decodes the JSON body, translating
  /// errors into friendly exceptions.
  Future<Map<String, dynamic>> _get(String url, String apiKey) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $apiKey', 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API Key. Please check your key and try again.');
      } else if (response.statusCode == 403) {
        throw const ManagementKeyRequiredException();
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded. Please wait a moment and try again.');
      } else {
        throw Exception('Server error (${response.statusCode}). Please try again later.');
      }
    } catch (e) {
      if (e is ManagementKeyRequiredException) rethrow;
      if (e is http.ClientException || e.toString().contains('SocketException')) {
        throw Exception('Network error. Please check your internet connection.');
      }
      rethrow;
    }
  }

  /// Masks the API key for safe logging (e.g., sk-or-v1-...1234).
  String maskKey(String key) {
    if (key.length <= 8) return '****';
    return '${key.substring(0, 8)}...${key.substring(key.length - 4)}';
  }
}
