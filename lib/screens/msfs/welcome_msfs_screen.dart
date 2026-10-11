import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';
import 'connect_account_screen.dart';

class MsfsWelcomeScreen extends StatefulWidget {
  final String edition;
  const MsfsWelcomeScreen({required this.edition, super.key});

  @override
  State<MsfsWelcomeScreen> createState() => _MsfsWelcomeScreenState();
}

class _MsfsWelcomeScreenState extends State<MsfsWelcomeScreen> {
  bool _accept = false;

  String get _title => widget.edition == '2024'
      ? 'Microsoft Flight Simulator 2024'
      : 'Microsoft Flight Simulator 2020';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [V.bg2, V.bg],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient:
                          const LinearGradient(colors: [V.neonLight, V.neon]),
                      boxShadow: [
                        BoxShadow(
                            color: V.neon.withOpacity(0.3), blurRadius: 20),
                      ],
                    ),
                    child: const Icon(Icons.cloud_rounded, color: V.bg, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Vuelo SkyConnect',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 15)),
                      Text('MSFS ${widget.edition}',
                          style: TextStyle(
                              color: V.neon, fontSize: 11, letterSpacing: 2)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text(
                'Bienvenido a la red de vuelo',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text('Conecta $_title con SkyConnect',
                  style: const TextStyle(color: V.muted, fontSize: 13)),
              const SizedBox(height: 20),
              GradientCard(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _Pntr(Icons.track_changes_rounded,
                        'Sincronización en vivo',
                        'Tu posición, velocidad y altitud se reportan en el Mapa en vivo de la red.'),
                    SizedBox(height: 14),
                    _Pntr(Icons.directions_rounded, 'Planes de vuelo',
                        'Sigue rutas, waypoints y jetways con planes de vuelo reales entre aeropuertos.'),
                    SizedBox(height: 14),
                    _Pntr(Icons.groups_rounded, 'Aerolíneas y flota',
                        'Pertenece a una aerolínea, opera tu propia flota y sube en el ranking de la red.'),
                    SizedBox(height: 14),
                    _Pntr(Icons.lock_clock_rounded,
                        'Horas de vuelo verificadas',
                        'Cada vuelo suma horas y XP a tu perfil de piloto de forma verificada.'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _accept = !_accept),
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: _accept ? V.neon : V.surface2,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: V.neon),
                      ),
                      child: _accept
                          ? const Icon(Icons.check_rounded,
                              color: V.bg, size: 18)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'He leído y acepto el funcionamiento de SkyConnect, y entiendo que mi vuelo será registrado en la base de datos de SkyConnect.',
                      style: TextStyle(color: V.muted, fontSize: 11.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _accept
                    ? () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => ConnectAccountScreen(
                                edition: widget.edition),
                          ),
                        )
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: _accept
                        ? const LinearGradient(
                            colors: [V.neonLight, V.neon])
                        : null,
                    color: _accept ? null : V.surface2,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: _accept ? V.neon : V.borderNeon),
                    boxShadow: _accept
                        ? [
                            BoxShadow(
                                color: V.neon.withOpacity(0.3),
                                blurRadius: 22,
                                offset: const Offset(0, 10))
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      'CONTINUAR',
                      style: TextStyle(
                        color: _accept ? V.bg : V.muted,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Center(
                child: Text(
                  'Al continuar vincularás tu cuenta de Xbox o Steam.',
                  style: TextStyle(color: V.muted, fontSize: 11),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pntr extends StatelessWidget {
  final IconData ic;
  final String t, d;
  const _Pntr(this.ic, this.t, this.d);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: V.neon.withOpacity(0.14),
            border: Border.all(color: V.neon.withOpacity(0.5)),
          ),
          child: Icon(ic, color: V.neon, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(d, style: const TextStyle(color: V.muted, fontSize: 11.5)),
            ],
          ),
        ),
      ],
    );
  }
}