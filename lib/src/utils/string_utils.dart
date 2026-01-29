import 'package:recase/recase.dart';

/// Utility class for string transformations using recase.
class StringUtils {
  StringUtils._();

  /// Converts string to PascalCase (e.g., "user profile" -> "UserProfile")
  static String toPascalCase(String input) => ReCase(input).pascalCase;

  /// Converts string to camelCase (e.g., "user profile" -> "userProfile")
  static String toCamelCase(String input) => ReCase(input).camelCase;

  /// Converts string to snake_case (e.g., "UserProfile" -> "user_profile")
  static String toSnakeCase(String input) => ReCase(input).snakeCase;

  /// Converts string to kebab-case (e.g., "UserProfile" -> "user-profile")
  static String toKebabCase(String input) => ReCase(input).paramCase;

  /// Converts string to CONSTANT_CASE (e.g., "userProfile" -> "USER_PROFILE")
  static String toConstantCase(String input) => ReCase(input).constantCase;

  /// Converts string to Title Case (e.g., "user_profile" -> "User Profile")
  static String toTitleCase(String input) => ReCase(input).titleCase;

  /// Converts string to Sentence case (e.g., "user_profile" -> "User profile")
  static String toSentenceCase(String input) => ReCase(input).sentenceCase;

  /// Converts string to dot.case (e.g., "UserProfile" -> "user.profile")
  static String toDotCase(String input) => ReCase(input).dotCase;

  /// Converts string to path/case (e.g., "UserProfile" -> "user/profile")
  static String toPathCase(String input) => ReCase(input).pathCase;

  /// Gets the plural form of a word (simple implementation)
  static String toPlural(String input) {
    if (input.isEmpty) return input;

    final lower = input.toLowerCase();

    // Handle common irregular plurals
    const irregulars = {
      'child': 'children',
      'person': 'people',
      'man': 'men',
      'woman': 'women',
      'tooth': 'teeth',
      'foot': 'feet',
      'mouse': 'mice',
      'goose': 'geese',
    };

    if (irregulars.containsKey(lower)) {
      final plural = irregulars[lower]!;
      // Preserve original case
      if (input[0].toUpperCase() == input[0]) {
        return plural[0].toUpperCase() + plural.substring(1);
      }
      return plural;
    }

    // Handle words ending in 'y'
    if (lower.endsWith('y') && !_isVowel(lower[lower.length - 2])) {
      return '${input.substring(0, input.length - 1)}ies';
    }

    // Handle words ending in 's', 'x', 'z', 'ch', 'sh'
    if (lower.endsWith('s') ||
        lower.endsWith('x') ||
        lower.endsWith('z') ||
        lower.endsWith('ch') ||
        lower.endsWith('sh')) {
      return '${input}es';
    }

    // Handle words ending in 'f' or 'fe'
    if (lower.endsWith('f')) {
      return '${input.substring(0, input.length - 1)}ves';
    }
    if (lower.endsWith('fe')) {
      return '${input.substring(0, input.length - 2)}ves';
    }

    // Default: add 's'
    return '${input}s';
  }

  static bool _isVowel(String char) =>
      ['a', 'e', 'i', 'o', 'u'].contains(char.toLowerCase());

  /// Capitalizes the first letter of the string
  static String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  /// Converts to lowercase
  static String toLowerCase(String input) => input.toLowerCase();

  /// Converts to uppercase
  static String toUpperCase(String input) => input.toUpperCase();
}
