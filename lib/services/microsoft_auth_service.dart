import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import '../config/auth_config.dart';

class XboxAccount {
  final String gamertag;
  final String xuid;
  final String email;
  const XboxAccount({
    required this.gamertag,
    required this.xuid,
    required this.email,
  });
}

class XboxAuthException implements Exception {
  final String message;
  XboxAuthException(this.message);
  @override
  String toString() => message;
}

class MicrosoftAuthService {
  // Scopes estándar de Microsoft Graph. NO se solicita XboxLive.signin para
  // evitar el error AADSTS70011 (scope inválido para la app en Azure).
  static const String _scopes = 'openid profile email offline_access User.Read';

  static const String _graphBase = 'https://graph.microsoft.com/v1.0';

  static String generateVerifier() {
    final rand = Random.secure();
    final bytes = List<int>.generate(32, (_) => rand.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  static String generateState() {
    final rand = Random.secure();
    final bytes = List<int>.generate(16, (_) => rand.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  static String _challenge(String verifier) {
    final digest = sha256.convert(ascii.encode(verifier));
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  static String buildAuthUrl({
    required String verifier,
    required String state,
  }) {
    final base =
        'https://login.microsoftonline.com/${AuthConfig.microsoftTenant}/oauth2/v2.0/authorize';
    final q = {
      'client_id': AuthConfig.microsoftClientId,
      'response_type': 'code',
      'redirect_uri': AuthConfig.redirectUri,
      'response_mode': 'query',
      'scope': _scopes,
      'state': state,
      'code_challenge': _challenge(verifier),
      'code_challenge_method': 'S256',
      'prompt': 'select_account',
    };
    final query = q.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
    return '$base?$query';
  }

  static Future<Map<String, dynamic>> exchangeCode({
    required String code,
    required String verifier,
  }) async {
    final url = Uri.parse(
        'https://login.microsoftonline.com/${AuthConfig.microsoftTenant}/oauth2/v2.0/token');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'client_id': AuthConfig.microsoftClientId,
        'grant_type': 'authorization_code',
        'redirect_uri': AuthConfig.redirectUri,
        'scope': _scopes,
        'code': code,
        'code_verifier': verifier,
      },
    );
    final data = _decode(res.body);
    if (res.statusCode >= 400 || data['access_token'] == null) {
      throw XboxAuthException(_tokenError(data));
    }
    return data;
  }

  /// Trae la identidad del usuario desde Microsoft Graph (/me).
  static Future<XboxAccount> fetchXboxProfile({
    required String accessToken,
    String? idToken,
  }) async {
    String name = '';
    String email = '';
    String id = '';

    try {
      final res = await http.get(
        Uri.parse('$_graphBase/me'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (res.statusCode < 400) {
        final me = _decode(res.body);
        name = '${me['displayName'] ?? ''}';
        email = '${me['mail'] ?? me['userPrincipalName'] ?? ''}';
        id = '${me['id'] ?? ''}';
      }
    } catch (_) {}

    if (idToken != null) {
      final claims = _claimsFromIdToken(idToken);
      if (name.isEmpty) name = '${claims['name'] ?? ''}';
      if (email.isEmpty) {
        email = '${claims['email'] ?? claims['preferred_username'] ?? ''}';
      }
      if (id.isEmpty) id = '${claims['oid'] ?? claims['sub'] ?? ''}';
    }

    if (name.isEmpty) {
      name = email.isNotEmpty ? email.split('@').first : 'Piloto Xbox';
    }

    return XboxAccount(gamertag: name, xuid: id, email: email);
  }

  static Map<String, dynamic> _claimsFromIdToken(String idToken) {
    try {
      final parts = idToken.split('.');
      if (parts.length < 2) return const {};
      final normalized = base64Url.normalize(parts[1]);
      return _decode(utf8.decode(base64Url.decode(normalized)));
    } catch (_) {
      return const {};
    }
  }

  static Map<String, dynamic> _decode(String body) {
    try {
      final j = jsonDecode(body);
      return j is Map<String, dynamic> ? j : <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  static String _tokenError(Map<String, dynamic> data) {
    final desc = '${data['error_description'] ?? data['error'] ?? ''}';
    if (desc.contains('AADSTS70011')) {
      return 'Azure rechazó los permisos solicitados. Revisa los scopes de la app.';
    }
    if (desc.contains('AADSTS50011')) {
      return 'La URI de redirección no coincide. Agrega vertexairlines://auth en Azure.';
    }
    return desc.isEmpty
        ? 'No se pudo completar el inicio de sesión con Microsoft.'
        : desc;
  }
}
