import 'package:flutter_test/flutter_test.dart';
import 'package:provider_demo/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('HomeScreen light theme golden', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CounterProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const HomeScreen()),
      ),
    );

    await expectLater(
      find.byType(HomeScreen),
      matchesGoldenFile('home_screen_light.png'),
    );
  });

  testWidgets('HomeScreen dark theme golden', (tester) async {
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
          home: const HomeScreen(),
        ),
      ),
    );

    await expectLater(
      find.byType(HomeScreen),
      matchesGoldenFile('home_screen_dark.png'),
    );
  });

  testWidgets('HomeScreen with count=5 golden', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final counter = CounterProvider();
    for (int i = 0; i < 5; i++) {
      counter.increment();
    }

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: counter),
          ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const HomeScreen()),
      ),
    );

    await expectLater(
      find.byType(HomeScreen),
      matchesGoldenFile('home_screen_count_5.png'),
    );
  });
}
