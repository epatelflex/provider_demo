import 'package:provider_demo/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';

  final SharedPreferences _prefs;
  ThemeMode _mode = ThemeMode.light;

  ThemeProvider(this._prefs) {
    _loadTheme();
  }

  ThemeMode get mode => _mode;

  void _loadTheme() {
    final savedTheme = _prefs.getString(_themeKey);
    if (savedTheme == 'dark') {
      _mode = ThemeMode.dark;
    } else if (savedTheme == 'light') {
      _mode = ThemeMode.light;
    }
    // If null, keep default (light)
  }

  Future<void> setMode(ThemeMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    await _prefs.setString(
      _themeKey,
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
    notifyListeners();
  }

  void toggle() {
    setMode(_mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}
