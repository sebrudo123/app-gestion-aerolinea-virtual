import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class FlightsTab extends StatelessWidget {
  const FlightsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 130),
          children: const [
            Text('MIS VUELOS - Historial de operaciones', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
            SizedBox(height: 18),
            _F(o: 'SKBO', d: 'SKRG', ac: 'Airbus A320', date: '02 Oct 2026', dur: '48 min', pts: '+25 pts'),
            SizedBox(height: 12),
            _F(o: 'KAVX', d: 'KNUC', ac: 'Airbus A320', date: '28 Sep 2026', dur: '22 min', pts: '+25 pts', appeal: true),
          ],
        ),
      ),
    );
  }
}

class _F extends StatelessWidget {
  final String o, d, ac, date, dur, pts;
  final bool appeal;
  const _F({required this.o, required this.d, required this.ac, required this.date, required this.dur, required this.pts, this.appeal = false});

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(children: [Text(o, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), const Text('Origen', style: TextStyle(color: V.muted, fontSize: 9))]),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(children: [const Icon(Icons.flight_rounded, color: V.gold, size: 16), Container(height: 1, color: V.borderGold)]),
                ),
              ),
              Column(children: [Text(d, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), const Text('Destino', style: TextStyle(color: V.muted, fontSize: 9))]),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(spacing: 6, children: [_C(Icons.airplanemode_active_rounded, ac), _C(Icons.timer_outlined, dur), _C(Icons.calendar_today_rounded, date)]),
          const SizedBox(height: 10),
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: V.green.withOpacity(0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: V.green.withOpacity(0.6))), child: Row(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.check_circle_rounded, color: V.green, size: 12), SizedBox(width: 4), Text('Aprobado', style: TextStyle(color: V.green, fontSize: 10, fontWeight: FontWeight.w700))])),
            const Spacer(),
            Text(pts, style: const TextStyle(color: V.goldLight, fontWeight: FontWeight.w800)),
          ]),
          if (appeal) ...[const SizedBox(height: 8), const Text('Apelación aceptada: se restauraron los puntos del vuelo.', style: TextStyle(color: V.green, fontSize: 11))],
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: V.gold), gradient: LinearGradient(colors: [V.gold.withOpacity(0.12), V.gold.withOpacity(0.04)])), child: const Center(child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.description_outlined, color: V.goldLight, size: 14), SizedBox(width: 6), Text('Certificado', style: TextStyle(color: V.goldLight, fontSize: 11, fontWeight: FontWeight.w700))]))),
        ],
      ),
    );
  }
}

class _C extends StatelessWidget {
  final IconData i;
  final String l;
  const _C(this.i, this.l);
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: V.surface2, borderRadius: BorderRadius.circular(10), border: Border.all(color: V.borderGold)), child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(i, color: V.goldLight, size: 12), const SizedBox(width: 4), Text(l, style: const TextStyle(color: V.muted, fontSize: 10))]));
  }
}
