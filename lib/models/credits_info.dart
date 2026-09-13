class CreditsInfo {
  final double totalCredits;
  final double totalUsage;

  CreditsInfo({required this.totalCredits, required this.totalUsage});

  factory CreditsInfo.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return CreditsInfo(
      totalCredits: _toDouble(data['total_credits']) ?? 0.0,
      totalUsage: _toDouble(data['total_usage']) ?? 0.0,
    );
  }

  /// Remaining account balance (purchased credits minus what has been spent).
  double get remaining => (totalCredits - totalUsage).clamp(0, double.infinity);

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
