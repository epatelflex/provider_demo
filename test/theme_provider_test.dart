import 'package:flutter_test/flutter_test.dart';
import 'package:provider_demo/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('ThemeProvider defaults to light and toggles to dark', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final t = ThemeProvider(prefs);
    expect(t.mode, ThemeMode.light);
    t.toggle();
    expect(t.mode, ThemeMode.dark);
  });

  test('ThemeProvider setMode notifies when changing', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final t = ThemeProvider(prefs);
    var count = 0;
    t.addListener(() => count++);
    await t.setMode(ThemeMode.dark);
    expect(t.mode, ThemeMode.dark);
    expect(count, 1);
    await t.setMode(ThemeMode.dark);
    expect(count, 1);
  });

  test('ThemeProvider loads saved theme on initialization', () async {
    SharedPreferences.setMockInitialValues({'theme_mode': 'dark'});
    final prefs = await SharedPreferences.getInstance();

    final t = ThemeProvider(prefs);
    expect(t.mode, ThemeMode.dark);
  });

  test('ThemeProvider persists theme mode', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final t = ThemeProvider(prefs);
    await t.setMode(ThemeMode.dark);

    // Check that it's saved in SharedPreferences
    expect(prefs.getString('theme_mode'), 'dark');
  });
}
