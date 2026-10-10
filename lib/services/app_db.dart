import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class AppUser {
  final String id;
  final String email;
  const AppUser({required this.id, required this.email});
}

class AppDb {
  static Database? _db;
  static bool _init = false;
  static String? _sessionEmail;

  static const String adminEmail = 'vertexairlanes@gmail.com';
  static const String _adminPass = 'vertexadmin123';

  static bool get enabled => _init;

  static Future<void> init() async {
    if (_init && _db != null) return;
    final path = p.join(await getDatabasesPath(), 'vertex_airlines.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE IF NOT EXISTS users ('
            'id TEXT PRIMARY KEY, email TEXT UNIQUE, pass_hash TEXT, '
            'created_at TEXT)');
        await db.execute('CREATE TABLE IF NOT EXISTS profiles ('
            'email TEXT PRIMARY KEY, display_name TEXT, platform TEXT, '
            'license TEXT, hours TEXT, avatar TEXT, steam_id TEXT, '
            'msfs_user TEXT, updated_at TEXT)');
        await db.execute('CREATE TABLE IF NOT EXISTS tickets ('
            'id TEXT PRIMARY KEY, email TEXT, title TEXT, description TEXT, '
            'category TEXT, status TEXT, created_at TEXT)');
        await db.execute('CREATE TABLE IF NOT EXISTS flights ('
            'id TEXT PRIMARY KEY, email TEXT, flight_number TEXT, '
            'origin TEXT, destination TEXT, aircraft TEXT, '
            'departure_time TEXT, duration TEXT, status TEXT)');
        await db.insert(
          'users',
          {
            'id': 'admin',
            'email': adminEmail,
            'pass_hash': _hash(_adminPass),
            'created_at': DateTime.now().toIso8601String(),
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      },
    );
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('session_logged_in') == true) {
      _sessionEmail = prefs.getString('session_email');
    }
    _init = true;
  }

  static Database get db {
    final d = _db;
    if (d == null) {
      throw StateError('AppDb no inicializada');
    }
    return d;
  }

  static String _hash(String s) =>
      sha256.convert(utf8.encode('vertex-airlines::$s')).toString();

  static AppUser? get currentUser {
    final e = _sessionEmail;
    if (e == null) return null;
    return AppUser(id: e, email: e);
  }

  static bool get isLoggedIn => _sessionEmail != null;

  static Future<void> signIn(String email, String password) async {
    final norm = email.trim().toLowerCase();
    final rows =
        await db.query('users', where: 'email = ?', whereArgs: [norm], limit: 1);
    if (rows.isEmpty) {
      if (norm == adminEmail && password == _adminPass) {
        _sessionEmail = norm;
        return;
      }
      throw Exception('Usuario no encontrado');
    }
    if (rows.first['pass_hash'] != _hash(password)) {
      throw Exception('Contraseña incorrecta');
    }
    _sessionEmail = norm;
  }

  static Future<void> register({
    required String email,
    required String password,
  }) async {
    final norm = email.trim().toLowerCase();
    await db.insert(
      'users',
      {
        'id': norm,
        'email': norm,
        'pass_hash': _hash(password),
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> signOut() async {
    _sessionEmail = null;
  }

  static Future<Map<String, dynamic>?> currentProfile() async {
    final e = _sessionEmail;
    if (e == null) return null;
    final r =
        await db.query('profiles', where: 'email = ?', whereArgs: [e], limit: 1);
    return r.isEmpty ? null : Map<String, dynamic>.from(r.first);
  }

  static Future<bool> saveProfile(Map<String, dynamic> data) async {
    final e = _sessionEmail;
    if (e == null) return false;
    final rows =
        await db.query('profiles', where: 'email = ?', whereArgs: [e], limit: 1);
    final map = <String, Object?>{
      'display_name': data['display_name'],
      'platform': data['platform'],
      'license': data['license'],
      'hours': data['hours'],
      'avatar': data['avatar'],
      'steam_id': data['steam_id'],
      'msfs_user': data['msfs_user'],
    }..removeWhere((_, v) => v == null);
    map['email'] = e;
    map['updated_at'] = DateTime.now().toIso8601String();
    if (rows.isEmpty) {
      await db.insert('profiles', map,
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      await db.update('profiles', map, where: 'email = ?', whereArgs: [e]);
    }
    return true;
  }

  static Future<List<Map<String, dynamic>>> tickets() async {
    final r = await db.query('tickets', orderBy: 'created_at DESC', limit: 100);
    return r.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<bool> createTicket({
    required String title,
    required String description,
    String category = 'General',
  }) async {
    final id = '#TK-${DateTime.now().millisecondsSinceEpoch ~/ 1000}';
    await db.insert(
      'tickets',
      {
        'id': id,
        'email': _sessionEmail,
        'title': title,
        'description': description,
        'category': category,
        'status': 'abierto',
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  static Future<List<Map<String, dynamic>>> flights() async {
    final e = _sessionEmail;
    final r = e == null
        ? await db.query('flights', orderBy: 'departure_time DESC', limit: 100)
        : await db.query('flights',
            where: 'email = ?',
            whereArgs: [e],
            orderBy: 'departure_time DESC',
            limit: 100);
    return r.map((x) => Map<String, dynamic>.from(x)).toList();
  }

  static Future<void> addFlight(Map<String, dynamic> flight) async {
    final id =
        flight['id'] ?? '#FL-${DateTime.now().millisecondsSinceEpoch ~/ 1000}';
    await db.insert(
      'flights',
      {
        'id': id,
        'email': _sessionEmail,
        'flight_number': flight['flight_number'],
        'origin': flight['origin'],
        'destination': flight['destination'],
        'aircraft': flight['aircraft'],
        'departure_time':
            flight['departure_time'] ?? DateTime.now().toIso8601String(),
        'duration': flight['duration'],
        'status': flight['status'] ?? 'completado',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
