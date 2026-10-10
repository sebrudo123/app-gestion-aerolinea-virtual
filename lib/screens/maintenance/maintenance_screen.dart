import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../main_shell.dart';
import '../../services/maintenance_service.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  Future<void> _retry(BuildContext context) async {
    final maint = await MaintenanceService.isEnabled();
    if (!context.mounted) return;
    if (!maint) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [V.bg2, V.bg],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 96,
                      width: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [V.goldLight, V.gold, V.bronze],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: V.gold.withOpacity(0.35),
                            blurRadius: 30,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.build_rounded,
                          color: V.bg, size: 44),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'VERTEX AIRLINES',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'MODO MANTENIMIENTO',
                      style: TextStyle(
                        color: V.neon,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Estamos realizando mejoras en nuestros sistemas.\n'
                      'Gracias por tu paciencia. Vuelve en unos minutos.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: V.muted, fontSize: 13),
                    ),
                    const SizedBox(height: 28),
                    GestureDetector(
                      onTap: () => _retry(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 34, vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [V.neonLight, V.neon],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: V.neon.withOpacity(0.3),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Text('REINTENTAR',
                            style: TextStyle(
                                color: V.bg,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2)),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text('Vertex Airlines • Soporte técnico',
                        style: TextStyle(color: V.muted, fontSize: 11)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}