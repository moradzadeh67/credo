import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_provider.dart';
import 'screens/home_screen.dart';
import 'screens/key_setup_screen.dart';

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
    return MaterialApp(
      title: 'Credo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF22C55E),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
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
