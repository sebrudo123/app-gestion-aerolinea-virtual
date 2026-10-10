import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _kEmail = 'session_email';
  static const String _kRemember = 'session_remember';
  static const String _kLoggedIn = 'session_logged_in';
  static const String _kAvatar = 'session_avatar';
  static const String _kName = 'session_name';
  static const String _kPlatform = 'session_platform';
  static const String _kLicense = 'session_license';
  static const String _kHours = 'session_hours';

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

  static Future<void> setAvatar(String avatar) async {
    final p = await _prefs();
    await p.setString(_kAvatar, avatar);
  }

  static Future<String> avatar() async {
    final p = await _prefs();
    return p.getString(_kAvatar) ?? 'S';
  }

  static Future<void> setProfile({
    String? name,
    String? platform,
    String? license,
    String? hours,
  }) async {
    final p = await _prefs();
    if (name != null) await p.setString(_kName, name);
    if (platform != null) await p.setString(_kPlatform, platform);
    if (license != null) await p.setString(_kLicense, license);
    if (hours != null) await p.setString(_kHours, hours);
  }

  static Future<String> name() async {
    final p = await _prefs();
    return p.getString(_kName) ?? 'Sebrudo12';
  }

  static Future<String> platform() async {
    final p = await _prefs();
    return p.getString(_kPlatform) ?? 'Xbox';
  }

  static Future<String> license() async {
    final p = await _prefs();
    return p.getString(_kLicense) ?? 'Comercial (ATPL)';
  }

  static Future<String> hours() async {
    final p = await _prefs();
    return p.getString(_kHours) ?? '248h 32m';
  }

  static String _kMsfsPlat(String e) => 'msfs_${e}_platform';
  static String _kMsfsUser(String e) => 'msfs_${e}_user';
  static String _kMsfsOwned(String e) => 'msfs_${e}_owned';

  static Future<void> setMsfsAccount(
    String edition, {
    required String platform,
    required String user,
  }) async {
    final p = await _prefs();
    await p.setString(_kMsfsPlat(edition), platform);
    await p.setString(_kMsfsUser(edition), user);
  }

  static Future<Map<String, String>?> msfsAccount(String edition) async {
    final p = await _prefs();
    final plat = p.getString(_kMsfsPlat(edition));
    final user = p.getString(_kMsfsUser(edition));
    if (plat == null || user == null) return null;
    return {'platform': plat, 'user': user};
  }

  static Future<void> setMsfsOwned(String edition, bool owned) async {
    final p = await _prefs();
    await p.setBool(_kMsfsOwned(edition), owned);
  }

  static Future<bool> msfsOwned(String edition) async {
    final p = await _prefs();
    return p.getBool(_kMsfsOwned(edition)) ?? false;
  }

  static Future<void> clearMsfsAccount(String edition) async {
    final p = await _prefs();
    await p.remove(_kMsfsPlat(edition));
    await p.remove(_kMsfsUser(edition));
    await p.remove(_kMsfsOwned(edition));
  }
}
