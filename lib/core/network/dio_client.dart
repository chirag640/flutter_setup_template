import 'package:dio/dio.dart';

/// Lightweight Dio wrapper so the rest of the app can depend on a single
/// injectable client. The full interceptor stack arrives in later phases.
class DioClient {
  DioClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: 'https://api.example.com',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: const <String, Object?>{
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

  final Dio _dio;

  Dio get dio => _dio;
}
