import 'package:provider_demo/index.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeProvider>();
    final isDark = themeNotifier.mode == ThemeMode.dark;
    return AppScaffold(
      appBar: AppBar(title: const AppTitle('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const AppBody('Dark Mode'),
            value: isDark,
            onChanged: (val) =>
                themeNotifier.setMode(val ? ThemeMode.dark : ThemeMode.light),
          ),
        ],
      ),
    );
  }
}
