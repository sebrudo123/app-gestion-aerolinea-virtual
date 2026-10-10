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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [V.bg2, V.bg],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 130),
          children: [
            const Text('PERFIL Y CONFIGURACIÓN',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1)),
            const SizedBox(height: 4),
            const Text('Información del piloto y ajustes',
                style: TextStyle(color: V.muted, fontSize: 13)),
            const SizedBox(height: 22),
            const _ProfileCard(),
            const SizedBox(height: 24),
            _Action(
              icon: Icons.edit_rounded,
              title: 'Editar Perfil',
              subtitle: 'Nombre, callsign y contraseña',
              onTap: () => _snack(context, 'Edición de perfil simulada'),
            ),
            const SizedBox(height: 12),
            _Action(
              icon: Icons.settings_rounded,
              title: 'Configuración de la App',
              subtitle: 'Sonidos, reportes de error y marcos de avatar',
              onTap: () => _snack(context, 'Configuración guardada'),
            ),
            const SizedBox(height: 12),
            _Action(
              icon: Icons.admin_panel_settings_rounded,
              title: 'Panel de Administración',
              subtitle: 'Aprobar PIREPs, rangos y control de flota',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AdminPanelScreen()),
              ),
            ),
            const SizedBox(height: 26),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: V.danger.withOpacity(0.6)),
                  gradient: LinearGradient(
                    colors: [V.danger.withOpacity(0.16), V.danger.withOpacity(0.04)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.logout_rounded, color: V.danger, size: 20),
                    SizedBox(width: 10),
                    Text('CERRAR SESIÓN',
                        style: TextStyle(
                            color: V.danger,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _snack(BuildContext context, String m) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(m)));
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();
  @override
  Widget build(BuildContext context) {
    return GradientCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          Container(
            height: 92,
            width: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [V.goldLight, V.gold, V.bronze]),
              border: Border.all(color: V.goldLight, width: 3),
              boxShadow: [
                BoxShadow(color: V.gold.withOpacity(0.35), blurRadius: 22),
              ],
            ),
            child: const Center(
              child: Text('S',
                  style: TextStyle(color: V.bg, fontSize: 38, fontWeight: FontWeight.w900)),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Sebrudos Nine',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text('seb****09@gmail.com',
              style: TextStyle(color: V.muted, fontSize: 13)),
          const SizedBox(height: 14),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Pill(label: 'PILOTO'),
            SizedBox(width: 8),
            Pill(label: 'VTG030'),
          ]),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: V.bg.withOpacity(0.35),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: V.borderGold),
            ),
            child: Row(
              children: const [
                Icon(Icons.airlines_rounded, color: V.gold, size: 20),
                SizedBox(width: 12),
                Expanded(
                    child: Text('Vertex Airlines',
                        style: TextStyle(fontWeight: FontWeight.w700))),
                Text('363 pts', style: TextStyle(color: V.goldLight, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  const _Action({required this.icon, required this.title, required this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GradientCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        radius: 18,
        child: Row(
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: V.gold.withOpacity(0.14),
                border: Border.all(color: V.borderGold),
              ),
              child: Icon(icon, color: V.goldLight, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(subtitle, style: const TextStyle(color: V.muted, fontSize: 12)),
              ]),
            ),
            const Icon(Icons.chevron_right_rounded, color: V.gold),
          ],
        ),
      ),
    );
  }
}
