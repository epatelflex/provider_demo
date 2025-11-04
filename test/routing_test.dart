import 'package:flutter_test/flutter_test.dart';
import 'package:provider_demo/index.dart';

void main() {
  testWidgets('navigates to details from home', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Go to details'), findsOneWidget);
    await tester.tap(find.text('Go to details'));
    await tester.pumpAndSettle();
    expect(find.text('Details'), findsOneWidget);
  });
}
