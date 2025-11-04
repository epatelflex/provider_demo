import 'package:flutter_test/flutter_test.dart';
import 'package:provider_demo/index.dart';

void main() {
  test('CounterNotifier increments and notifies once', () {
    final notifier = CounterNotifier();
    var notified = 0;
    notifier.addListener(() => notified++);
    notifier.increment();
    expect(notifier.count, 1);
    expect(notified, 1);
  });
}
