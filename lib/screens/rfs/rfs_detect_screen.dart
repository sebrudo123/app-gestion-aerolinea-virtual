import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/sim_detector.dart';
import 'rfs_hub_screen.dart';

class RfsDetectScreen extends StatefulWidget {
  const RfsDetectScreen({super.key});

  @override
  State<RfsDetectScreen> createState() => _RfsDetectScreenState();
}

class _RfsDetectScreenState extends State<RfsDetectScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  bool _checking = true;
  bool _installed = false;
  int _step = 0;

  static const _steps = [
    'Accediendo al dispositivo…',
    'Buscando Real Flight Simulator…',
    'Verificando paquete com.fdc.rfs.aero…',
  ];

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _scan();
  }

  Future<void> _scan() async {
    setState(() {
      _checking = true;
      _step = 0;
    });
    for (var i = 0; i < _steps.length; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 650));
      if (!mounted) return;
      setState(() => _step = i + 1);
    }
    final installed = await SimDetector.rfsInstalled();
    if (!mounted) return;
    setState(() {
      _installed = installed;
      _checking = false;
    });
    _c.stop();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [V.bg2, V.bg]),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 20),
              Center(
                child: FadeTransition(
                  opacity: _c,
                  child: Container(
                    height: 118,
                    width: 118,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                          colors: [V.goldLight, V.gold, V.bronze]),
                      boxShadow: [
                        BoxShadow(
                            color: V.gold.withOpacity(0.35), blurRadius: 34),
                      ],
                    ),
                    child: Icon(
                      _checking
                          ? Icons.phone_android_rounded
                          : _installed
                              ? Icons.check_rounded
                              : Icons.download_for_offline_rounded,
                      color: V.bg,
                      size: 50,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 34),
              if (_checking) ...[
                for (var i = 0; i < _steps.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Icon(
                          i < _step
                              ? Icons.check_circle_rounded
                              : i == _step
                                  ? Icons.radio_button_checked_rounded
                                  : Icons.radio_button_unchecked_rounded,
                          color: i <= _step ? V.goldLight : V.muted,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(_steps[i],
                              style: TextStyle(
                                  color: i <= _step ? V.text : V.muted,
                                  fontSize: 12.5)),
                        ),
                      ],
                    ),
                  ),
              ] else ...[
                Center(
                  child: Text(
                    _installed
                        ? 'RFS detectado en tu teléfono'
                        : 'RFS no encontrado',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: _installed ? V.goldLight : V.danger),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _installed
                      ? 'Real Flight Simulator está instalado. Puedes entrar al Airline Manager.'
                      : 'No detectamos Real Flight Simulator instalado en este dispositivo. Instálalo desde Play Store para continuar.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: V.muted, fontSize: 12),
                ),
                const SizedBox(height: 26),
                if (_installed)
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const RfsHubScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [V.goldLight, V.gold]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: V.gold.withOpacity(0.3),
                              blurRadius: 22,
                              offset: const Offset(0, 10)),
                        ],
                      ),
                      child: const Center(
                        child: Text('ABRIR RFS AIRLINE MANAGER',
                            style: TextStyle(
                                color: V.bg,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                                fontSize: 12.5)),
                      ),
                    ),
                  )
                else ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: V.surface2,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: V.borderNeon),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('¿Cómo instalarlo?',
                            style: TextStyle(fontWeight: FontWeight.w800)),
                        SizedBox(height: 8),
                        Text('1. Abre Play Store.',
                            style: TextStyle(
                                color: V.muted, fontSize: 12)),
                        Text('2. Busca "Real Flight Simulator".',
                            style: TextStyle(
                                color: V.muted, fontSize: 12)),
                        Text('3. Instálalo y vuelve aquí.',
                            style: TextStyle(
                                color: V.muted, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: _scan,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: V.surface2,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: V.borderNeon),
                      ),
                      child: const Center(
                        child: Text('REINTENTAR DETECCIÓN',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8)),
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}