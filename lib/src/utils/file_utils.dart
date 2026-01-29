import 'dart:io';

import 'package:path/path.dart' as p;

/// Utility class for file system operations.
class FileUtils {
  FileUtils._();

  /// Creates a directory at the given path if it doesn't exist.
  /// Creates parent directories as needed.
  static Future<Directory> createDirectory(String path) async {
    final dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Creates a directory synchronously at the given path if it doesn't exist.
  static Directory createDirectorySync(String path) {
    final dir = Directory(path);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }

  /// Writes content to a file at the given path.
  /// Creates parent directories if they don't exist.
  static Future<File> writeFile(String path, String content) async {
    final file = File(path);
    await createDirectory(p.dirname(path));
    await file.writeAsString(content);
    return file;
  }

  /// Writes content to a file synchronously.
  static File writeFileSync(String path, String content) {
    final file = File(path);
    createDirectorySync(p.dirname(path));
    file.writeAsStringSync(content);
    return file;
  }

  /// Reads the content of a file.
  static Future<String> readFile(String path) async {
    final file = File(path);
    return file.readAsString();
  }

  /// Reads the content of a file synchronously.
  static String readFileSync(String path) {
    final file = File(path);
    return file.readAsStringSync();
  }

  /// Checks if a file exists at the given path.
  static Future<bool> fileExists(String path) async {
    final file = File(path);
    return file.exists();
  }

  /// Checks if a file exists synchronously.
  static bool fileExistsSync(String path) {
    final file = File(path);
    return file.existsSync();
  }

  /// Checks if a directory exists at the given path.
  static Future<bool> directoryExists(String path) async {
    final dir = Directory(path);
    return dir.exists();
  }

  /// Checks if a directory exists synchronously.
  static bool directoryExistsSync(String path) {
    final dir = Directory(path);
    return dir.existsSync();
  }

  /// Deletes a file at the given path.
  static Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Deletes a file synchronously.
  static void deleteFileSync(String path) {
    final file = File(path);
    if (file.existsSync()) {
      file.deleteSync();
    }
  }

  /// Deletes a directory and all its contents.
  static Future<void> deleteDirectory(String path) async {
    final dir = Directory(path);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  /// Deletes a directory synchronously.
  static void deleteDirectorySync(String path) {
    final dir = Directory(path);
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  }

  /// Copies a file from source to destination.
  static Future<File> copyFile(String source, String destination) async {
    final sourceFile = File(source);
    await createDirectory(p.dirname(destination));
    return sourceFile.copy(destination);
  }

  /// Lists all files in a directory (optionally recursive).
  static Future<List<File>> listFiles(
    String path, {
    bool recursive = false,
    List<String>? extensions,
  }) async {
    final dir = Directory(path);
    if (!await dir.exists()) {
      return [];
    }

    final files = <File>[];
    await for (final entity
        in dir.list(recursive: recursive, followLinks: false)) {
      if (entity is File) {
        if (extensions == null ||
            extensions.any((ext) => entity.path.endsWith(ext))) {
          files.add(entity);
        }
      }
    }
    return files;
  }

  /// Lists all files in a directory synchronously.
  static List<File> listFilesSync(
    String path, {
    bool recursive = false,
    List<String>? extensions,
  }) {
    final dir = Directory(path);
    if (!dir.existsSync()) {
      return [];
    }

    final files = <File>[];
    for (final entity
        in dir.listSync(recursive: recursive, followLinks: false)) {
      if (entity is File) {
        if (extensions == null ||
            extensions.any((ext) => entity.path.endsWith(ext))) {
          files.add(entity);
        }
      }
    }
    return files;
  }

  /// Gets the relative path from base to path.
  static String relativePath(String path, String base) =>
      p.relative(path, from: base);

  /// Joins path segments.
  static String joinPath(List<String> segments) => p.joinAll(segments);

  /// Gets the file name without extension.
  static String basenameWithoutExtension(String path) =>
      p.basenameWithoutExtension(path);

  /// Gets the file name with extension.
  static String basename(String path) => p.basename(path);

  /// Gets the directory name.
  static String dirname(String path) => p.dirname(path);

  /// Gets the file extension.
  static String extension(String path) => p.extension(path);

  /// Normalizes the path.
  static String normalize(String path) => p.normalize(path);

  /// Checks if path is absolute.
  static bool isAbsolute(String path) => p.isAbsolute(path);

  /// Gets the current working directory.
  static String get currentDirectory => Directory.current.path;
}
