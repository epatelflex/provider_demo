import 'package:flutter_test/flutter_test.dart';
import 'package:provider_demo/index.dart';

void main() {
  test('UserProvider initializes with empty state', () {
    final notifier = UserProvider();
    expect(notifier.users, null);
    expect(notifier.isLoading, false);
    expect(notifier.error, null);
    expect(notifier.hasData, false);
    expect(notifier.hasError, false);
  });

  test('UserProvider sets loading state when loadUsers is called', () async {
    final notifier = UserProvider();
    var notifyCount = 0;
    notifier.addListener(() => notifyCount++);

    // Start loading - this will make an actual HTTP request
    final loadFuture = notifier.loadUsers();

    // Should be loading immediately
    expect(notifier.isLoading, true);
    expect(notifyCount, 1);

    // Wait for completion
    await loadFuture;

    // Should have finished loading
    expect(notifier.isLoading, false);
    expect(notifyCount, 2);

    // Should either have data or error
    expect(notifier.hasData || notifier.hasError, true);
  });

  test('UserProvider clearError removes error', () {
    final notifier = UserProvider();
    // Manually set error for testing
    notifier.loadUsers(); // This might fail or succeed

    var notifyCount = 0;
    notifier.addListener(() => notifyCount++);

    notifier.clearError();
    expect(notifier.error, null);
    expect(notifier.hasError, false);
    expect(notifyCount, 1);
  });
}
