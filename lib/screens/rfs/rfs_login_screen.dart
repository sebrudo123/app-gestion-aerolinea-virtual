import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class RfsLoginScreen extends StatelessWidget {
  const RfsLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 84,
                  width: 84,
                  decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [V.goldLight, V.gold, V.bronze]), boxShadow: [BoxShadow(color: V.gold.withOpacity(0.3), blurRadius: 26)]),
                  child: const Center(child: Icon(Icons.flight_rounded, color: V.bg, size: 40)),
                ),
                const SizedBox(height: 14),
                const Text('RFS', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 2)),
                const Text('Real Flight Simulator', style: TextStyle(color: V.muted, fontSize: 12)),
                const SizedBox(height: 36),
                GradientCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const _Btn('INICIAR SESIÓN', V.neon),
                      const SizedBox(height: 10),
                      const _Btn('CREAR CUENTA', V.gold),
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
  final String t;
  final Color c;
  const _Btn(this.t, this.c);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [c.withOpacity(0.95), c.withOpacity(0.75)]), borderRadius: BorderRadius.circular(14)),
      child: Center(child: Text(t, style: const TextStyle(color: V.bg, fontWeight: FontWeight.w900, letterSpacing: 0.8))),
    );
  }
}