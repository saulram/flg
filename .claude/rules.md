# Dart CLI Development Rules

## Project Structure

```
bin/
  main.dart              # Main entry point
lib/
  src/
    commands/            # CLI commands (one per file)
    models/              # Data models
    services/            # Business logic
    utils/               # Shared utilities
  <package_name>.dart    # Barrel file exporting public API
test/
  commands/              # Command tests
  services/              # Service tests
  fixtures/              # Test data
pubspec.yaml
analysis_options.yaml
```

## Recommended Dependencies

### Core
- `args` - CLI argument parsing
- `cli_util` - Standard CLI utilities
- `path` - Cross-platform path manipulation

### Interactivity
- `interact_cli` or `prompts` - Interactive prompts
- `dart_console` - Advanced console manipulation

### Output
- `ansi_styles` or `chalk` - Terminal colors and styles
- `cli_spinners` - Progress indicators

### Testing
- `test` - Testing framework
- `mocktail` - Mocking
- `test_process` - Process testing

## Code Conventions

### Commands
```dart
// Use Command classes with CommandRunner
class MyCommand extends Command {
  @override
  String get name => 'command';

  @override
  String get description => 'Clear description of the command.';

  @override
  List<String> get aliases => ['c', 'cmd'];

  MyCommand() {
    argParser
      ..addFlag('verbose', abbr: 'v', help: 'Detailed output')
      ..addOption('output', abbr: 'o', help: 'Output directory');
  }

  @override
  Future<void> run() async {
    final verbose = argResults?['verbose'] as bool? ?? false;
    // Implementation
  }
}
```

### Error Handling
```dart
// Use UsageException for user errors
throw UsageException('Missing required argument', usage);

// Standard exit codes
abstract class ExitCode {
  static const success = 0;
  static const usage = 64;        // Usage error
  static const dataErr = 65;      // Input data error
  static const noInput = 66;      // Input file does not exist
  static const software = 70;     // Internal error
  static const ioErr = 74;        // I/O error
  static const config = 78;       // Configuration error
}
```

### Output and Logging
```dart
// Use stderr for errors and logs, stdout for output
stderr.writeln('Error: file not found');
stdout.writeln(result);

// Structured logger
class Logger {
  final bool verbose;

  void info(String message) => stdout.writeln(message);
  void error(String message) => stderr.writeln('Error: $message');
  void debug(String message) {
    if (verbose) stderr.writeln('[DEBUG] $message');
  }
}
```

## Best Practices

### 1. Configuration
- Support configuration files (`~/.config/app/config.yaml`)
- Environment variables as fallback
- CLI flags have highest precedence

### 2. Interactivity
- Detect if stdin is TTY before interactive prompts
- Provide `--yes` or `--no-interactive` flags for scripts

### 3. Output
- Use `--json` for machine-parseable output
- Use `--quiet` to silence non-essential output
- Colors only when stdout is TTY

### 4. Performance
- Lazy loading of heavy dependencies
- Show progress for long operations
- Support cancellation with Ctrl+C (SIGINT)

### 5. Documentation
- Include examples in `--help`
- Man pages or `--help-all` for extended documentation
- Error messages with solution suggestions

## Analysis Options

```yaml
include: package:lints/recommended.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true

linter:
  rules:
    - always_declare_return_types
    - avoid_print  # Use Logger instead
    - avoid_dynamic_calls
    - cancel_subscriptions
    - close_sinks
    - directives_ordering
    - prefer_single_quotes
    - require_trailing_commas
    - sort_constructors_first
    - sort_pub_dependencies
    - unawaited_futures
```

## Testing

### Test Structure
```dart
void main() {
  group('MyCommand', () {
    late CommandRunner runner;

    setUp(() {
      runner = CommandRunner('app', 'Description')
        ..addCommand(MyCommand());
    });

    test('executes correctly with valid arguments', () async {
      await runner.run(['mycommand', '--option', 'value']);
      // Verifications
    });

    test('shows error with invalid arguments', () async {
      expect(
        () => runner.run(['mycommand', '--invalid']),
        throwsA(isA<UsageException>()),
      );
    });
  });
}
```

### I/O Mocking
```dart
// Use IOOverrides for testing
await IOOverrides.runZoned(
  () async {
    // Test code
  },
  stdin: () => mockStdin,
  stdout: () => mockStdout,
);
```

## Publishing

### pubspec.yaml
```yaml
name: my_cli
description: Concise tool description.
version: 1.0.0
repository: https://github.com/user/my_cli

environment:
  sdk: ^3.0.0

executables:
  my-cli: main  # Executable name

dependencies:
  args: ^2.4.0
  # other dependencies

dev_dependencies:
  lints: ^3.0.0
  test: ^1.24.0
```

### Native Compilation
```bash
# Compile native executable
dart compile exe bin/main.dart -o my-cli

# With optimizations
dart compile exe bin/main.dart -o my-cli -O2
```

## Release Management

### Before Publishing
When the user requests to publish or create an update:

1. **Ask release type**: "¿Es release o pre-release?"
   - **Release**: Increment version (e.g., 1.1.0 → 1.2.0)
   - **Pre-release**: Increment pre-release (e.g., 1.2.0-beta.1 → 1.2.0-beta.2)

2. **Update ALL version strings** before publishing:
   - `pubspec.yaml` → `version:`
   - `bin/flg.dart` → `const String version =`
   - `bin/flg_mcp.dart` → `version:` in Implementation
   - `CHANGELOG.md` → Add new version section

3. **Commit version changes BEFORE `dart pub publish`**

### Version Locations
```
pubspec.yaml:5          → version: X.Y.Z
bin/flg.dart:11         → const String version = 'X.Y.Z';
bin/flg_mcp.dart:27     → version: 'X.Y.Z',
CHANGELOG.md            → ## [X.Y.Z] - YYYY-MM-DD
```

### Publishing Checklist
- [ ] Ask: release or pre-release?
- [ ] Update version in ALL 4 locations
- [ ] Update CHANGELOG.md with changes
- [ ] Run `dart analyze` (no errors)
- [ ] Run `dart test` (all pass)
- [ ] Commit all changes
- [ ] Create git tag: `git tag -a vX.Y.Z -m "message"`
- [ ] Push: `git push origin main && git push origin vX.Y.Z`
- [ ] Publish: `dart pub publish --force`
