import 'package:flutter_test/flutter_test.dart';
import 'package:provider_demo/index.dart';

void main() {
  test('CounterProvider increments and notifies once', () {
    final notifier = CounterProvider();
    var notified = 0;
    notifier.addListener(() => notified++);
    notifier.increment();
    expect(notifier.count, 1);
    expect(notified, 1);
  });
}
