import 'package:flutter/services.dart';

class SimDetector {
  static const MethodChannel _channel = MethodChannel('com.vertex.airlines/sims');

  static const Map<String, String> simPackages = {
    'rfs': 'com.fdc.rfs.aero',
    'msfs2024': 'com.microsoft.flightsimulator',
    'msfs2020': 'com.microsoft.flightsimulator',
    'msfs_asobo': 'com.asobostudio.flightsimulator',
  };

  static Future<List<String>> detectInstalled() async {
    try {
      final res = await _channel.invokeMethod<List<dynamic>>(
        'detectInstalled',
        {'packages': simPackages.values.toList()},
      );
      if (res == null) return [];
      return res.cast<String>();
    } catch (_) {
      return [];
    }
  }

  static Future<bool> rfsInstalled() async {
    final installed = await detectInstalled();
    return installed.contains(simPackages['rfs']);
  }

  static Future<bool> msfsInstalled({String? edition}) async {
    final installed = await detectInstalled();
    final check = <String>{
      simPackages['msfs2024']!,
      simPackages['msfs2020']!,
      simPackages['msfs_asobo']!,
    };
    if (edition == '2024') {
      return installed.contains(simPackages['msfs2024']) ||
          installed.contains(simPackages['msfs_asobo']);
    }
    if (edition == '2020') {
      return installed.contains(simPackages['msfs2020']) ||
          installed.contains(simPackages['msfs_asobo']);
    }
    return installed.any(check.contains);
  }
}