import 'package:provider_demo/index.dart';

/// Mixin that provides async loading state management for ChangeNotifier providers.
///
/// Type parameter [T] represents the type of data being loaded.
///
/// This mixin handles the three-phase async loading pattern:
/// 1. Pre-fetch: Set loading state, clear errors
/// 2. Fetch: Execute the async operation
/// 3. Post-fetch: Update state with results or errors
///
/// Example usage:
/// ```dart
/// class MyProvider extends ChangeNotifier with AsyncLoadingMixin<List<Item>> {
///   final MyService _service;
///
///   Future<void> loadItems() async {
///     await loadData(() => _service.fetchItems());
///   }
/// }
/// ```
mixin AsyncLoadingMixin<T> on AsyncNotifier {
  T? _data;
  bool _isLoading = false;
  Object? _error;

  /// The loaded data, or null if not yet loaded or if an error occurred
  @override
  T? get data => _data;

  /// Whether an async operation is currently in progress
  @override
  bool get isLoading => _isLoading;

  /// Error object from the last failed operation, or null if no error.
  /// Can be cast to specific exception types for detailed error handling.
  @override
  Object? get error => _error;

  /// Whether data has been successfully loaded
  @override
  bool get hasData => _data != null;

  /// Whether an error occurred during the last operation
  @override
  bool get hasError => _error != null;

  /// Executes an async data loading operation with automatic state management.
  ///
  /// The [fetcher] function should return a Future that resolves to the data.
  ///
  /// This method handles:
  /// - Setting loading state before the operation
  /// - Clearing previous errors
  /// - Updating data on success
  /// - Capturing errors on failure
  /// - Clearing loading state after completion
  /// - Notifying listeners at appropriate times
  Future<void> loadData(Future<T> Function() fetcher) async {
    // Phase 1: Pre-fetch - set loading state
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Phase 2: Fetch - execute the async operation
      _data = await fetcher();
      _error = null;
    } catch (e) {
      // Handle errors - store the actual error object
      _error = e;
      _data = null;
    } finally {
      // Phase 3: Post-fetch - clear loading state
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clears the current error state and notifies listeners.
  ///
  /// Useful for dismissing error messages in the UI.
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clears all state (data, loading, error) and notifies listeners.
  ///
  /// Useful for resetting the provider to its initial state.
  void reset() {
    _data = null;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}
