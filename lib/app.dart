import 'package:http/http.dart' as http;
import 'package:provider_demo/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Infrastructure layer: HTTP client and SharedPreferences
        Provider<http.Client>(
          create: (_) => http.Client(),
          dispose: (_, client) => client.close(),
        ),
        Provider<SharedPreferences>.value(value: prefs),

        // Service layer: Business logic services
        ProxyProvider<http.Client, UserService>(
          update: (_, client, __) => UserService(client),
        ),

        // Provider layer: State management
        ChangeNotifierProxyProvider<UserService, UserProvider>(
          create: (context) => UserProvider(context.read<UserService>()),
          update: (_, service, previous) =>
              previous ?? UserProvider(service),
        ),
        ChangeNotifierProvider(create: (_) => CounterProvider()),
        ChangeNotifierProxyProvider<SharedPreferences, ThemeProvider>(
          create: (context) => ThemeProvider(context.read<SharedPreferences>()),
          update: (_, prefs, previous) =>
              previous ?? ThemeProvider(prefs),
        ),
      ],
      child: Builder(
        builder: (context) => MaterialApp.router(
          title: 'Provider + GoRouter Demo',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: context.watch<ThemeProvider>().mode,
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
