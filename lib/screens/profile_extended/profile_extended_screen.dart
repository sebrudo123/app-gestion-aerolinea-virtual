import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';
import '../../services/session_service.dart';
import 'change_avatar_screen.dart';
import 'edit_profile_screen.dart';
import 'flight_history_screen.dart';

class ProfileExtendedScreen extends StatefulWidget {
  const ProfileExtendedScreen({super.key});

  @override
  State<ProfileExtendedScreen> createState() => _ProfileExtendedScreenState();
}

class _ProfileExtendedScreenState extends State<ProfileExtendedScreen> {
  String _name = 'Sebrudo12';
  String _avatar = 'S';
  String _email = 'sebrudo12@gmail.com';
  String _platform = 'Xbox';
  String _hours = '248h 32m';
  String _license = 'Comercial (ATPL)';
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final name = await SessionService.name();
    final avatar = await SessionService.avatar();
    final email = await SessionService.savedEmail() ?? '';
    final platform = await SessionService.platform();
    final hours = await SessionService.hours();
    final license = await SessionService.license();
    if (!mounted) return;
    setState(() {
      _name = name;
      _avatar = avatar;
      if (email.isNotEmpty) _email = email;
      _platform = platform;
      _hours = hours;
      _license = license;
      _ready = true;
    });
  }

  Future<void> _go(Widget w) async {
    final changed = await Navigator.of(context)
        .push<bool>(MaterialPageRoute(builder: (_) => w));
    if (changed == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil del Piloto',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [V.bg2, V.bg]),
        ),
        child: !_ready
            ? const Center(child: CircularProgressIndicator(color: V.neon))
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  GradientCard(
                    child: Column(
                      children: [
                        Container(
                          height: 88,
                          width: 88,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                                colors: [V.neonLight, V.neon]),
                            border: Border.all(color: V.neon, width: 3),
                            boxShadow: [
                              BoxShadow(
                                  color: V.neon.withOpacity(0.25),
                                  blurRadius: 24),
                            ],
                          ),
                          child: Center(
                            child: Text(_avatar,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(_name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 2),
                        const Text('Piloto • CEO',
                            style:
                                TextStyle(color: V.muted, fontSize: 12)),
                        const SizedBox(height: 10),
                        Row(children: [
                          const Text('Nivel 12',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w700)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: const LinearProgressIndicator(
                                  value: 0.496,
                                  minHeight: 6,
                                  backgroundColor: V.surface2,
                                  valueColor:
                                      AlwaysStoppedAnimation(V.neon)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('2,480 / 5,000 XP',
                              style: TextStyle(
                                  color: V.muted, fontSize: 10)),
                        ]),
                        const SizedBox(height: 14),
                        _Row('Nombre de usuario', _name),
                        const Divider(color: V.borderNeon),
                        _Row('Correo', _email),
                        const Divider(color: V.borderNeon),
                        _Row('Plataforma', _platform),
                        const Divider(color: V.borderNeon),
                        _Row('Horas de vuelo', _hours),
                        const Divider(color: V.borderNeon),
                        _Row('Licencia', _license),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GradientCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        _Opt(Icons.person, 'Cambiar avatar',
                            () => _go(const ChangeAvatarScreen())),
                        _Opt(Icons.edit, 'Editar perfil',
                            () => _go(const EditProfileScreen())),
                        _Opt(Icons.history, 'Historial de vuelos',
                            () => _go(const FlightHistoryScreen())),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String l, v;
  const _Row(this.l, this.v);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Text(l, style: const TextStyle(color: V.muted, fontSize: 12)),
        const Spacer(),
        Flexible(
          child: Text(v,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 12)),
        ),
      ]),
    );
  }
}

class _Opt extends StatelessWidget {
  final IconData i;
  final String t;
  final VoidCallback onTap;
  const _Opt(this.i, this.t, this.onTap);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: V.surface2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: V.borderNeon),
        ),
        child: Row(children: [
          Icon(i, color: V.neon),
          const SizedBox(width: 10),
          Expanded(
              child: Text(t,
                  style: const TextStyle(fontWeight: FontWeight.w700))),
          const Icon(Icons.chevron_right_rounded, color: V.muted),
        ]),
      ),
    );
  }
}