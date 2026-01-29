import '../../config/fcli_config.dart';

/// Template for generating fcli.json
class FcliJsonTemplate {
  FcliJsonTemplate._();

  /// Generates a fcli.json configuration file.
  static String generate(FcliConfig config) => '''
{
  "projectName": "${config.projectName}",
  "org": "${config.org}",
  "stateManagement": "${config.stateManagement.value}",
  "router": "${config.router.value}",
  "useFreezed": ${config.useFreezed},
  "useDioClient": ${config.useDioClient},
  "platforms": [${config.platforms.map((p) => '"${p.value}"').join(', ')}],
  "features": [${config.features.map((f) => '"$f"').join(', ')}],
  "generateTests": ${config.generateTests},
  "l10n": ${config.l10n}
}
''';

  /// Generates a schema for fcli.json (for documentation).
  static String generateSchema() => '''
{
  "\$schema": "http://json-schema.org/draft-07/schema#",
  "title": "fcli Configuration",
  "type": "object",
  "properties": {
    "projectName": {
      "type": "string",
      "description": "The name of the Flutter project"
    },
    "org": {
      "type": "string",
      "description": "Organization identifier (reverse domain)",
      "default": "com.example"
    },
    "stateManagement": {
      "type": "string",
      "enum": ["riverpod", "bloc", "provider"],
      "description": "State management solution",
      "default": "riverpod"
    },
    "router": {
      "type": "string",
      "enum": ["go_router", "auto_route"],
      "description": "Navigation/routing solution",
      "default": "go_router"
    },
    "useFreezed": {
      "type": "boolean",
      "description": "Whether to use Freezed for data classes",
      "default": true
    },
    "useDioClient": {
      "type": "boolean",
      "description": "Whether to use Dio for HTTP requests",
      "default": true
    },
    "platforms": {
      "type": "array",
      "items": {
        "type": "string",
        "enum": ["android", "ios", "web", "macos", "windows", "linux"]
      },
      "description": "Target platforms",
      "default": ["android", "ios"]
    },
    "features": {
      "type": "array",
      "items": {
        "type": "string"
      },
      "description": "List of feature modules"
    },
    "generateTests": {
      "type": "boolean",
      "description": "Whether to generate test files",
      "default": true
    },
    "l10n": {
      "type": "boolean",
      "description": "Whether to enable localization",
      "default": false
    }
  },
  "required": ["projectName"]
}
''';
}
