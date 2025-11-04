import 'package:flutter_test/flutter_test.dart';
import 'package:provider_demo/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('SettingsScreen light mode off golden', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CounterProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const SettingsScreen()),
      ),
    );

    await expectLater(
      find.byType(SettingsScreen),
      matchesGoldenFile('settings_screen_light.png'),
    );
  });

  testWidgets('SettingsScreen dark mode on golden', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CounterProvider()),
          ChangeNotifierProvider(
            create: (_) {
              final theme = ThemeProvider(prefs);
              theme.setMode(ThemeMode.dark);
              return theme;
            },
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.dark,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.dark,
          home: const SettingsScreen(),
        ),
      ),
    );

    await expectLater(
      find.byType(SettingsScreen),
      matchesGoldenFile('settings_screen_dark.png'),
    );
  });
}
