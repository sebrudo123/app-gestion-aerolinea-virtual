import 'package:shared_preferences/shared_preferences.dart';
import 'app_db.dart';

class MaintenanceService {
  static const String adminEmail = 'vertexairlanes@gmail.com';
  static const String _k = 'maintenance_mode';

  static bool isAdmin(String email) =>
      email.trim().toLowerCase() == adminEmail;

  static Future<bool> isEnabled() async {
    if (AppDb.enabled) {
      try {
        final res = await AppDb.client
            .from('app_config')
            .select('value')
            .eq('key', 'maintenance_mode')
            .maybeSingle();
        if (res != null) return res['value'] == true;
      } catch (_) {}
    }
    final p = await SharedPreferences.getInstance();
    return p.getBool(_k) ?? false;
  }

  static Future<void> setEnabled(bool v) async {
    if (AppDb.enabled) {
      try {
        await AppDb.client.from('app_config').upsert({
          'key': 'maintenance_mode',
          'value': v,
        });
      } catch (_) {}
    }
    final p = await SharedPreferences.getInstance();
    await p.setBool(_k, v);
  }
}