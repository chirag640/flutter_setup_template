import 'package:flutter_test/flutter_test.dart';
import 'package:setup/core/services/logger_service.dart';

void main() {
  group('AppLogger', () {
    late AppLogger logger;

    setUp(() async {
      logger = AppLogger.instance;
      await logger.init(enableConsoleLogging: false, enableFileLogging: false);
      await logger.clearLogs();
    });

    test('initialization updates configuration', () {
      expect(logger.isInitialized, isTrue);
      expect(logger.minLogLevel, equals(LogLevel.debug));
      expect(logger.isConsoleLoggingEnabled, isFalse);
      expect(logger.isFileLoggingEnabled, isFalse);
    });

    test('filters logs below minimum level', () async {
      await logger.init(
        minLogLevel: LogLevel.info,
        enableConsoleLogging: false,
        enableFileLogging: false,
      );
      await logger.clearLogs();

      logger.d('Debug message should be ignored');
      logger.i('Info message should be logged');

      final logs = logger.getRecentLogs();
      expect(logs.contains('DEBUG'), isFalse);
      expect(logs.contains('INFO'), isTrue);
    });
  });
}
