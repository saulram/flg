import '../../config/fcli_config.dart';
import '../../utils/string_utils.dart';

/// Template for generating main.dart
class MainTemplate {
  MainTemplate._();

  static String generate(FcliConfig config) {
    final appName = StringUtils.toPascalCase(config.projectName);

    if (config.usesRiverpod) {
      return _generateRiverpod(config, appName);
    } else if (config.usesBloc) {
      return _generateBloc(config, appName);
    } else {
      return _generateProvider(config, appName);
    }
  }

  static String _generateRiverpod(FcliConfig config, String appName) {
    final routerImport = config.usesGoRouter
        ? "import 'core/router/app_router.dart';"
        : "import 'core/router/app_router.dart';";

    final routerConfig = config.usesGoRouter
        ? '''
      routerConfig: AppRouter.router,'''
        : '''
      routerConfig: _appRouter.config(),''';

    final routerField = config.usesAutoRoute
        ? '''
  final _appRouter = AppRouter();

'''
        : '';

    return '''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

$routerImport

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: ${appName}App(),
    ),
  );
}

class ${appName}App extends ConsumerWidget {
  const ${appName}App({super.key});

$routerField  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: '$appName',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
$routerConfig
      debugShowCheckedModeBanner: false,
    );
  }
}
''';
  }

  static String _generateBloc(FcliConfig config, String appName) {
    final routerConfig = config.usesGoRouter
        ? '''
      routerConfig: AppRouter.router,'''
        : '''
      routerConfig: _appRouter.config(),''';

    final routerField = config.usesAutoRoute
        ? '''
  final _appRouter = AppRouter();

'''
        : '';

    return '''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ${appName}App());
}

class ${appName}App extends StatelessWidget {
  const ${appName}App({super.key});

$routerField  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Add your BlocProviders here
      ],
      child: MaterialApp.router(
        title: '$appName',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
$routerConfig
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
''';
  }

  static String _generateProvider(FcliConfig config, String appName) {
    final routerConfig = config.usesGoRouter
        ? '''
      routerConfig: AppRouter.router,'''
        : '''
      routerConfig: _appRouter.config(),''';

    final routerField = config.usesAutoRoute
        ? '''
  final _appRouter = AppRouter();

'''
        : '';

    return '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ${appName}App());
}

class ${appName}App extends StatelessWidget {
  const ${appName}App({super.key});

$routerField  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Add your ChangeNotifierProviders here
      ],
      child: MaterialApp.router(
        title: '$appName',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
$routerConfig
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
''';
  }
}
