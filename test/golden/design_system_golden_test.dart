import 'package:flutter_test/flutter_test.dart';
import 'package:provider_demo/index.dart';

void main() {
  testWidgets('Design system widgets light theme golden', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Typography
                const AppHeadline('Headline Text'),
                const SizedBox(height: AppSpacing.sm),
                const AppTitle('Title Text'),
                const SizedBox(height: AppSpacing.sm),
                const AppBody('Body Text'),
                const SizedBox(height: AppSpacing.sm),
                const AppCaption('Caption Text'),
                const SizedBox(height: AppSpacing.lg),

                // Buttons
                AppButton(
                  onPressed: () {},
                  child: const AppBody('Filled Button', color: Colors.white),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  onPressed: () {},
                  filled: false,
                  child: const AppBody('Outlined Button'),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Card
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      AppTitle('Card Title'),
                      SizedBox(height: AppSpacing.xs),
                      AppBody('Card content goes here'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('design_system_light.png'),
    );
  });

  testWidgets('Design system widgets dark theme golden', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.dark,
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Typography
                const AppHeadline('Headline Text'),
                const SizedBox(height: AppSpacing.sm),
                const AppTitle('Title Text'),
                const SizedBox(height: AppSpacing.sm),
                const AppBody('Body Text'),
                const SizedBox(height: AppSpacing.sm),
                const AppCaption('Caption Text'),
                const SizedBox(height: AppSpacing.lg),

                // Buttons
                AppButton(
                  onPressed: () {},
                  child: const AppBody('Filled Button', color: Colors.white),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  onPressed: () {},
                  filled: false,
                  child: const AppBody('Outlined Button'),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Card
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      AppTitle('Card Title'),
                      SizedBox(height: AppSpacing.xs),
                      AppBody('Card content goes here'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('design_system_dark.png'),
    );
  });
}
