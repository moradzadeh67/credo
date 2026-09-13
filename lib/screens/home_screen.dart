import 'package:flutter/material.dart';
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
            'Last updated: ${DateFormat.jm().format(provider.lastUpdated!)}',
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 24),
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

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            const Text('Available Credits', style: TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(
              amountText,
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Color(0xFF22C55E),
              ),
            ),
            if (progress != null) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey.shade200,
                color: Colors.greenAccent,
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
          children: cards
              .map((card) => _buildUsageCard(card['label'] as String, card['value'] as double))
              .toList(),
        );
      },
    );
  }

  Widget _buildUsageCard(String label, double value) {
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRefreshHint() {
    return const Center(
      child: Text('Pull down to refresh', style: TextStyle(color: Colors.grey)),
    );
  }
}
