class KeyInfo {
  final String label;
  final double? limit;
  final double? limitRemaining;
  final String? limitReset;
  final double usage;
  final double usageDaily;
  final double usageWeekly;
  final double usageMonthly;
  final bool isFreeTier;
  final bool isManagementKey;

  KeyInfo({
    required this.label,
    this.limit,
    this.limitRemaining,
    this.limitReset,
    required this.usage,
    required this.usageDaily,
    required this.usageWeekly,
    required this.usageMonthly,
    required this.isFreeTier,
    required this.isManagementKey,
  });

  factory KeyInfo.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return KeyInfo(
      label: data['label'] as String,
      limit: _toDouble(data['limit']),
      limitRemaining: _toDouble(data['limit_remaining']),
      limitReset: data['limit_reset'] as String?,
      usage: _toDouble(data['usage']) ?? 0.0,
      usageDaily: _toDouble(data['usage_daily']) ?? 0.0,
      usageWeekly: _toDouble(data['usage_weekly']) ?? 0.0,
      usageMonthly: _toDouble(data['usage_monthly']) ?? 0.0,
      isFreeTier: data['is_free_tier'] as bool? ?? false,
      isManagementKey: data['is_management_key'] as bool? ?? false,
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return null;
  }

  bool get hasLimit => limit != null;
  bool get isUnlimited => limit == null;

  double get remainingPercentage {
    if (limit == null || limit == 0 || limitRemaining == null) return 0.0;
    return (limitRemaining! / limit!) * 100;
  }
}
