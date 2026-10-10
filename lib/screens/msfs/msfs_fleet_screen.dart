import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class MsfsFleetScreen extends StatelessWidget {
  const MsfsFleetScreen({super.key});

  static const _fleet = [
    {'model': 'Boeing 737-800', 'reg': 'N737SK', 'state': 'Activo', 'hours': '1,240 h', 'range': '2,935 nm'},
    {'model': 'Airbus A320neo', 'reg': 'N320VA', 'state': 'Activo', 'hours': '860 h', 'range': '3,400 nm'},
    {'model': 'Boeing 787-9', 'reg': 'N789DR', 'state': 'Mantenimiento', 'hours': '410 h', 'range': '7,635 nm'},
    {'model': 'Cessna 172 Skyhawk', 'reg': 'N172CT', 'state': 'Activo', 'hours': '96 h', 'range': '640 nm'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi flota',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [V.bg2, V.bg]),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('AERONAVES REGISTRADAS',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    color: V.muted)),
            const SizedBox(height: 10),
            for (final f in _fleet) ...[
              GradientCard(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Container(
                      height: 46,
                      width: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: V.neon.withOpacity(0.14),
                        border: Border.all(color: V.borderNeon),
                      ),
                      child: const Icon(Icons.airplanemode_active_rounded,
                          color: V.neon, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${f['model']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13.5)),
                          const SizedBox(height: 2),
                          Text(
                              '${f['reg']} • ${f['range']}  •  ${f['hours']}',
                              style: const TextStyle(
                                  color: V.muted, fontSize: 11)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (f['state'] == 'Activo' ? V.green : V.gold)
                            .withOpacity(0.16),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: (f['state'] == 'Activo'
                                    ? V.green
                                    : V.gold)
                                .withOpacity(0.6)),
                      ),
                      child: Text('${f['state']}',
                          style: TextStyle(
                              color: f['state'] == 'Activo'
                                  ? V.green
                                  : V.gold,
                              fontSize: 10,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
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