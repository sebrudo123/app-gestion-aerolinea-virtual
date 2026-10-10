import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';
import '../../widgets/pill.dart';
import '../login_screen.dart';
import '../admin_panel_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 130),
          children: [
            const Text('PERFIL, TIENDA Y CONFIGURACIÓN', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 0.4)),
            const SizedBox(height: 18),
            const _P(),
            const SizedBox(height: 16),
            _A(icon: Icons.edit_rounded, title: 'Editar Perfil', subtitle: 'Nombre, correo, callsign y contraseña', onTap: () => _s(context, 'Editar Perfil (simulado)')),
            const SizedBox(height: 10),
            _A(icon: Icons.palette_rounded, title: 'Configuración Avanzada', subtitle: 'Marcos, fondos, sonidos, privacidad', onTap: () => _s(context, 'Configuración avanzada')),
            const SizedBox(height: 10),
            _A(icon: Icons.account_balance_wallet_rounded, title: 'Billetera Virtual (\$ VTX Coins)', subtitle: 'Saldo y tienda de libreas', onTap: () => _s(context, '\$ VTX Coins')),
            const SizedBox(height: 10),
            _A(icon: Icons.analytics_rounded, title: 'Caja Negra y Análisis de FPM', subtitle: 'Calificación de aterrizajes', onTap: () => _s(context, 'Caja Negra / FPM')),
            const SizedBox(height: 10),
            _A(icon: Icons.cloud_rounded, title: 'Centro METAR / Clima y Despacho', subtitle: 'Meteorología y combustible óptimo', onTap: () => _s(context, 'METAR / Despacho')),
            const SizedBox(height: 10),
            _A(icon: Icons.school_rounded, title: 'Academia de Pilotos', subtitle: 'Exámenes para ascensos de rango', onTap: () => _s(context, 'Academia de Pilotos')),
            const SizedBox(height: 10),
            _A(icon: Icons.notifications_active_rounded, title: 'Notificaciones Push', subtitle: 'Aprobaciones, amigos y eventos', onTap: () => _s(context, 'Notificaciones')),
            const SizedBox(height: 10),
            _A(icon: Icons.admin_panel_settings_rounded, title: 'Panel de Administración', subtitle: 'Aprobar PIREPs, flota y horas', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminPanelScreen()))),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen())),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: V.danger.withOpacity(0.6)), gradient: LinearGradient(colors: [V.danger.withOpacity(0.16), V.danger.withOpacity(0.04)])),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.logout_rounded, color: V.danger), SizedBox(width: 8), Text('CERRAR SESIÓN', style: TextStyle(color: V.danger, fontWeight: FontWeight.w800, letterSpacing: 0.8))]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _s(BuildContext c, String m) {
  ScaffoldMessenger.of(c)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(m)));
}

class _P extends StatelessWidget {
  const _P();
  @override
  Widget build(BuildContext context) {
    return GradientCard(
      child: Column(
        children: [
          Container(height: 82, width: 82, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [V.goldLight, V.gold, V.bronze]), border: Border.all(color: V.goldLight, width: 3)), child: const Center(child: Text('S', style: TextStyle(color: V.bg, fontSize: 34, fontWeight: FontWeight.w900)))),
          const SizedBox(height: 12),
          const Text('Sebrudos Nine', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('vertexairlanes@gmail.com', style: TextStyle(color: V.muted, fontSize: 12)),
          const SizedBox(height: 8),
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Pill(label: 'PILOTO'), SizedBox(width: 6), Pill(label: 'CADETE'), SizedBox(width: 6), Pill(label: 'VTG030')]),
        ],
      ),
    );
  }
}

class _A extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  const _A({required this.icon, required this.title, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GradientCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        radius: 16,
        child: Row(
          children: [
            Container(height: 40, width: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: V.gold.withOpacity(0.14), border: Border.all(color: V.borderGold)), child: Icon(icon, color: V.goldLight)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 2), Text(subtitle, style: const TextStyle(color: V.muted, fontSize: 11))])),
            const Icon(Icons.chevron_right_rounded, color: V.gold),
          ],
        ),
      ),
    );
  }
}
