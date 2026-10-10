import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';
import '../../services/session_service.dart';
import '../../services/steam_auth_service.dart';
import '../../services/microsoft_auth_service.dart';
import 'steam_login_screen.dart';
import 'xbox_login_screen.dart';
import 'ownership_screen.dart';

class ConnectAccountScreen extends StatefulWidget {
  final String edition;
  const ConnectAccountScreen({required this.edition, super.key});

  @override
  State<ConnectAccountScreen> createState() => _ConnectAccountScreenState();
}

class _ConnectAccountScreenState extends State<ConnectAccountScreen> {
  String? _platform;
  String _user = '';
  String _id = '';
  String _avatar = '';
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final acc = await SessionService.msfsAccount(widget.edition);
    if (acc == null) return;
    final id = await SessionService.msfsAccountId(widget.edition) ?? '';
    final avatar =
        await SessionService.msfsAccountAvatar(widget.edition) ?? '';
    if (!mounted) return;
    setState(() {
      _platform = acc['platform'];
      _user = acc['user'] ?? '';
      _id = id;
      _avatar = avatar;
    });
  }

  Future<void> _linkXbox() async {
    setState(() => _busy = true);
    final acc = await Navigator.of(context).push<XboxAccount>(
      MaterialPageRoute(builder: (_) => const XboxLoginScreen()),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (acc == null) return;
    await SessionService.setMsfsAccount(
      widget.edition,
      platform: 'xbox',
      user: acc.gamertag,
      id: acc.xuid,
      avatar: '',
    );
    if (!mounted) return;
    setState(() {
      _platform = 'xbox';
      _user = acc.gamertag;
      _id = acc.xuid;
      _avatar = '';
    });
  }

  Future<void> _linkSteam() async {
    setState(() => _busy = true);
    final acc = await Navigator.of(context).push<SteamAccount>(
      MaterialPageRoute(builder: (_) => const SteamLoginScreen()),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (acc == null) return;
    await SessionService.setMsfsAccount(
      widget.edition,
      platform: 'steam',
      user: acc.personaName,
      id: acc.steamId,
      avatar: acc.avatarUrl,
    );
    if (!mounted) return;
    setState(() {
      _platform = 'steam';
      _user = acc.personaName;
      _id = acc.steamId;
      _avatar = acc.avatarUrl;
    });
  }

  Future<void> _continue() async {
    if (_platform == null) return;
    setState(() => _busy = true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => OwnershipScreen(edition: widget.edition),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conectar Cuenta',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [V.bg2, V.bg]),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('CONECTA TU PLATAFORMA',
                style: TextStyle(
                    fontWeight: FontWeight.w800, letterSpacing: 1.5)),
            const SizedBox(height: 4),
            Text(
              'Inicia sesión con la cuenta real con la que juegas MSFS ${widget.edition}.',
              style: const TextStyle(color: V.muted, fontSize: 12),
            ),
            const SizedBox(height: 16),
            _PlatformCard(
              icon: Icons.sports_esports_rounded,
              title: 'Xbox Live',
              desc: 'Inicia sesión con Microsoft y vincula tu gamertag',
              accent: V.green,
              linked: _platform == 'xbox',
              busy: _busy && _platform == null,
              onTap: _linkXbox,
            ),
            const SizedBox(height: 12),
            _PlatformCard(
              icon: Icons.games_rounded,
              title: 'Steam',
              desc: 'Inicia sesión en Steam y vincula tu cuenta',
              accent: V.neon,
              linked: _platform == 'steam',
              busy: _busy && _platform == null,
              onTap: _linkSteam,
            ),
            const SizedBox(height: 20),
            if (_platform != null) ...[
              GradientCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Cuenta vinculada',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        if (_avatar.isNotEmpty)
                          ClipOval(
                            child: Image.network(
                              _avatar,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _initial(),
                            ),
                          )
                        else
                          _initial(),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_user,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(height: 2),
                              Text(
                                _id.isEmpty ? 'ID no disponible' : 'ID: $_id',
                                style: const TextStyle(
                                    color: V.muted, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          _platform == 'xbox'
                              ? Icons.sports_esports_rounded
                              : Icons.games_rounded,
                          color: _platform == 'xbox' ? V.green : V.neon,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Con la cuenta vinculada, Vertex Airlines registra tus vuelos y estadísticas.',
                      style: TextStyle(color: V.muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            GestureDetector(
              onTap: _platform == null ? null : _continue,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: _platform != null
                      ? const LinearGradient(colors: [V.neonLight, V.neon])
                      : null,
                  color: _platform == null ? V.surface2 : null,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: _platform != null ? V.neon : V.borderNeon),
                ),
                child: Center(
                  child: Text(
                    _platform == null
                        ? 'VINCULA UNA CUENTA PARA CONTINUAR'
                        : 'CONTINUAR Y VERIFICAR LICENCIA',
                    style: TextStyle(
                      color: _platform != null ? V.bg : V.muted,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'La vinculación es real: Vertex Airlines recibe tu identidad de Steam o Xbox.',
              textAlign: TextAlign.center,
              style: TextStyle(color: V.muted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _initial() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: V.surface2,
        border: Border.all(color: V.borderNeon),
      ),
      child: Center(
        child: Text(
          _user.isEmpty ? '?' : _user[0].toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class _PlatformCard extends StatelessWidget {
  final IconData icon;
  final String title, desc;
  final Color accent;
  final bool linked;
  final bool busy;
  final VoidCallback onTap;
  const _PlatformCard({
    required this.icon,
    required this.title,
    required this.desc,
    required this.accent,
    required this.linked,
    required this.busy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: busy ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: linked
                ? [accent.withOpacity(0.9), accent.withOpacity(0.55)]
                : [V.surface, V.surface2],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: linked ? accent : V.borderNeon, width: linked ? 1.6 : 1),
          boxShadow: linked
              ? [BoxShadow(color: accent.withOpacity(0.2), blurRadius: 18)]
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: linked ? V.bg : accent, size: 30),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: linked ? V.bg : V.text)),
                  const SizedBox(height: 2),
                  Text(desc,
                      style: TextStyle(
                          color: linked ? V.bg.withOpacity(0.85) : V.muted,
                          fontSize: 11)),
                ],
              ),
            ),
            if (busy)
              const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: linked
                      ? V.bg.withOpacity(0.9)
                      : accent.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  linked ? 'Vinculada' : 'Iniciar sesión',
                  style: TextStyle(
                      color: accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w800),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
