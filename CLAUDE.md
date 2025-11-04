# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter demo application showcasing Provider state management with GoRouter navigation. Uses a centralized barrel export pattern (lib/index.dart) for all imports.

## Development Commands

### Makefile Commands (Recommended)

The project includes a Makefile with common tasks. Run `make menu` to see all options or `make` for interactive selection.

**Common Commands:**
```bash
make test             # Run all tests
make test_unit        # Run unit tests (notifier tests)
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
flutter test test/counter_notifier_test.dart   # Single test file
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
Uses Provider for state management with two main notifiers:
- **CounterNotifier** (lib/data/counter_notifier.dart): Manages counter state
- **ThemeNotifier** (lib/data/theme_notifier.dart): Manages light/dark theme state

Both notifiers are registered in MultiProvider at the app root (lib/main.dart:31-35).

### Routing
GoRouter configuration in lib/main.dart:12-29 with routes:
- `/` - HomeScreen
- `/details` - DetailsScreen
- `/settings` - SettingsScreen

Navigation uses `context.go('/path')` pattern.

### Design System
Centralized design system in lib/design/:
- **app_theme.dart**: Light and dark ThemeData with AppBar, button, and card theming
- **app_colors.dart**: Color constants
- **app_typography.dart**: Text style definitions
- **app_spacing.dart**: Spacing constants
- **widgets/**: Reusable UI components (AppScaffold, AppButton, AppCard, AppText)

### Barrel Export Pattern
All imports use `package:provider_demo/index.dart` which exports all Flutter/package dependencies and internal modules. When creating new files, add exports to lib/index.dart and import only from index.dart.

### Testing
Widget tests use flutter_test package. Tests verify both notifier behavior (counter_notifier_test.dart) and widget functionality (count_text_test.dart, settings_screen_test.dart).

**Golden Tests**: Visual regression tests in test/golden/ verify UI appearance across light/dark themes:
- home_screen_golden_test.dart: Tests HomeScreen in different states
- details_screen_golden_test.dart: Tests DetailsScreen
- settings_screen_golden_test.dart: Tests SettingsScreen with theme toggle
- design_system_golden_test.dart: Tests all design system widgets

Uses `golden_toolkit` package for proper font loading in golden tests. Font loading configured in test/flutter_test_config.dart.

After UI changes, regenerate golden files with `flutter test --update-goldens`.
