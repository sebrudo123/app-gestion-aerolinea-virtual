import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class AirportsScreen extends StatelessWidget {
  const AirportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aeropuertos', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            _A('KJFK', 'Nueva York • John F. Kennedy', 'EE. UU.'),
            _A('KLAX', 'Los Ángeles', 'EE. UU.'),
            _A('SKBO', 'Bogotá • El Dorado', 'Colombia'),
            _A('SKRG', 'Rionegro • José María Córdova', 'Colombia'),
            _A('SCL', 'Santiago • Arturo Merino Benítez', 'Chile'),
            _A('MIA', 'Miami', 'EE. UU.'),
            _A('BOG', 'Bogotá', 'Colombia'),
            _A('KAVX', 'Santa Catalina Island', 'EE. UU.'),
            _A('KNUC', 'San Clemente Island', 'EE. UU.'),
          ],
        ),
      ),
    );
  }
}

class _A extends StatelessWidget {
  final String code, n, p;
  const _A(this.code, this.n, this.p);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GradientCard(
        padding: const EdgeInsets.all(14),
        radius: 16,
        child: Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), decoration: BoxDecoration(color: V.neon.withOpacity(0.14), borderRadius: BorderRadius.circular(10)), child: Text(code, style: const TextStyle(fontWeight: FontWeight.w900, color: V.neon))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(n, style: const TextStyle(fontWeight: FontWeight.w700)), Text(p, style: const TextStyle(color: V.muted, fontSize: 11))])),
          const Icon(Icons.chevron_right_rounded, color: V.neon),
        ]),
      ),
    );
  }
}