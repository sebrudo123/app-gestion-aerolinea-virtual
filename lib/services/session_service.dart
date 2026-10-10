import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _kEmail = 'session_email';
  static const String _kRemember = 'session_remember';
  static const String _kLoggedIn = 'session_logged_in';

  static SharedPreferences? _p;

  static Future<SharedPreferences> _prefs() async =>
      _p ??= await SharedPreferences.getInstance();

  static Future<void> init() async {
    await _prefs();
  }

  static Future<void> saveSession(String email, {required bool remember}) async {
    final p = await _prefs();
    await p.setString(_kEmail, email);
    await p.setBool(_kRemember, remember);
    await p.setBool(_kLoggedIn, true);
  }

  static Future<bool> isLoggedIn() async {
    final p = await _prefs();
    return p.getBool(_kLoggedIn) ?? false;
  }

  static Future<String?> savedEmail() async {
    final p = await _prefs();
    return p.getString(_kEmail);
  }

  static Future<bool> rememberFlag() async {
    final p = await _prefs();
    return p.getBool(_kRemember) ?? false;
  }

  static Future<void> logout() async {
    final p = await _prefs();
    await p.setBool(_kLoggedIn, false);
  }
}
