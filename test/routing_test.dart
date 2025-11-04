import 'package:flutter_test/flutter_test.dart';
import 'package:provider_demo/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('navigates to details from home', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(MyApp(prefs: prefs));
    expect(find.text('Go to details'), findsOneWidget);
    await tester.tap(find.text('Go to details'));
    await tester.pumpAndSettle();
    expect(find.text('Details'), findsOneWidget);
  });
}
