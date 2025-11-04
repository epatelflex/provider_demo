import 'package:provider_demo/index.dart';

/// A generic widget that renders different UI states for async data loading.
///
/// Type parameter [T] represents the type of provider that implements AsyncLoadable.
///
/// This widget automatically handles:
/// - Initial data loading (if not already loaded)
/// - Loading state (shows loading indicator)
/// - Error state (shows error message with retry button)
/// - Empty state (shows empty message)
/// - Data state (shows your custom UI)
///
/// Example usage:
/// ```dart
/// AsyncBuilder<UserProvider>(
///   onLoad: (provider) => provider.loadUsers(),
///   errorBuilder: (context, provider, error) {
///     return Center(child: Text('Failed: $error'));
///   },
///   builder: (context, provider) {
///     return ListView(
///       children: provider.data!.map((user) => UserCard(user)).toList(),
///     );
///   },
/// )
/// ```
class AsyncBuilder<T extends AsyncNotifier> extends StatefulWidget {
  /// Callback to load data. Called on first build (if needed) and when retry is pressed.
  final void Function(T provider) onLoad;

  /// Builder for the data state. Called when data is available.
  final Widget Function(BuildContext context, T provider) builder;

  /// Optional builder for the loading state.
  /// Defaults to centered CircularProgressIndicator.
  final Widget Function(BuildContext context)? loadingBuilder;

  /// Optional builder for the error state.
  /// Defaults to error icon, message, and retry button.
  /// Receives the error object as the third parameter (can be cast to specific exception types).
  final Widget Function(BuildContext context, T provider, Object error)?
      errorBuilder;

  /// Optional builder for the empty state (when data is null or empty).
  /// Defaults to "No data found" message.
  final Widget Function(BuildContext context)? emptyBuilder;

  /// Optional callback to check if data is empty.
  /// If not provided, only checks if data is null.
  final bool Function(T provider)? isEmpty;

  const AsyncBuilder({
    super.key,
    required this.onLoad,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.isEmpty,
  });

  @override
  State<AsyncBuilder<T>> createState() => _AsyncBuilderState<T>();
}

class _AsyncBuilderState<T extends AsyncNotifier>
    extends State<AsyncBuilder<T>> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final provider = context.read<T>();

      if (!provider.hasData && !provider.isLoading) {
        // Schedule after build to avoid calling notifyListeners during build
        Future.microtask(() => widget.onLoad(provider));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<T>();

    // Show loading state
    if (provider.isLoading) {
      return widget.loadingBuilder?.call(context) ??
          _defaultLoadingBuilder(context);
    }

    // Show error state
    if (provider.hasError) {
      final error = provider.error!;
      return widget.errorBuilder?.call(context, provider, error) ??
          _defaultErrorBuilder(context, provider, error);
    }

    // Show empty state
    final data = provider.data;
    final isEmptyData = widget.isEmpty?.call(provider) ?? data == null;
    if (isEmptyData) {
      return widget.emptyBuilder?.call(context) ?? _defaultEmptyBuilder(context);
    }

    // Show data state
    return widget.builder(context, provider);
  }

  Widget _defaultLoadingBuilder(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _defaultErrorBuilder(BuildContext context, T provider, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: AppSpacing.md),
          AppBody('Error: $error'),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            onPressed: () => widget.onLoad(provider),
            child: const AppBody('Retry', color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _defaultEmptyBuilder(BuildContext context) {
    return const Center(child: AppBody('No data found'));
  }
}

