import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';
import '../msfs/msfs_hub_screen.dart';
import '../rfs/rfs_hub_screen.dart';
import '../rfs/rfs_fpl.dart';
import '../airports/airports_screen.dart';
import '../weather/weather_screen.dart';

class FlightsHubScreen extends StatelessWidget {
  const FlightsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void go(Widget w) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));
    return Scaffold(
      appBar: AppBar(title: const Text('Vuelos', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('VUELOS ACTIVOS', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1, color: V.muted)),
            const SizedBox(height: 10),
            _Flight('SKY728', 'KJFK ➔ KLAX', 'Boeing 737-800 • En vuelo', '35,000 ft • 482 kts'),
            const SizedBox(height: 8),
            _Flight('SV102', 'SCL ➔ MIA', 'En vuelo (RFS)', 'Activo'),
            const SizedBox(height: 8),
            _Flight('SV203', 'MIA ➔ BOG', 'Programado (RFS)', 'Programado'),
            const SizedBox(height: 20),
            const Text('MÓDULOS', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1, color: V.muted)),
            const SizedBox(height: 10),
            _Big('MSFS / SkyConnect', Icons.cloud_rounded, () => go(const MsfsHubScreen())),
            const SizedBox(height: 10),
            _Big('RFS Airline Manager', Icons.flight_rounded, () => go(const RfsHubScreen())),
            const SizedBox(height: 10),
            _Big('RFS Plan de Vuelo', Icons.edit_note_rounded, () => go(const RfsFpl())),
            const SizedBox(height: 10),
            _Big('Aeropuertos', Icons.location_city_rounded, () => go(const AirportsScreen())),
            const SizedBox(height: 10),
            _Big('Clima', Icons.wb_sunny_rounded, () => go(const WeatherScreen())),
          ],
        ),
      ),
    );
  }
}

class _Flight extends StatelessWidget {
  final String id, r, t, sub;
  const _Flight(this.id, this.r, this.t, this.sub);
  @override
  Widget build(BuildContext context) {
    return GradientCard(
      padding: const EdgeInsets.all(14),
      radius: 16,
      child: Row(children: [
        Container(height: 38, width: 38, decoration: BoxDecoration(shape: BoxShape.circle, color: V.neon.withOpacity(0.14), border: Border.all(color: V.borderNeon)), child: const Icon(Icons.flight_takeoff_rounded, color: V.neon, size: 18)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Text(id, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(width: 6), Text(r, style: const TextStyle(fontWeight: FontWeight.w700))]),
          const SizedBox(height: 2),
          Text(t, style: const TextStyle(color: V.muted, fontSize: 11)),
          Text(sub, style: const TextStyle(color: V.neon, fontSize: 11, fontWeight: FontWeight.w700)),
        ])),
      ]),
    );
  }
}

class _Big extends StatelessWidget {
  final String t;
  final IconData ic;
  final VoidCallback onTap;
  const _Big(this.t, this.ic, this.onTap);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: V.surface2, borderRadius: BorderRadius.circular(16), border: Border.all(color: V.borderNeon), boxShadow: [BoxShadow(color: V.neon.withOpacity(0.08), blurRadius: 16)]),
        child: Row(children: [Icon(ic, color: V.neon, size: 22), const SizedBox(width: 12), Expanded(child: Text(t, style: const TextStyle(fontWeight: FontWeight.w800))), const Icon(Icons.chevron_right_rounded, color: V.neon)]),
      ),
    );
  }
}