import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:setup/core/providers/upload_provider.dart';
import 'package:setup/core/services/api_client.dart';

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  const mockUrl = 'https://example.com/upload';

  test('UploadService returns parsed filename when response is ok', () async {
    final api = _MockApiClient();
    final file = File('dummy.txt');
    final service = UploadService(api);

    when(() => api.uploadFile(mockUrl, file: file, auth: true)).thenAnswer(
      (_) async => const ApiResult(
        statusCode: 200,
        body: {
          'obj': {'fileName': 'photo.png'},
        },
        headers: {},
      ),
    );

    final result = await service.uploadSingleFile(url: mockUrl, file: file);
    expect(result, 'photo.png');
  });

  test('UploadService returns null when response is not ok', () async {
    final api = _MockApiClient();
    final file = File('dummy.txt');
    final service = UploadService(api);

    when(() => api.uploadFile(mockUrl, file: file, auth: true)).thenAnswer(
      (_) async => const ApiResult(
        statusCode: 500,
        body: {'status': false},
        headers: {},
      ),
    );

    final result = await service.uploadSingleFile(url: mockUrl, file: file);
    expect(result, isNull);
  });

  test('uploadServiceProvider can be overridden for testing', () async {
    final api = _MockApiClient();
    final container = ProviderContainer(
      overrides: [apiClientProvider.overrideWithValue(api)],
    );
    addTearDown(container.dispose);

    final service = container.read(uploadServiceProvider);

    final file = File('dummy.txt');

    when(() => api.uploadFile(mockUrl, file: file, auth: true)).thenAnswer(
      (_) async => const ApiResult(
        statusCode: 200,
        body: {'raw': 'asset.jpg'},
        headers: {},
      ),
    );

    final result = await service.uploadSingleFile(url: mockUrl, file: file);
    expect(result, 'asset.jpg');
  });
}
