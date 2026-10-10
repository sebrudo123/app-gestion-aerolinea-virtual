import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class FlightPlanScreen extends StatelessWidget {
  const FlightPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plan de Vuelo', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GradientCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PLAN DE VUELO (DB)', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
                  const SizedBox(height: 18),
                  const _F('Salida', 'KLAX'),
                  const SizedBox(height: 12),
                  const _F('Llegada', 'KJFK'),
                  const SizedBox(height: 12),
                  const _F('Fecha', '24 jun 2025'),
                  const SizedBox(height: 12),
                  const _F('Hora UTC', '14:30'),
                  const SizedBox(height: 12),
                  const _F('Aeronave', 'Boeing 737-800'),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [V.neonLight, V.neon]), borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: V.neon.withOpacity(0.25), blurRadius: 16, offset: Offset(0, 8))]),
                    child: const Center(child: Text('GUARDAR PLAN EN EL SERVIDOR', style: TextStyle(color: V.bg, fontWeight: FontWeight.w900, letterSpacing: 0.8))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _F extends StatelessWidget {
  final String l, v;
  const _F(this.l, this.v);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: V.surface2, borderRadius: BorderRadius.circular(12), border: Border.all(color: V.borderNeon)),
      child: Row(children: [
        Text(l, style: const TextStyle(color: V.muted, fontSize: 12)),
        const Spacer(),
        Text(v, style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(width: 6),
        const Icon(Icons.edit_outlined, color: V.neon, size: 16),
      ]),
    );
  }
}