import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../widgets/force_update_dialog.dart';

class UpdateService {
  static final Dio _dio = Dio();

  static Future<void> checkForUpdate(BuildContext context) async {
    try {
      final info = await PackageInfo.fromPlatform();
      final current = info.version;

      final res = await _dio.get(
        'https://api.github.com/repos/sebrudo123/app-gestion-aerolinea-virtual/releases/latest',
        options: Options(headers: {'Accept': 'application/vnd.github.v3+json'}),
      );

      final data = res.data as Map<String, dynamic>;
      final tag = (data['tag_name'] as String?)?.replaceAll('v', '') ?? '';
      final body = (data['body'] as String?) ?? '';
      final assets = data['assets'] as List<dynamic>? ?? [];

      if (_compareVersions(current, tag) >= 0) return;

      String? apkUrl;
      for (final a in assets) {
        final name = (a['name'] as String?) ?? '';
        final url = (a['browser_download_url'] as String?) ?? '';
        if (name.endsWith('.apk')) {
          apkUrl = url;
          break;
        }
      }
      apkUrl ??= data['html_url'] as String? ?? '';

      final notes = body.isEmpty
          ? ['Mejoras de estabilidad y rendimiento.']
          : body
              .split(RegExp(r'\r?\n'))
              .where((e) => e.trim().isNotEmpty)
              .map((e) => e.replaceFirst(RegExp(r'^[-*]\s*'), '').trim())
              .take(10)
              .toList();

      if (!context.mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => ForceUpdateDialog(
          version: tag.isEmpty ? 'Nueva' : tag,
          notes: notes,
          onDownload: () async {
            if (apkUrl == null || apkUrl.isEmpty) return;
            try {
              Directory dir;
              if (Platform.isAndroid) {
                dir = (await getExternalStorageDirectory()) ??
                    (await getApplicationDocumentsDirectory());
              } else {
                dir = await getApplicationDocumentsDirectory();
              }
              final file = File('${dir.path}/VertexAirlines-$tag.apk');
              await _dio.download(apkUrl!, file.path);
              await OpenFile.open(file.path);
            } catch (e) {
              // ignore
            }
          },
        ),
      );
    } catch (_) {}
  }

  static int _compareVersions(String a, String b) {
    List<int> pa = a.split('.').map((x) => int.tryParse(x) ?? 0).toList();
    List<int> pb = b.split('.').map((x) => int.tryParse(x) ?? 0).toList();
    int len = pa.length > pb.length ? pa.length : pb.length;
    for (int i = 0; i < len; i++) {
      int da = i < pa.length ? pa.length == len ? pa[i] : (i < pa.length ? pa[i] : 0) : 0;
      int db = i < pb.length ? pb.length == len ? pb[i] : (i < pb.length ? pb[i] : 0) : 0;
      if (da != db) return da.compareTo(db);
    }
    return 0;
  }
}
