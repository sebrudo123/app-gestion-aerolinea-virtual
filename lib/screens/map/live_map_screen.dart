import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class LiveMapScreen extends StatelessWidget {
  const LiveMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa en vivo', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          Row(
            children: const [
              Icon(Icons.circle, color: V.green, size: 10),
              SizedBox(width: 6),
              Text('23:18 • Conectado', style: TextStyle(fontSize: 11)),
              SizedBox(width: 14),
            ],
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: V.borderNeon, width: 1.4),
                    gradient: const LinearGradient(colors: [V.surface, V.surface2]),
                    boxShadow: [BoxShadow(color: V.neon.withOpacity(0.16), blurRadius: 24, offset: const Offset(0, 8))],
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.map_outlined, color: V.neon, size: 42),
                            SizedBox(height: 6),
                            Text('MAPA SATELITAL', style: TextStyle(letterSpacing: 2, fontSize: 11, color: V.muted)),
                            SizedBox(height: 4),
                            Text('KJFK ➔ KLAX • SKY728', style: TextStyle(fontSize: 11, color: V.muted)),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        child: GradientCard(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          radius: 14,
                          child: const Text('SKY728 • KJFK ➔ KLAX • ALT 35000 ft • 482 kts'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: GradientCard(
                padding: const EdgeInsets.all(16),
                child: const Row(
                  children: [
                    Icon(Icons.airplanemode_active_rounded, color: V.neon),
                    SizedBox(width: 10),
                    Expanded(child: Text('Boeing 737-800 • En curso', style: TextStyle(fontWeight: FontWeight.w700))),
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('35,000 ft • 482 kts • ETA 3h 24m', style: TextStyle(color: V.muted, fontSize: 11)),
                    ])
                  ],
                ),
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
