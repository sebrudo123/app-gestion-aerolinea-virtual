import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';
import '../../models/pirep.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final List<Pirep> _p = [
    Pirep(id: 'VA-001', route: 'SKBO → SKRG', pilot: 'sebrudo09', hours: 0.80, status: 'Pendiente', ac: 'Airbus A320'),
    Pirep(id: 'VA-002', route: 'KAVX → KNUC', pilot: 'captain.va', hours: 0.37, status: 'Pendiente', ac: 'Airbus A320'),
  ];
  String _fs = 'Operativo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff / Administración', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GradientCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('APROBACIÓN DE PIREPs', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
                  const SizedBox(height: 14),
                  ...List.generate(_p.length, (i) {
                    final x = _p[i];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: V.surface2, borderRadius: BorderRadius.circular(12), border: Border.all(color: V.borderGold)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [Text(x.id, style: const TextStyle(fontWeight: FontWeight.w700)), const Spacer(), _S(x.status)]),
                          const SizedBox(height: 4),
                          Text('${x.route} • ${x.hours.toStringAsFixed(2)} h • ${x.pilot} • ${x.ac}', style: const TextStyle(color: V.muted, fontSize: 11)),
                          if (x.status == 'Pendiente') ...[
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => setState(() => _p[i].status = 'Aprobado'),
                              child: Container(padding: const EdgeInsets.symmetric(vertical: 8), decoration: BoxDecoration(gradient: const LinearGradient(colors: [V.goldLight, V.gold]), borderRadius: BorderRadius.circular(10)), child: const Center(child: Text('APROBAR', style: TextStyle(color: V.bg, fontWeight: FontWeight.w800, fontSize: 11)))),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 14),
            GradientCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text('MÉTRICAS DE AEROLÍNEA', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)), SizedBox(height: 8), Text('Vuelos activos: 0 • Pilotos activos: 1 • Horas totales: 6.17 h', style: TextStyle(color: V.muted))])),
            const SizedBox(height: 14),
            GradientCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CONTROL DE FLOTA', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  Row(children: [const Expanded(child: Text('Estado operativo general')), DropdownButton<String>(dropdownColor: V.surface2, value: _fs, items: ['Operativo', 'En mantenimiento parcial', 'Restringido'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => _fs = v ?? _fs))]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _S extends StatelessWidget {
  final String s;
  const _S(this.s);
  @override
  Widget build(BuildContext context) {
    final ok = s == 'Aprobado';
    return Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: (ok ? V.green : V.gold).withOpacity(0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: (ok ? V.green : V.gold).withOpacity(0.6))), child: Text(s, style: TextStyle(color: ok ? V.green : V.gold, fontSize: 9, fontWeight: FontWeight.w700)));
  }
}
