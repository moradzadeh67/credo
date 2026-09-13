import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/credits_info.dart';
import '../models/key_info.dart';
import '../models/key_type.dart';
import '../providers/app_provider.dart';
import 'home_screen.dart';

class KeySetupScreen extends StatefulWidget {
  const KeySetupScreen({super.key});

  @override
  State<KeySetupScreen> createState() => _KeySetupScreenState();
}

class _KeySetupScreenState extends State<KeySetupScreen> {
  final TextEditingController _keyController = TextEditingController();
  bool _obscureKey = true;
  KeyType _selectedType = KeyType.inference;

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  void _handleTestConnection() async {
    final key = _keyController.text.trim();
    if (key.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please enter an API Key')));
      return;
    }

    final success = await context.read<AppProvider>().testConnection(key, _selectedType);
    if (success && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Connection Successful!')));
    }
  }

  void _handleSaveKey() async {
    final key = _keyController.text.trim();
    if (key.isEmpty) return;

    await context.read<AppProvider>().saveKey(key, _selectedType);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('API Key saved securely.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Setup OpenRouter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome to Credo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your OpenRouter API key to start monitoring your usage and credits.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            _buildTypeSelector(),
            const SizedBox(height: 20),
            TextField(
              controller: _keyController,
              obscureText: _obscureKey,
              decoration: InputDecoration(
                labelText: 'OpenRouter API Key',
                hintText: 'sk-or-v1-...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureKey ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _obscureKey = !_obscureKey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : _handleTestConnection,
                    child: provider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Test Connection'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: provider.isLoading ? null : _handleSaveKey,
                    child: const Text('Save Key'),
                  ),
                ),
              ],
            ),
            if (provider.errorMessage != null) ...[
              const SizedBox(height: 24),
              _buildErrorCard(provider.errorMessage!),
            ],
            if (provider.keyInfo != null || provider.creditsInfo != null) ...[
              const SizedBox(height: 24),
              _buildResultCard(provider.keyInfo, provider.creditsInfo),
            ],
            if (provider.isKeySaved) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
                },
                child: const Text('Go to Dashboard'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Key Type', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SegmentedButton<KeyType>(
          segments: KeyType.values
              .map(
                (type) => ButtonSegment<KeyType>(
                  value: type,
                  label: Text(type.title),
                  icon: Icon(
                    type == KeyType.management ? Icons.admin_panel_settings : Icons.vpn_key,
                  ),
                ),
              )
              .toList(),
          selected: {_selectedType},
          onSelectionChanged: (selection) {
            setState(() => _selectedType = selection.first);
          },
        ),
        const SizedBox(height: 8),
        Text(
          _selectedType.description,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildErrorCard(String message) {
    return Card(
      color: Colors.red.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.red.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(KeyInfo? info, CreditsInfo? credits) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Connection Result',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(height: 24),
            if (credits != null) ...[
              _buildInfoRow('Account Balance', '\$${credits.remaining.toStringAsFixed(2)}'),
              _buildInfoRow('Total Purchased', '\$${credits.totalCredits.toStringAsFixed(2)}'),
              const Divider(height: 24),
            ],
            if (info != null) ...[
              _buildInfoRow('Label', info.label),
              _buildInfoRow(
                'Limit',
                info.isUnlimited ? 'Unlimited' : '\$${info.limit?.toStringAsFixed(2)}',
              ),
              if (info.hasLimit)
                _buildInfoRow('Remaining', '\$${info.limitRemaining?.toStringAsFixed(2)}'),
              _buildInfoRow('Usage (Total)', '\$${info.usage.toStringAsFixed(4)}'),
              _buildInfoRow('Usage (Daily)', '\$${info.usageDaily.toStringAsFixed(4)}'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
