import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class MsfsRankingScreen extends StatefulWidget {
  const MsfsRankingScreen({super.key});

  @override
  State<MsfsRankingScreen> createState() => _MsfsRankingScreenState();
}

class _MsfsRankingScreenState extends State<MsfsRankingScreen> {
  int _tab = 0;

  static const _airlines = [
    {'name': 'SkyLink Virtual', 'pts': '184,320', 'pilots': '42'},
    {'name': 'IberiaVirtual', 'pts': '171,880', 'pilots': '38'},
    {'name': 'GlobalWings', 'pts': '160,540', 'pilots': '35'},
    {'name': 'AndesConnect', 'pts': '142,110', 'pilots': '29'},
    {'name': 'PacificAir VA', 'pts': '128,960', 'pilots': '24'},
  ];
  static const _players = [
    {'name': 'Capt_Alex', 'pts': '18,420', 'airline': 'SkyLink Virtual'},
    {'name': 'SkyPilot12', 'pts': '16,880', 'airline': 'SkyLink Virtual'},
    {'name': 'MariVuela', 'pts': '15,240', 'airline': 'IberiaVirtual'},
    {'name': 'Tower_Juan', 'pts': '13,970', 'airline': 'GlobalWings'},
    {'name': 'NewPilot_23', 'pts': '2,110', 'airline': 'SkyLink Virtual'},
  ];

  @override
  Widget build(BuildContext context) {
    final list = _tab == 0 ? _airlines : _players;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking',
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
            Row(
              children: [
                _Tab('Aerolíneas', 0),
                const SizedBox(width: 8),
                _Tab('Jugadores', 1),
              ],
            ),
            const SizedBox(height: 16),
            GradientCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  for (var i = 0; i < list.length; i++) ...[
                    if (i > 0) const Divider(color: V.borderNeon),
                    _Row(
                      rank: i + 1,
                      name: '${list[i]['name']}',
                      sub: _tab == 0
                          ? '${list[i]['pilots']} pilotos'
                          : '${list[i]['airline']}',
                      pts: '${list[i]['pts']} pts',
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text('Los puntos se calculan por horas de vuelo, precisión y rutas completadas.',
                style: TextStyle(color: V.muted, fontSize: 11),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _Tab(String t, int i) {
    final sel = _tab == i;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tab = i),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: sel
                ? const LinearGradient(colors: [V.neonLight, V.neon])
                : null,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: V.borderNeon),
          ),
          child: Center(
            child: Text(t,
                style: TextStyle(
                    color: sel ? V.bg : V.muted,
                    fontWeight: FontWeight.w700,
                    fontSize: 12)),
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final int rank;
  final String name, sub, pts;
  const _Row(
      {required this.rank,
      required this.name,
      required this.sub,
      required this.pts});

  @override
  Widget build(BuildContext context) {
    final medal = rank == 1
        ? V.goldLight
        : rank == 2
            ? const Color(0xFFB9C2CC)
            : rank == 3
                ? V.bronze
                : V.muted;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: medal.withOpacity(0.16),
              border: Border.all(color: medal.withOpacity(0.7)),
            ),
            child: Center(
              child: Text('$rank',
                  style: TextStyle(
                      color: medal,
                      fontWeight: FontWeight.w900,
                      fontSize: 12)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 13)),
                Text(sub,
                    style: const TextStyle(color: V.muted, fontSize: 10.5)),
              ],
            ),
          ),
          Text(pts,
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: V.neon)),
        ],
      ),
    );
  }
}