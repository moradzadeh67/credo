import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/credits_info.dart';
import '../models/key_info.dart';
import '../models/key_type.dart';
import '../providers/app_provider.dart';
import '../utils/url_helper.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _formatAmount(double amount) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Credo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: provider.isLoading ? null : () => provider.refreshData(),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.refreshData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(padding: const EdgeInsets.all(24.0), child: _buildBody(context, provider)),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppProvider provider) {
    if (provider.isInitialLoading) {
      return Container(
        alignment: Alignment.center,
        height: 300,
        child: const CircularProgressIndicator(),
      );
    }

    if (provider.keyInfo == null && provider.creditsInfo == null && !provider.isLoading) {
      return Container(
        alignment: Alignment.center,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage ?? 'No data available.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (provider.lastUpdated != null)
          Text(
            'Last updated: ${_timeAgo(provider.lastUpdated!)}',
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 24),
        ?_buildLowBalanceBanner(provider),
        _buildMainCard(context, provider),
        const SizedBox(height: 24),
        if (provider.keyInfo != null) _buildUsageCards(provider.keyInfo!),
        const SizedBox(height: 24),
        _buildRefreshHint(),
      ],
    );
  }

  Widget _buildMainCard(BuildContext context, AppProvider provider) {
    final CreditsInfo? credits = provider.creditsInfo;
    final KeyInfo? keyInfo = provider.keyInfo;

    // Prefer the real account balance when available.
    final String amountText;
    final double? progress;
    String? caption;

    if (credits != null) {
      amountText = _formatAmount(credits.remaining);
      final double total = credits.totalCredits;
      progress = total > 0 ? (credits.remaining / total).clamp(0.0, 1.0) : null;
      caption = 'of ${_formatAmount(total)} purchased';
    } else if (keyInfo != null && keyInfo.hasLimit) {
      amountText = _formatAmount(keyInfo.limitRemaining ?? 0);
      progress = keyInfo.remainingPercentage / 100;
    } else {
      amountText = 'Unlimited';
      progress = null;
      caption = provider.creditsUnavailableHint;
    }

    // Warn with colour when the remaining balance gets low.
    final Color amountColor = _balanceColor(progress);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            const Text('Available Credits', style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _copyToClipboard(context, amountText),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(
                  amountText,
                  style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: amountColor),
                ),
              ),
            ),
            if (progress != null) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                color: amountColor,
                borderRadius: BorderRadius.circular(5),
              ),
              const SizedBox(height: 8),
              Text(
                '${(progress * 100).toStringAsFixed(1)}% remaining',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
            if (caption != null) ...[
              const SizedBox(height: 12),
              Text(
                caption,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
            if (provider.estimatedDaysLeft != null) ...[
              const SizedBox(height: 8),
              Text(
                '≈ ${provider.estimatedDaysLeft} days left at current rate',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
            if (provider.creditsUnavailable && provider.keyType != KeyType.management) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final opened = await UrlHelper.launchOpenRouterKeys();
                  if (!opened) {
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Could not open a browser on this device.')),
                    );
                  }
                },
                icon: const Icon(Icons.open_in_new, size: 16),
                label: const Text('Create Management Key'),
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUsageCards(KeyInfo info) {
    // Only show a progress bar when a per-key limit is configured.
    final double? limit = (info.hasLimit && info.limit! > 0) ? info.limit : null;
    final cards = [
      {'label': 'Today', 'value': info.usageDaily},
      {'label': 'This Week', 'value': info.usageWeekly},
      {'label': 'This Month', 'value': info.usageMonthly},
      {'label': 'Total Usage', 'value': info.usage},
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: isWide ? WrapAlignment.start : WrapAlignment.center,
          children: cards.map((card) {
            final double value = card['value'] as double;
            return _buildUsageCard(
              card['label'] as String,
              value,
              progress: limit == null ? null : (value / limit).clamp(0.0, 1.0),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildUsageCard(String label, double value, {double? progress}) {
    return SizedBox(
      width: 140,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(label, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              Text(
                _formatAmount(value),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              if (progress != null) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Human friendly "time ago" label for the last refresh.
  String _timeAgo(DateTime dateTime) {
    final Duration diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} h ago';
    return '${diff.inDays} d ago';
  }

  /// Returns a warning colour when the remaining balance is low.
  Color _balanceColor(double? progress) {
    if (progress == null) return const Color(0xFF22C55E);
    if (progress < 0.05) return Colors.red;
    if (progress < 0.20) return Colors.orange;
    return const Color(0xFF22C55E);
  }

  /// Copies [text] to the clipboard and confirms it with a snack bar.
  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard'), duration: Duration(seconds: 1)),
    );
  }

  /// Shows a warning banner when the remaining credits drop below a threshold.
  Widget? _buildLowBalanceBanner(AppProvider provider) {
    final CreditsInfo? credits = provider.creditsInfo;
    if (credits == null || credits.totalCredits <= 0) return null;

    final double pct = credits.remaining / credits.totalCredits;
    if (pct >= 0.20) return null;

    final bool critical = pct < 0.05;
    final Color color = critical ? Colors.red : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: critical ? Colors.red.shade50 : Colors.orange.shade50,
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              critical
                  ? 'Critical: less than 5% credits remaining!'
                  : 'Low balance: less than 20% credits remaining.',
              style: TextStyle(color: critical ? Colors.red.shade900 : Colors.orange.shade900),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshHint() {
    return const Center(
      child: Text('Pull down to refresh', style: TextStyle(color: Colors.grey)),
    );
  }
}
