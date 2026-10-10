import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ForceUpdateDialog extends StatelessWidget {
  final String version;
  final List<String> notes;
  final VoidCallback onInstall;
  final VoidCallback onSave;
  final ValueNotifier<double> progress;
  final ValueNotifier<String> status;
  final ValueNotifier<bool> busy;
  final ValueNotifier<String> result;

  const ForceUpdateDialog({
    super.key,
    required this.version,
    required this.notes,
    required this.onInstall,
    required this.onSave,
    required this.progress,
    required this.status,
    required this.busy,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [V.surface, V.surface2]),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: V.borderNeon),
        ),
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 76,
                width: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [V.neonLight, V.neon]),
                  boxShadow: [
                    BoxShadow(color: V.neon.withOpacity(0.35), blurRadius: 28),
                  ],
                ),
                child: const Icon(Icons.system_update_rounded,
                    color: V.bg, size: 38),
              ),
              const SizedBox(height: 18),
              const Text('ACTUALIZACIÓN DISPONIBLE',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.6)),
              const SizedBox(height: 6),
              Text('Vertex Airlines v$version',
                  style: const TextStyle(
                      color: V.neon,
                      fontWeight: FontWeight.w800,
                      fontSize: 15)),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: V.bg.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: V.borderNeon),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: notes
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text('• $e',
                                style: const TextStyle(
                                    color: V.muted, fontSize: 11.5)),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 18),
              ValueListenableBuilder<bool>(
                valueListenable: busy,
                builder: (_, isBusy, __) {
                  if (isBusy) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ValueListenableBuilder<double>(
                            valueListenable: progress,
                            builder: (_, value, __) => LinearProgressIndicator(
                              value: value.clamp(0.0, 1.0),
                              minHeight: 10,
                              backgroundColor: V.bg,
                              valueColor:
                                  const AlwaysStoppedAnimation(V.neon),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ValueListenableBuilder<String>(
                          valueListenable: status,
                          builder: (_, s, __) => Text(
                            s,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: V.neon,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    );
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ValueListenableBuilder<String>(
                        valueListenable: result,
                        builder: (_, r, __) {
                          if (r.isEmpty) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              r,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: V.green, fontSize: 11.5),
                            ),
                          );
                        },
                      ),
                      _Button(
                        icon: Icons.download_done_rounded,
                        label: 'INSTALAR AHORA',
                        primary: true,
                        onTap: onInstall,
                      ),
                      const SizedBox(height: 10),
                      _Button(
                        icon: Icons.download_rounded,
                        label: 'GUARDAR EN DESCARGAS',
                        primary: false,
                        onTap: onSave,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              const Text(
                'Al instalar se abrirá el instalador de Android para que confirmes la actualización.',
                textAlign: TextAlign.center,
                style: TextStyle(color: V.muted, fontSize: 10.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool primary;
  final VoidCallback onTap;
  const _Button({
    required this.icon,
    required this.label,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient:
              primary ? const LinearGradient(colors: [V.neonLight, V.neon]) : null,
          color: primary ? null : V.surface2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primary ? V.neon : V.borderNeon),
          boxShadow: primary
              ? [
                  BoxShadow(
                      color: V.neon.withOpacity(0.3),
                      blurRadius: 18,
                      offset: const Offset(0, 8)),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: primary ? V.bg : V.neon, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: primary ? V.bg : V.text,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
