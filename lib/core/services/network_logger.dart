import 'dart:convert';
import 'package:http/http.dart' as http;
import 'logger_service.dart';

class NetworkLogger {
  static const String _tag = 'NetworkLogger';
  static final AppLogger _logger = AppLogger.instance;

  static void logRequest(
    String method,
    Uri uri, {
    Map<String, String>? headers,
    dynamic body,
    String? requestId,
  }) {
    final id = requestId ?? _generateRequestId();

    final StringBuffer buffer = StringBuffer();
    buffer.writeln('🌐 HTTP REQUEST [$id]');
    buffer.writeln('Method: $method');
    buffer.writeln('URL: $uri');

    if (headers != null && headers.isNotEmpty) {
      buffer.writeln('Headers:');
      headers.forEach((key, value) {
        if (_isSensitiveHeader(key)) {
          buffer.writeln('  $key: ***HIDDEN***');
        } else {
          buffer.writeln('  $key: $value');
        }
      });
    }

    if (body != null) {
      buffer.writeln('Body:');
      buffer.writeln(_formatBody(body));
    }

    _logger.d(buffer.toString(), tag: _tag);
  }

  static void logResponse(
    http.Response response, {
    String? requestId,
    Duration? duration,
  }) {
    final id = requestId ?? _generateRequestId();

    final StringBuffer buffer = StringBuffer();
    buffer.writeln('📥 HTTP RESPONSE [$id]');
    buffer.writeln('Status: ${response.statusCode} ${response.reasonPhrase ?? ''}');
    buffer.writeln('URL: ${response.request?.url}');

    if (duration != null) {
      buffer.writeln('Duration: ${duration.inMilliseconds}ms');
    }

    if (response.headers.isNotEmpty) {
      buffer.writeln('Headers:');
      response.headers.forEach((key, value) {
        buffer.writeln('  $key: $value');
      });
    }

    if (response.body.isNotEmpty) {
      buffer.writeln('Body:');
      buffer.writeln(_formatResponseBody(response.body, response.headers['content-type']));
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      _logger.d(buffer.toString(), tag: _tag);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      _logger.w(buffer.toString(), tag: _tag);
    } else if (response.statusCode >= 500) {
      _logger.e(buffer.toString(), tag: _tag);
    } else {
      _logger.i(buffer.toString(), tag: _tag);
    }
  }

  static void logError(
    String method,
    Uri uri,
    dynamic error, {
    StackTrace? stackTrace,
    String? requestId,
    Duration? duration,
  }) {
    final id = requestId ?? _generateRequestId();

    final StringBuffer buffer = StringBuffer();
    buffer.writeln('❌ HTTP ERROR [$id]');
    buffer.writeln('Method: $method');
    buffer.writeln('URL: $uri');

    if (duration != null) {
      buffer.writeln('Duration: ${duration.inMilliseconds}ms');
    }

    buffer.writeln('Error: $error');

    _logger.e(buffer.toString(), tag: _tag, stackTrace: stackTrace);
  }

  static String _generateRequestId() => DateTime.now().millisecondsSinceEpoch.toString();

  static bool _isSensitiveHeader(String headerName) {
    final sensitiveHeaders = {
      'authorization',
      'cookie',
      'set-cookie',
      'x-api-key',
      'x-auth-token',
      'x-access-token',
      'bearer',
    };
    return sensitiveHeaders.contains(headerName.toLowerCase());
  }

  static String _formatBody(dynamic body) {
    if (body == null) return 'null';
    try {
      if (body is String) {
        try {
          final jsonData = jsonDecode(body);
          return _formatJson(jsonData);
        } catch (_) {
          return body;
        }
      } else if (body is Map || body is List) {
        return _formatJson(body);
      } else {
        return body.toString();
      }
    } catch (e) {
      return 'Error formatting body: $e';
    }
  }

  static String _formatResponseBody(String body, String? contentType) {
    if (body.isEmpty) return 'Empty';
    try {
      if (contentType?.toLowerCase().contains('json') ?? false) {
        final jsonData = jsonDecode(body);
        return _formatJson(jsonData);
      }
      if (contentType?.toLowerCase().contains('xml') ?? false) {
        return _formatXml(body);
      }
      if (body.length > 1000) {
        return '${body.substring(0, 1000)}...\n[Content truncated - ${body.length} characters total]';
      }
      return body;
    } catch (_) {
      if (body.length > 500) {
        return '${body.substring(0, 500)}...\n[Raw content truncated - ${body.length} characters total]';
      }
      return body;
    }
  }

  static String _formatJson(dynamic json) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    } catch (_) {
      return json.toString();
    }
  }

  static String _formatXml(String xml) {
    try {
      return xml.replaceAllMapped(RegExp(r'><'), (m) => '>\n<')
        .replaceAllMapped(RegExp(r'<([^>]+)>'), (m) => '  ${m.group(0)}');
    } catch (_) {
      return xml;
    }
  }
}

class LoggingHttpClient extends http.BaseClient {
  final http.Client _inner;
  final bool _logRequests;
  final bool _logResponses;
  final bool _logErrors;

  LoggingHttpClient({
    http.Client? innerClient,
    bool logRequests = true,
    bool logResponses = true,
    bool logErrors = true,
  })  : _inner = innerClient ?? http.Client(),
        _logRequests = logRequests,
        _logResponses = logResponses,
        _logErrors = logErrors;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final requestId = NetworkLogger._generateRequestId();
    final stopwatch = Stopwatch()..start();

    try {
      if (_logRequests) {
        String? body;
        if (request is http.Request) {
          body = request.body;
        }
        NetworkLogger.logRequest(
          request.method,
          request.url,
          headers: request.headers,
          body: body,
          requestId: requestId,
        );
      }

      final streamed = await _inner.send(request);
      final response = await http.Response.fromStream(streamed);
      stopwatch.stop();

      if (_logResponses) {
        NetworkLogger.logResponse(
          response,
          requestId: requestId,
          duration: stopwatch.elapsed,
        );
      }

      return http.StreamedResponse(
        Stream.fromIterable([response.bodyBytes]),
        response.statusCode,
        contentLength: response.bodyBytes.length,
        request: request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    } catch (error, stackTrace) {
      stopwatch.stop();
      if (_logErrors) {
        NetworkLogger.logError(
          request.method,
          request.url,
          error,
          stackTrace: stackTrace,
          requestId: requestId,
          duration: stopwatch.elapsed,
        );
      }
      rethrow;
    }
  }

  @override
  void close() => _inner.close();
}

class NetworkStatsLogger {
  static final Map<String, List<Duration>> _requestTimes = <String, List<Duration>>{};
  static final Map<String, int> _requestCounts = <String, int>{};
  static final Map<int, int> _statusCodeCounts = <int, int>{};
  static int _totalRequests = 0;
  static int _totalErrors = 0;

  static void recordRequest(String endpoint, Duration duration, int statusCode) {
    _totalRequests++;
    _requestTimes.putIfAbsent(endpoint, () => <Duration>[]).add(duration);
    _requestCounts[endpoint] = (_requestCounts[endpoint] ?? 0) + 1;
    _statusCodeCounts[statusCode] = (_statusCodeCounts[statusCode] ?? 0) + 1;
    if (statusCode >= 400) _totalErrors++;
  }

  static Map<String, dynamic> getStats() {
    final Map<String, Map<String, dynamic>> endpointStats = <String, Map<String, dynamic>>{};

    _requestTimes.forEach((endpoint, times) {
      if (times.isNotEmpty) {
        times.sort();
        final avg = times.fold<int>(0, (sum, t) => sum + t.inMilliseconds) / times.length;
        final median = times[times.length ~/ 2].inMilliseconds;
        endpointStats[endpoint] = {
          'count': _requestCounts[endpoint] ?? 0,
          'avg_time_ms': avg.round(),
          'median_time_ms': median,
          'min_time_ms': times.first.inMilliseconds,
          'max_time_ms': times.last.inMilliseconds,
        };
      }
    });

    return {
      'total_requests': _totalRequests,
      'total_errors': _totalErrors,
      'error_rate': _totalRequests > 0 ? (_totalErrors / _totalRequests * 100).toStringAsFixed(2) : '0.00',
      'status_code_counts': _statusCodeCounts,
      'endpoint_stats': endpointStats,
      'last_updated': DateTime.now().toIso8601String(),
    };
  }

  static void logStatsSummary() {
    final stats = getStats();
    final logger = AppLogger.instance;

    logger.i('📊 Network Statistics Summary:', tag: 'NetworkStats');
    logger.i('Total Requests: ${stats['total_requests']}', tag: 'NetworkStats');
    logger.i('Total Errors: ${stats['total_errors']}', tag: 'NetworkStats');
    logger.i('Error Rate: ${stats['error_rate']}%', tag: 'NetworkStats');

    final statusCodes = stats['status_code_counts'] as Map<int, int>;
    if (statusCodes.isNotEmpty) {
      logger.i('Status Codes:', tag: 'NetworkStats');
      statusCodes.forEach((code, count) {
        logger.i('  $code: $count', tag: 'NetworkStats');
      });
    }
  }

  static void clearStats() {
    _requestTimes.clear();
    _requestCounts.clear();
    _statusCodeCounts.clear();
    _totalRequests = 0;
    _totalErrors = 0;
  }
}
