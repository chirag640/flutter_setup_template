import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_client.dart';
import '../services/logger_service.dart';

/// Provides a shared [ApiClient] instance that callers can override in tests.
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient.withLogging();
});

/// Service responsible for orchestrating file uploads and parsing results.
class UploadService {
  UploadService(this._apiClient);

  final ApiClient _apiClient;

  Future<String?> uploadSingleFile({
    required String url,
    required File file,
    String field = 'file',
    bool auth = true,
    Map<String, String>? fields,
    Map<String, String>? headers,
  }) async {
    try {
      final res = await _apiClient.uploadFile(
        url,
        file: file,
        field: field,
        auth: auth,
        fields: fields,
        headers: headers,
      );

      if (!res.ok) {
        AppLogger.instance.w(
          'Upload failed',
          tag: runtimeType.toString(),
          extra: {'code': res.statusCode, 'body': res.body},
        );
        return null;
      }

      return _parseUploadResponse(res.body);
    } catch (e, st) {
      AppLogger.instance.e(
        'Upload threw exception',
        tag: runtimeType.toString(),
        extra: e,
        stackTrace: st,
      );
      return null;
    }
  }

  String? _parseUploadResponse(Map<String, dynamic> body) {
    if (body.containsKey('raw')) {
      final raw = body['raw']?.toString() ?? '';
      if (raw.trim().isEmpty || raw.trim().toLowerCase() == 'string') {
        AppLogger.instance.w(
          'Upload returned placeholder raw payload',
          tag: runtimeType.toString(),
          extra: raw,
        );
        return null;
      }
      if (!raw.contains(' ')) return raw;
    }

    final dynamic data = body['data'];
    if (data is List && data.isNotEmpty) {
      final first = data.first;
      if (first != null) return first.toString();
    }

    final obj = body['obj'];
    if (obj is Map<String, dynamic>) {
      if (obj['fileName'] != null) return obj['fileName'].toString();
      if (obj['path'] != null) return obj['path'].toString();
      if (obj['file'] != null) return obj['file'].toString();
    } else if (obj is String) {
      final s = obj.trim();
      if (s.isNotEmpty && !s.contains(' ') && s.length < 300) return s;
    }

    if (body['fileName'] != null) return body['fileName'].toString();
    if (body['path'] != null) return body['path'].toString();
    if (body['file'] != null) return body['file'].toString();

    AppLogger.instance.w(
      'Upload returned unexpected payload',
      tag: runtimeType.toString(),
      extra: body,
    );
    return null;
  }
}

/// Riverpod provider that exposes a lazily created [UploadService].
final uploadServiceProvider = Provider<UploadService>((ref) {
  final api = ref.watch(apiClientProvider);
  return UploadService(api);
});
