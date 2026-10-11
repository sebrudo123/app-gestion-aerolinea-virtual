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

  /// Lanza el instalador de Android para el APK indicado.
  /// Devuelve true si se abrió el instalador, false si hay que conceder
  /// permiso de "instalar apps desconocidas" primero.
  static Future<bool> installApk(String filePath) async {
    try {
      final res = await _channel.invokeMethod<bool>('installApk', {
        'path': filePath,
      });
      return res ?? false;
    } catch (_) {
      return false;
    }
  }
}
