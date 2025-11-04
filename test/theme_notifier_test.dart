import 'package:flutter_test/flutter_test.dart';
import 'package:provider_demo/index.dart';

void main() {
  test('ThemeNotifier defaults to light and toggles to dark', () {
    final t = ThemeNotifier();
    expect(t.mode, ThemeMode.light);
    t.toggle();
    expect(t.mode, ThemeMode.dark);
  });

  test('ThemeNotifier setMode notifies when changing', () {
    final t = ThemeNotifier();
    var count = 0;
    t.addListener(() => count++);
    t.setMode(ThemeMode.dark);
    expect(t.mode, ThemeMode.dark);
    expect(count, 1);
    t.setMode(ThemeMode.dark);
    expect(count, 1);
  });
}
