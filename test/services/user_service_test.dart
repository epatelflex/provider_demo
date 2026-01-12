import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider_demo/index.dart';

void main() {
  group('UserService', () {
    test('getUsers() returns list of users on successful response', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        expect(request.url.toString(), contains('/users'));
        return http.Response('''
[
  {
    "id": 1,
    "name": "John Doe",
    "username": "johndoe",
    "email": "john@example.com",
    "phone": "123-456-7890",
    "website": "example.com",
    "address": {
      "street": "123 Main St",
      "suite": "Apt 1",
      "city": "Springfield",
      "zipcode": "12345",
      "geo": {"lat": "0.0", "lng": "0.0"}
    },
    "company": {
      "name": "Test Company",
      "catchPhrase": "Testing is fun",
      "bs": "test business"
    }
  },
  {
    "id": 2,
    "name": "Jane Smith",
    "username": "janesmith",
    "email": "jane@example.com",
    "phone": "098-765-4321",
    "website": "example.org",
    "address": {
      "street": "456 Oak Ave",
      "suite": "Suite 200",
      "city": "Springfield",
      "zipcode": "12345",
      "geo": {"lat": "1.0", "lng": "1.0"}
    },
    "company": {
      "name": "Another Company",
      "catchPhrase": "We test too",
      "bs": "another business"
    }
  }
]
''', 200);
      });

      final service = UserService(mockClient);

      // Act
      final users = await service.getUsers();

      // Assert
      expect(users, hasLength(2));
      expect(users[0].name, 'John Doe');
      expect(users[0].email, 'john@example.com');
      expect(users[1].name, 'Jane Smith');
      expect(users[1].email, 'jane@example.com');
    });

    test('getUsers() throws ParseException on invalid JSON', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response('invalid json', 200);
      });

      final service = UserService(mockClient);

      // Act & Assert
      expect(() => service.getUsers(), throwsA(isA<ParseException>()));
    });

    test(
      'getUsers() throws ParseException on missing required fields',
      () async {
        // Arrange
        final mockClient = MockClient((request) async {
          return http.Response('[{"id": 1}]', 200); // Missing required fields
        });

        final service = UserService(mockClient);

        // Act & Assert
        expect(() => service.getUsers(), throwsA(isA<ParseException>()));
      },
    );

    test('getUsers() throws NetworkException on 4xx errors', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final service = UserService(mockClient);

      // Act & Assert
      expect(
        () => service.getUsers(),
        throwsA(
          isA<NetworkException>()
              .having((e) => e.statusCode, 'statusCode', 404)
              .having((e) => e.message, 'message', contains('404')),
        ),
      );
    });

    test('getUsers() throws ServerException on 5xx errors', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final service = UserService(mockClient);

      // Act & Assert
      expect(
        () => service.getUsers(),
        throwsA(
          isA<ServerException>().having((e) => e.statusCode, 'statusCode', 500),
        ),
      );
    });

    test(
      'getUsers() throws ServerException on 503 Service Unavailable',
      () async {
        // Arrange
        final mockClient = MockClient((request) async {
          return http.Response('Service Unavailable', 503);
        });

        final service = UserService(mockClient);

        // Act & Assert
        expect(
          () => service.getUsers(),
          throwsA(
            isA<ServerException>().having(
              (e) => e.statusCode,
              'statusCode',
              503,
            ),
          ),
        );
      },
    );

    test('getUsers() throws RequestTimeoutException on timeout', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        await Future.delayed(const Duration(seconds: 11));
        return http.Response('Too late', 200);
      });

      final service = UserService(mockClient);

      // Act & Assert
      expect(() => service.getUsers(), throwsA(isA<RequestTimeoutException>()));
    });

    test('getUsers() throws NoInternetException on SocketException', () async {
      // Arrange
      final mockClient = MockClient((request) async {
        throw const SocketException('No internet connection');
      });

      final service = UserService(mockClient);

      // Act & Assert
      expect(() => service.getUsers(), throwsA(isA<NoInternetException>()));
    });

    test('exception messages are user-friendly', () {
      expect(NetworkException(404, 'Not found').message, 'Not found');

      expect(ServerException(500).message, contains('Server error'));

      expect(RequestTimeoutException().message, contains('timed out'));

      expect(ParseException('Invalid data').message, contains('parse'));

      expect(NoInternetException().message, contains('No internet'));
    });
  });
}
