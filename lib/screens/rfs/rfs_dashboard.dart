import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class RfsDashboard extends StatelessWidget {
  const RfsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RFS Airline Manager', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Bienvenido, SkyPilot12 (CEO de SkyAir Virtual)', style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            Wrap(spacing: 8, runSpacing: 8, children: const [_Chip('Plan de vuelo'), _Chip('Flota'), _Chip('Finanzas'), _Chip('Tripulación')]),
            const SizedBox(height: 14),
            GradientCard(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SkyAir Virtual • Level 3', style: TextStyle(fontWeight: FontWeight.w800)),
                  SizedBox(height: 8),
                  Text('12,480 / 20,000 XP', style: TextStyle(color: V.muted, fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            GradientCard(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PLANES RFS (DB)', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
                  SizedBox(height: 8),
                  Text('Activos • SV102 SCL-MIA • En vuelo', style: TextStyle(color: V.muted, fontSize: 11)),
                  Text('Programado • SV203 MIA-BOG', style: TextStyle(color: V.muted, fontSize: 11)),
                  Text('Historial/Borradores sincronizados', style: TextStyle(color: V.muted, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String t;
  const _Chip(this.t);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: V.borderNeon), color: V.surface2),
      child: Text(t, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
