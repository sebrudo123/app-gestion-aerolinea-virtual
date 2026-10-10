import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/app_theme.dart';
import '../../config/auth_config.dart';
import '../../services/microsoft_auth_service.dart';

class XboxLoginScreen extends StatefulWidget {
  const XboxLoginScreen({super.key});

  @override
  State<XboxLoginScreen> createState() => _XboxLoginScreenState();
}

class _XboxLoginScreenState extends State<XboxLoginScreen> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  late final String _verifier;
  late final String _state;
  bool _busy = false;
  String _status = 'Esperando que inicies sesión en Microsoft…';

  @override
  void initState() {
    super.initState();
    _verifier = MicrosoftAuthService.generateVerifier();
    _state = MicrosoftAuthService.generateState();
    if (AuthConfig.microsoftConfigured) {
      _launch();
    }
  }

  Future<void> _launch() async {
    _sub = _appLinks.uriLinkStream.listen(_onUri);
    final initial = await _appLinks.getInitialLink();
    if (initial != null) _onUri(initial);
    setState(() => _busy = false);
    final url = Uri.parse(
        MicrosoftAuthService.buildAuthUrl(verifier: _verifier, state: _state));
    final ok = await launchUrl(url, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      setState(() => _status = 'No se pudo abrir el navegador.');
    }
  }

  Future<void> _onUri(Uri uri) async {
    if (uri.scheme != AuthConfig.redirectScheme) return;
    final code = uri.queryParameters['code'];
    final error = uri.queryParameters['error'];
    final state = uri.queryParameters['state'];
    if (error != null) {
      _fail('Inicio de sesión cancelado o rechazado.');
      return;
    }
    if (code == null) return;
    if (state != null && state != _state) {
      _fail('Respuesta de autenticación no válida.');
      return;
    }
    setState(() {
      _busy = true;
      _status = 'Verificando tu cuenta de Xbox…';
    });
    try {
      final tokens = await MicrosoftAuthService.exchangeCode(
        code: code,
        verifier: _verifier,
      );
      final acc = await MicrosoftAuthService.fetchXboxProfile(
        accessToken: '${tokens['access_token']}',
        idToken: tokens['id_token'] as String?,
      );
      if (!mounted) return;
      Navigator.of(context).pop(acc);
    } on XboxAuthException catch (e) {
      _fail(e.message);
    } catch (_) {
      _fail('No se pudo completar el inicio de sesión con Microsoft.');
    }
  }

  void _fail(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conectar con Xbox',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [V.bg2, V.bg]),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: AuthConfig.microsoftConfigured
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: V.green),
                      const SizedBox(height: 20),
                      Text(_status,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: V.neon, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      const Text(
                        'Se abrió Microsoft en tu navegador. Inicia sesión y acepta para vincular tu cuenta.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: V.muted, fontSize: 12),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: _launch,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: V.borderNeon),
                          ),
                          child: const Text('ABRIR MICROSOFT OTRA VEZ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                  letterSpacing: 0.8)),
                        ),
                      ),
                    ],
                  )
                : _setupHint(),
          ),
        ),
      ),
    );
  }

  Widget _setupHint() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.vpn_key_rounded, color: V.goldLight, size: 46),
          const SizedBox(height: 16),
          const Text('Falta configurar Microsoft',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          const Text(
            'Para el inicio de sesión real con Xbox necesitas registrar una app en Azure '
            'y pegar su "client_id" en lib/config/auth_config.dart.',
            textAlign: TextAlign.center,
            style: TextStyle(color: V.muted, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: V.bg.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: V.borderNeon),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('1. portal.azure.com → Registros de aplicaciones → Nuevo',
                    style: TextStyle(fontSize: 11.5)),
                SizedBox(height: 6),
                Text('2. Cuenta: "Solo cuentas personales de Microsoft"',
                    style: TextStyle(fontSize: 11.5)),
                SizedBox(height: 6),
                Text('3. Autenticación → App móvil/escritorio → URI:',
                    style: TextStyle(fontSize: 11.5)),
                SizedBox(height: 4),
                Text('   vertexairlines://auth',
                    style: TextStyle(
                        fontSize: 11.5,
                        color: V.neon,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: 6),
                Text('4. Copia el client_id en auth_config.dart',
                    style: TextStyle(fontSize: 11.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
