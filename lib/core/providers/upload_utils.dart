import 'dart:io';

import '../services/api_client.dart';
import 'upload_provider.dart';

export 'upload_provider.dart';

/// Legacy helper retained for compatibility while migrating to Riverpod.
/// Prefer injecting [UploadService] via [uploadServiceProvider].
@Deprecated('Use UploadService via uploadServiceProvider instead.')
Future<String?> uploadSingleFile(
  ApiClient api, {
  required String url,
  required File file,
  String field = 'file',
  bool auth = true,
  Map<String, String>? fields,
  Map<String, String>? headers,
}) {
  final service = UploadService(api);
  return service.uploadSingleFile(
    url: url,
    file: file,
    field: field,
    auth: auth,
    fields: fields,
    headers: headers,
  );
}
