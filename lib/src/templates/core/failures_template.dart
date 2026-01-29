/// Template for generating core/error/failures.dart
class FailuresTemplate {
  FailuresTemplate._();

  static String generate() => '''
import 'package:equatable/equatable.dart';

/// Base failure class for the application.
/// Represents a failure that occurred during an operation.
abstract class Failure extends Equatable {
  const Failure([this.message = 'An unexpected error occurred']);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Failure caused by server errors.
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

/// Failure caused by network issues.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network error occurred']);
}

/// Failure caused by cache issues.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

/// Failure caused by authentication issues.
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

/// Failure when a resource is not found.
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

/// Failure caused by validation errors.
class ValidationFailure extends Failure {
  const ValidationFailure([
    super.message = 'Validation failed',
    this.errors = const {},
  ]);

  final Map<String, List<String>> errors;

  @override
  List<Object?> get props => [message, errors];
}

/// Failure caused by unauthorized access.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized access']);
}

/// Failure caused by request timeout.
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timed out']);
}

/// Unknown or unexpected failure.
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'An unexpected error occurred']);
}
''';
}
