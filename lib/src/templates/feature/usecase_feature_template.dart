import '../../utils/string_utils.dart';

/// Template for generating domain/usecases/<action>_<feature>_usecase.dart
class UseCaseFeatureTemplate {
  UseCaseFeatureTemplate._();

  /// Generates a use case class.
  ///
  /// [featureName] - The feature name (e.g., 'user', 'product')
  /// [action] - The action (e.g., 'get', 'create', 'update', 'delete')
  /// [entityName] - Optional custom entity name, defaults to feature name
  /// [returnType] - Optional custom return type
  /// [paramsType] - Optional params type (null for NoParams)
  static String generate(
    String featureName,
    String action, {
    String? entityName,
    String? returnType,
    String? paramsType,
    String? paramsFields,
  }) {
    final name = entityName ?? featureName;
    final pascalName = StringUtils.toPascalCase(name);
    final snakeName = StringUtils.toSnakeCase(name);
    final pascalAction = StringUtils.toPascalCase(action);
    final camelAction = StringUtils.toCamelCase(action);

    final useCaseName = '$pascalAction$pascalName';
    final hasParams = paramsType != null;
    final effectiveReturnType = returnType ?? '${pascalName}Entity';
    final effectiveParamsType = paramsType ?? 'NoParams';

    final paramsClass = hasParams
        ? _generateParamsClass(useCaseName, paramsType!, paramsFields)
        : '';

    final repoMethod = _getRepoMethod(action, pascalName);

    return '''
import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../entities/${snakeName}_entity.dart';
import '../repositories/${snakeName}_repository.dart';

/// Use case for ${action}ing $pascalName.
class ${useCaseName}UseCase implements UseCase<$effectiveReturnType, $effectiveParamsType> {
  const ${useCaseName}UseCase(this._repository);

  final ${pascalName}Repository _repository;

  @override
  Future<Either<Failure, $effectiveReturnType>> call($effectiveParamsType params) {
    return _repository.$repoMethod;
  }
}
$paramsClass
''';
  }

  static String _getRepoMethod(String action, String pascalName) {
    switch (action.toLowerCase()) {
      case 'get':
        return 'getById(params.id)';
      case 'getall' || 'get_all' || 'list':
        return 'getAll()';
      case 'create':
        return 'create(params.entity)';
      case 'update':
        return 'update(params.entity)';
      case 'delete':
        return 'delete(params.id)';
      default:
        return '$action(params)';
    }
  }

  static String _generateParamsClass(
    String useCaseName,
    String paramsType,
    String? paramsFields,
  ) {
    final fields = paramsFields ?? _defaultParamsFields(paramsType);
    return '''

/// Parameters for ${useCaseName}UseCase.
class $paramsType {
  const $paramsType($fields);

${_generateParamsProperties(fields)}
}
''';
  }

  static String _defaultParamsFields(String paramsType) {
    if (paramsType.contains('Id')) {
      return '{required this.id}';
    }
    if (paramsType.contains('Entity')) {
      return '{required this.entity}';
    }
    return '{}';
  }

  static String _generateParamsProperties(String fields) {
    final buffer = StringBuffer();
    final regex = RegExp(r'this\.(\w+)');
    final matches = regex.allMatches(fields);

    for (final match in matches) {
      final fieldName = match.group(1)!;
      final type = _inferType(fieldName);
      buffer.writeln('  final $type $fieldName;');
    }
    return buffer.toString();
  }

  static String _inferType(String fieldName) {
    if (fieldName == 'id') return 'String';
    if (fieldName.endsWith('Entity')) return fieldName;
    if (fieldName.endsWith('Id')) return 'String';
    return 'dynamic';
  }

  /// Generates a set of common use cases for a feature.
  static Map<String, String> generateCommonUseCases(
    String featureName, {
    String? entityName,
  }) {
    final name = entityName ?? featureName;
    final pascalName = StringUtils.toPascalCase(name);
    final snakeName = StringUtils.toSnakeCase(name);

    return {
      'get_${snakeName}_usecase.dart': generate(
        featureName,
        'get',
        entityName: entityName,
        paramsType: 'Get${pascalName}Params',
        paramsFields: '{required this.id}',
      ),
      'get_all_${snakeName}s_usecase.dart': generate(
        featureName,
        'getAll',
        entityName: entityName,
        returnType: 'List<${pascalName}Entity>',
      ),
      'create_${snakeName}_usecase.dart': generate(
        featureName,
        'create',
        entityName: entityName,
        paramsType: 'Create${pascalName}Params',
        paramsFields: '{required this.entity}',
      ),
      'update_${snakeName}_usecase.dart': generate(
        featureName,
        'update',
        entityName: entityName,
        paramsType: 'Update${pascalName}Params',
        paramsFields: '{required this.entity}',
      ),
      'delete_${snakeName}_usecase.dart': generate(
        featureName,
        'delete',
        entityName: entityName,
        returnType: 'void',
        paramsType: 'Delete${pascalName}Params',
        paramsFields: '{required this.id}',
      ),
    };
  }
}
