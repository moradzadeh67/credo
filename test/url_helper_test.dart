import 'package:flutter_test/flutter_test.dart';

import 'package:credo/utils/url_helper.dart';

void main() {
  group('UrlHelper', () {
    test('points at the OpenRouter keys page over https', () {
      final uri = Uri.parse(UrlHelper.openRouterKeysUrl);

      expect(uri.scheme, 'https');
      expect(uri.host, 'openrouter.ai');
      expect(uri.path, '/keys');
    });
  });
}
