import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/key_type.dart';
import '../providers/app_provider.dart';
import '../utils/api_key_mask.dart';
import '../utils/url_helper.dart';
import 'key_setup_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _SectionHeader('Credentials'),
          ListTile(
            leading: const Icon(Icons.key),
            title: const Text('API Key'),
            subtitle: _ApiKeySubtitle(provider: provider),
            trailing: const Icon(Icons.visibility_off),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: const Text('Key Type'),
            subtitle: Text(
              '${provider.keyType.title}\n${provider.keyType.description}',
              style: const TextStyle(fontSize: 12),
            ),
            isThreeLine: true,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SegmentedButton<KeyType>(
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
              selected: {provider.keyType},
              onSelectionChanged: (selection) async {
                final messenger = ScaffoldMessenger.of(context);
                await provider.setKeyType(selection.first);
                messenger.showSnackBar(
                  SnackBar(content: Text('Key type set to ${selection.first.title}.')),
                );
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.open_in_new),
            title: const Text('Create / Manage Keys'),
            subtitle: const Text('Open the OpenRouter keys page'),
            onTap: () async {
              final messenger = ScaffoldMessenger.of(context);
              final opened = await UrlHelper.launchOpenRouterKeys();
              if (!opened) {
                messenger.showSnackBar(
                  const SnackBar(content: Text('Could not open a browser on this device.')),
                );
              }
            },
          ),
          const Divider(),
          _SectionHeader('Account'),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout & Delete Key', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await provider.logout();
              if (context.mounted) {
                Navigator.of(context).popUntil((route) => route.isFirst);
                if (provider.isKeySaved) return;
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (_) => const KeySetupScreen()));
              }
            },
          ),
          const Divider(),
          _SectionHeader('About'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About Credo'),
            subtitle: const Text('An OpenRouter Credits Monitor'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Credo',
                applicationVersion: '1.0.0',
                children: [
                  const Text(
                    'Credo is an open-source app to monitor your OpenRouter credits and usage.',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// A small grey heading used to group related settings.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _ApiKeySubtitle extends StatelessWidget {
  const _ApiKeySubtitle({required this.provider});

  final AppProvider provider;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: provider.storageService.getApiKey(),
      builder: (context, snapshot) {
        final key = snapshot.data;
        if (key == null || key.isEmpty) {
          return const Text('No key saved.');
        }
        return Text(maskApiKey(key));
      },
    );
  }
}
