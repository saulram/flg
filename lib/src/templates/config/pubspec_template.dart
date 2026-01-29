import '../../config/fcli_config.dart';

/// Template for generating pubspec.yaml
class PubspecTemplate {
  PubspecTemplate._();

  /// Generates a pubspec.yaml file.
  static String generate(FcliConfig config) {
    final deps = <String>[];
    final devDeps = <String>[];

    // Core dependencies
    deps.addAll([
      '  flutter:',
      '    sdk: flutter',
      '  equatable: ^2.0.5',
      '  dartz: ^0.10.1',
    ]);

    // State management
    switch (config.stateManagement) {
      case StateManagement.riverpod:
        deps.add('  flutter_riverpod: ^2.4.9');
        deps.add('  riverpod_annotation: ^2.3.3');
        devDeps.add('  riverpod_generator: ^2.3.9');
      case StateManagement.bloc:
        deps.add('  flutter_bloc: ^8.1.3');
      case StateManagement.provider:
        deps.add('  provider: ^6.1.1');
    }

    // Router
    switch (config.router) {
      case RouterOption.goRouter:
        deps.add('  go_router: ^13.0.1');
      case RouterOption.autoRoute:
        deps.add('  auto_route: ^7.8.4');
        devDeps.add('  auto_route_generator: ^7.3.2');
    }

    // Freezed
    if (config.useFreezed) {
      deps.add('  freezed_annotation: ^2.4.1');
      devDeps.add('  freezed: ^2.4.6');
      devDeps.add('  json_serializable: ^6.7.1');
    }

    // HTTP client
    if (config.useDioClient) {
      deps.add('  dio: ^5.4.0');
    } else {
      deps.add('  http: ^1.1.2');
    }

    // L10n
    if (config.l10n) {
      deps.add('  flutter_localizations:');
      deps.add('    sdk: flutter');
      deps.add('  intl: ^0.18.1');
    }

    // Dev dependencies
    devDeps.addAll([
      '  flutter_test:',
      '    sdk: flutter',
      '  flutter_lints: ^3.0.1',
      '  build_runner: ^2.4.8',
      '  mocktail: ^1.0.1',
    ]);

    return '''
name: ${config.projectName}
description: A Flutter project with Clean Architecture.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.0.0

dependencies:
${deps.join('\n')}

dev_dependencies:
${devDeps.join('\n')}

flutter:
  uses-material-design: true
${config.l10n ? '''
  generate: true
''' : ''}
''';
  }

  /// Generates the l10n.yaml file for localization.
  static String generateL10nYaml() => '''
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
''';

  /// Generates the default English ARB file.
  static String generateDefaultArb(String projectName) => '''
{
  "@@locale": "en",
  "appTitle": "$projectName",
  "@appTitle": {
    "description": "The title of the application"
  }
}
''';
}
