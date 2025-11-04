import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider_demo/index.dart';

class UserService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  final http.Client _client;

  UserService(this._client);

  Future<List<User>> getUsers() async {
    try {
      final response = await _client
          .get(Uri.parse('$baseUrl/users'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        try {
          final List<dynamic> jsonList =
              json.decode(response.body) as List<dynamic>;
          return jsonList
              .map((json) => User.fromJson(json as Map<String, dynamic>))
              .toList();
        } catch (e) {
          throw ParseException('Invalid JSON structure: $e');
        }
      } else if (response.statusCode >= 500) {
        throw ServerException(response.statusCode);
      } else {
        throw NetworkException(
          response.statusCode,
          'Failed to load users: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw RequestTimeoutException();
    } on ApiException {
      rethrow;
    }
  }
}
