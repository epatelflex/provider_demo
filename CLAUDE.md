# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter demo application showcasing Provider state management with GoRouter navigation and REST API integration. Uses a centralized barrel export pattern (lib/index.dart) for all imports. Demonstrates separation of concerns with providers for business logic, services for API calls, and screens for UI.

## Development Commands

### Makefile Commands (Recommended)

The project includes a Makefile with common tasks. Run `make menu` to see all options or `make` for interactive selection.

**Common Commands:**
```bash
make test             # Run all tests
make test_unit        # Run unit tests (provider tests)
make test_widget      # Run widget tests
make test_golden      # Run golden tests only
make golden_update    # Update golden files after UI changes
make coverage         # Run tests with coverage report

make analyze          # Run flutter analyze
make fix              # Auto-fix linting issues
make lint             # Run analyze + fix

make format           # Format code with dart format
make reset            # flutter clean && flutter pub get

make run              # Run app on default device
make run_chrome       # Run app on Chrome

make build_apk        # Build Android APK
make build_ios        # Build iOS app
make build_web        # Build web app
```

### Direct Flutter Commands

```bash
# Run the app
flutter run

# Run tests
flutter test                                    # All tests
flutter test test/counter_provider_test.dart   # Single test file
flutter test --coverage                        # With coverage
flutter test --update-goldens                  # Update golden files
flutter test test/golden/                      # Golden tests only

# Linting
flutter analyze
dart fix --apply

# Build
flutter build apk
flutter build ios
flutter build web

# Dependencies
flutter pub get
flutter pub upgrade
```

## Architecture

### State Management
Uses Provider package for state management with three main providers:
- **CounterProvider** (lib/providers/counter_provider.dart): Manages counter state
- **ThemeProvider** (lib/providers/theme_provider.dart): Manages light/dark theme state
- **UserProvider** (lib/providers/user_provider.dart): Manages user data fetched from API with loading/error states using AsyncLoadingMixin

All providers are registered in MultiProvider at the app root (lib/app.dart:10-12). Providers follow a consistent pattern: extend ChangeNotifier, expose state via getters, and call notifyListeners() when state changes.

#### Async Data Loading Pattern
For providers that fetch data asynchronously (like UserProvider), use the **AsyncLoadingMixin<T>** pattern:

**AsyncLoadingMixin<T>** (lib/mixins/async_loading_mixin.dart):
- Provides automatic loading/error/data state management
- Generic type parameter T represents the data type (e.g., List<User>)
- Includes built-in methods: `loadData()`, `clearError()`, `reset()`
- Exposes getters: `data`, `isLoading`, `error` (Object type), `hasData`, `hasError`
- Stores the actual error/exception object (not just a string) for better error handling
- Eliminates boilerplate for three-phase async pattern (pre-fetch, fetch, post-fetch)

**AsyncBuilder<T>** (lib/widgets/async_builder.dart):
- Generic widget for rendering async data loading states
- Automatically handles: initial loading, loading state, error state, empty state, data state
- Customizable builders for each state
- Automatic retry functionality
- Error object is passed to errorBuilder (can be cast to specific exception types)
- Example usage:
  ```dart
  AsyncBuilder<UserProvider>(
    onLoad: (provider) => provider.loadUsers(),
    isEmpty: (provider) => provider.users?.isEmpty ?? true,
    errorBuilder: (context, provider, error) {
      // error is Object - can cast to specific types if needed
      return Center(child: Text('Failed: $error'));
    },
    builder: (context, provider) {
      return ListView(...); // Your data UI
    },
  )
  ```

**Creating a new async provider:**
1. Extend ChangeNotifier and mix in AsyncLoadingMixin<YourDataType>
2. Implement load method that calls `loadData(() => yourService.fetch())`
3. Add convenience getter for data if needed
4. Use AsyncBuilder in your screen to handle all UI states

Example:
```dart
class MyProvider extends ChangeNotifier with AsyncLoadingMixin<List<Item>> {
  final MyService _service = MyService();
  List<Item>? get items => data;

  Future<void> loadItems() async {
    await loadData(() => _service.fetchItems());
  }
}
```

### Project Structure
- **lib/main.dart**: Entry point with `main()` function only
- **lib/app.dart**: MyApp widget with MultiProvider and MaterialApp.router setup
- **lib/router.dart**: Centralized GoRouter configuration exported as `appRouter`
- **lib/providers/**: State management providers (extend ChangeNotifier)
- **lib/mixins/**: Reusable mixins for providers (e.g., AsyncLoadingMixin)
- **lib/data/**: Data models (e.g., User, Address, Company)
- **lib/services/**: API services for external data fetching
- **lib/screens/**: Full-page screen widgets
- **lib/widgets/**: Reusable widget components (including AsyncBuilder)
- **lib/design/**: Design system (theme, colors, typography, spacing, and design widgets)

### Routing
GoRouter configuration in lib/router.dart with routes:
- `/` - HomeScreen
- `/details` - DetailsScreen
- `/settings` - SettingsScreen
- `/users` - UsersScreen (displays users from API)

Navigation uses `context.go('/path')` pattern. Router is registered in lib/app.dart.

### Design System
Centralized design system in lib/design/:
- **app_theme.dart**: Light and dark ThemeData with AppBar, button, and card theming
- **app_colors.dart**: Color constants
- **app_typography.dart**: Text style definitions
- **app_spacing.dart**: Spacing constants
- **widgets/**: Reusable UI components (AppScaffold, AppButton, AppCard, AppText)

### Barrel Export Pattern
All imports use `package:provider_demo/index.dart` which exports all Flutter/package dependencies and internal modules. When creating new files, add exports to lib/index.dart and import only from index.dart.

**Important**: Every file should import from index.dart, not individual files:
```dart
import 'package:provider_demo/index.dart';  // ✅ Correct
import 'package:provider_demo/data/user.dart';  // ❌ Wrong
```

### API Integration
REST API calls handled through service layer:
- **UserService** (lib/services/user_service.dart): Fetches users from JSONPlaceholder API
- Services are used by providers, not directly by UI
- Pattern: Screen → Provider → Service → API
- Error handling and loading states managed in providers

### Testing
Three types of tests are used:

**Unit Tests** (test/*_provider_test.dart):
- Test providers in isolation: CounterProvider, ThemeProvider, UserProvider
- Verify state changes and listener notifications
- Run with: `make test_unit` or `flutter test test/counter_provider_test.dart`

**Widget Tests** (test/*_test.dart):
- Test widget behavior and interactions
- Examples: count_text_test.dart, settings_screen_test.dart, routing_test.dart
- Run with: `make test_widget`

**Golden Tests** (test/golden/*_golden_test.dart):
- Visual regression tests verifying UI appearance across light/dark themes
- home_screen_golden_test.dart, details_screen_golden_test.dart, settings_screen_golden_test.dart, design_system_golden_test.dart
- Uses `golden_toolkit` package for proper font loading (configured in test/flutter_test_config.dart)
- After UI changes, regenerate: `make golden_update` or `flutter test --update-goldens`
- Run with: `make test_golden`

**Test Organization**:
- Unit tests verify business logic (providers)
- Widget tests verify UI behavior and user interactions
- Golden tests verify visual appearance and prevent unintended UI changes
