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
          route: '${r['departure'] ?? r['origin'] ?? '--'} ➔ ${r['arrival'] ?? r['destination'] ?? '--'}',
          aircraft: '${r['aircraft'] ?? '—'}',
          date: '${r['departure_time'] ?? r['created_at'] ?? ''}',
          hours: '${r['duration'] ?? r['hours'] ?? '—'}',
          ok: true,
        ),
    ];
    if (list.isEmpty) {
      list.addAll(const [
        _H(id: 'SKY728', route: 'KJFK ➔ KLAX', aircraft: 'Boeing 737-800', date: '24 jun 2025', hours: '5h 12m', ok: true),
        _H(id: 'SV102', route: 'SCL ➔ MIA', aircraft: 'Airbus A320neo', date: '22 jun 2025', hours: '7h 48m', ok: true),
        _H(id: 'SV203', route: 'MIA ➔ BOG', aircraft: 'Boeing 787-9', date: '20 jun 2025', hours: '3h 26m', ok: true),
        _H(id: 'SV117', route: 'MAD ➔ EZE', aircraft: 'Boeing 787-9', date: '17 jun 2025', hours: '12h 05m', ok: true),
        _H(id: 'SV088', route: 'LIM ➔ SCL', aircraft: 'Airbus A320neo', date: '15 jun 2025', hours: '3h 40m', ok: false),
      ]);
    }
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