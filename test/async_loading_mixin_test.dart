import 'package:flutter_test/flutter_test.dart';
import 'package:provider_demo/index.dart';

// Test provider using the mixin
class TestProvider extends AsyncNotifier with AsyncLoadingMixin<String> {
  Future<void> loadSuccess(String value) async {
    await loadData(() async {
      await Future.delayed(const Duration(milliseconds: 10));
      return value;
    });
  }

  Future<void> loadFailure(Exception error) async {
    await loadData(() async {
      await Future.delayed(const Duration(milliseconds: 10));
      throw error;
    });
  }
}

void main() {
  group('AsyncLoadingMixin', () {
    test('initializes with empty state', () {
      final provider = TestProvider();
      expect(provider.data, null);
      expect(provider.isLoading, false);
      expect(provider.error, null);
      expect(provider.hasData, false);
      expect(provider.hasError, false);
    });

    test('sets loading state during async operation', () async {
      final provider = TestProvider();
      var notifyCount = 0;
      provider.addListener(() => notifyCount++);

      final loadFuture = provider.loadSuccess('test');

      // Should be loading immediately
      expect(provider.isLoading, true);
      expect(provider.error, null);
      expect(notifyCount, 1); // Pre-fetch notification

      await loadFuture;

      // Should have finished loading
      expect(provider.isLoading, false);
      expect(provider.hasData, true);
      expect(provider.data, 'test');
      expect(provider.error, null);
      expect(notifyCount, 2); // Post-fetch notification
    });

    test('stores error object on failure', () async {
      final provider = TestProvider();
      final testError = Exception('Test error message');
      var notifyCount = 0;
      provider.addListener(() => notifyCount++);

      await provider.loadFailure(testError);

      expect(provider.isLoading, false);
      expect(provider.hasError, true);
      expect(provider.error, testError); // Should be the same object
      expect(provider.error is Exception, true);
      expect(provider.data, null);
      expect(notifyCount, 2); // Pre-fetch and post-fetch
    });

    test('error toString matches exception message', () async {
      final provider = TestProvider();
      final testError = Exception('Custom error');

      await provider.loadFailure(testError);

      expect(provider.error.toString(), contains('Custom error'));
    });

    test('clears data on error', () async {
      final provider = TestProvider();

      // First load successfully
      await provider.loadSuccess('initial data');
      expect(provider.data, 'initial data');
      expect(provider.hasData, true);

      // Then fail
      await provider.loadFailure(Exception('Error'));
      expect(provider.data, null);
      expect(provider.hasData, false);
      expect(provider.hasError, true);
    });

    test('clears error on success', () async {
      final provider = TestProvider();

      // First fail
      await provider.loadFailure(Exception('Error'));
      expect(provider.hasError, true);

      // Then succeed
      await provider.loadSuccess('success data');
      expect(provider.error, null);
      expect(provider.hasError, false);
      expect(provider.hasData, true);
      expect(provider.data, 'success data');
    });

    test('clearError removes error and notifies', () async {
      final provider = TestProvider();
      await provider.loadFailure(Exception('Error'));

      var notifyCount = 0;
      provider.addListener(() => notifyCount++);

      provider.clearError();

      expect(provider.error, null);
      expect(provider.hasError, false);
      expect(notifyCount, 1);
    });

    test('clearError notifies even when no error exists', () {
      final provider = TestProvider();
      var notifyCount = 0;
      provider.addListener(() => notifyCount++);

      provider.clearError();

      expect(provider.error, null);
      expect(notifyCount, 1);
    });

    test('reset clears all state and notifies', () async {
      final provider = TestProvider();
      await provider.loadSuccess('test data');

      var notifyCount = 0;
      provider.addListener(() => notifyCount++);

      provider.reset();

      expect(provider.data, null);
      expect(provider.isLoading, false);
      expect(provider.error, null);
      expect(provider.hasData, false);
      expect(provider.hasError, false);
      expect(notifyCount, 1);
    });

    test('reset clears error state', () async {
      final provider = TestProvider();
      await provider.loadFailure(Exception('Error'));

      provider.reset();

      expect(provider.error, null);
      expect(provider.hasError, false);
    });

    test('multiple loads clear previous state', () async {
      final provider = TestProvider();

      await provider.loadSuccess('first');
      expect(provider.data, 'first');

      await provider.loadSuccess('second');
      expect(provider.data, 'second');

      await provider.loadFailure(Exception('Error'));
      expect(provider.data, null);
      expect(provider.hasError, true);

      await provider.loadSuccess('third');
      expect(provider.data, 'third');
      expect(provider.hasError, false);
    });

    test('concurrent loads handle state correctly', () async {
      final provider = TestProvider();

      // Start first load
      final load1 = provider.loadSuccess('first');
      expect(provider.isLoading, true);

      // Wait for completion
      await load1;
      expect(provider.isLoading, false);
      expect(provider.data, 'first');
    });
  });
}
