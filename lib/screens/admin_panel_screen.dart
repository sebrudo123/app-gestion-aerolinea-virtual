import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_card.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final List<_Pirep> _pireps = [
    _Pirep(id: 'VA-001', route: 'SKBO → SKRG', pilot: 'sebrudo09', hours: 0.80, status: 'Pendiente'),
    _Pirep(id: 'VA-002', route: 'KAVX → KNUC', pilot: 'captain.va', hours: 0.37, status: 'Pendiente'),
  ];

  String _fleetStatus = 'Operativo';

  void _approve(int i) {
    setState(() => _pireps[i].status = 'Aprobado');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('PIREPs ${_pireps[i].id} aprobado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [V.bg2, V.bg],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GradientCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('APROBACIÓN DE PIREPs',
                      style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
                  const SizedBox(height: 16),
                  ...List.generate(_pireps.length, (i) {
                    final p = _pireps[i];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: V.surface2,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: V.borderGold),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text(p.id, style: const TextStyle(fontWeight: FontWeight.w700)),
                            const Spacer(),
                            _Status(p.status),
                          ]),
                          const SizedBox(height: 6),
                          Text('${p.route} • ${p.hours.toStringAsFixed(2)} h • ${p.pilot}',
                              style: const TextStyle(color: V.muted, fontSize: 12)),
                          if (p.status == 'Pendiente') ...[
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => _approve(i),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [V.goldLight, V.gold]),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Text('APROBAR REPORTE',
                                      style: TextStyle(color: V.bg, fontWeight: FontWeight.w800, fontSize: 12)),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GradientCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('REVISIÓN DE HORAS TOTALES',
                      style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
                  const SizedBox(height: 10),
                  const Text('Horas registradas en aerolínea virtual: 6.17 h',
                      style: TextStyle(color: V.muted)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GradientCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CONTROL DE FLOTA',
                      style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1)),
                  const SizedBox(height: 16),
                  Row(children: [
                    const Expanded(child: Text('Estado operativo general')),
                    DropdownButton<String>(
                      dropdownColor: V.surface2,
                      value: _fleetStatus,
                      items: ['Operativo', 'En mantenimiento parcial', 'Restringido']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => setState(() => _fleetStatus = v ?? _fleetStatus),
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pirep {
  final String id, route, pilot;
  final double hours;
  String status;
  _Pirep({required this.id, required this.route, required this.pilot, required this.hours, required this.status});
}

class _Status extends StatelessWidget {
  final String s;
  const _Status(this.s);
  @override
  Widget build(BuildContext context) {
    final ok = s == 'Aprobado';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (ok ? V.green : V.gold).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: (ok ? V.green : V.gold).withOpacity(0.6)),
      ),
      child: Text(s,
          style: TextStyle(
              color: ok ? V.green : V.gold,
              fontSize: 10,
              fontWeight: FontWeight.w700)),
    );
  }
}
