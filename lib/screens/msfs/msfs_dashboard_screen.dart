import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';
import '../../services/session_service.dart';
import '../map/live_map_screen.dart';
import 'my_airlines_screen.dart';
import 'msfs_profile_screen.dart';
import 'flight_plan_screen.dart';
import 'msfs_settings_screen.dart';
import 'msfs_fleet_screen.dart';
import 'msfs_team_screen.dart';
import 'msfs_ranking_screen.dart';

class MsfsDashboardScreen extends StatefulWidget {
  final String edition;
  const MsfsDashboardScreen({required this.edition, super.key});

  @override
  State<MsfsDashboardScreen> createState() => _MsfsDashboardScreenState();
}

class _MsfsDashboardScreenState extends State<MsfsDashboardScreen> {
  int _tab = 0;
  String _user = 'SkyPilot12';
  String _avatar = 'S';
  String _hours = '248h 32m';
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final acc = await SessionService.msfsAccount(widget.edition);
    final avatar = await SessionService.avatar();
    final hours = await SessionService.hours();
    if (mounted) {
      setState(() {
        _user = acc?['user'] ?? 'SkyPilot12';
        _avatar = avatar;
        _hours = hours;
        _ready = true;
      });
  }
  }

  void _go(Widget w) =>
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));

  @override
  Widget build(BuildContext context) {
    final editionLabel = widget.edition == '2024' ? 'MSFS 2024' : 'MSFS 2020';
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [V.bg2, V.bg]),
        ),
        child: IndexedStack(
          index: _tab,
          children: [
            _buildHome(context),
            const LiveMapScreen(),
            const MyAirlinesScreen(),
            const MsfsProfileScreen(),
            MsfsSettingsScreen(
                edition: widget.edition, userLabel: _user),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: V.surface2,
          border: Border(top: BorderSide(color: V.borderNeon, width: 1)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Nb(Icons.home_rounded, 'Inicio', 0),
                _Nb(Icons.public_rounded, 'Mapa', 1),
                _Nb(Icons.groups_rounded, 'Aerolíneas', 2),
                _Nb(Icons.badge_rounded, 'Perfil', 3),
                _Nb(Icons.settings_rounded, 'Ajustes', 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _Nb(IconData ic, String label, int i) {
    final sel = _tab == i;
    return GestureDetector(
      onTap: () => setState(() => _tab = i),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: sel ? V.neon.withOpacity(0.14) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(ic, color: sel ? V.neon : V.muted, size: 22),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    color: sel ? V.neon : V.muted,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _buildHome(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Panel ${widget.edition == '2024' ? '2024' : '2020'}',
            style: const TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: V.green.withOpacity(0.14),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: V.green.withOpacity(0.6)),
            ),
            child: const Row(children: [
              Icon(Icons.circle, color: V.green, size: 9),
              SizedBox(width: 6),
              Text('Conectado',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
            ]),
          ),
        ],
      ),
      body: !_ready
          ? const Center(child: CircularProgressIndicator(color: V.neon))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                GradientCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 62,
                            width: 62,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                  colors: [V.neonLight, V.neon]),
                              border: Border.all(color: V.neon, width: 2),
                            ),
                            child: Center(
                              child: Text(_avatar,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900)),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_user,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16)),
                                Row(children: [
                                  const Icon(Icons.verified_rounded,
                                      color: V.neon, size: 14),
                                  const SizedBox(width: 4),
                                  const Text('Piloto verificado',
                                      style: TextStyle(
                                          color: V.muted, fontSize: 11)),
                                ]),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Nivel 12',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13)),
                              Text('SIN SINCRONIZAR',
                                  style: TextStyle(
                                      color: V.gold, fontSize: 9,
                                      fontWeight: FontWeight.w800, letterSpacing: .5)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(child: _Stat('Horas de vuelo', _hours, V.neon)),
                          const SizedBox(width: 10),
                          Expanded(
                              child: _Stat('Vuelos', '248', V.goldLight)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(children: [
                        Text('XP',
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w700)),
                        SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                                value: 0.496,
                                minHeight: 6,
                                backgroundColor: V.surface,
                                valueColor:
                                    AlwaysStoppedAnimation(V.neon)),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('2,480 / 5,000',
                            style: TextStyle(color: V.muted, fontSize: 10)),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text('TU AEROLÍNEA',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                        color: V.muted)),
                const SizedBox(height: 8),
                GradientCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Icon(Icons.business_rounded,
                          color: V.goldLight, size: 26),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('SkyLink Virtual',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14)),
                            Text('Comandante • Ruta KLAX ➔ KJFK',
                                style: TextStyle(
                                    color: V.muted, fontSize: 11)),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: V.goldLight),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text('ACCESOS RÁPIDOS',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                        color: V.muted)),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                    child: _Qa(Icons.directions_rounded, 'Plan de vuelo',
                        () => _go(const FlightPlanScreen())),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _Qa(Icons.airplanemode_active_rounded, 'Mi flota',
                        () => _go(const MsfsFleetScreen())),
                  ),
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                    child: _Qa(Icons.groups_rounded, 'Mi equipo',
                        () => _go(const MsfsTeamScreen())),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _Qa(Icons.leaderboard_rounded, 'Ranking',
                        () => _go(const MsfsRankingScreen())),
                  ),
                ]),
                const SizedBox(height: 16),
                GradientCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      const Icon(Icons.flight_rounded, color: V.neon),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Próximo vuelo',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800)),
                            Text('SKY728 • KLAX ➔ KJFK • On Time',
                                style: TextStyle(
                                    color: V.muted, fontSize: 11)),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded,
                          color: V.muted),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
    );
  }

}

class _Stat extends StatelessWidget {
  final String l, v;
  final Color c;
  const _Stat(this.l, this.v, this.c);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: V.surface2,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: V.borderNeon),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(v,
              style: TextStyle(
                  color: c, fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 2),
          Text(l, style: const TextStyle(color: V.muted, fontSize: 10.5)),
        ],
      ),
    );
  }
}

class _Qa extends StatelessWidget {
  final IconData ic;
  final String t;
  final VoidCallback onTap;
  const _Qa(this.ic, this.t, this.onTap);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: V.surface2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: V.borderNeon),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(ic, color: V.neon, size: 24),
            const SizedBox(height: 8),
            Text(t,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 12.5)),
            const SizedBox(height: 2),
            const Text('Ver más', style: TextStyle(color: V.muted, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
