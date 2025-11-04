import 'package:flutter_test/flutter_test.dart';
import 'package:provider_demo/index.dart';

void main() {
  testWidgets('SettingsScreen light mode off golden', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CounterNotifier()),
          ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const SettingsScreen(),
        ),
      ),
    );

    await expectLater(
      find.byType(SettingsScreen),
      matchesGoldenFile('settings_screen_light.png'),
    );
  });

  testWidgets('SettingsScreen dark mode on golden', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CounterNotifier()),
          ChangeNotifierProvider(
            create: (_) => ThemeNotifier()..setMode(ThemeMode.dark),
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
