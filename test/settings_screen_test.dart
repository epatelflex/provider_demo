import 'package:flutter_test/flutter_test.dart';
import 'package:provider_demo/index.dart';

void main() {
  testWidgets('settings gear opens Settings and toggles dark mode', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byIcon(Icons.settings), findsOneWidget);
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsOneWidget);

    final switchTile = find.byType(SwitchListTile);
    expect(switchTile, findsOneWidget);
    final wasDark = tester.widget<SwitchListTile>(switchTile).value;
    await tester.tap(switchTile);
    await tester.pumpAndSettle();
    final isDark = tester.widget<SwitchListTile>(switchTile).value;
    expect(isDark, !wasDark);
  });
}
