import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/session_service.dart';
import '../../services/app_db.dart';
import '../../services/maintenance_service.dart';
import '../msfs/msfs_hub_screen.dart';
import '../rfs/rfs_hub_screen.dart';
import '../aerofly/aerofly_hub_screen.dart';
import '../main_shell.dart';
import '../maintenance/maintenance_screen.dart';

class SimSelectorScreen extends StatefulWidget {
  const SimSelectorScreen({super.key});

  @override
  State<SimSelectorScreen> createState() => _SimSelectorScreenState();
}

class _SimSelectorScreenState extends State<SimSelectorScreen> {
  bool _logged = false;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final logged = AppDb.enabled
        ? AppDb.isLoggedIn
        : await SessionService.isLoggedIn();
    if (!mounted) return;
    setState(() {
      _logged = logged;
      _ready = true;
    });
  }

  void _go(Widget w) => Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (_) => w));

  Future<void> _continueSession() async {
    final maint = await MaintenanceService.isEnabled();
    if (!mounted) return;
    final email = AppDb.enabled
        ? (AppDb.currentUser?.email ?? '')
        : (await SessionService.savedEmail() ?? '');
    if (maint && !MaintenanceService.isAdmin(email)) {
      _go(const MaintenanceScreen());
    } else {
      _go(const MainShell());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [V.bg2, V.bg],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 40),
            children: [
              Row(
                children: [
                  Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [V.goldLight, V.gold, V.bronze],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: V.gold.withOpacity(0.3),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.flight_takeoff_rounded,
                        color: V.bg, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('VERTEX AIRLINES',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.4)),
                      Text('SkyConnect Hub',
                          style:
                              TextStyle(color: V.neon, fontSize: 11, letterSpacing: 2)),
                    ],
                  ),
                  const Spacer(),
                  Icon(Icons.tune_rounded, color: V.muted),
                ],
              ),
              const SizedBox(height: 42),
              const Text('SELECCIONA TU PLATAFORMA',
                  style: TextStyle(fontSize: 13, letterSpacing: 2, color: V.muted, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text('¿Desde qué simulador vuelas hoy?',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 28),
              _Sim(
                icon: Icons.cloud_rounded,
                title: 'Microsoft Flight Simulator',
                tag: 'MSFS 2024 / 2020',
                accent: V.neon,
                desc: 'SkyConnect • Xbox / Steam\nVuelo, planes y aerolíneas sincronizados.',
                onTap: () => _go(const MsfsHubScreen()),
              ),
              const SizedBox(height: 16),
              _Sim(
                icon: Icons.phone_android_rounded,
                title: 'Real Flight Simulator',
                tag: 'RFS AIRLINE MANAGER',
                accent: V.goldLight,
                desc: 'SkyAir Virtual • Cuenta oficial RFS\nDashboard, flota y plan de vuelo.',
                onTap: () => _go(const RfsHubScreen()),
              ),
              const SizedBox(height: 16),
              _Sim(
                icon: Icons.airplanemode_active_rounded,
                title: 'Aerofly FS',
                tag: 'AEROFLY CONNECT',
                accent: V.green,
                desc: 'Migración de pilotos Aerofly\nPerfil verificado y un solo ID de piloto.',
                onTap: () => _go(const AeroflyHubScreen()),
              ),
              const SizedBox(height: 30),
              if (_ready && _logged)
                GestureDetector(
                  onTap: _continueSession,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: V.surface2,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: V.borderNeon),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.play_circle_fill_rounded,
                            color: V.neon, size: 22),
                        SizedBox(width: 8),
                        Text('CONTINUAR SESIÓN',
                            style: TextStyle(
                                fontWeight: FontWeight.w900, letterSpacing: 1)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Sim extends StatelessWidget {
  final IconData icon;
  final String title, tag, desc;
  final Color accent;
  final VoidCallback onTap;
  const _Sim({
    required this.icon,
    required this.title,
    required this.tag,
    required this.desc,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [V.surface, V.surface2],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: accent.withOpacity(0.7), width: 1.4),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.14),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 62,
              width: 62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [accent.withOpacity(0.9), accent.withOpacity(0.55)],
                ),
              ),
              child: Icon(icon, color: V.bg, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 15)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(tag,
                            style: TextStyle(
                                color: accent,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(desc,
                      style: const TextStyle(
                          color: V.muted, fontSize: 11, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: accent),
          ],
        ),
      ),
    );
  }
}