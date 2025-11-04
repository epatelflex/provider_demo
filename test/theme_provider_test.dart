import 'package:flutter_test/flutter_test.dart';
import 'package:provider_demo/index.dart';

void main() {
  test('ThemeProvider defaults to light and toggles to dark', () {
    final t = ThemeProvider();
    expect(t.mode, ThemeMode.light);
    t.toggle();
    expect(t.mode, ThemeMode.dark);
  });

  test('ThemeProvider setMode notifies when changing', () {
    final t = ThemeProvider();
    var count = 0;
    t.addListener(() => count++);
    t.setMode(ThemeMode.dark);
    expect(t.mode, ThemeMode.dark);
    expect(count, 1);
    t.setMode(ThemeMode.dark);
    expect(count, 1);
  });
}
