import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class WelcomeMultiplatform extends StatelessWidget {
  const WelcomeMultiplatform({super.key});

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
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.flight_takeoff_rounded, color: V.neon, size: 72),
                const SizedBox(height: 16),
                const Text(
                  'VERTEX AIRLINES',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2),
                ),
                const SizedBox(height: 8),
                const Text('SkyConnect • RFS • MSFS 2020/2024',
                    style: TextStyle(color: V.muted)),
                const SizedBox(height: 40),
                GradientCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _Btn(text: 'Iniciar sesión con Xbox', color: V.green),
                      const SizedBox(height: 10),
                      _Btn(text: 'Iniciar sesión con Steam', color: V.neon),
                      const SizedBox(height: 10),
                      _Btn(text: 'Iniciar sesión (SkyConnect)', color: V.gold),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final String text;
  final Color color;
  const _Btn({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.withOpacity(0.95), color.withOpacity(0.75)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.9)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Center(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800))),
    );
  }
}
