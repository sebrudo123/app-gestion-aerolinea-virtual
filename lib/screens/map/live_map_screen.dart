import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class LiveMapScreen extends StatelessWidget {
  const LiveMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa en vivo',
            style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5)),
        actions: [
          const Row(
            children: [
              Icon(Icons.circle, color: V.green, size: 10),
              SizedBox(width: 6),
              Text('23:18 • Conectado',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              SizedBox(width: 14),
            ],
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [V.bg2, V.bg],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: V.borderNeon, width: 1.4),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [V.surface, V.surface2],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: V.neon.withOpacity(0.16),
                        blurRadius: 28,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: RadialGradient(
                            center: Alignment.bottomRight,
                            radius: 1.4,
                            colors: [
                              V.neon.withOpacity(0.08),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.satellite_alt_rounded,
                                color: V.neon, size: 42),
                            SizedBox(height: 8),
                            Text('MAPA SATELITAL',
                                style: TextStyle(
                                    letterSpacing: 2,
                                    fontSize: 10,
                                    color: V.muted,
                                    fontWeight: FontWeight.w600)),
                            SizedBox(height: 4),
                            Text('KJFK ➔ KLAX',
                                style:
                                    TextStyle(color: V.text, fontSize: 14)),
                            SizedBox(height: 2),
                            Text('Trayectoria activa',
                                style:
                                    TextStyle(color: V.muted, fontSize: 11)),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 12,
                        right: 12,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: GradientCard(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            radius: 16,
                            child: const Text(
                              'SKY728 • KJFK ➔ KLAX • ALT: 35,000 ft • 482 kts',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: GradientCard(
                padding: const EdgeInsets.all(16),
                radius: 18,
                child: const Row(
                  children: [
                    Icon(Icons.airplanemode_active_rounded, color: V.neon),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Boeing 737-800',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 14)),
                          SizedBox(height: 2),
                          Text('Vuelo en curso',
                              style:
                                  TextStyle(color: V.muted, fontSize: 11)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Altitud: 35,000 ft',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 12)),
                        Text('Velocidad: 482 kts',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 12)),
                        Text('ETA: 3h 24m',
                            style: TextStyle(
                                color: V.muted,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 78),
          ],
        ),
      ),
    );
  }
}
