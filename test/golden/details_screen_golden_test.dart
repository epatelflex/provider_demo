import 'package:flutter_test/flutter_test.dart';
import 'package:provider_demo/index.dart';

void main() {
  testWidgets('DetailsScreen light theme golden', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CounterNotifier()),
          ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const DetailsScreen(),
        ),
      ),
    );

    await expectLater(
      find.byType(DetailsScreen),
      matchesGoldenFile('details_screen_light.png'),
    );
  });

  testWidgets('DetailsScreen dark theme golden', (tester) async {
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
