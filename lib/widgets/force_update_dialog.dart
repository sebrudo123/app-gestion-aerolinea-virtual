import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ForceUpdateDialog extends StatelessWidget {
  final String version;
  final List<String> notes;
  final VoidCallback onDownload;

  const ForceUpdateDialog({
    required this.version,
    required this.notes,
    required this.onDownload,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: V.surface2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: V.borderGold),
        ),
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
                    colors: [V.goldLight, V.gold, V.bronze],
                  ),
                ),
                child: const Icon(Icons.system_update_rounded, color: V.bg, size: 34),
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
                  border: Border.all(color: V.borderGold),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: notes
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text('• $e',
                                style: const TextStyle(color: V.muted, fontSize: 11.5)),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: onDownload,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [V.goldLight, V.gold, V.bronze],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text('DESCARGAR APK',
                        style: TextStyle(
                            color: V.bg,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.6)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
