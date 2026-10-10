import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';
import 'connect_account_screen.dart';
import 'msfs_profile_screen.dart';
import 'flight_plan_screen.dart';
import 'my_airlines_screen.dart';
import 'flight_details_screen.dart';

class MsfsHubScreen extends StatelessWidget {
  const MsfsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void go(Widget w) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));
    return Scaffold(
      appBar: AppBar(title: const Text('MSFS • SkyConnect', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('FLUJO SKYCONNECT', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1, color: V.muted)),
            const SizedBox(height: 10),
            _L(Icons.login_rounded, 'Welcome / Landing', 'Iniciar sesión con Xbox o Steam', () {}),
            _L(Icons.link_rounded, 'Conectar Cuenta', 'Vincular Xbox y Steam (ID único en DB)', () => go(const ConnectAccountScreen())),
            _L(Icons.badge_rounded, 'Mi Perfil (SkyPilot12)', 'Piloto Verificado • 248 vuelos', () => go(const MsfsProfileScreen())),
            _L(Icons.edit_note_rounded, 'Plan de Vuelo', 'KLAX ➔ KJFK • 24 jun 2025 • 14:30 UTC', () => go(const FlightPlanScreen())),
            _L(Icons.groups_rounded, 'Mis Aerolíneas', 'SkyLink Virtual y aerolíneas globales', () => go(const MyAirlinesScreen())),
            _L(Icons.monitor_heart_rounded, 'Detalles del Vuelo', 'Monitor en vivo KLAX ➔ KJFK', () => go(const FlightDetailsScreen())),
          ],
        ),
      ),
    );
  }
}

class _L extends StatelessWidget {
  final IconData ic;
  final String t, sub;
  final VoidCallback onTap;
  const _L(this.ic, this.t, this.sub, this.onTap);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GradientCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        radius: 16,
        child: Row(children: [
          Container(height: 38, width: 38, decoration: BoxDecoration(shape: BoxShape.circle, color: V.neon.withOpacity(0.14), border: Border.all(color: V.borderNeon)), child: Icon(ic, color: V.neon, size: 19)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 2), Text(sub, style: const TextStyle(color: V.muted, fontSize: 10))])),
          const Icon(Icons.chevron_right_rounded, color: V.neon),
        ]),
      ),
    );
  }
}