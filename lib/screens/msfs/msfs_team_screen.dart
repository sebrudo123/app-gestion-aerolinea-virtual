import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class MsfsTeamScreen extends StatelessWidget {
  const MsfsTeamScreen({super.key});

  static const _members = [
    {'name': 'SkyPilot12', 'role': 'CEO • Comandante', 'hours': '248 h'},
    {'name': 'Capt_Alex', 'role': 'Comandante', 'hours': '412 h'},
    {'name': 'MariVuela', 'role': 'Primer Oficial', 'hours': '186 h'},
    {'name': 'Tower_Juan', 'role': 'ATC • Instructor', 'hours': '305 h'},
    {'name': 'NewPilot_23', 'role': 'Cadete', 'hours': '24 h'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi equipo',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [V.bg2, V.bg]),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GradientCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: const [
                  Icon(Icons.groups_rounded, color: V.neon, size: 30),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SkyLink Virtual',
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 15)),
                        Text('5 pilotos • 1,175 horas totales',
                            style: TextStyle(
                                color: V.muted, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text('MIEMBROS',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    color: V.muted)),
            const SizedBox(height: 10),
            for (final m in _members) ...[
              GradientCard(
                padding: const EdgeInsets.all(13),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient:
                            LinearGradient(colors: [V.neonLight, V.neon]),
                      ),
                      child: Center(
                        child: Text(
                            '${m['name']}'.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${m['name']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13)),
                          Text('${m['role']}',
                              style: const TextStyle(
                                  color: V.muted, fontSize: 11)),
                        ],
                      ),
                    ),
                    Text('${m['hours']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}