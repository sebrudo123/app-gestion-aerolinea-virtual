import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gold_gradient_text.dart';
import '../services/update_service.dart';
import '../services/session_service.dart';
import 'login_screen.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  Timer? _timer;
  int _idx = 0;

  final _msgs = const [
    'Conectando con el servidor de RFS...',
    'Verificando actualizaciones en GitHub...',
    'Verificando sesión de usuario...',
    'Cargando perfil de piloto...',
  ];
  final _jokes = const [
    'Verificando que nadie dejó su equipaje en casa',
    'Revisando planes de vuelo',
    'Chequeando checklist pre-vuelo',
    'Calentando motores en la pista 27R',
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..forward();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_idx < _msgs.length - 1) _idx++;
      });
    });
    Timer(const Duration(seconds: 3), () async {
      if (!mounted) return;
      await UpdateService.checkForUpdate(context);
      if (!mounted) return;
      final loggedIn = await SessionService.isLoggedIn();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) =>
              loggedIn ? const MainShell() : const LoginScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
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
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                const Spacer(flex: 2),
                FadeTransition(
                  opacity: CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.3)),
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [V.goldLight, V.gold, V.bronze],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: V.neon.withOpacity(0.35),
                              blurRadius: 32,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.flight_takeoff_rounded,
                            size: 60, color: V.bg),
                      ),
                      const SizedBox(height: 24),
                      const GoldGradientText('VERTEX AIRLINES', size: 26),
                      const SizedBox(height: 8),
                      const Text('Aerolínea Virtual',
                          style: TextStyle(color: V.muted, fontSize: 12)),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                FadeTransition(
                  opacity: CurvedAnimation(parent: _ctrl, curve: const Interval(0.3, 0.6)),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _ctrl,
                        builder: (_, __) => ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: _ctrl.value,
                            minHeight: 6,
                            backgroundColor: V.surface,
                            valueColor: const AlwaysStoppedAnimation(V.neon),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Text(
                          _msgs[_idx],
                          key: ValueKey(_idx),
                          style: const TextStyle(
                              color: V.neon,
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Text(
                    _jokes[_idx % _jokes.length],
                    key: ValueKey(_idx % _jokes.length),
                    style: const TextStyle(color: V.muted, fontSize: 11),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
