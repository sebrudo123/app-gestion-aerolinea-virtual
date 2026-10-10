import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';
import '../../widgets/pill.dart';
import '../login_screen.dart';
import '../admin_panel_screen.dart';
import '../profile_extended/edit_profile_screen.dart';
import '../profile_extended/change_avatar_screen.dart';
import '../profile_extended/flight_history_screen.dart';
import '../../services/session_service.dart';
import '../../services/app_db.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String _name = 'Piloto';
  String _avatar = 'S';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final name = await SessionService.name();
    final avatar = await SessionService.avatar();
    final email = await SessionService.savedEmail() ?? '';
    if (!mounted) return;
    setState(() {
      _name = name;
      _avatar = avatar;
      _email = email;
    });
  }

  Future<void> _open(Widget w) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => w));
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [V.bg2, V.bg])),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 130),
          children: [
            const Text('PERFIL, TIENDA Y CONFIGURACIÓN',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.4)),
            const SizedBox(height: 18),
            _P(name: _name, avatar: _avatar, email: _email),
            const SizedBox(height: 16),
            _A(
                icon: Icons.edit_rounded,
                title: 'Editar Perfil',
                subtitle: 'Nombre, correo, plataforma y licencia',
                onTap: () => _open(const EditProfileScreen())),
            const SizedBox(height: 10),
            _A(
                icon: Icons.palette_rounded,
                title: 'Cambiar Avatar',
                subtitle: 'Elige la insignia de tu piloto',
                onTap: () => _open(const ChangeAvatarScreen())),
            const SizedBox(height: 10),
            _A(
                icon: Icons.history_rounded,
                title: 'Historial de Vuelos',
                subtitle: 'Tus vuelos registrados y horas',
                onTap: () => _open(const FlightHistoryScreen())),
            const SizedBox(height: 10),
            _A(
                icon: Icons.admin_panel_settings_rounded,
                title: 'Panel de Administración',
                subtitle: 'Aprobar PIREPs, flota y horas',
                onTap: () => _open(const AdminPanelScreen())),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: () async {
                await AppDb.signOut();
                await SessionService.logout();
                if (!context.mounted) return;
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => const LoginScreen()));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: V.danger.withOpacity(0.6)),
                    gradient: LinearGradient(colors: [
                      V.danger.withOpacity(0.16),
                      V.danger.withOpacity(0.04)
                    ])),
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, color: V.danger),
                      SizedBox(width: 8),
                      Text('CERRAR SESIÓN',
                          style: TextStyle(
                              color: V.danger,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8))
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _P extends StatelessWidget {
  final String name, avatar, email;
  const _P({required this.name, required this.avatar, required this.email});
  @override
  Widget build(BuildContext context) {
    return GradientCard(
      child: Column(
        children: [
          Container(
              height: 82,
              width: 82,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                      colors: [V.goldLight, V.gold, V.bronze]),
                  border: Border.all(color: V.goldLight, width: 3)),
              child: Center(
                  child: Text(avatar,
                      style: const TextStyle(
                          color: V.bg,
                          fontSize: 34,
                          fontWeight: FontWeight.w900)))),
          const SizedBox(height: 12),
          Text(name,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(email.isEmpty ? 'Sin correo' : email,
              style: const TextStyle(color: V.muted, fontSize: 12)),
          const SizedBox(height: 8),
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Pill(label: 'PILOTO'),
            SizedBox(width: 6),
            Pill(label: 'VTG030')
          ]),
        ],
      ),
    );
  }
}

class _A extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  const _A(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GradientCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        radius: 16,
        child: Row(
          children: [
            Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: V.gold.withOpacity(0.14),
                    border: Border.all(color: V.borderGold)),
                child: Icon(icon, color: V.goldLight)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(color: V.muted, fontSize: 11))
                ])),
            const Icon(Icons.chevron_right_rounded, color: V.gold),
          ],
        ),
      ),
    );
  }
}
