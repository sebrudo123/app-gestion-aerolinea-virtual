import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class RfsFpl extends StatelessWidget {
  const RfsFpl({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plan de Vuelo RFS', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            _S('Activos'),
            _It('SV102 • En vuelo • SCL-MIA'),
            SizedBox(height: 10),
            _S('Historial'),
            _It('SV101 • Completado • MIA-SCL'),
            SizedBox(height: 10),
            _S('Borradores'),
            _It('SV203 • Programado • MIA-BOG'),
          ],
        ),
      ),
    );
  }
}

class _S extends StatelessWidget {
  final String t;
  const _S(this.t);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(t, style: const TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}

class _It extends StatelessWidget {
  final String t;
  const _It(this.t);
  @override
  Widget build(BuildContext context) {
    return GradientCard(
      padding: const EdgeInsets.all(12),
      child: Text(t, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
