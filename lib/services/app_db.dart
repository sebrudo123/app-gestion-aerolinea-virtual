import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class AppDb {
  static bool _init = false;

  static bool get enabled => SupabaseConfig.enabled;

  static Future<void> init() async {
    if (!enabled || _init) return;
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
    _init = true;
  }

  static SupabaseClient get client => Supabase.instance.client;

  static User? get currentUser =>
      enabled ? client.auth.currentUser : null;

  static bool get isLoggedIn =>
      _init && enabled && client.auth.currentSession != null;

  static Future<void> signIn(String email, String password) async {
    await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    if (enabled) {
      await client.auth.signOut();
    }
  }
}