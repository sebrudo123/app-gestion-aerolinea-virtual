import 'package:shared_preferences/shared_preferences.dart';

class MaintenanceService {
  static const String adminEmail = 'vertexairlanes@gmail.com';
  static const String _k = 'maintenance_mode';

  static bool isAdmin(String email) =>
      email.trim().toLowerCase() == adminEmail;

  static Future<bool> isEnabled() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_k) ?? false;
  }

  static Future<void> setEnabled(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_k, v);
  }
}
