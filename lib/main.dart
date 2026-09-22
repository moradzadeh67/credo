import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_provider.dart';
import 'screens/home_screen.dart';
import 'screens/key_setup_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppProvider())],
      child: const CredoApp(),
    ),
  );
}

class CredoApp extends StatelessWidget {
  const CredoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // CredoApp is a child of MultiProvider, so it can watch the provider.
    final themeMode = context.watch<AppProvider>().themeMode;

    return MaterialApp(
      title: 'Credo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: const _AppRoot(),
    );
  }
}

/// Root widget that decides which screen to show based on saved key state.
class _AppRoot extends StatelessWidget {
  const _AppRoot();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    // While checking for a saved key, show a splash/loading indicator.
    if (provider.isInitialLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (provider.isKeySaved) {
      return const HomeScreen();
    }

    return const KeySetupScreen();
  }
}
