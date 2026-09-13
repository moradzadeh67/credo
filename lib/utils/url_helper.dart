import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  static const String openRouterKeysUrl = 'https://openrouter.ai/keys';

  /// Opens the OpenRouter API-keys page in the user's browser.
  ///
  /// Returns `true` when a browser handled the URL.
  ///
  /// We deliberately attempt the launch instead of gating on `canLaunchUrl`:
  /// under Android 11+ package-visibility rules that check can report `false`
  /// even when the launch would succeed, which would silently break the button.
  static Future<bool> launchOpenRouterKeys() async {
    final Uri url = Uri.parse(openRouterKeysUrl);
    try {
      return await launchUrl(url, mode: LaunchMode.externalApplication);
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    } catch (_) {
      return false;
    }
  }
}
