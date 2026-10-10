import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';
import '../login_screen.dart';
import '../../services/session_service.dart';

class RfsSettingsScreen extends StatelessWidget {
  const RfsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GradientCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: const [
                  _Set(Icons.notifications_active_rounded, 'Notificaciones', 'Activadas (DB)'),
                  Divider(color: V.borderNeon),
                  _Set(Icons.language_rounded, 'Idioma', 'Español'),
                  Divider(color: V.borderNeon),
                  _Set(Icons.straighten_rounded, 'Unidades', 'Métricas'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                await SessionService.logout();
                if (!context.mounted) return;
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: V.danger.withOpacity(0.6)), color: V.danger.withOpacity(0.12)),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.logout_rounded, color: V.danger), SizedBox(width: 8), Text('CERRAR SESIÓN', style: TextStyle(color: V.danger, fontWeight: FontWeight.w800))]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Set extends StatelessWidget {
  final IconData ic;
  final String t, sub;
  const _Set(this.ic, this.t, this.sub);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: Row(children: [
        Icon(ic, color: V.neon),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(fontWeight: FontWeight.w700)), Text(sub, style: const TextStyle(color: V.muted, fontSize: 11))])),
        const Icon(Icons.chevron_right_rounded, color: V.muted),
      ]),
    );
  }
}