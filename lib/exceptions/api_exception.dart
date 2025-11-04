/// Base exception class for all API-related errors.
///
/// This provides a common interface for handling various types of API failures
/// with specific error messages and context.
abstract class ApiException implements Exception {
  /// Human-readable error message describing what went wrong
  String get message;

  @override
  String toString() => message;
}

/// Exception thrown when a network request fails due to HTTP errors.
///
/// This includes client errors (4xx) and other network-related issues.
class NetworkException extends ApiException {
  /// HTTP status code from the failed request
  final int statusCode;

  /// Detailed error message
  @override
  final String message;

  NetworkException(this.statusCode, this.message);

  @override
  String toString() => 'NetworkException($statusCode): $message';
}

/// Exception thrown when a request times out.
///
/// This occurs when the server doesn't respond within the configured timeout period.
class RequestTimeoutException extends ApiException {
  @override
  String get message => 'Request timed out. Please check your connection and try again.';

  @override
  String toString() => 'RequestTimeoutException: $message';
}

/// Exception thrown when response parsing fails.
///
/// This typically happens when the API returns invalid JSON or unexpected data structure.
class ParseException extends ApiException {
  /// Details about what went wrong during parsing
  final String reason;

  ParseException(this.reason);

  @override
  String get message => 'Failed to parse response: $reason';

  @override
  String toString() => 'ParseException: $message';
}

/// Exception thrown when the server returns a 5xx error.
///
/// This indicates server-side issues that are typically temporary.
class ServerException extends ApiException {
  /// HTTP status code (5xx)
  final int statusCode;

  ServerException(this.statusCode);

  @override
  String get message =>
      'Server error ($statusCode). Please try again later.';

  @override
  String toString() => 'ServerException($statusCode): $message';
}

/// Exception thrown when there is no internet connection.
///
/// This occurs when the device cannot reach the network.
class NoInternetException extends ApiException {
  @override
  String get message =>
      'No internet connection. Please check your network settings.';

  @override
  String toString() => 'NoInternetException: $message';
}
