import 'package:flutter_test/flutter_test.dart';
import 'package:provider_demo/index.dart';

// Test provider for AsyncBuilder tests
class MockProvider extends AsyncNotifier with AsyncLoadingMixin<List<String>> {
  Future<void> loadSuccess(List<String> items) async {
    await loadData(() async {
      await Future.delayed(const Duration(milliseconds: 10));
      return items;
    });
  }

  Future<void> loadFailure(Object error) async {
    await loadData(() async {
      await Future.delayed(const Duration(milliseconds: 10));
      throw error;
    });
  }
}

void main() {
  group('AsyncBuilder', () {
    testWidgets('shows loading state then data', (tester) async {
      final provider = MockProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: MaterialApp(
            home: Scaffold(
              body: AsyncBuilder<MockProvider>(
                onLoad: (p) async => await p.loadSuccess(['item1']),
                builder: (context, p) => const Text('Data loaded'),
              ),
            ),
          ),
        ),
      );

      // Initial pump - microtask scheduled but not executed yet
      await tester.pump();

      // Should show loading after microtask executes
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Should show data
      expect(find.text('Data loaded'), findsOneWidget);
    });

    testWidgets('shows custom loading builder', (tester) async {
      final provider = MockProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: MaterialApp(
            home: Scaffold(
              body: AsyncBuilder<MockProvider>(
                onLoad: (p) async => await p.loadSuccess(['item1']),
                loadingBuilder: (context) => const Text('Custom loading'),
                builder: (context, p) => const Text('Data loaded'),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Custom loading'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('Data loaded'), findsOneWidget);
    });

    testWidgets('shows error state with default error builder', (tester) async {
      final provider = MockProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: MaterialApp(
            home: Scaffold(
              body: AsyncBuilder<MockProvider>(
                onLoad: (p) async => await p.loadFailure(Exception('Test error')),
                builder: (context, p) => const Text('Data loaded'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.textContaining('Test error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('shows custom error builder with error object', (tester) async {
      final provider = MockProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: MaterialApp(
            home: Scaffold(
              body: AsyncBuilder<MockProvider>(
                onLoad: (p) async => await p.loadFailure(Exception('Custom error message')),
                errorBuilder: (context, p, error) {
                  return Text('Custom error: ${error.toString()}');
                },
                builder: (context, p) => const Text('Data loaded'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Custom error:'), findsOneWidget);
      expect(find.textContaining('Custom error message'), findsOneWidget);
    });

    testWidgets('retry button calls onLoad again', (tester) async {
      final provider = MockProvider();
      var loadCallCount = 0;

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: MaterialApp(
            home: Scaffold(
              body: AsyncBuilder<MockProvider>(
                onLoad: (p) async {
                  loadCallCount++;
                  await p.loadFailure(Exception('Error'));
                },
                builder: (context, p) => const Text('Data loaded'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(loadCallCount, 1);

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(loadCallCount, 2);
    });

    testWidgets('shows empty state', (tester) async {
      final provider = MockProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: MaterialApp(
            home: Scaffold(
              body: AsyncBuilder<MockProvider>(
                onLoad: (p) async => await p.loadSuccess([]),
                isEmpty: (p) => p.data?.isEmpty ?? true,
                builder: (context, p) => const Text('Data loaded'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('No data found'), findsOneWidget);
    });

    testWidgets('shows custom empty builder', (tester) async {
      final provider = MockProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: MaterialApp(
            home: Scaffold(
              body: AsyncBuilder<MockProvider>(
                onLoad: (p) async => await p.loadSuccess([]),
                isEmpty: (p) => p.data?.isEmpty ?? true,
                emptyBuilder: (context) => const Text('Custom empty state'),
                builder: (context, p) => const Text('Data loaded'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Custom empty state'), findsOneWidget);
    });

    testWidgets('shows data state', (tester) async {
      final provider = MockProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: MaterialApp(
            home: Scaffold(
              body: AsyncBuilder<MockProvider>(
                onLoad: (p) async => await p.loadSuccess(['item1', 'item2']),
                isEmpty: (p) => p.data?.isEmpty ?? true,
                builder: (context, p) => Text('Items: ${p.data!.length}'),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Items: 2'), findsOneWidget);
    });

    testWidgets('builder has access to provider data', (tester) async {
      final provider = MockProvider();

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: MaterialApp(
            home: Scaffold(
              body: AsyncBuilder<MockProvider>(
                onLoad: (p) async => await p.loadSuccess(['a', 'b', 'c']),
                builder: (context, p) {
                  return Column(
                    children: p.data!.map((item) => Text(item)).toList(),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('a'), findsOneWidget);
      expect(find.text('b'), findsOneWidget);
      expect(find.text('c'), findsOneWidget);
    });
  });
}
