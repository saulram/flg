// Copyright (c) 2025, Saul Ramirez. All rights reserved.
// Use of this source code is governed by an MIT-style license.

/// MCP Server for FLG - Flutter Generator CLI.
///
/// Exposes FLG functionality as MCP tools for use with AI assistants
/// like Claude Code.
library;

import 'dart:async';
import 'dart:io' as io;

import 'package:dart_mcp/server.dart';
import 'package:dart_mcp/stdio.dart';

void main() {
  FlgMcpServer(stdioChannel(input: io.stdin, output: io.stdout));
}

/// MCP Server that exposes FLG tools to AI assistants.
base class FlgMcpServer extends MCPServer with ToolsSupport {
  FlgMcpServer(super.channel)
      : super.fromStreamChannel(
          implementation: Implementation(
            name: 'flg',
            version: '1.1.0',
          ),
          instructions: '''
FLG - Flutter Generator CLI

A tool for generating Flutter code with Clean Architecture.

Available tools:
- flg_generate_feature: Generate a complete feature module
- flg_generate_screen: Generate a screen widget
- flg_generate_widget: Generate a widget
- flg_generate_provider: Generate a provider/notifier/bloc
- flg_generate_usecase: Generate use cases
- flg_generate_repository: Generate repository
- flg_setup: Setup FLG in an existing project
- flg_info: Show project configuration
''',
        ) {
    // Register all tools
    registerTool(_generateFeatureTool, _generateFeature);
    registerTool(_generateScreenTool, _generateScreen);
    registerTool(_generateWidgetTool, _generateWidget);
    registerTool(_generateProviderTool, _generateProvider);
    registerTool(_generateUsecaseTool, _generateUsecase);
    registerTool(_generateRepositoryTool, _generateRepository);
    registerTool(_setupTool, _setup);
    registerTool(_infoTool, _info);
  }

  // ============================================================
  // Tool Definitions
  // ============================================================

  final _generateFeatureTool = Tool(
    name: 'flg_generate_feature',
    description:
        'Generates a complete feature module with Clean Architecture layers '
        '(domain, data, presentation). Creates entity, repository, model, '
        'datasource, screen, provider/notifier, and widget files.',
    inputSchema: Schema.object(
      properties: {
        'name': Schema.string(
          description: 'Name of the feature (e.g., "auth", "user_profile")',
        ),
        'path': Schema.string(
          description:
              'Path to the Flutter project. Defaults to current directory.',
        ),
        'dry_run': Schema.bool(
          description: 'Preview without creating files',
        ),
      },
      required: ['name'],
    ),
  );

  final _generateScreenTool = Tool(
    name: 'flg_generate_screen',
    description: 'Generates a screen widget for a feature.',
    inputSchema: Schema.object(
      properties: {
        'name': Schema.string(
          description: 'Name of the screen (e.g., "login", "profile_detail")',
        ),
        'feature': Schema.string(
          description: 'Feature the screen belongs to',
        ),
        'path': Schema.string(
          description: 'Path to the Flutter project',
        ),
      },
      required: ['name', 'feature'],
    ),
  );

  final _generateWidgetTool = Tool(
    name: 'flg_generate_widget',
    description: 'Generates a widget for a feature.',
    inputSchema: Schema.object(
      properties: {
        'name': Schema.string(
          description: 'Name of the widget (e.g., "user_avatar")',
        ),
        'feature': Schema.string(
          description: 'Feature the widget belongs to',
        ),
        'type': Schema.string(
          description:
              'Widget type: stateless, stateful, card, list_tile, form',
        ),
        'path': Schema.string(
          description: 'Path to the Flutter project',
        ),
      },
      required: ['name', 'feature'],
    ),
  );

  final _generateProviderTool = Tool(
    name: 'flg_generate_provider',
    description:
        'Generates a provider/notifier/bloc based on project state management.',
    inputSchema: Schema.object(
      properties: {
        'name': Schema.string(
          description: 'Name of the provider',
        ),
        'feature': Schema.string(
          description: 'Feature the provider belongs to',
        ),
        'path': Schema.string(
          description: 'Path to the Flutter project',
        ),
      },
      required: ['name', 'feature'],
    ),
  );

  final _generateUsecaseTool = Tool(
    name: 'flg_generate_usecase',
    description: 'Generates use case(s) for a feature.',
    inputSchema: Schema.object(
      properties: {
        'name': Schema.string(
          description: 'Name of the use case',
        ),
        'feature': Schema.string(
          description: 'Feature the use case belongs to',
        ),
        'action': Schema.string(
          description: 'Action type: get, create, update, delete',
        ),
        'crud': Schema.bool(
          description: 'Generate all CRUD use cases at once',
        ),
        'path': Schema.string(
          description: 'Path to the Flutter project',
        ),
      },
      required: ['name', 'feature'],
    ),
  );

  final _generateRepositoryTool = Tool(
    name: 'flg_generate_repository',
    description: 'Generates a repository interface and implementation.',
    inputSchema: Schema.object(
      properties: {
        'name': Schema.string(
          description: 'Name of the repository',
        ),
        'feature': Schema.string(
          description: 'Feature the repository belongs to',
        ),
        'path': Schema.string(
          description: 'Path to the Flutter project',
        ),
      },
      required: ['name', 'feature'],
    ),
  );

  final _setupTool = Tool(
    name: 'flg_setup',
    description: 'Sets up FLG in an existing Flutter project, creating '
        'the flg.json configuration file and core structure.',
    inputSchema: Schema.object(
      properties: {
        'path': Schema.string(
          description: 'Path to the Flutter project',
        ),
        'state': Schema.string(
          description: 'State management: riverpod, bloc, provider',
        ),
        'router': Schema.string(
          description: 'Router: go_router, auto_route',
        ),
        'skip_prompts': Schema.bool(
          description: 'Skip interactive prompts and use defaults',
        ),
      },
    ),
  );

  final _infoTool = Tool(
    name: 'flg_info',
    description:
        'Shows the current FLG configuration for a project (reads flg.json).',
    inputSchema: Schema.object(
      properties: {
        'path': Schema.string(
          description: 'Path to the Flutter project',
        ),
      },
    ),
  );

  // ============================================================
  // Tool Implementations
  // ============================================================

  FutureOr<CallToolResult> _generateFeature(CallToolRequest request) async {
    final name = request.arguments!['name'] as String;
    final path = request.arguments!['path'] as String? ?? io.Directory.current.path;
    final dryRun = request.arguments!['dry_run'] as bool? ?? false;

    final args = ['generate', 'feature', name];
    if (dryRun) args.add('--dry-run');

    return _runFlg(args, path);
  }

  FutureOr<CallToolResult> _generateScreen(CallToolRequest request) async {
    final name = request.arguments!['name'] as String;
    final feature = request.arguments!['feature'] as String;
    final path = request.arguments!['path'] as String? ?? io.Directory.current.path;

    return _runFlg(['generate', 'screen', name, '--feature', feature], path);
  }

  FutureOr<CallToolResult> _generateWidget(CallToolRequest request) async {
    final name = request.arguments!['name'] as String;
    final feature = request.arguments!['feature'] as String;
    final type = request.arguments!['type'] as String?;
    final path = request.arguments!['path'] as String? ?? io.Directory.current.path;

    final args = ['generate', 'widget', name, '--feature', feature];
    if (type != null) args.addAll(['--type', type]);

    return _runFlg(args, path);
  }

  FutureOr<CallToolResult> _generateProvider(CallToolRequest request) async {
    final name = request.arguments!['name'] as String;
    final feature = request.arguments!['feature'] as String;
    final path = request.arguments!['path'] as String? ?? io.Directory.current.path;

    return _runFlg(['generate', 'provider', name, '--feature', feature], path);
  }

  FutureOr<CallToolResult> _generateUsecase(CallToolRequest request) async {
    final name = request.arguments!['name'] as String;
    final feature = request.arguments!['feature'] as String;
    final action = request.arguments!['action'] as String?;
    final crud = request.arguments!['crud'] as bool? ?? false;
    final path = request.arguments!['path'] as String? ?? io.Directory.current.path;

    final args = ['generate', 'usecase', name, '--feature', feature];
    if (action != null) args.addAll(['--action', action]);
    if (crud) args.add('--crud');

    return _runFlg(args, path);
  }

  FutureOr<CallToolResult> _generateRepository(CallToolRequest request) async {
    final name = request.arguments!['name'] as String;
    final feature = request.arguments!['feature'] as String;
    final path = request.arguments!['path'] as String? ?? io.Directory.current.path;

    return _runFlg(['generate', 'repository', name, '--feature', feature], path);
  }

  FutureOr<CallToolResult> _setup(CallToolRequest request) async {
    final path = request.arguments!['path'] as String? ?? io.Directory.current.path;
    final state = request.arguments!['state'] as String?;
    final router = request.arguments!['router'] as String?;
    final skipPrompts = request.arguments!['skip_prompts'] as bool? ?? true;

    final args = ['setup'];
    if (state != null) args.addAll(['--state', state]);
    if (router != null) args.addAll(['--router', router]);
    if (skipPrompts) args.add('--skip-prompts');

    return _runFlg(args, path);
  }

  FutureOr<CallToolResult> _info(CallToolRequest request) async {
    final path = request.arguments!['path'] as String? ?? io.Directory.current.path;

    // Read flg.json directly
    final configFile = io.File('$path/flg.json');
    if (!configFile.existsSync()) {
      return CallToolResult(
        content: [
          TextContent(
            text: 'No flg.json found in $path\n\n'
                'Run "flg setup" to initialize FLG in this project.',
          ),
        ],
        isError: true,
      );
    }

    final config = configFile.readAsStringSync();
    return CallToolResult(
      content: [
        TextContent(
          text: 'FLG Configuration ($path/flg.json):\n\n$config',
        ),
      ],
    );
  }

  // ============================================================
  // Helper Methods
  // ============================================================

  Future<CallToolResult> _runFlg(List<String> args, String workingDirectory) async {
    try {
      final result = await io.Process.run(
        'flg',
        args,
        workingDirectory: workingDirectory,
      );

      final stdout = result.stdout.toString().trim();
      final stderr = result.stderr.toString().trim();

      if (result.exitCode != 0) {
        return CallToolResult(
          content: [
            TextContent(
              text: 'Command failed with exit code ${result.exitCode}\n\n'
                  'stdout:\n$stdout\n\n'
                  'stderr:\n$stderr',
            ),
          ],
          isError: true,
        );
      }

      return CallToolResult(
        content: [
          TextContent(
            text: stdout.isNotEmpty ? stdout : 'Command completed successfully.',
          ),
        ],
      );
    } catch (e) {
      return CallToolResult(
        content: [
          TextContent(
            text: 'Error running flg: $e\n\n'
                'Make sure flg is installed: dart pub global activate flg',
          ),
        ],
        isError: true,
      );
    }
  }
}
