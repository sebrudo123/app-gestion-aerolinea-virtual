import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(seconds: 8))
      ..repeat();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa en vivo',
            style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5)),
        actions: const [
          Row(
            children: [
              Icon(Icons.circle, color: V.green, size: 10),
              SizedBox(width: 6),
              Text('EN RUTA',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
              SizedBox(width: 14),
            ],
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [V.bg2, V.bg],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: V.borderNeon, width: 1.4),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF071018), Color(0xFF0A1A26)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: V.neon.withOpacity(0.16),
                          blurRadius: 28,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: AnimatedBuilder(
                            animation: _c,
                            builder: (_, __) => CustomPaint(
                              painter: _MapPainter(_c.value),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          left: 12,
                          right: 12,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: GradientCard(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              radius: 16,
                              child: const Text(
                                'SKY728 • KJFK ➔ KLAX • ALT 35,000 ft • 482 kts • HDG 268°',
                                style: TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 14,
                          bottom: 14,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: V.borderNeon),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.satellite_alt_rounded,
                                    color: V.neon, size: 14),
                                SizedBox(width: 6),
                                Text('TRAYECTORIA ACTIVA',
                                    style: TextStyle(
                                        fontSize: 9.5,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w700,
                                        color: V.muted)),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 14,
                          bottom: 14,
                          child: AnimatedBuilder(
                            animation: _c,
                            builder: (_, __) => Text(
                              'ETA 3h 24m',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.white.withOpacity(
                                    0.6 + 0.4 * math.sin(_c.value * math.pi * 2)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: GradientCard(
                padding: const EdgeInsets.all(16),
                radius: 18,
                child: const Row(
                  children: [
                    Icon(Icons.airplanemode_active_rounded, color: V.neon),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Boeing 737-800 • N737SK',
                              style: TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 14)),
                          SizedBox(height: 2),
                          Text('Vuelo en curso',
                              style:
                                  TextStyle(color: V.muted, fontSize: 11)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('35,000 ft',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 12)),
                        Text('482 kts',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 12)),
                        Text('3h 24m',
                            style: TextStyle(
                                color: V.muted,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  final double t;
  _MapPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    _grid(canvas, size, w, h);
    _landmass(canvas, size);
    final path = _routePath(w, h);
    _route(canvas, path);
    _radar(canvas, size);
    _markers(canvas, path, size);
  }

  void _grid(Canvas canvas, Size size, double w, double h) {
    final p = Paint()
      ..color = V.neon.withOpacity(0.06)
      ..strokeWidth = 1;
    for (double x = 0; x < w; x += 44) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), p);
    }
    for (double y = 0; y < h; y += 44) {
      canvas.drawLine(Offset(0, y), Offset(w, y), p);
    }
    final eq = Paint()
      ..color = V.neon.withOpacity(0.12)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, h * 0.5), Offset(w, h * 0.5), eq);
  }

  void _landmass(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final fill = Paint()..color = V.neon.withOpacity(0.045);
    final stroke = Paint()
      ..color = V.neon.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    Path blob(List<Offset> pts) {
      final p = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (var i = 0; i < pts.length; i++) {
        final a = pts[i];
        final b = pts[(i + 1) % pts.length];
        final mx = (a.dx + b.dx) / 2;
        final my = (a.dy + b.dy) / 2;
        p.quadraticBezierTo(a.dx, a.dy, mx, my);
      }
      p.close();
      return p;
    }

    final north = blob([
      Offset(w * 0.08, h * 0.28),
      Offset(w * 0.22, h * 0.18),
      Offset(w * 0.34, h * 0.24),
      Offset(w * 0.30, h * 0.40),
      Offset(w * 0.16, h * 0.44),
      Offset(w * 0.06, h * 0.38),
    ]);
    final south = blob([
      Offset(w * 0.20, h * 0.58),
      Offset(w * 0.32, h * 0.62),
      Offset(w * 0.30, h * 0.84),
      Offset(w * 0.18, h * 0.90),
      Offset(w * 0.12, h * 0.74),
    ]);
    final east = blob([
      Offset(w * 0.66, h * 0.22),
      Offset(w * 0.86, h * 0.20),
      Offset(w * 0.94, h * 0.34),
      Offset(w * 0.80, h * 0.42),
      Offset(w * 0.66, h * 0.34),
    ]);
    for (final p in [north, south, east]) {
      canvas.drawPath(p, fill);
      canvas.drawPath(p, stroke);
    }
  }

  Path _routePath(double w, double h) {
    final start = Offset(w * 0.80, h * 0.34);
    final end = Offset(w * 0.20, h * 0.52);
    final control = Offset(w * 0.50, h * 0.04);
    return Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
  }

  void _route(Canvas canvas, Path path) {
    final glow = Paint()
      ..color = V.neon.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    final line = Paint()
      ..color = V.neon
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, glow);
    canvas.drawPath(path, line);
  }

  void _radar(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final radius = size.width * 0.55;
    final angle = t * math.pi * 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweep = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: math.pi * 2,
        colors: [
          V.neon.withOpacity(0.0),
          V.neon.withOpacity(0.0),
          V.neon.withOpacity(0.14),
        ],
        transform: GradientRotation(angle),
        stops: const [0.0, 0.85, 1.0],
      ).createShader(rect);
    canvas.drawCircle(center, radius, sweep);
  }

  void _markers(Canvas canvas, Path path, Size size) {
    final metrics = path.computeMetrics().toList();
    if (metrics.isEmpty) return;
    final metric = metrics.first;
    final total = metric.length;

    final start = metric.getTangentForOffset(0)!.position;
    final end = metric.getTangentForOffset(total)!.position;

    _pulse(canvas, start, V.green);
    _pulse(canvas, end, V.danger);

    final pos = (t % 1.0) * total;
    final tan = metric.getTangentForOffset(pos)!;
    _plane(canvas, tan.position, tan.angle + math.pi / 2);
  }

  void _pulse(Canvas canvas, Offset o, Color c) {
    final ring = Paint()
      ..color = c.withOpacity(0.35 * (1 - t))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(o, 6 + 14 * t, ring);
    canvas.drawCircle(o, 4, Paint()..color = c);
  }

  void _plane(Canvas canvas, Offset o, double angle) {
    canvas.save();
    canvas.translate(o.dx, o.dy);
    canvas.rotate(angle);
    final p = Path()
      ..moveTo(0, -10)
      ..lineTo(7, 8)
      ..lineTo(0, 4)
      ..lineTo(-7, 8)
      ..close();
    canvas.drawPath(
        p,
        Paint()
          ..color = V.neon
          ..style = PaintingStyle.fill);
    canvas.drawCircle(o, 14, Paint()..color = V.neon.withOpacity(0.18));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MapPainter old) => old.t != t;
}