import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gold_gradient_text.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _msgTimer;
  int _msgIndex = 0;
  int _jokeIndex = 0;

  final List<String> _messages = const [
    'Conectando con el servidor...',
    'Verificando sesión de usuario...',
    'Cargando perfil de piloto...',
  ];

  final List<String> _jokes = const [
    'Verificando que nadie dejó su equipaje en casa',
    'Revisando planes de vuelo',
    'Chequeando el checklist pre-vuelo',
    'Calentando motores en la pista 27R',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();

    _msgTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_msgIndex < _messages.length - 1) _msgIndex++;
        _jokeIndex = (_jokeIndex + 1) % _jokes.length;
      });
    });

    Timer(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _msgTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fadeIn = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
    );
    final fadeProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
    );

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
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 2),
                FadeTransition(
                  opacity: fadeIn,
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
                              color: V.gold.withOpacity(0.35),
                              blurRadius: 32,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.flight_takeoff_rounded,
                          size: 60,
                          color: V.bg,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const GoldGradientText('VERTEX AIRLINES', size: 26),
                      const SizedBox(height: 10),
                      const Text(
                        'Elevando la experiencia de vuelo virtual',
                        style: TextStyle(
                          color: V.muted,
                          fontSize: 13,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                FadeTransition(
                  opacity: fadeProgress,
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, _) => ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: _controller.value,
                            minHeight: 6,
                            backgroundColor: V.surface,
                            valueColor: const AlwaysStoppedAnimation(V.gold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Text(
                          _messages[_msgIndex],
                          key: ValueKey(_msgIndex),
                          style: const TextStyle(
                            color: V.goldLight,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Row(
                    key: ValueKey(_jokeIndex),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.tips_and_updates_outlined,
                        color: V.bronze,
                        size: 15,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _jokes[_jokeIndex],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: V.muted,
                            fontSize: 11.5,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
