import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gold_gradient_text.dart';
import '../services/update_service.dart';
import '../services/session_service.dart';
import '../services/maintenance_service.dart';
import 'auth/sim_selector_screen.dart';
import 'maintenance/maintenance_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  Timer? _timer;
  int _idx = 0;

  final _msgs = const [
    'Iniciando SkyConnect...',
    'Verificando actualizaciones en GitHub...',
    'Conectando con el servidor de RFS...',
    'Cargando perfil de piloto...',
  ];
  final _jokes = const [
    'Verificando que nadie dejó su equipaje en casa',
    'Revisando planes de vuelo',
    'Chequeando checklist pre-vuelo',
    'Calentando motores en la pista 27R',
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..forward();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_idx < _msgs.length - 1) _idx++;
      });
    });
    Timer(const Duration(seconds: 3), () async {
      if (!mounted) return;
      final needsUpdate = await UpdateService.checkForUpdate(context);
      if (!mounted) return;
      if (needsUpdate) return; // diálogo de actualización obligatoria en pantalla
      final target = await _gate(context);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => target,
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
      );
    });
  }

  Future<Widget> _gate(BuildContext context) async {
    final maint = await MaintenanceService.isEnabled();
    final email = await SessionService.savedEmail() ?? '';
    if (maint && !MaintenanceService.isAdmin(email)) {
      return const MaintenanceScreen();
    }
    return const SimSelectorScreen();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
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
            colors: [V.bg2, V.bg],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                const Spacer(flex: 2),
                FadeTransition(
                  opacity: CurvedAnimation(
                      parent: _ctrl,
                      curve: const Interval(0, 0.3, curve: Curves.easeOut)),
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.82, end: 1.0).animate(
                      CurvedAnimation(
                          parent: _ctrl,
                          curve: const Interval(0, 0.4,
                              curve: Curves.easeOutBack)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [V.goldLight, V.gold, V.bronze],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: V.neon.withOpacity(0.35),
                                blurRadius: 32,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.flight_takeoff_rounded,
                              size: 60, color: V.bg),
                        ),
                        const SizedBox(height: 24),
                        const GoldGradientText('VERTEX AIRLINES', size: 26),
                        const SizedBox(height: 8),
                        const Text('SkyConnect • MSFS 2024 • MSFS 2020 • RFS',
                            style: TextStyle(color: V.muted, fontSize: 12)),
                        const SizedBox(height: 26),
                        SizedBox(
                          height: 34,
                          width: 220,
                          child: AnimatedBuilder(
                            animation: _ctrl,
                            builder: (_, __) => CustomPaint(
                              painter: _RouteSplashPainter(_ctrl.value),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                FadeTransition(
                  opacity: CurvedAnimation(parent: _ctrl, curve: const Interval(0.3, 0.6)),
                  child: SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(0, 0.25), end: Offset.zero)
                        .animate(CurvedAnimation(
                            parent: _ctrl,
                            curve: const Interval(0.3, 0.7,
                                curve: Curves.easeOut))),
                    child: Column(
                      children: [
                        AnimatedBuilder(
                          animation: _ctrl,
                          builder: (_, __) => ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: _ctrl.value,
                              minHeight: 6,
                              backgroundColor: V.surface,
                              valueColor:
                                  const AlwaysStoppedAnimation(V.neon),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: Text(
                            _msgs[_idx],
                            key: ValueKey(_idx),
                            style: const TextStyle(
                                color: V.neon,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 1),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Text(
                    _jokes[_idx % _jokes.length],
                    key: ValueKey(_idx % _jokes.length),
                    style: const TextStyle(color: V.muted, fontSize: 11),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RouteSplashPainter extends CustomPainter {
  final double t;
  _RouteSplashPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(8, h * 0.7)
      ..quadraticBezierTo(w * 0.5, h * 0.05, w - 8, h * 0.55);

    final track = Paint()
      ..color = V.neon.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawPath(path, track);

    final metric = path.computeMetrics().first;
    final total = metric.length;
    final pos = (t * 1.4 % 1.0) * total;

    final flownPaint = Paint()
      ..color = V.neon
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(metric.extractPath(0, pos), flownPaint);

    final tan = metric.getTangentForOffset(pos)!;
    canvas.save();
    canvas.translate(tan.position.dx, tan.position.dy);
    canvas.rotate(tan.angle);
    final plane = Path()
      ..moveTo(6, 0)
      ..lineTo(-5, 4)
      ..lineTo(-5, -4)
      ..close();
    canvas.drawPath(plane, Paint()..color = V.goldLight);
    canvas.restore();

    canvas.drawCircle(Offset(8, h * 0.7), 3, Paint()..color = V.green);
    canvas.drawCircle(Offset(w - 8, h * 0.55), 3, Paint()..color = V.danger);
  }

  @override
  bool shouldRepaint(covariant _RouteSplashPainter old) => old.t != t;
}
