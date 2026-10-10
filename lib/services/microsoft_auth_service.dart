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
  static const String _scopes =
      'openid profile email offline_access XboxLive.signin';

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
        'scope': _scopes,
        'code': code,
        'redirect_uri': AuthConfig.redirectUri,
        'grant_type': 'authorization_code',
        'code_verifier': verifier,
      },
    );
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode >= 400 || data['access_token'] == null) {
      throw XboxAuthException(
          '${data['error_description'] ?? data['error'] ?? 'No se pudo iniciar sesión con Microsoft.'}');
    }
    return data;
  }

  static Future<XboxAccount> fetchXboxProfile({
    required String accessToken,
    String? idToken,
  }) async {
    final email = idToken != null ? _emailFromIdToken(idToken) : '';

    final userRes = await http.post(
      Uri.parse('https://user.auth.xboxlive.com/user/authenticate'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'Properties': {
          'AuthMethod': 'RPL',
          'SiteName': 'user.auth.xboxlive.com',
          'RpsTicket': 'd=$accessToken',
        },
        'RelyingParty': 'http://auth.xboxlive.com',
        'TokenType': 'JWT',
      }),
    );
    final userData = jsonDecode(userRes.body) as Map<String, dynamic>;
    if (userRes.statusCode >= 400 || userData['Token'] == null) {
      throw XboxAuthException('Xbox Live rechazó la autenticación.');
    }
    final userToken = '${userData['Token']}';
    final uhs = _claim(userData, 'uhs');

    final xstsRes = await http.post(
      Uri.parse('https://xsts.auth.xboxlive.com/xsts/authorize'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'Properties': {
          'SandboxId': 'RETAIL',
          'UserTokens': [userToken],
        },
        'RelyingParty': 'http://xboxlive.com',
        'TokenType': 'JWT',
      }),
    );
    final xstsData = jsonDecode(xstsRes.body) as Map<String, dynamic>;
    if (xstsRes.statusCode >= 400 || xstsData['Token'] == null) {
      final xerr = '${xstsData['XErr'] ?? ''}';
      throw XboxAuthException(_xboxError(xerr));
    }
    final xstsToken = '${xstsData['Token']}';
    final xuid = _claim(xstsData, 'xid');

    String gamertag = 'Piloto Xbox';
    try {
      final profRes = await http.get(
        Uri.parse(
            'https://profile.xboxlive.com/users/me/profile/settings'
            '?settings=Gamertag,ModernGamertag'),
        headers: {
          'Authorization': 'XBL3.0 x=$uhs;$xstsToken',
          'x-xbl-contract-version': '3',
          'Accept-Language': 'en-US',
        },
      );
      final profData = jsonDecode(profRes.body) as Map<String, dynamic>;
      final users = profData['profileUsers'];
      if (users is List && users.isNotEmpty) {
        final first = users.first;
        final settings = first is Map ? first['settings'] : null;
        if (settings is List) {
          for (final s in settings) {
            if (s is Map && s['id'] == 'Gamertag' && s['value'] != null) {
              gamertag = '${s['value']}';
              break;
            }
          }
        }
      }
    } catch (_) {}

    return XboxAccount(gamertag: gamertag, xuid: xuid, email: email);
  }

  static String _claim(Map<String, dynamic> data, String key) {
    final claims = data['DisplayClaims'];
    if (claims is! Map) return '';
    final xui = claims['xui'];
    if (xui is! List || xui.isEmpty) return '';
    final first = xui.first;
    if (first is! Map) return '';
    return '${first[key] ?? ''}';
  }

  static String _emailFromIdToken(String idToken) {
    try {
      final parts = idToken.split('.');
      if (parts.length < 2) return '';
      final normalized = base64Url.normalize(parts[1]);
      final payload =
          jsonDecode(utf8.decode(base64Url.decode(normalized))) as Map;
      return '${payload['email'] ?? payload['preferred_username'] ?? ''}';
    } catch (_) {
      return '';
    }
  }

  static String _xboxError(String code) {
    switch (code) {
      case '2148916233':
        return 'Tu cuenta de Microsoft no tiene un perfil de Xbox. Crea uno primero.';
      case '2148916235':
        return 'Xbox Live no está disponible en tu país o región.';
      case '2148916236':
      case '2148916237':
        return 'Tu cuenta necesita verificación de adulto.';
      case '2148916238':
        return 'Tu cuenta es infantil y requiere aprobación familiar.';
      default:
        return 'Xbox Live rechazó el inicio de sesión.';
    }
  }
}
