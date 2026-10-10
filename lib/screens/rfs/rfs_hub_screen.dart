import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';
import 'rfs_login_screen.dart';
import 'rfs_dashboard.dart';
import 'rfs_fpl.dart';
import 'rfs_fleet_screen.dart';
import 'rfs_airline_profile_screen.dart';
import 'rfs_settings_screen.dart';

class RfsHubScreen extends StatelessWidget {
  const RfsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void go(Widget w) => Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));
    return Scaffold(
      appBar: AppBar(title: const Text('RFS Airline Manager', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('FLUJO RFS', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1, color: V.muted)),
            const SizedBox(height: 10),
            _L(Icons.login_rounded, 'Splash / Login RFS', 'Inicio de sesión oficial', () => go(const RfsLoginScreen())),
            _L(Icons.dashboard_rounded, 'Dashboard RFS', 'SkyPilot12 • CEO de SkyAir Virtual', () => go(const RfsDashboard())),
            _L(Icons.edit_note_rounded, 'Plan de Vuelo RFS', 'Activos • Historial • Borradores', () => go(const RfsFpl())),
            _L(Icons.airplanemode_active_rounded, 'Gestión de Flota', 'B738 • A320 • B744 • E190', () => go(const RfsFleetScreen())),
            _L(Icons.business_rounded, 'Perfil de Aerolínea', 'SkyAir Virtual • \$2,480,650', () => go(const RfsAirlineProfileScreen())),
            _L(Icons.settings_rounded, 'Configuración', 'Notificaciones • Idioma • Unidades', () => go(const RfsSettingsScreen())),
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
          Container(height: 38, width: 38, decoration: BoxDecoration(shape: BoxShape.circle, color: V.gold.withOpacity(0.14), border: Border.all(color: V.borderGold)), child: Icon(ic, color: V.goldLight, size: 19)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 2), Text(sub, style: const TextStyle(color: V.muted, fontSize: 10))])),
          const Icon(Icons.chevron_right_rounded, color: V.goldLight),
        ]),
      ),
    );
  }
}