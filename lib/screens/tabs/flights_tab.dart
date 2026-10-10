import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class FlightsTab extends StatelessWidget {
  const FlightsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [V.bg2, V.bg],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 130),
          children: const [
            Text('MIS VUELOS - Historial de operaciones',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1)),
            SizedBox(height: 20),
            _FCard(
              o: 'SKBO',
              d: 'SKRG',
              ac: 'Airbus A320',
              date: '02 Oct 2026',
              dur: '48 min',
              pts: '+25 pts',
            ),
            SizedBox(height: 14),
            _FCard(
              o: 'KAVX',
              d: 'KNUC',
              ac: 'Airbus A320',
              date: '28 Sep 2026',
              dur: '22 min',
              pts: '+25 pts',
            ),
          ],
        ),
      ),
    );
  }
}

class _FCard extends StatelessWidget {
  final String o, d, ac, date, dur, pts;
  const _FCard({
    required this.o,
    required this.d,
    required this.ac,
    required this.date,
    required this.dur,
    required this.pts,
  });

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(children: [
                Text(o, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                const Text('Origen', style: TextStyle(color: V.muted, fontSize: 10)),
              ]),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(children: [
                    const Icon(Icons.flight_rounded, color: V.gold, size: 18),
                    Container(height: 1.5, color: V.borderGold),
                  ]),
                ),
              ),
              Column(children: [
                Text(d, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                const Text('Destino', style: TextStyle(color: V.muted, fontSize: 10)),
              ]),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Chip(icon: Icons.airplanemode_active_rounded, label: ac),
              _Chip(icon: Icons.timer_outlined, label: dur),
              _Chip(icon: Icons.calendar_today_rounded, label: date),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: V.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: V.green.withOpacity(0.6)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: const [
                  Icon(Icons.check_circle_rounded, color: V.green, size: 13),
                  SizedBox(width: 5),
                  Text('Aprobado', style: TextStyle(color: V.green, fontSize: 11, fontWeight: FontWeight.w700)),
                ]),
              ),
              const Spacer(),
              Text(pts, style: const TextStyle(color: V.goldLight, fontSize: 15, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: V.gold),
              gradient: LinearGradient(colors: [V.gold.withOpacity(0.14), V.gold.withOpacity(0.04)]),
            ),
            child: const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.description_outlined, color: V.goldLight, size: 16),
                  SizedBox(width: 8),
                  Text('Certificado', style: TextStyle(color: V.goldLight, fontWeight: FontWeight.w700, fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text('Apelación aceptada: se restauraron los puntos del vuelo.',
              style: TextStyle(color: V.green, fontSize: 11.5)),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Chip({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: V.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: V.borderGold),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, color: V.goldLight, size: 13),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: V.muted, fontSize: 11)),
      ]),
    );
  }
}
