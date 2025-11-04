import 'package:flutter_test/flutter_test.dart';
import 'package:provider_demo/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('DetailsScreen light theme golden', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CounterProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const DetailsScreen()),
      ),
    );

    await expectLater(
      find.byType(DetailsScreen),
      matchesGoldenFile('details_screen_light.png'),
    );
  });

  testWidgets('DetailsScreen dark theme golden', (tester) async {
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
          home: const DetailsScreen(),
        ),
      ),
    );

    await expectLater(
      find.byType(DetailsScreen),
      matchesGoldenFile('details_screen_dark.png'),
    );
  });
}
