import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/auth_config.dart';

class SteamAccount {
  final String steamId;
  final String personaName;
  final String avatarUrl;
  const SteamAccount({
    required this.steamId,
    required this.personaName,
    required this.avatarUrl,
  });
}

class SteamAuthService {
  static const String _openIdUrl = 'https://steamcommunity.com/openid/login';

  static String buildLoginUrl() {
    final params = {
      'openid.ns': 'http://specs.openid.net/auth/2.0',
      'openid.mode': 'checkid_setup',
      'openid.return_to': AuthConfig.steamReturnUrl,
      'openid.realm': AuthConfig.steamRealm,
      'openid.identity':
          'http://specs.openid.net/auth/2.0/identifier_select',
      'openid.claimed_id':
          'http://specs.openid.net/auth/2.0/identifier_select',
    };
    final query = params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
    return '$_openIdUrl?$query';
  }

  static String? extractSteamId(Uri callback) {
    final claimed = callback.queryParameters['openid.claimed_id'];
    if (claimed == null) return null;
    const marker = '/openid/id/';
    final i = claimed.indexOf(marker);
    if (i < 0) return null;
    final rest = claimed.substring(i + marker.length);
    return RegExp(r'^\d+').firstMatch(rest)?.group(0);
  }

  static Future<bool> verify(Uri callback) async {
    final body = <String, String>{};
    callback.queryParameters.forEach((k, v) {
      if (k.startsWith('openid.')) body[k] = v;
    });
    if (body.isEmpty) return false;
    body['openid.mode'] = 'check_authentication';
    try {
      final res = await http.post(
        Uri.parse(_openIdUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );
      return res.body.contains('is_valid:true');
    } catch (_) {
      return false;
    }
  }

  static Future<SteamAccount> fetchAccount(String steamId) async {
    const fallbackName = 'Piloto Steam';
    if (!AuthConfig.steamApiConfigured) {
      return SteamAccount(
        steamId: steamId,
        personaName: fallbackName,
        avatarUrl: '',
      );
    }
    try {
      final url = Uri.parse(
          'https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/'
          '?key=${AuthConfig.steamApiKey}&steamids=$steamId');
      final res = await http.get(url);
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final players = (data['response']?['players'] as List?) ?? const [];
      if (players.isEmpty) {
        return SteamAccount(
            steamId: steamId, personaName: fallbackName, avatarUrl: '');
      }
      final pl = players.first as Map<String, dynamic>;
      return SteamAccount(
        steamId: steamId,
        personaName: '${pl['personaname'] ?? fallbackName}',
        avatarUrl: '${pl['avatarfull'] ?? pl['avatarmedium'] ?? ''}',
      );
    } catch (_) {
      return SteamAccount(
        steamId: steamId,
        personaName: fallbackName,
        avatarUrl: '',
      );
    }
  }
}
