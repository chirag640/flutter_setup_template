// No-op file log sink used on platforms that do not support dart:io (e.g., web).

class FileLogSink {
  String? get filePath => null;

  Future<void> init({
    required int maxFileSizeBytes,
    required int maxFiles,
  }) async {}

  void write(String data) {}

  Future<void> clear() async {}

  Future<String?> readAll() async => null;

  Future<Object?> getFileForSharing() async => null;
}
