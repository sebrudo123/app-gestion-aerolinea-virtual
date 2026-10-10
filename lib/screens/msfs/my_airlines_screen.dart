import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class MyAirlinesScreen extends StatelessWidget {
  const MyAirlinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Aerolíneas', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('MI AEROLÍNEA', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
            const SizedBox(height: 10),
            GradientCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(height: 46, width: 46, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [V.goldLight, V.gold])), child: const Icon(Icons.flight, color: V.bg, size: 22)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                    Text('SkyLink Virtual', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    SizedBox(height: 2),
                    Text('248 vuelos • 12 miembros • 6 aviones', style: TextStyle(color: V.muted, fontSize: 11)),
                  ])),
                  const Icon(Icons.star_rounded, color: V.gold),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text('AEROLÍNEAS GLOBALES (DB)', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
            const SizedBox(height: 10),
            const _Al('Global Air'),
            const SizedBox(height: 8),
            const _Al('Blue Horizon'),
            const SizedBox(height: 8),
            const _Al('SkyTeam VA'),
          ],
        ),
      ),
    );
  }
}

class _Al extends StatelessWidget {
  final String t;
  const _Al(this.t);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: V.surface2, borderRadius: BorderRadius.circular(14), border: Border.all(color: V.borderNeon)),
      child: Row(children: [
        Container(height: 34, width: 34, decoration: BoxDecoration(shape: BoxShape.circle, color: V.neon.withOpacity(0.16)), child: const Icon(Icons.flight_takeoff_rounded, color: V.neon, size: 16)),
        const SizedBox(width: 10),
        Expanded(child: Text(t, style: const TextStyle(fontWeight: FontWeight.w700))),
        const Icon(Icons.chevron_right_rounded, color: V.muted),
      ]),
    );
  }
}