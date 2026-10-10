import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';
import '../../services/app_db.dart';
import '../msfs/flight_details_screen.dart';

class FlightHistoryScreen extends StatefulWidget {
  const FlightHistoryScreen({super.key});

  @override
  State<FlightHistoryScreen> createState() => _FlightHistoryScreenState();
}

class _FlightHistoryScreenState extends State<FlightHistoryScreen> {
  bool _loading = true;
  List<_H> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final remote = await AppDb.flights();
    final list = <_H>[
      for (final r in remote)
        _H(
          id: '${r['flight_number'] ?? r['id']}',
          route:
              '${r['origin'] ?? '--'} ➔ ${r['destination'] ?? '--'}',
          aircraft: '${r['aircraft'] ?? '—'}',
          date: '${r['departure_time'] ?? ''}',
          hours: '${r['duration'] ?? '—'}',
          ok: '${r['status'] ?? 'completado'}' != 'cancelado',
        ),
    ];
    if (!mounted) return;
    setState(() {
      _items = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de vuelos',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [V.bg2, V.bg]),
        ),
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: V.neon))
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  GradientCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Expanded(
                          child: _Mini('Vuelos', '${_items.length}'),
                        ),
                        Expanded(
                          child: _Mini('Completados',
                              '${_items.where((e) => e.ok).length}'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_items.isEmpty)
                    GradientCard(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        children: const [
                          Icon(Icons.flight_outlined,
                              color: V.muted, size: 40),
                          SizedBox(height: 12),
                          Text('Sin vuelos registrados',
                              style:
                                  TextStyle(fontWeight: FontWeight.w800)),
                          SizedBox(height: 4),
                          Text(
                            'Cuando registres un vuelo aparecerá aquí.',
                            style: TextStyle(color: V.muted, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  for (final h in _items) ...[
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const FlightDetailsScreen()),
                      ),
                      child: GradientCard(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Container(
                              height: 42,
                              width: 42,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (h.ok ? V.green : V.danger)
                                    .withOpacity(0.14),
                                border: Border.all(
                                    color: (h.ok ? V.green : V.danger)
                                        .withOpacity(0.5)),
                              ),
                              child: Icon(
                                  h.ok
                                      ? Icons.flight_takeoff_rounded
                                      : Icons.close_rounded,
                                  color: h.ok ? V.green : V.danger,
                                  size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${h.id} • ${h.route}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 13)),
                                  const SizedBox(height: 2),
                                  Text(
                                      '${h.aircraft} • ${h.date}',
                                      style: const TextStyle(
                                          color: V.muted, fontSize: 11)),
                                ],
                              ),
                            ),
                            Text(h.hours,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
      ),
    );
  }
}

class _H {
  final String id, route, aircraft, date, hours;
  final bool ok;
  const _H(
      {required this.id,
      required this.route,
      required this.aircraft,
      required this.date,
      required this.hours,
      required this.ok});
}

class _Mini extends StatelessWidget {
  final String l, v;
  const _Mini(this.l, this.v);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(v,
            style: const TextStyle(
                fontWeight: FontWeight.w900, fontSize: 18, color: V.neon)),
        Text(l, style: const TextStyle(color: V.muted, fontSize: 11)),
      ],
    );
  }
}