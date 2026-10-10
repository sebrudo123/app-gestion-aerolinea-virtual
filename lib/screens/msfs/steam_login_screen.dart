import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../theme/app_theme.dart';
import '../../config/auth_config.dart';
import '../../services/steam_auth_service.dart';

class SteamLoginScreen extends StatefulWidget {
  const SteamLoginScreen({super.key});

  @override
  State<SteamLoginScreen> createState() => _SteamLoginScreenState();
}

class _SteamLoginScreenState extends State<SteamLoginScreen> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _done = false;
  String _status = 'Conectando con Steam…';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(V.bg)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _loading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onNavigationRequest: _onNav,
        ),
      )
      ..loadRequest(Uri.parse(SteamAuthService.buildLoginUrl()));
  }

  NavigationDecision _onNav(NavigationRequest request) {
    final url = request.url;
    if (url.startsWith(AuthConfig.steamReturnUrl) ||
        url.startsWith(AuthConfig.steamRealm)) {
      _handleCallback(Uri.parse(url));
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  Future<void> _handleCallback(Uri uri) async {
    if (_done) return;
    _done = true;
    if (mounted) {
      setState(() {
        _loading = true;
        _status = 'Verificando tu cuenta de Steam…';
      });
    }
    final steamId = SteamAuthService.extractSteamId(uri);
    if (steamId == null) {
      _fail('No pudimos leer tu SteamID. Intenta de nuevo.');
      return;
    }
    await SteamAuthService.verify(uri);
    final acc = await SteamAuthService.fetchAccount(steamId);
    if (!mounted) return;
    Navigator.of(context).pop(acc);
  }

  void _fail(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar sesión con Steam',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_loading)
              Container(
                color: V.bg.withOpacity(0.9),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: V.neon),
                      const SizedBox(height: 16),
                      Text(_status,
                          style: const TextStyle(
                              color: V.neon, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
