import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class RfsFleetScreen extends StatelessWidget {
  const RfsFleetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Flota', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('FLOTA GUARDADA EN LA NUBE', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
            const SizedBox(height: 10),
            const _Plane('Boeing 737-800', 'B738 • 186 asientos', Icons.flight_takeoff_rounded),
            const SizedBox(height: 8),
            const _Plane('Airbus A320', 'A320 • 180 asientos', Icons.flight_rounded),
            const SizedBox(height: 8),
            const _Plane('Boeing 747-400', 'B744 • 416 asientos', Icons.flight_land_rounded),
            const SizedBox(height: 8),
            const _Plane('Embraer E190', 'E190 • 114 asientos', Icons.airplanemode_active_rounded),
          ],
        ),
      ),
    );
  }
}

class _Plane extends StatelessWidget {
  final String t, sub;
  final IconData ic;
  const _Plane(this.t, this.sub, this.ic);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: V.surface2, borderRadius: BorderRadius.circular(14), border: Border.all(color: V.borderNeon)),
      child: Row(children: [
        Container(height: 38, width: 38, decoration: BoxDecoration(shape: BoxShape.circle, color: V.neon.withOpacity(0.14)), child: Icon(ic, color: V.neon, size: 20)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 2), Text(sub, style: const TextStyle(color: V.muted, fontSize: 11))])),
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: V.green.withOpacity(0.16), borderRadius: BorderRadius.circular(10)), child: const Text('EN SERVICIO', style: TextStyle(color: V.green, fontSize: 9, fontWeight: FontWeight.w800))),
      ]),
    );
  }
}