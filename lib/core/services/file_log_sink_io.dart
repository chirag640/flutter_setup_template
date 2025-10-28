// IO implementation of the file log sink (mobile/desktop). Uses path_provider.

import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class FileLogSink {
  File? _logFile;
  late int _maxFileSizeBytes;
  late int _maxFiles;

  String? get filePath => _logFile?.path;

  Future<void> init({
    required int maxFileSizeBytes,
    required int maxFiles,
  }) async {
    _maxFileSizeBytes = maxFileSizeBytes;
    _maxFiles = maxFiles;

    final dir = await getApplicationDocumentsDirectory();
    final logsDir = Directory('${dir.path}/logs');
    if (!await logsDir.exists()) {
      await logsDir.create(recursive: true);
    }
    final day = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _logFile = File('${logsDir.path}/app_log_$day.log');
    await _rotateIfNeeded();
    await _cleanupOldLogs(logsDir);
  }

  void write(String data) {
    final file = _logFile;
    if (file == null) return;
    file
        .writeAsString(data, mode: FileMode.append)
        .then((_) async {
          await _rotateIfNeeded();
        })
        .catchError((_) {});
  }

  Future<void> clear() async {
    final file = _logFile;
    if (file == null) return;
    if (await file.exists()) {
      await file.delete();
      await file.create(recursive: true);
    }
  }

  Future<String?> readAll() async {
    final file = _logFile;
    if (file == null || !await file.exists()) return null;
    try {
      return await file.readAsString();
    } catch (_) {
      return null;
    }
  }

  Future<Object?> getFileForSharing() async {
    final file = _logFile;
    if (file == null || !await file.exists()) return null;
    return file; // Return File for platform share integrations
  }

  Future<void> _rotateIfNeeded() async {
    final file = _logFile;
    if (file == null) return;
    if (await file.exists()) {
      final size = await file.length();
      if (size > _maxFileSizeBytes) {
        await _archiveCurrent(file);
      }
    }
  }

  Future<void> _archiveCurrent(File current) async {
    final ts = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());
    final archivedPath = current.path.replaceFirst('.log', '_$ts.log');
    try {
      await current.rename(archivedPath);
    } catch (_) {
      // If rename fails (e.g., across volumes), fallback to copy+truncate
      try {
        await current.copy(archivedPath);
        await current.writeAsString('');
      } catch (_) {}
    }
    // Recreate current file handle
    _logFile = File(current.path);
  }

  Future<void> _cleanupOldLogs(Directory logsDir) async {
    try {
      final files = await logsDir
          .list()
          .where((e) => e is File && e.path.endsWith('.log'))
          .cast<File>()
          .toList();
      files.sort(
        (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
      );
      if (files.length > _maxFiles) {
        for (int i = _maxFiles; i < files.length; i++) {
          try {
            await files[i].delete();
          } catch (_) {}
        }
      }
    } catch (_) {}
  }
}
