import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../widgets/force_update_dialog.dart';
import 'downloads_service.dart';

class UpdateService {
  static const String _repo = 'sebrudo123/app-gestion-aerolinea-virtual';
  static const String _api = 'https://api.github.com/repos/$_repo';

  static const Map<String, String> _headers = {
    'User-Agent': 'VertexAirlines-App',
    'Accept': 'application/vnd.github+json',
    'X-GitHub-Api-Version': '2022-11-28',
  };

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 60),
      headers: _headers,
    ),
  );

  static Future<bool> checkForUpdate(BuildContext context) async {
    try {
      final info = await PackageInfo.fromPlatform();
      final current = info.version;

      final release = await _fetchLatestRelease();
      if (release == null) return false;

      final rawTag = (release['tag_name'] as String?) ?? '';
      final tag = rawTag.replaceFirst(RegExp(r'^[vV]'), '').trim();
      final body = (release['body'] as String?) ?? '';
      final assets = release['assets'] as List<dynamic>? ?? [];

      String? apkUrl;
      for (final a in assets) {
        final name = (a['name'] as String?)?.toLowerCase() ?? '';
        final url = (a['browser_download_url'] as String?) ?? '';
        if (name.endsWith('.apk') && url.isNotEmpty) {
          apkUrl = url;
          break;
        }
      }
      if (apkUrl == null) return false;

      final currentV = _parseVersion(current);
      final tagV = _parseVersion(tag);

      if (currentV != null && tagV != null) {
        if (_compare(currentV, tagV) >= 0) return false;
      } else {
        final seen = await _lastSeenTag();
        if (seen == rawTag) return false;
      }

      await _saveSeenTag(rawTag);

      final notes = body.isEmpty
          ? ['Mejoras de estabilidad y rendimiento.']
          : body
              .split(RegExp(r'\r?\n'))
              .where((e) => e.trim().isNotEmpty)
              .map((e) => e.replaceFirst(RegExp(r'^[-*#\s]+'), '').trim())
              .where((e) => e.isNotEmpty)
              .take(10)
              .toList();

      if (!context.mounted) return false;
      final progress = ValueNotifier<double>(0);
      final status = ValueNotifier<String>('Preparando descarga…');
      final busy = ValueNotifier<bool>(false);
      final result = ValueNotifier<String>('');
      var shown = false;
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          shown = true;
          return ForceUpdateDialog(
            version: tag.isEmpty ? rawTag : tag,
            notes: notes,
            progress: progress,
            status: status,
            busy: busy,
            result: result,
            onInstall: () =>
                _download(apkUrl!, tag, progress, status, busy, result,
                    install: true),
            onSave: () => _download(
                apkUrl!, tag, progress, status, busy, result,
                install: false),
          );
        },
      );
      return shown;
    } catch (_) {
      // sin conexión o API no disponible: se reintenta en el próximo inicio
      return false;
    }
  }

  static Future<void> _download(
    String url,
    String tag,
    ValueNotifier<double> progress,
    ValueNotifier<String> status,
    ValueNotifier<bool> busy,
    ValueNotifier<String> result, {
    required bool install,
  }) async {
    busy.value = true;
    result.value = '';
    progress.value = 0;
    status.value = 'Preparando descarga…';
    try {
      final dir = await getTemporaryDirectory();
      final safeTag = tag.replaceAll(RegExp(r'[^0-9A-Za-z._-]'), '');
      final file = File('${dir.path}/VertexAirlines-$safeTag.apk');
      if (await file.exists()) await file.delete();

      await _dio.download(
        url,
        file.path,
        options: Options(
          headers: {'User-Agent': 'VertexAirlines-App'},
          followRedirects: true,
        ),
        onReceiveProgress: (received, total) {
          if (total <= 0) {
            progress.value = 0.5;
            status.value = 'Descargando...';
            return;
          }
          final p = received / total;
          progress.value = p;
          status.value = 'Descargando... ${(p * 100).toStringAsFixed(0)}%';
        },
      );
      if (!await file.exists() || await file.length() == 0) {
        throw Exception('Archivo vacío');
      }
      progress.value = 1.0;

      if (install) {
        status.value = 'Abriendo el instalador de Android…';
        await Future<void>.delayed(const Duration(milliseconds: 350));
        var opened = await DownloadsService.installApk(file.path);
        if (!opened) {
          final res = await OpenFile.open(file.path);
          opened = res.type == ResultType.done;
        }
        busy.value = false;
        result.value = opened
            ? 'Instalador abierto. Confirma la actualización para terminar.'
            : 'Permite "instalar apps desconocidas" para Vertex Airlines y vuelve a intentarlo.';
      } else {
        status.value = 'Guardando en Descargas…';
        final saved = await DownloadsService.saveToDownloads(
          file.path,
          'VertexAirlines-$safeTag.apk',
        );
        busy.value = false;
        result.value = saved == null
            ? 'No se pudo guardar en Descargas. Prueba "Instalar ahora".'
            : 'Guardado en Descargas/Vertex Airlines. Instálalo desde ahí.';
      }
    } catch (_) {
      busy.value = false;
      result.value =
          'No se pudo descargar. Revisa tu conexión e inténtalo otra vez.';
    }
  }

  static Future<Map<String, dynamic>?> _fetchLatestRelease() async {
    try {
      final res = await _dio.get('$_api/releases/latest');
      final data = res.data;
      if (data is Map) return Map<String, dynamic>.from(data);
    } catch (_) {}
    try {
      final res = await _dio.get('$_api/releases');
      final data = res.data;
      if (data is List) {
        for (final e in data) {
          if (e is Map && e['draft'] != true && e['prerelease'] != true) {
            return Map<String, dynamic>.from(e);
          }
        }
      }
    } catch (_) {}
    return null;
  }

  static File? _seenFile;

  static Future<File?> _seenTagFile() async {
    if (_seenFile != null) return _seenFile;
    try {
      final dir = await getApplicationDocumentsDirectory();
      _seenFile = File('${dir.path}/.vertex_last_release');
      return _seenFile;
    } catch (_) {
      return null;
    }
  }

  static Future<String?> _lastSeenTag() async {
    final f = await _seenTagFile();
    if (f == null || !await f.exists()) return null;
    try {
      return (await f.readAsString()).trim();
    } catch (_) {
      return null;
    }
  }

  static Future<void> _saveSeenTag(String tag) async {
    try {
      final f = await _seenTagFile();
      await f?.writeAsString(tag);
    } catch (_) {}
  }

  static List<int>? _parseVersion(String v) {
    final clean = v.split('+').first.trim();
    if (clean.isEmpty) return null;
    final parts = clean.split('.');
    final out = <int>[];
    for (final p in parts) {
      final n = int.tryParse(p);
      if (n == null) return null;
      out.add(n);
    }
    return out.isEmpty ? null : out;
  }

  static int _compare(List<int> a, List<int> b) {
    final len = a.length > b.length ? a.length : b.length;
    for (int i = 0; i < len; i++) {
      final da = i < a.length ? a[i] : 0;
      final db = i < b.length ? b[i] : 0;
      if (da != db) return da.compareTo(db);
    }
    return 0;
  }
}
