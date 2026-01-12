import 'package:provider_demo/index.dart';

/// Provides a fluent API for subscribing to provider values with automatic rebuilds.
///
/// Usage:
/// ```dart
/// final count = context.subscribe.count;  // Rebuilds when count changes
/// final themeMode = context.subscribe.themeMode;  // Rebuilds when theme changes
/// ```
///
/// This is equivalent to using `context.select()` but with better discoverability
/// and a more concise syntax.
class AppSubscriber {
  final BuildContext context;
  const AppSubscriber(this.context);
}

/// Provides a fluent API for accessing providers without subscribing to changes.
///
/// Usage:
/// ```dart
/// context.get.counter.increment();  // Access provider without rebuild
/// context.get.theme.toggle();  // Toggle theme without subscribing
/// ```
///
/// This is equivalent to using `context.read<T>()` but with better discoverability
/// and a more concise syntax.
class AppGetter {
  final BuildContext context;
  const AppGetter(this.context);
}

/// Extension on [BuildContext] to provide fluent provider access.
extension AppContextExtensions on BuildContext {
  /// Access provider values with automatic subscription (rebuilds on change).
  ///
  /// Use this in `build()` methods when you need the widget to rebuild
  /// when the value changes.
  AppSubscriber get subscribe => AppSubscriber(this);

  /// Access providers for one-time reads or method calls (no rebuild).
  ///
  /// Use this in callbacks (onPressed, onTap, etc.) where you don't need
  /// to subscribe to changes.
  AppGetter get get => AppGetter(this);
}

/// Subscriber extensions for reactive access to provider values.
///
/// These use `context.select()` under the hood, so the widget will only
/// rebuild when the specific selected value changes.
extension AppSubscriberExtensions on AppSubscriber {
  // CounterProvider
  /// The current counter value. Rebuilds when count changes.
  int get count => context.select((CounterProvider p) => p.count);

  // ThemeProvider
  /// The current theme mode. Rebuilds when theme changes.
  ThemeMode get themeMode => context.select((ThemeProvider p) => p.mode);

  // UserProvider
  /// The loaded users list, or null if not loaded. Rebuilds when users change.
  List<User>? get users => context.select((UserProvider p) => p.users);

  /// Whether users are currently loading. Rebuilds when loading state changes.
  bool get isLoadingUsers => context.select((UserProvider p) => p.isLoading);

  /// Whether users have been loaded. Rebuilds when data state changes.
  bool get hasUsers => context.select((UserProvider p) => p.hasData);

  /// The current error, if any. Rebuilds when error state changes.
  Object? get usersError => context.select((UserProvider p) => p.error);
}

/// Getter extensions for one-time provider access.
///
/// These use `context.read<T>()` under the hood, so no subscription is created.
/// Use these in callbacks where you need to call methods on providers.
extension AppGetterExtensions on AppGetter {
  /// Access the [CounterProvider] for method calls.
  CounterProvider get counter => context.read<CounterProvider>();

  /// Access the [ThemeProvider] for method calls.
  ThemeProvider get theme => context.read<ThemeProvider>();

  /// Access the [UserProvider] for method calls.
  UserProvider get userProvider => context.read<UserProvider>();
}
