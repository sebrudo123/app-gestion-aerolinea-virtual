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
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [V.bg2, V.bg],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 130),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              const SizedBox(height: 22),
              const _PilotCard(),
              const SizedBox(height: 26),
              const _Section('ACCESOS RÁPIDOS'),
              const SizedBox(height: 14),
              const _QuickGrid(),
              const SizedBox(height: 26),
              const _Section('ESTADÍSTICAS'),
              const SizedBox(height: 14),
              const _StatsGrid(),
              const SizedBox(height: 22),
              const _RankCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Buenas tardes, CADETE',
                  style: TextStyle(color: V.muted, fontSize: 13)),
              SizedBox(height: 4),
              GoldGradientText('sebrudo09', size: 24, spacing: 0.5),
            ],
          ),
        ),
        _IconBtn(icon: Icons.notifications_none_rounded, hasBadge: true),
        const SizedBox(width: 12),
        _IconBtn(icon: Icons.headset_mic_outlined),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final bool hasBadge;

  const _IconBtn({required this.icon, this.hasBadge = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: V.surface,
            border: Border.all(color: V.borderGold),
          ),
          child: Icon(icon, color: V.goldLight, size: 22),
        ),
        if (hasBadge)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              height: 9,
              width: 9,
              decoration: BoxDecoration(
                color: V.danger,
                shape: BoxShape.circle,
                border: Border.all(color: V.bg, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }
}

class _PilotCard extends StatelessWidget {
  const _PilotCard();

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [V.goldLight, V.gold, V.bronze],
                  ),
                  border: Border.all(color: V.goldLight, width: 2),
                ),
                child: const Center(
                  child: Text(
                    'S',
                    style: TextStyle(
                      color: V.bg,
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sebrudos Nine',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Pill(label: 'CADETE'),
                        SizedBox(width: 8),
                        Pill(label: 'VTG030', color: V.goldLight),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.military_tech_rounded, color: V.gold, size: 34),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              _VipStat('4 h', 'HORAS'),
              _Divider(),
              _VipStat('6', 'VUELOS'),
              _Divider(),
              _VipStat('VTG030', 'CALLSIGN'),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: V.bg.withOpacity(0.35),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: V.borderGold),
            ),
            child: Row(
              children: const [
                Icon(Icons.workspace_premium_rounded, color: V.gold, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Insignia: Ala de Bronce — Piloto en formación',
                    style: TextStyle(
                      color: V.goldLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VipStat extends StatelessWidget {
  final String v, l;
  const _VipStat(this.v, this.l);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(v,
              style: const TextStyle(
                  color: V.goldLight, fontSize: 17, fontWeight: FontWeight.w800)),
          Text(l,
              style: const TextStyle(color: V.muted, fontSize: 10, letterSpacing: 1)),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) {
    return Container(height: 30, width: 1, color: V.borderGold);
  }
}

class _Section extends StatelessWidget {
  final String t;
  const _Section(this.t);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 18, decoration: BoxDecoration(color: V.gold, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 10),
        Text(t, style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.2)),
      ],
    );
  }
}

class _QuickGrid extends StatelessWidget {
  const _QuickGrid();
  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.route_rounded, 'Plan de Vuelo'),
      (Icons.list_alt_rounded, 'Mis Planes'),
      (Icons.emoji_events_rounded, 'Rankings'),
      (Icons.groups_rounded, 'Mi Equipo'),
    ];
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.78,
      children: List.generate(4, (i) {
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [V.surface, V.surface2]),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: V.borderGold),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: V.gold.withOpacity(0.14),
                  border: Border.all(color: V.borderGold),
                ),
                child: Icon(items[i].$1, color: V.goldLight, size: 20),
              ),
              const SizedBox(height: 8),
              Text(items[i].$2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: V.muted, fontSize: 10)),
            ],
          ),
        );
      }),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid();
  @override
  Widget build(BuildContext context) {
    const s = [
      (Icons.schedule_rounded, '4 h', 'Horas voladas'),
      (Icons.flight_takeoff_rounded, '6', 'Vuelos completados'),
      (Icons.public_rounded, '2,480', 'Millas recorridas'),
      (Icons.stars_rounded, '363 pts', 'Puntos de rango'),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.75,
      children: List.generate(4, (i) {
        return GradientCard(
          padding: const EdgeInsets.all(16),
          radius: 18,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(s[i].$1, color: V.gold, size: 22),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s[i].$2, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                Text(s[i].$3, style: const TextStyle(color: V.muted, fontSize: 11)),
              ]),
            ],
          ),
        );
      }),
    );
  }
}

class _RankCard extends StatelessWidget {
  const _RankCard();
  @override
  Widget build(BuildContext context) {
    return GradientCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [
            Icon(Icons.trending_up_rounded, color: V.gold, size: 20),
            SizedBox(width: 10),
            Expanded(child: Text('Progreso de rango', style: TextStyle(fontWeight: FontWeight.w700))),
            Text('363 / 500 pts', style: TextStyle(color: V.goldLight, fontSize: 12)),
          ]),
          const SizedBox(height: 18),
          Row(children: const [
            Text('CADETE', style: TextStyle(color: V.muted, fontSize: 11, letterSpacing: 1, fontWeight: FontWeight.w700)),
            Spacer(),
            Text('SEGUNDO OFICIAL', style: TextStyle(color: V.gold, fontSize: 11, letterSpacing: 1, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: 0.726,
              minHeight: 10,
              backgroundColor: V.bg,
              valueColor: const AlwaysStoppedAnimation(V.gold),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Te faltan 137 pts para ascender a SEGUNDO OFICIAL',
              style: TextStyle(color: V.muted, fontSize: 11.5)),
        ],
      ),
    );
  }
}
