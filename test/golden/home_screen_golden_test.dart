import 'package:flutter_test/flutter_test.dart';
import 'package:provider_demo/index.dart';

void main() {
  testWidgets('HomeScreen light theme golden', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CounterNotifier()),
          ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const HomeScreen(),
        ),
      ),
    );

    await expectLater(
      find.byType(HomeScreen),
      matchesGoldenFile('home_screen_light.png'),
    );
  });

  testWidgets('HomeScreen dark theme golden', (tester) async {
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
    final counter = CounterNotifier();
    for (int i = 0; i < 5; i++) {
      counter.increment();
    }

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: counter),
          ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const HomeScreen(),
        ),
      ),
    );

    await expectLater(
      find.byType(HomeScreen),
      matchesGoldenFile('home_screen_count_5.png'),
    );
  });
}
