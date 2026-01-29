/// Template for generating core/error/exceptions.dart
class ExceptionsTemplate {
  ExceptionsTemplate._();

  static String generate() => '''
/// Base exception class for the application.
abstract class AppException implements Exception {
  const AppException([this.message]);

  final String? message;

  @override
  String toString() => message ?? runtimeType.toString();
}

/// Exception thrown when a server error occurs.
class ServerException extends AppException {
  const ServerException([super.message]);
}

/// Exception thrown when there is no internet connection.
class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}

/// Exception thrown when a cache operation fails.
class CacheException extends AppException {
  const CacheException([super.message]);
}

/// Exception thrown when authentication fails.
class AuthException extends AppException {
  const AuthException([super.message]);
}

/// Exception thrown when a resource is not found.
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found']);
}

/// Exception thrown when validation fails.
class ValidationException extends AppException {
  const ValidationException([super.message]);

  final Map<String, List<String>> errors = const {};
}

/// Exception thrown when the user is not authorized.
class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized']);
}

/// Exception thrown when a request times out.
class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Request timed out']);
}
''';
}
