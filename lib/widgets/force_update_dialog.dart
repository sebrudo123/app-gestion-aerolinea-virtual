import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ForceUpdateDialog extends StatelessWidget {
  final String version;
  final List<String> notes;
  final VoidCallback onDownload;
  final ValueNotifier<double>? progress;
  final ValueNotifier<String>? status;

  const ForceUpdateDialog({
    required this.version,
    required this.notes,
    required this.onDownload,
    this.progress,
    this.status,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: V.surface2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: V.borderNeon),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [V.neonLight, V.neon],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: V.neon.withOpacity(0.35),
                        blurRadius: 22,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.system_update_rounded,
                      color: V.bg, size: 34),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Actualización obligatoria',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'Nueva versión $version disponible',
                  style: const TextStyle(color: V.muted, fontSize: 12),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Novedades:',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 8),
                Container(
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
                ValueListenableBuilder<double>(
                  valueListenable: progress!,
                  builder: (_, value, __) {
                    final downloading = value > 0;
                    if (!downloading) {
                      return GestureDetector(
                        onTap: onDownload,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
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
                          child: const Center(
                            child: Text('DESCARGAR APK',
                                style: TextStyle(
                                    color: V.bg,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.6)),
                          ),
                        ),
                      );
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: value.clamp(0.0, 1.0),
                            minHeight: 8,
                            backgroundColor: V.bg,
                            valueColor:
                                const AlwaysStoppedAnimation(V.neon),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ValueListenableBuilder<String>(
                          valueListenable: status!,
                          builder: (_, s, __) => Text(
                            s,
                            style: const TextStyle(
                                color: V.neon,
                                fontSize: 11,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}