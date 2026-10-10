import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class ProfileExtendedScreen extends StatelessWidget {
  const ProfileExtendedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil del Piloto', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
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
                      gradient: const LinearGradient(colors: [V.neonLight, V.neon]),
                      border: Border.all(color: V.neon, width: 3),
                      boxShadow: [BoxShadow(color: V.neon.withOpacity(0.25), blurRadius: 24)],
                    ),
                    child: const Center(child: Text('S', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900))),
                  ),
                  const SizedBox(height: 12),
                  const Text('Sebrudo12', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  const Text('Piloto • CEO', style: TextStyle(color: V.muted, fontSize: 12)),
                  const SizedBox(height: 10),
                  Row(children: [
                    const Text('Nivel 12', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: const LinearProgressIndicator(value: 0.496, minHeight: 6, backgroundColor: V.surface2, valueColor: AlwaysStoppedAnimation(V.neon)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('2,480 / 5,000 XP', style: TextStyle(color: V.muted, fontSize: 10)),
                  ]),
                  const SizedBox(height: 14),
                  const _Row('Nombre de usuario', 'Sebrudo12'),
                  const Divider(color: V.borderNeon),
                  const _Row('Correo', 'sebrudo12@gmail.com'),
                  const Divider(color: V.borderNeon),
                  const _Row('Plataforma', 'Xbox'),
                  const Divider(color: V.borderNeon),
                  const _Row('Horas de vuelo', '248h 32m'),
                  const Divider(color: V.borderNeon),
                  const _Row('Licencia', 'Comercial (ATPL)'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GradientCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: const [
                  _Opt(Icons.person, 'Cambiar avatar'),
                  _Opt(Icons.edit, 'Editar perfil'),
                  _Opt(Icons.history, 'Historial de vuelos'),
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
      child: Row(children: [Text(l, style: const TextStyle(color: V.muted, fontSize: 12)), const Spacer(), Text(v, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))]),
    );
  }
}

class _Opt extends StatelessWidget {
  final IconData i;
  final String t;
  const _Opt(this.i, this.t);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: V.surface2, borderRadius: BorderRadius.circular(12), border: Border.all(color: V.borderNeon)),
      child: Row(children: [Icon(i, color: V.neon), const SizedBox(width: 10), Expanded(child: Text(t, style: const TextStyle(fontWeight: FontWeight.w700))), const Icon(Icons.chevron_right_rounded, color: V.muted)]),
    );
  }
}
