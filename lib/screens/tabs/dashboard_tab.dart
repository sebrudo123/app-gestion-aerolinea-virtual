import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';
import '../../widgets/gold_gradient_text.dart';
import '../../widgets/pill.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg]),
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 130),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Buenas tardes, CADETE', style: TextStyle(color: V.muted, fontSize: 13)),
                        SizedBox(height: 4),
                        GoldGradientText('sebrudo09', size: 24),
                      ],
                    ),
                  ),
                  _I(icon: Icons.notifications_none_rounded, badge: true),
                  const SizedBox(width: 10),
                  _I(icon: Icons.headset_mic_outlined),
                ],
              ),
              const SizedBox(height: 20),
              GradientCard(
                child: Row(
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [V.goldLight, V.gold, V.bronze]), border: Border.all(color: V.goldLight, width: 2)),
                      child: const Center(child: Text('S', style: TextStyle(color: V.bg, fontSize: 22, fontWeight: FontWeight.w900))),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Sebrudos Nine', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                          SizedBox(height: 4),
                          Row(children: [Pill(label: 'CADETE'), SizedBox(width: 6), Pill(label: 'VTG030')]),
                        ],
                      ),
                    ),
                    Column(children: const [Text('4 h', style: TextStyle(color: V.goldLight, fontWeight: FontWeight.w800)), Text('Horas', style: TextStyle(color: V.muted, fontSize: 10))]),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const _T('ACCESOS RÁPIDOS'),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.78,
                children: const [
                  _Q(Icons.route_rounded, 'FPL'),
                  _Q(Icons.library_books_rounded, 'Briefing'),
                  _Q(Icons.checklist_rounded, 'Checklists'),
                  _Q(Icons.settings_input_antenna_rounded, 'ATC'),
                ],
              ),
              const SizedBox(height: 22),
              const _T('ESTADÍSTICAS'),
              const SizedBox(height: 12),
              const _Stats(),
              const SizedBox(height: 20),
              const _Rank(),
            ],
          ),
        ),
      ),
    );
  }
}

class _I extends StatelessWidget {
  final IconData icon;
  final bool badge;
  const _I({required this.icon, this.badge = false});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(height: 44, width: 44, decoration: BoxDecoration(shape: BoxShape.circle, color: V.surface, border: Border.all(color: V.borderGold)), child: Icon(icon, color: V.goldLight)),
        if (badge)
          Positioned(
            right: 6,
            top: 6,
            child: Container(height: 8, width: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: V.danger, border: Border.all(color: V.bg, width: 1.5))),
          ),
      ],
    );
  }
}

class _T extends StatelessWidget {
  final String t;
  const _T(this.t);
  @override
  Widget build(BuildContext context) {
    return Row(children: [Container(width: 4, height: 16, decoration: BoxDecoration(color: V.gold, borderRadius: BorderRadius.circular(2))), const SizedBox(width: 8), Text(t, style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.1))]);
  }
}

class _Q extends StatelessWidget {
  final IconData i;
  final String l;
  const _Q(this.i, this.l);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [V.surface, V.surface2]), borderRadius: BorderRadius.circular(16), border: Border.all(color: V.borderGold)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(i, color: V.goldLight, size: 20), const SizedBox(height: 6), Text(l, textAlign: TextAlign.center, style: const TextStyle(color: V.muted, fontSize: 10))]),
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats();
  @override
  Widget build(BuildContext context) {
    const d = [(Icons.schedule_rounded, '4 h', 'Horas voladas'), (Icons.flight_takeoff_rounded, '6', 'Vuelos completados'), (Icons.public_rounded, '2,480', 'Millas recorridas'), (Icons.stars_rounded, '363 pts', 'Puntos de rango')];
    return GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.8, children: d.map((e) => GradientCard(padding: const EdgeInsets.all(14), radius: 16, child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(e.$1, color: V.gold), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(e.$2, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)), Text(e.$3, style: const TextStyle(color: V.muted, fontSize: 10))])]))).toList());
  }
}

class _Rank extends StatelessWidget {
  const _Rank();
  @override
  Widget build(BuildContext context) {
    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [Icon(Icons.trending_up_rounded, color: V.gold), SizedBox(width: 8), Expanded(child: Text('Progreso de rango', style: TextStyle(fontWeight: FontWeight.w700))), Text('363 / 500 pts', style: TextStyle(color: V.goldLight, fontSize: 11))]),
          const SizedBox(height: 16),
          Row(children: const [Text('CADETE', style: TextStyle(color: V.muted, fontSize: 10, letterSpacing: 0.5, fontWeight: FontWeight.w700)), Spacer(), Text('SEGUNDO OFICIAL', style: TextStyle(color: V.gold, fontSize: 10, letterSpacing: 0.5, fontWeight: FontWeight.w700))]),
          const SizedBox(height: 8),
          ClipRRect(borderRadius: BorderRadius.circular(20), child: const LinearProgressIndicator(value: 0.726, minHeight: 8, backgroundColor: V.bg, valueColor: AlwaysStoppedAnimation(V.gold))),
          const SizedBox(height: 8),
          const Text('Te faltan 137 pts para ascender a SEGUNDO OFICIAL', style: TextStyle(color: V.muted, fontSize: 11)),
        ],
      ),
    );
  }
}
