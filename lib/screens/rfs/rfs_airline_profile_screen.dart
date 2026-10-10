import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class RfsAirlineProfileScreen extends StatelessWidget {
  const RfsAirlineProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil de Aerolínea', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GradientCard(
              child: Column(
                children: [
                  Container(height: 72, width: 72, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [V.goldLight, V.gold, V.bronze])), child: const Icon(Icons.flight_rounded, color: V.bg, size: 34)),
                  const SizedBox(height: 10),
                  const Text('SkyAir Virtual', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  const Text('Aerolínea sincronizada con la nube', style: TextStyle(color: V.muted, fontSize: 11)),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _m('\$2,480,650', 'Ingresos globales'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _m('152', 'Total de vuelos'),
                      _m('24', 'Miembros activos'),
                    ],
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

class _m extends StatelessWidget {
  final String v, l;
  const _m(this.v, this.l);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(v, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: V.neon)),
      Text(l, style: const TextStyle(color: V.muted, fontSize: 11)),
    ]);
  }
}