import 'dart:convert';

import '../models/credits_info.dart';
import '../models/key_info.dart';

/// Builds a JSON snapshot of the current credits/key information so the user
/// can copy or back it up.
class ExportHelper {
  const ExportHelper._();

  static String toJson({KeyInfo? keyInfo, CreditsInfo? creditsInfo}) {
    final Map<String, dynamic> map = {
      'exported_at': DateTime.now().toIso8601String(),
      if (creditsInfo != null)
        'credits': {
          'total_credits': creditsInfo.totalCredits,
          'total_usage': creditsInfo.totalUsage,
          'remaining': creditsInfo.remaining,
        },
      if (keyInfo != null)
        'key': {
          'label': keyInfo.label,
          'limit': keyInfo.limit,
          'limit_remaining': keyInfo.limitRemaining,
          'usage': keyInfo.usage,
          'usage_daily': keyInfo.usageDaily,
          'usage_weekly': keyInfo.usageWeekly,
          'usage_monthly': keyInfo.usageMonthly,
        },
    };
    return const JsonEncoder.withIndent('  ').convert(map);
  }
}
