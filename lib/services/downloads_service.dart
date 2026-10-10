import 'package:flutter/services.dart';

class DownloadsService {
  static const MethodChannel _channel =
      MethodChannel('com.vertex.airlines/downloads');

  static Future<String?> saveToDownloads(
    String filePath,
    String fileName, {
    String subfolder = 'Vertex Airlines',
  }) async {
    try {
      final res = await _channel.invokeMethod<String>('saveToDownloads', {
        'path': filePath,
        'fileName': fileName,
        'subfolder': subfolder,
      });
      return res;
    } catch (_) {
      return null;
    }
  }
}
