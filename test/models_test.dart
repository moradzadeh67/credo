import 'package:flutter_test/flutter_test.dart';

import 'package:credo/models/credits_info.dart';
import 'package:credo/models/key_info.dart';
import 'package:credo/models/key_type.dart';

void main() {
  group('CreditsInfo', () {
    test('parses the credits payload', () {
      final credits = CreditsInfo.fromJson({
        'data': {'total_credits': 25.38, 'total_usage': 2.30},
      });

      expect(credits.totalCredits, 25.38);
      expect(credits.totalUsage, 2.30);
      expect(credits.remaining, closeTo(23.08, 0.0001));
    });

    test('never reports a negative balance', () {
      final credits = CreditsInfo.fromJson({
        'data': {'total_credits': 5.0, 'total_usage': 9.0},
      });

      expect(credits.remaining, 0.0);
    });

    test('tolerates missing fields', () {
      final credits = CreditsInfo.fromJson({'data': <String, dynamic>{}});

      expect(credits.totalCredits, 0.0);
      expect(credits.totalUsage, 0.0);
      expect(credits.remaining, 0.0);
    });
  });

  group('KeyType', () {
    test('round-trips through storage values', () {
      for (final type in KeyType.values) {
        expect(KeyType.fromStorage(type.storageValue), type);
      }
    });

    test('defaults to inference for unknown or null values', () {
      expect(KeyType.fromStorage(null), KeyType.inference);
      expect(KeyType.fromStorage('something-else'), KeyType.inference);
    });
  });

  group('KeyInfo', () {
    test('reports unlimited when no limit is set', () {
      final info = KeyInfo.fromJson({
        'data': {
          'label': 'my-key',
          'limit': null,
          'limit_remaining': null,
          'usage': 2.30,
          'usage_daily': 2.30,
          'usage_weekly': 2.30,
          'usage_monthly': 2.30,
        },
      });

      expect(info.hasLimit, isFalse);
      expect(info.isUnlimited, isTrue);
      expect(info.usage, 2.30);
    });

    test('computes the remaining percentage when a limit exists', () {
      final info = KeyInfo.fromJson({
        'data': {'label': 'limited-key', 'limit': 100.0, 'limit_remaining': 74.25, 'usage': 25.75},
      });

      expect(info.hasLimit, isTrue);
      expect(info.remainingPercentage, closeTo(74.25, 0.0001));
    });
  });
}
