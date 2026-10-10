import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class FlightDetailsScreen extends StatelessWidget {
  const FlightDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del Vuelo', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GradientCard(
              child: Column(
                children: [
                  const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('KLAX', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                    Icon(Icons.flight_takeoff_rounded, color: V.neon),
                    Text('KJFK', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                  ]),
                  const SizedBox(height: 6),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: V.green.withOpacity(0.16), borderRadius: BorderRadius.circular(10)), child: const Text('● EN VUELO', style: TextStyle(color: V.green, fontSize: 11, fontWeight: FontWeight.w800))),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _m('Velocidad', '459 kts'),
                      _m('Altitud', '36,000 ft'),
                      _m('T. restante', '2h 14m'),
                      _m('Distancia', '2,987 nm'),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: const LinearProgressIndicator(value: 0.62, minHeight: 8, backgroundColor: V.surface2, valueColor: AlwaysStoppedAnimation(V.neon)),
                  ),
                  const SizedBox(height: 6),
                  const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('KLAX', style: TextStyle(color: V.muted, fontSize: 10)),
                    Text('62% de avance en ruta', style: TextStyle(color: V.muted, fontSize: 10)),
                    Text('KJFK', style: TextStyle(color: V.muted, fontSize: 10)),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _m(String l, String v) => Column(children: [
      Text(v, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
      Text(l, style: const TextStyle(color: V.muted, fontSize: 10)),
    ]);