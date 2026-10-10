import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';
import '../login_screen.dart';
import '../msfs/flight_plan_screen.dart';
import '../msfs/my_airlines_screen.dart';
import '../msfs/flight_details_screen.dart';
import '../rfs/rfs_settings_screen.dart';

class AeroflyHubScreen extends StatelessWidget {
  const AeroflyHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void go(Widget w) =>
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aerofly FS • Connect',
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
              child: Column(
                children: [
                  Container(
                    height: 74,
                    width: 74,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [V.green, Color(0xFF0FA36B)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: V.green.withOpacity(0.3),
                          blurRadius: 22,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.airplanemode_active_rounded,
                        color: V.bg, size: 34),
                  ),
                  const SizedBox(height: 12),
                  const Text('AEROFLY CONNECT',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.4)),
                  const SizedBox(height: 4),
                  const Text('Pilotos Aerofly migrados a Vertex Airlines',
                      style: TextStyle(color: V.muted, fontSize: 12)),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _m('48', 'Vuelos'),
                      _m('287', 'Horas'),
                      _m('1', 'Aerolínea'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text('MÓDULOS AEROFLY',
                style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1, color: V.muted)),
            const SizedBox(height: 10),
            _L(Icons.login_rounded, 'Iniciar sesión', 'Cuenta Vertex / migración', V.green, () => go(const LoginScreen())),
            _L(Icons.edit_note_rounded, 'Plan de Vuelo', 'Registrar salida y llegada', V.green, () => go(const FlightPlanScreen())),
            _L(Icons.groups_rounded, 'Mis Aerolíneas', 'SkyLink y aerolíneas globales', V.green, () => go(const MyAirlinesScreen())),
            _L(Icons.monitor_heart_rounded, 'Detalles del Vuelo', 'Monitor en vivo en ruta', V.green, () => go(const FlightDetailsScreen())),
            _L(Icons.settings_rounded, 'Configuración', 'Cuenta, idioma y unidades', V.green, () => go(const RfsSettingsScreen())),
          ],
        ),
      ),
    );
  }
}

class _m extends StatelessWidget {
  final String v, l;
  const _m(this.v, this.l);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(v,
          style: const TextStyle(
              fontWeight: FontWeight.w900, fontSize: 19, color: V.green)),
      Text(l, style: const TextStyle(color: V.muted, fontSize: 11)),
    ]);
  }
}

class _L extends StatelessWidget {
  final IconData ic;
  final String t, sub;
  final Color c;
  final VoidCallback onTap;
  const _L(this.ic, this.t, this.sub, this.c, this.onTap);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GradientCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        radius: 16,
        child: Row(children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.withOpacity(0.14),
              border: Border.all(color: c.withOpacity(0.6)),
            ),
            child: Icon(ic, color: c, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(sub, style: const TextStyle(color: V.muted, fontSize: 10)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: c),
        ]),
      ),
    );
  }
}