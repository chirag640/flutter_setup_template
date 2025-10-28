import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'logger_service.dart';
import 'network_logger.dart';

@immutable
class ApiResult {
  const ApiResult({
    required this.statusCode,
    required this.body,
    required this.headers,
  });
  final int statusCode;
  final Map<String, dynamic> body;
  final Map<String, String> headers;

  bool get ok {
    // Prefer explicit response signals from the body when present.
    // If the API returns a response_code (or code) treat it as the source of truth.
    final dynamic rcRaw =
        body['response_code'] ?? body['responseCode'] ?? body['code'];
    if (rcRaw != null) {
      final rcStr = rcRaw.toString();
      // treat numeric 200/201 as success; anything else is failure
      if (rcStr == '200' || rcStr == '201') return true;
      return false;
    }

    // If API returns a boolean status flag, use it.
    final st = body['status'];
    if (st is bool) return st;

    // No explicit status in body, fallback to HTTP status code.
    return statusCode >= 200 && statusCode < 300;
  }

  String message([String fallback = 'Something went wrong']) {
    return body['message']?.toString() ?? body['obj']?.toString() ?? fallback;
  }
}

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;
  @override
  String toString() => 'ApiException($statusCode): $message';
}

typedef TokenProvider = Future<String?> Function();

class ApiClient {
  ApiClient({
    this.tokenProvider,
    http.Client? client,
    this.timeout = const Duration(seconds: 20),
  }) : _client = client ?? LoggingHttpClient();

  /// Convenience factory to ensure logging client is used explicitly
  factory ApiClient.withLogging({
    TokenProvider? tokenProvider,
    Duration timeout = const Duration(seconds: 20),
  }) {
    return ApiClient(
      tokenProvider: tokenProvider,
      client: LoggingHttpClient(),
      timeout: timeout,
    );
  }
  final http.Client _client;
  final TokenProvider? tokenProvider;
  final Duration timeout;

  Future<ApiResult> post(
    String url, {
    Map<String, dynamic>? body,
    bool auth = false,
    Map<String, String>? headers,
  }) async {
    final h = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?headers,
    };
    if (auth && tokenProvider != null) {
      final t = await tokenProvider!.call();
      // Log token presence (preview only) for debugging — do not enable in production
      try {
        log.i({
          'POST-token-present': t != null && t.isNotEmpty,
          'token_preview': t == null
              ? null
              : (t.length > 8
                    ? '${t.substring(0, 4)}...${t.substring(t.length - 4)}'
                    : t),
        });
      } catch (_) {}
      if (t != null && t.isNotEmpty) {
        h['Authorization'] = 'Bearer $t';
        h['token'] = t; // some APIs expect this
      }
    }
    // Log the exact request we are about to send for troubleshooting
    try {
      log.i({
        'POST-sending': {'url': url, 'headers': h, 'body': body ?? {}},
      });
    } catch (_) {}
    final stopwatch = Stopwatch()..start();
    try {
      final resp = await _client
          .post(Uri.parse(url), headers: h, body: jsonEncode(body ?? {}))
          .timeout(timeout);
      final parsed = _tryDecode(resp.body);
      final result = ApiResult(
        statusCode: resp.statusCode,
        body: parsed,
        headers: resp.headers,
      );
      stopwatch.stop();
      NetworkStatsLogger.recordRequest(url, stopwatch.elapsed, resp.statusCode);
      if (result.ok) {
        log.i({'POST': url, 'code': resp.statusCode});
      } else {
        log.e({
          'POST': url,
          'code': resp.statusCode,
          'response_code': parsed['response_code'],
          'message': parsed['message'],
          'obj': parsed['obj'],
        });
      }
      return result;
    } on TimeoutException catch (e) {
      stopwatch.stop();
      log.e('POST timeout $url', error: e);
      throw ApiException('Request timed out');
    } on SocketException catch (e) {
      stopwatch.stop();
      log.e('POST network $url', error: e);
      throw ApiException('Network error');
    } catch (e) {
      stopwatch.stop();
      log.e('POST unknown $url', error: e);
      throw ApiException(e.toString());
    }
  }

  /// Upload a single file as multipart/form-data. Returns ApiResult similar
  /// to [post]. Caller is responsible for parsing response body.
  Future<ApiResult> uploadFile(
    String url, {
    required File file,
    String field = 'file',
    bool auth = false,
    Map<String, String>? fields,
    Map<String, String>? headers,
  }) async {
    final h = <String, String>{'Accept': 'application/json', ...?headers};
    if (auth && tokenProvider != null) {
      final t = await tokenProvider!.call();
      if (t != null && t.isNotEmpty) {
        h['Authorization'] = 'Bearer $t';
        h['token'] = t;
      }
    }

    final stopwatch = Stopwatch()..start();
    try {
      final uri = Uri.parse(url);
      final req = http.MultipartRequest('POST', uri);
      req.headers.addAll(h);
      // add additional form fields
      if (fields != null) req.fields.addAll(fields);
      final stream = http.ByteStream(file.openRead());
      final length = await file.length();
      final multipartFile = http.MultipartFile(
        field,
        stream,
        length,
        filename: file.path.split('/').last,
      );
      req.files.add(multipartFile);

      // Use underlying client to send so LoggingHttpClient can capture it
      final streamed = await _client.send(req).timeout(timeout);
      final resp = await http.Response.fromStream(streamed);
      final parsed = _tryDecode(resp.body);
      final result = ApiResult(
        statusCode: resp.statusCode,
        body: parsed,
        headers: resp.headers,
      );

      // Always log response body for upload debugging
      log.i({'UPLOAD': url, 'code': resp.statusCode, 'body': parsed});
      stopwatch.stop();
      NetworkStatsLogger.recordRequest(url, stopwatch.elapsed, resp.statusCode);

      return result;
    } on TimeoutException catch (e) {
      stopwatch.stop();
      log.e('UPLOAD timeout $url', error: e);
      throw ApiException('Request timed out');
    } on SocketException catch (e) {
      stopwatch.stop();
      log.e('UPLOAD network $url', error: e);
      throw ApiException('Network error');
    } catch (e) {
      stopwatch.stop();
      log.e('UPLOAD unknown $url', error: e);
      throw ApiException(e.toString());
    }
  }

  static String extractToken(ApiResult r) {
    final h = r.headers;
    final b = r.body;
    return h['token'] ??
        h['authorization'] ??
        h['auth-token'] ??
        b['token']?.toString() ??
        b['access_token']?.toString() ??
        b['auth_token']?.toString() ??
        '';
  }

  Map<String, dynamic> _tryDecode(String src) {
    try {
      final v = jsonDecode(src);
      if (v is Map<String, dynamic>) return v;
      return {'data': v};
    } catch (_) {
      return {'raw': src};
    }
  }
}
