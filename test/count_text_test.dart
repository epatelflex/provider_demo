import 'package:flutter_test/flutter_test.dart';
import 'package:provider_demo/index.dart';

void main() {
  testWidgets('CountText shows current count and updates', (tester) async {
    final counter = CounterNotifier();
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider.value(value: counter)],
        child: const MaterialApp(home: Scaffold(body: CountText())),
      ),
    );

    expect(find.text('0'), findsOneWidget);
    counter.increment();
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });
}

