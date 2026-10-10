import 'package:flutter/services.dart';

class SimDetector {
  static const MethodChannel _channel = MethodChannel('com.vertex.airlines/sims');

  static const Map<String, String> simPackages = {
    'rfs': 'com.fdc.rfs.aero',
    'msfs2024': 'com.asobostudio.flightsimulator',
    'msfs2020': 'com.asobostudio.flightsimulator',
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
}