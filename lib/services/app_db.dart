import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
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

  static Future<Map<String, dynamic>?> currentProfile() async {
    if (!enabled || currentUser == null) return null;
    try {
      final r = await client
          .from('profiles')
          .select()
          .eq('id', currentUser!.id)
          .maybeSingle();
      return r == null ? null : Map<String, dynamic>.from(r);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> saveProfile(Map<String, dynamic> data) async {
    if (!enabled || currentUser == null) return false;
    try {
      final id = currentUser!.id;
      await client.from('profiles').upsert({'id': id, ...data, 'updated_at': DateTime.now().toIso8601String()});
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> tickets() async {
    if (!enabled || currentUser == null) return [];
    try {
      final r = await client
          .from('tickets')
          .select()
          .order('created_at', ascending: false)
          .limit(50);
      return (r as List).map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<bool> createTicket({
    required String title,
    required String description,
    String category = 'General',
  }) async {
    if (!enabled || currentUser == null) return false;
    try {
      await client.from('tickets').insert({
        'user_id': currentUser!.id,
        'title': title,
        'description': description,
        'category': category,
        'status': 'abierto',
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> flights() async {
    if (!enabled || currentUser == null) return [];
    try {
      final r = await client
          .from('flights')
          .select()
          .eq('pilot_email', currentUser!.email ?? '')
          .order('departure_time', ascending: false)
          .limit(100);
      return (r as List).map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static const String _kLocalTickets = 'local_tickets';

  static Future<List<Map<String, dynamic>>> localTickets() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_kLocalTickets);
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveLocalTicket(Map<String, dynamic> ticket) async {
    final p = await SharedPreferences.getInstance();
    final list = await localTickets();
    list.insert(0, ticket);
    await p.setString(_kLocalTickets, jsonEncode(list));
  }
}