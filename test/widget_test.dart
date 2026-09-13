import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:credo/providers/app_provider.dart';
import 'package:credo/screens/key_setup_screen.dart';

void main() {
  testWidgets('KeySetupScreen renders correctly', (WidgetTester tester) async {
    // Provide a fresh AppProvider. The screen itself is self-contained for display.
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => AppProvider())],
        child: const MaterialApp(home: KeySetupScreen()),
      ),
    );

    // Wait for a single frame to render.
    await tester.pump(const Duration(milliseconds: 100));

    // Verify that the setup screen is shown.
    expect(find.text('Welcome to Credo'), findsOneWidget);
    expect(find.text('Test Connection'), findsOneWidget);
  });
}
