/// Template for generating core/usecases/usecase.dart
class UseCaseBaseTemplate {
  UseCaseBaseTemplate._();

  static String generate() => '''
import 'package:dartz/dartz.dart';

import '../error/failures.dart';

/// Base class for all use cases.
///
/// [Type] is the return type of the use case.
/// [Params] is the type of parameters the use case accepts.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case that doesn't require any parameters.
abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}

/// Use case that returns a stream.
abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

/// Use case that returns a stream and doesn't require parameters.
abstract class StreamUseCaseNoParams<Type> {
  Stream<Either<Failure, Type>> call();
}

/// Placeholder class for use cases that don't require parameters.
class NoParams {
  const NoParams();
}
''';
}
