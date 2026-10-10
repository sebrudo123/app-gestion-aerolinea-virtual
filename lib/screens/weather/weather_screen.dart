import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clima / METAR', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            _W('KJFK', '21°C • Viento 120/08 kt • Despejado', Icons.wb_sunny_rounded),
            _W('KLAX', '17°C • Viento 260/10 kt • Niebla ligera', Icons.foggy),
            _W('SKBO', '13°C • Viento 050/05 kt • Cubierto', Icons.cloud_rounded),
            _W('SKRG', '16°C • Viento 030/06 kt • Lluvia leve', Icons.water_drop_rounded),
          ],
        ),
      ),
    );
  }
}

class _W extends StatelessWidget {
  final String a, m;
  final IconData ic;
  const _W(this.a, this.m, this.ic);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GradientCard(
        padding: const EdgeInsets.all(14),
        radius: 16,
        child: Row(children: [
          Container(height: 36, width: 36, decoration: BoxDecoration(shape: BoxShape.circle, color: V.neon.withOpacity(0.14)), child: Icon(ic, color: V.neon, size: 18)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(a, style: const TextStyle(fontWeight: FontWeight.w800)), Text(m, style: const TextStyle(color: V.muted, fontSize: 11))])),
        ]),
      ),
    );
  }
}