import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider_demo/index.dart';

void main() {
  test('UserProvider initializes with empty state', () {
    final mockClient = MockClient((request) async {
      return http.Response('[]', 200);
    });
    final service = UserService(mockClient);
    final notifier = UserProvider(service);

    expect(notifier.users, null);
    expect(notifier.isLoading, false);
    expect(notifier.error, null);
    expect(notifier.hasData, false);
    expect(notifier.hasError, false);
  });

  test('UserProvider sets loading state when loadUsers is called', () async {
    final mockClient = MockClient((request) async {
      await Future.delayed(const Duration(milliseconds: 10));
      return http.Response(
        '[{"id":1,"name":"Test","username":"test","email":"test@example.com","phone":"123","website":"test.com","address":{"street":"","suite":"","city":"","zipcode":"","geo":{"lat":"0","lng":"0"}},"company":{"name":"Test","catchPhrase":"","bs":""}}]',
        200,
      );
    });
    final service = UserService(mockClient);
    final notifier = UserProvider(service);
    var notifyCount = 0;
    notifier.addListener(() => notifyCount++);

    // Start loading
    final loadFuture = notifier.loadUsers();

    // Should be loading immediately
    expect(notifier.isLoading, true);
    expect(notifyCount, 1);

    // Wait for completion
    await loadFuture;

    // Should have finished loading
    expect(notifier.isLoading, false);
    expect(notifyCount, 2);

    // Should have data
    expect(notifier.hasData, true);
    expect(notifier.users, hasLength(1));
  });

  test('UserProvider clearError removes error', () async {
    final mockClient = MockClient((request) async {
      return http.Response('[]', 200);
    });
    final service = UserService(mockClient);
    final notifier = UserProvider(service);

    var notifyCount = 0;
    notifier.addListener(() => notifyCount++);

    notifier.clearError();
    expect(notifier.error, null);
    expect(notifier.hasError, false);
    expect(notifyCount, 1);
  });
}
