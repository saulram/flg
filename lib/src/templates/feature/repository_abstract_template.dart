import '../../utils/string_utils.dart';

/// Template for generating domain/repositories/<feature>_repository.dart
class RepositoryAbstractTemplate {
  RepositoryAbstractTemplate._();

  /// Generates an abstract repository interface.
  ///
  /// [featureName] - The feature name (e.g., 'user', 'product')
  /// [entityName] - Optional custom entity name, defaults to feature name
  /// [methods] - Optional list of methods as tuples (returnType, name, params)
  static String generate(
    String featureName, {
    String? entityName,
    List<(String returnType, String name, String params)>? methods,
  }) {
    final name = entityName ?? featureName;
    final pascalName = StringUtils.toPascalCase(name);
    final snakeName = StringUtils.toSnakeCase(name);

    final methodsList = methods ?? _defaultMethods(pascalName);
    final methodsCode = _generateMethods(methodsList);

    return '''
import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../entities/${snakeName}_entity.dart';

/// Abstract repository interface for $pascalName operations.
abstract class ${pascalName}Repository {
$methodsCode
}
''';
  }

  static List<(String, String, String)> _defaultMethods(String pascalName) => [
        (
          'Future<Either<Failure, List<${pascalName}Entity>>>',
          'getAll',
          '',
        ),
        (
          'Future<Either<Failure, ${pascalName}Entity>>',
          'getById',
          'String id',
        ),
        (
          'Future<Either<Failure, ${pascalName}Entity>>',
          'create',
          '${pascalName}Entity entity',
        ),
        (
          'Future<Either<Failure, ${pascalName}Entity>>',
          'update',
          '${pascalName}Entity entity',
        ),
        (
          'Future<Either<Failure, void>>',
          'delete',
          'String id',
        ),
      ];

  static String _generateMethods(
      List<(String returnType, String name, String params)> methods) {
    final buffer = StringBuffer();
    for (final (returnType, name, params) in methods) {
      buffer.writeln('  $returnType $name($params);');
      buffer.writeln();
    }
    return buffer.toString();
  }
}
