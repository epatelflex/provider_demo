import 'package:flutter/foundation.dart';

/// Interface that defines the contract for providers that support async data loading.
///
/// This interface is implemented by [AsyncLoadingMixin] and can be implemented
/// by any provider that needs to expose loading/error/data state.
///
/// Used by [AsyncBuilder] to provide type-safe access to async state properties
/// without dynamic casting.
abstract class AsyncLoadable {
  /// The loaded data, or null if not yet loaded or if an error occurred.
  Object? get data;

  /// Whether an async operation is currently in progress.
  bool get isLoading;

  /// Error object from the last failed operation, or null if no error.
  ///
  /// Can be cast to specific exception types for detailed error handling.
  Object? get error;

  /// Whether data has been successfully loaded.
  bool get hasData;

  /// Whether an error occurred during the last operation.
  bool get hasError;
}

/// Base class that combines ChangeNotifier with AsyncLoadable.
///
/// This is used as a type constraint in AsyncBuilder to ensure providers
/// are both observable (ChangeNotifier) and support async loading (AsyncLoadable).
///
/// Providers using AsyncLoadingMixin automatically satisfy this constraint.
abstract class AsyncNotifier extends ChangeNotifier implements AsyncLoadable {}

