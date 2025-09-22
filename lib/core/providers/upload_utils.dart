import 'dart:io';
import '../services/api_client.dart';
import '../services/logger_service.dart';

/// Centralized file upload helper.
/// Returns a server-provided path/filename string on success, or null on failure.
Future<String?> uploadSingleFile(
  ApiClient api, {
  required String url,
  required File file,
  String field = 'file',
  bool auth = true,
  Map<String, String>? fields,
}) async {
  try {
    final res = await api.uploadFile(
      url,
      file: file,
      field: field,
      auth: auth,
      fields: fields,
    );

    if (!res.ok) {
      log.w({'upload_failed': {'code': res.statusCode, 'body': res.body}});
      return null;
    }

    final Map<String, dynamic> body = res.body;
    // If the server returned a raw string (decoded into {'raw': '...'}),
    // prefer to treat obvious placeholders like 'string' as failure.
    if (body.containsKey('raw')) {
      final raw = body['raw']?.toString() ?? '';
      // reject placeholder 'string' or empty values
      if (raw.trim().isEmpty || raw.trim().toLowerCase() == 'string') {
        log.w({'upload_raw_unhelpful': raw});
        return null;
      }
      // If raw looks like a path or filename, return it
      if (!raw.contains(' ')) return raw;
    }
    // Try common patterns
    // 1) data: [ "fileName" ]
    final dynamic data = body['data'];
    if (data is List && data.isNotEmpty) {
      final first = data.first;
      if (first != null) return first.toString();
    }

    // 2) obj: can be either a map { fileName: ..., path: ... } or a
    //    simple string filename (some backends return the filename directly).
    final obj = body['obj'];
    if (obj is Map<String, dynamic>) {
      if (obj['fileName'] != null) return obj['fileName'].toString();
      if (obj['path'] != null) return obj['path'].toString();
      if (obj['file'] != null) return obj['file'].toString();
    } else if (obj is String) {
      // Validate simple filename string (no spaces, reasonable length)
      final s = obj.trim();
      if (s.isNotEmpty && !s.contains(' ') && s.length < 300) return s;
    }

    // 3) direct fields { fileName: ... }
    if (body['fileName'] != null) return body['fileName'].toString();
    if (body['path'] != null) return body['path'].toString();
    if (body['file'] != null) return body['file'].toString();

    log.w({'upload_unexpected_format': body});
    return null;
  } catch (e, st) {
    log.e('uploadSingleFile error', error: e, stackTrace: st);
    return null;
  }
}
