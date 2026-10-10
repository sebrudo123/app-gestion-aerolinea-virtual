import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';
import '../msfs/msfs_hub_screen.dart';
import '../rfs/rfs_hub_screen.dart';

class SyncSimScreen extends StatefulWidget {
  const SyncSimScreen({super.key});

  @override
  State<SyncSimScreen> createState() => _SyncSimScreenState();
}

class _SyncSimScreenState extends State<SyncSimScreen> {
  int _s = 0;
  final _tabs = ['MSFS 2024', 'MSFS 2020', 'RFS'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sincronización de vuelo', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: const [
          Row(children: [Icon(Icons.circle, color: V.green, size: 10), SizedBox(width: 6), Text('Conectado', style: TextStyle(fontSize: 11)), SizedBox(width: 14)]),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: List.generate(_tabs.length, (i) {
                final sel = i == _s;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _s = i),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: sel ? const LinearGradient(colors: [V.neonLight, V.neon]) : null,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: V.borderNeon),
                      ),
                      child: Center(child: Text(_tabs[i], style: TextStyle(color: sel ? V.bg : V.muted, fontWeight: FontWeight.w700, fontSize: 12))),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            GradientCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [Icon(Icons.flight, color: V.neon), SizedBox(width: 8), Text('Microsoft Flight Simulator 2024', style: TextStyle(fontWeight: FontWeight.w800))]),
                  const SizedBox(height: 10),
                  const Text('Sim está activo', style: TextStyle(color: V.green, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  ...const [
                    _Chk('Vuelo detectado'),
                    _Chk('Posición sincronizada'),
                    _Chk('Datos de vuelo en tiempo real'),
                    _Chk('Multijugador / ATC'),
                  ],
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [V.neonLight, V.neon]), borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: V.neon.withOpacity(0.2), blurRadius: 16, offset: Offset(0, 8))]),
                    child: const Center(child: Text('Ver en el simulador', style: TextStyle(color: V.bg, fontWeight: FontWeight.w900))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GradientCard(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SINCRONIZADO DESDE DB', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
                  SizedBox(height: 10),
                  Text('Matrícula: N123SK • Aeronave: Boeing 737-800 • Destino: KLAX', style: TextStyle(color: V.muted, fontSize: 12)),
                  SizedBox(height: 6),
                  Text('Altitud: 35,000 ft • Velocidad: 482 kts', style: TextStyle(color: V.muted, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MsfsHubScreen())),
              child: _Hub('MSFS / SkyConnect', 'Welcome • Cuentas • Perfil • Plan • Aerolíneas • Vuelo', Icons.cloud_rounded, V.neon),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RfsHubScreen())),
              child: _Hub('RFS Airline Manager', 'Login • Dashboard • FPL • Flota • Perfil • Config', Icons.flight_rounded, V.goldLight),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hub extends StatelessWidget {
  final String t, sub;
  final IconData ic;
  final Color c;
  const _Hub(this.t, this.sub, this.ic, this.c);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: V.surface2, borderRadius: BorderRadius.circular(16), border: Border.all(color: V.borderNeon)),
      child: Row(children: [
        Icon(ic, color: c, size: 22),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(fontWeight: FontWeight.w800)), Text(sub, style: TextStyle(color: V.muted, fontSize: 10))])),
        const Icon(Icons.chevron_right_rounded, color: V.neon),
      ]),
    );
  }
}

class _Chk extends StatelessWidget {
  final String t;
  const _Chk(this.t);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [const Icon(Icons.check_circle, color: V.green, size: 16), const SizedBox(width: 6), Text(t, style: const TextStyle(color: V.text, fontSize: 11))]),
    );
  }
}
