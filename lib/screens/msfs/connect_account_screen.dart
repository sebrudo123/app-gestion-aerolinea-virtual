import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';
import '../../services/session_service.dart';
import 'ownership_screen.dart';

class ConnectAccountScreen extends StatefulWidget {
  final String edition;
  const ConnectAccountScreen({required this.edition, super.key});

  @override
  State<ConnectAccountScreen> createState() => _ConnectAccountScreenState();
}

class _ConnectAccountScreenState extends State<ConnectAccountScreen> {
  String? _platform;
  final _id = TextEditingController();
  bool _busy = false;

  Future<void> _link(String platform) async {
    setState(() => _busy = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _platform = platform;
      _busy = false;
    });
  }

  Future<void> _continue() async {
    final platform = _platform;
    if (platform == null) return;
    setState(() => _busy = true);
    final user = _id.text.trim().isEmpty
        ? 'SkyPilot@${platform.toLowerCase()}'
        : _id.text.trim();
    await SessionService.setMsfsAccount(
      widget.edition,
      platform: platform,
      user: user,
    );
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => OwnershipScreen(edition: widget.edition),
      ),
    );
  }

  @override
  void dispose() {
    _id.dispose();
    super.dispose();
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
              'Para detectar tu licencia de MSFS ${widget.edition} vincula la cuenta con la que juegas.',
              style: const TextStyle(color: V.muted, fontSize: 12),
            ),
            const SizedBox(height: 16),
            _PlatformCard(
              icon: Icons.sports_esports_rounded,
              title: 'Xbox Live',
              desc: 'Gamertag y biblioteca de juegos de Microsoft',
              accent: V.green,
              linked: _platform == 'xbox',
              busy: _busy && _platform == 'xbox',
              onTap: () => _link('xbox'),
            ),
            const SizedBox(height: 12),
            _PlatformCard(
              icon: Icons.games_rounded,
              title: 'Steam',
              desc: 'ID de Steam y biblioteca Steam',
              accent: V.neon,
              linked: _platform == 'steam',
              busy: _busy && _platform == 'steam',
              onTap: () => _link('steam'),
            ),
            const SizedBox(height: 20),
            if (_platform != null) ...[
              GradientCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ID/Nombre en la plataforma',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _id,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: _platform == 'xbox'
                            ? 'Ej: SkyPilot12'
                            : 'Ej: SkyPilot12',
                        hintStyle:
                            const TextStyle(color: V.muted, fontSize: 12),
                        filled: true,
                        fillColor: V.surface2,
                        prefixIcon: Icon(
                            _platform == 'xbox'
                                ? Icons.sports_esports_rounded
                                : Icons.games_rounded,
                            color: V.neon,
                            size: 19),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: V.borderNeon),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Con la cuenta vinculada, Vertex Airlines verifica tu licencia y registra tus vuelos.',
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
                  child: _busy
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: V.neon, strokeWidth: 2.5),
                        )
                      : Text(
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
              'La cuenta se asocia a tu ID único de piloto en la base de datos.',
              style: TextStyle(
                  color: V.muted,
                  fontSize: 11,
                  fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlatformCard extends StatelessWidget {
  final IconData icon;
  final String title, desc;
  final Color accent;
  final bool linked, busy;
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
      onTap: linked ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinkedGrad(linked, accent),
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
                          color:
                              linked ? V.bg.withOpacity(0.85) : V.muted,
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
                  linked ? 'Vinculada' : 'Vincular',
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

  LinearGradient? LinkedGrad(bool linked, Color accent) {
    return linked
        ? LinearGradient(colors: [
            accent.withOpacity(0.95),
            accent.withOpacity(0.7),
          ])
        : null;
  }
}