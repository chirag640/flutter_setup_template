// Enhanced application logger with levels, console/file logging, rotation, and helpers.
// File logging uses conditional imports to avoid dart:io on web.

import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

// Conditional file sink: uses IO implementation when available, otherwise a no-op stub
import 'file_log_sink_stub.dart' if (dart.library.io) 'file_log_sink_io.dart';

enum LogLevel {
  debug(0, 'DEBUG', '🐛'),
  info(1, 'INFO', 'ℹ️'),
  warning(2, 'WARNING', '⚠️'),
  error(3, 'ERROR', '❌'),
  critical(4, 'CRITICAL', '🚨');

  const LogLevel(this.level, this.label, this.emoji);
  final int level;
  final String label;
  final String emoji;
}

class AppLogger {
  AppLogger._internal();
  static AppLogger? _instance;
  static AppLogger get instance => _instance ??= AppLogger._internal();

  // Configuration
  LogLevel _minLogLevel = kDebugMode ? LogLevel.debug : LogLevel.info;
  bool _enableConsoleLogging = true;
  bool _enableFileLogging = true;
  bool _enableCrashlytics = false; // placeholder switch
  int _maxLogFileSize = 5 * 1024 * 1024; // 5MB
  int _maxLogFiles = 5;

  // Internal state
  FileLogSink? _fileSink;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final List<String> _logBuffer = <String>[];
  bool _isInitialized = false;

  // Public getters
  LogLevel get minLogLevel => _minLogLevel;
  bool get isConsoleLoggingEnabled => _enableConsoleLogging;
  bool get isFileLoggingEnabled => _enableFileLogging;

  Future<void> init({
    LogLevel minLogLevel = LogLevel.debug,
    bool enableConsoleLogging = true,
    bool enableFileLogging = true,
    bool enableCrashlytics = false,
    int maxLogFileSize = 5 * 1024 * 1024,
    int maxLogFiles = 5,
  }) async {
    _minLogLevel = minLogLevel;
    _enableConsoleLogging = enableConsoleLogging;
    _enableFileLogging = enableFileLogging;
    _enableCrashlytics = enableCrashlytics;
    _maxLogFileSize = maxLogFileSize;
    _maxLogFiles = maxLogFiles;

    if (_enableFileLogging) {
      _fileSink = FileLogSink();
      try {
        await _fileSink!.init(maxFileSizeBytes: _maxLogFileSize, maxFiles: _maxLogFiles);
      } catch (e) {
        // If file sink fails (e.g., on web), disable file logging
        _enableFileLogging = false;
        _fileSink = null;
        // Fall back to console log of the issue
        _printToConsole(LogLevel.warning, 'File logging disabled: $e');
      }
    }

    _isInitialized = true;

    info('Logger initialized', tag: 'Logger');
    info('Min log level: ${_minLogLevel.label}', tag: 'Logger');
    info('Console logging: $_enableConsoleLogging', tag: 'Logger');
    info('File logging: $_enableFileLogging', tag: 'Logger');
  }

  // Public API (short)
  void d(String message, {String? tag, dynamic extra}) => _log(LogLevel.debug, message, tag: tag, extra: extra);
  void i(String message, {String? tag, dynamic extra}) => _log(LogLevel.info, message, tag: tag, extra: extra);
  void w(String message, {String? tag, dynamic extra}) => _log(LogLevel.warning, message, tag: tag, extra: extra);
  void e(String message, {String? tag, dynamic extra, StackTrace? stackTrace}) =>
      _log(LogLevel.error, message, tag: tag, extra: extra, stackTrace: stackTrace);
  void c(String message, {String? tag, dynamic extra, StackTrace? stackTrace}) =>
      _log(LogLevel.critical, message, tag: tag, extra: extra, stackTrace: stackTrace);

  // Public API (aliases)
  void debug(String message, {String? tag, dynamic extra}) => d(message, tag: tag, extra: extra);
  void info(String message, {String? tag, dynamic extra}) => i(message, tag: tag, extra: extra);
  void warning(String message, {String? tag, dynamic extra}) => w(message, tag: tag, extra: extra);
  void error(String message, {String? tag, dynamic extra, StackTrace? stackTrace}) =>
      e(message, tag: tag, extra: extra, stackTrace: stackTrace);
  void critical(String message, {String? tag, dynamic extra, StackTrace? stackTrace}) =>
      c(message, tag: tag, extra: extra, stackTrace: stackTrace);

  void _log(
    LogLevel level,
    String message, {
    String? tag,
    dynamic extra,
    StackTrace? stackTrace,
  }) {
    if (level.level < _minLogLevel.level) return;

    final timestamp = _dateFormat.format(DateTime.now());
    final tagStr = tag != null ? '[$tag]' : '';
    final logMessage = '$timestamp ${level.emoji} ${level.label} $tagStr: $message';

    if (_enableConsoleLogging) {
      _printToConsole(level, logMessage, extra: extra, stackTrace: stackTrace);
    }

    if (_enableFileLogging && _isInitialized && _fileSink != null) {
      final buffer = StringBuffer(logMessage)
        ..writeln();
      if (extra != null) buffer.writeln('Extra: $extra');
      if (stackTrace != null) buffer.writeln('StackTrace: $stackTrace');
      _fileSink!.write(buffer.toString());
    }

    _logBuffer.add(logMessage);
    if (_logBuffer.length > 100) _logBuffer.removeAt(0);

    if (_enableCrashlytics && level.level >= LogLevel.error.level) {
      // Hook here to your crash reporting service (e.g., Firebase Crashlytics)
      // Example:
      // FirebaseCrashlytics.instance.log('${level.label}: $message');
      // if (level == LogLevel.critical) {
      //   FirebaseCrashlytics.instance.recordError(message, stackTrace, fatal: true);
      // }
    }
  }

  void _printToConsole(LogLevel level, String message, {dynamic extra, StackTrace? stackTrace}) {
    // ANSI colors (supported in most dev consoles)
    const reset = '\x1B[0m';
    const red = '\x1B[31m';
    const yellow = '\x1B[33m';
    const blue = '\x1B[34m';
    const green = '\x1B[32m';
    const magenta = '\x1B[35m';

    String color;
    switch (level) {
      case LogLevel.debug:
        color = blue;
        break;
      case LogLevel.info:
        color = green;
        break;
      case LogLevel.warning:
        color = yellow;
        break;
      case LogLevel.error:
        color = red;
        break;
      case LogLevel.critical:
        color = magenta;
        break;
    }

    final colored = '$color$message$reset';
    if (kDebugMode) {
      // print is fine in debug, keeps formatting
      // ignore: avoid_print
      print(colored);
      if (extra != null) {
        // ignore: avoid_print
        print('${color}Extra: $extra$reset');
      }
      if (stackTrace != null) {
        // ignore: avoid_print
        print('${color}StackTrace: $stackTrace$reset');
      }
    } else {
      developer.log(
        message,
        name: 'AppLogger',
        level: level.level * 100,
        error: extra,
        stackTrace: stackTrace,
      );
    }
  }

  String getRecentLogs({int count = 50}) {
    final recent = _logBuffer.length > count ? _logBuffer.sublist(_logBuffer.length - count) : _logBuffer;
    return recent.join('\n');
  }

  String? getLogFilePath() => _fileSink?.filePath;

  Future<void> clearLogs() async {
    _logBuffer.clear();
    if (_enableFileLogging && _fileSink != null) {
      try {
        await _fileSink!.clear();
      } catch (_) {}
    }
  }

  Future<String?> exportLogs() async {
    if (_fileSink != null) {
      try {
        final content = await _fileSink!.readAll();
        if (content != null && content.isNotEmpty) return content;
      } catch (_) {}
    }
    return getRecentLogs();
  }

  Future<Object?> getLogFileForSharing() async {
    if (_fileSink != null) {
      try {
        return await _fileSink!.getFileForSharing();
      } catch (_) {}
    }
    return null;
  }

  Map<String, dynamic> getLogStats() {
    final Map<LogLevel, int> levelCounts = {};
    for (final log in _logBuffer) {
      for (final level in LogLevel.values) {
        if (log.contains(level.label)) {
          levelCounts[level] = (levelCounts[level] ?? 0) + 1;
          break;
        }
      }
    }
    return {
      'total_logs': _logBuffer.length,
      'level_counts': levelCounts.map((k, v) => MapEntry(k.label, v)),
      'log_file_path': _fileSink?.filePath,
      'file_logging_enabled': _enableFileLogging,
      'console_logging_enabled': _enableConsoleLogging,
      'min_log_level': _minLogLevel.label,
    };
  }
}

// Easy extension methods for any object
extension LoggerExtension on Object {
  void logd(String message, {dynamic extra}) => AppLogger.instance.d(message, tag: runtimeType.toString(), extra: extra);
  void logi(String message, {dynamic extra}) => AppLogger.instance.i(message, tag: runtimeType.toString(), extra: extra);
  void logw(String message, {dynamic extra}) => AppLogger.instance.w(message, tag: runtimeType.toString(), extra: extra);
  void loge(String message, {dynamic extra, StackTrace? stackTrace}) =>
      AppLogger.instance.e(message, tag: runtimeType.toString(), extra: extra, stackTrace: stackTrace);
  void logc(String message, {dynamic extra, StackTrace? stackTrace}) =>
      AppLogger.instance.c(message, tag: runtimeType.toString(), extra: extra, stackTrace: stackTrace);
}

// Simple performance timing utilities
class PerformanceLogger {
  static final Map<String, Stopwatch> _stopwatches = <String, Stopwatch>{};
  static final AppLogger _logger = AppLogger.instance;

  static void startTiming(String operationName) {
    _stopwatches[operationName] = Stopwatch()..start();
    _logger.d('Started timing: $operationName', tag: 'Performance');
  }

  static Duration stopTiming(String operationName) {
    final sw = _stopwatches.remove(operationName);
    if (sw == null) {
      _logger.w('No stopwatch found for: $operationName', tag: 'Performance');
      return Duration.zero;
    }
    sw.stop();
    final duration = sw.elapsed;
    _logger.i('⏱️ $operationName took ${duration.inMilliseconds}ms', tag: 'Performance');
    if (duration.inMilliseconds > 1000) {
      _logger.w('Slow operation detected: $operationName (${duration.inMilliseconds}ms)', tag: 'Performance');
    }
    return duration;
  }

  static Future<T> timeAsync<T>(String operationName, Future<T> Function() op) async {
    startTiming(operationName);
    try {
      final result = await op();
      stopTiming(operationName);
      return result;
    } catch (e) {
      stopTiming(operationName);
      rethrow;
    }
  }

  static T timeSync<T>(String operationName, T Function() op) {
    startTiming(operationName);
    try {
      final result = op();
      stopTiming(operationName);
      return result;
    } catch (e) {
      stopTiming(operationName);
      rethrow;
    }
  }
}

// Compatibility wrapper to mimic a subset of the `package:logger` API used elsewhere in the app.
// Provides `log.d`, `log.i`, `log.w`, `log.e`, `log.wtf`, and `log.v` forwarding to AppLogger.
final CompatLogger log = CompatLogger();

class CompatLogger {
  void d(dynamic message, {Object? error, StackTrace? stackTrace}) =>
    AppLogger.instance.d(message.toString(), extra: error);
  void i(dynamic message, {Object? error, StackTrace? stackTrace}) =>
    AppLogger.instance.i(message.toString(), extra: error);
  void w(dynamic message, {Object? error, StackTrace? stackTrace}) =>
    AppLogger.instance.w(message.toString(), extra: error);
  void e(dynamic message, {Object? error, StackTrace? stackTrace}) =>
    AppLogger.instance.e(message.toString(), extra: error, stackTrace: stackTrace);
  // Map 'wtf' (what a terrible failure) to critical
  void wtf(dynamic message, {Object? error, StackTrace? stackTrace}) =>
    AppLogger.instance.c(message.toString(), extra: error, stackTrace: stackTrace);
  // Verbose -> debug
  void v(dynamic message, {Object? error, StackTrace? stackTrace}) =>
    AppLogger.instance.d(message.toString(), extra: error);
}

