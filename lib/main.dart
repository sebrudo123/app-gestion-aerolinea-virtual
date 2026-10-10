import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const VantageApp());
}

class V {
  static const Color bg = Color(0xFF090E17);
  static const Color bg2 = Color(0xFF0B132B);
  static const Color surface = Color(0xFF1C2541);
  static const Color surface2 = Color(0xFF141B2E);
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFFFC077);
  static const Color bronze = Color(0xFF8C6D2F);
  static const Color text = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFF9AA3B2);
  static const Color green = Color(0xFF3DDC84);
  static const Color danger = Color(0xFFE05A5A);
}

class VantageApp extends StatelessWidget {
  const VantageApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.dark(useMaterial3: true);
    return MaterialApp(
      title: 'Vantage Airlines',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        scaffoldBackgroundColor: V.bg,
        colorScheme: base.colorScheme.copyWith(
          primary: V.gold,
          secondary: V.goldLight,
          surface: V.surface,
          onPrimary: V.bg,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        textTheme: base.textTheme.apply(
          bodyColor: V.text,
          displayColor: V.text,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class GoldGradientText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final double spacing;

  const GoldGradientText(
    this.text, {
    super.key,
    this.size = 22,
    this.weight = FontWeight.w800,
    this.spacing = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => const LinearGradient(
        colors: [V.goldLight, V.gold, V.bronze],
      ).createShader(rect),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: size,
          fontWeight: weight,
          letterSpacing: spacing,
        ),
      ),
    );
  }
}

class GradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Gradient gradient;
  final Color border;
  final double radius;

  const GradientCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(18),
    this.radius = 22,
    this.border = const Color(0x33D4AF37),
    this.gradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [V.surface, V.surface2],
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progress;
  late final Animation<double> _fade;
  Timer? _messageTimer;
  int _msgIndex = 0;

  final List<String> _messages = const [
    'Conectando con el servidor...',
    'Verificando sesión de usuario...',
    'Cargando perfil de piloto...',
  ];

  final List<String> _jokes = const [
    'Verificando que nadie dejó su equipaje en casa...',
    'Revisando planes de vuelo y el clima...',
    'Calentando motores en la pista 27R...',
    'Recordando a todos abrocharse el cinturón...',
  ];

  int _jokeIndex = 0;

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _fade = CurvedAnimation(parent: _progress, curve: const Interval(0, 0.3, curve: Curves.easeOut));
    _progress.forward();

    _messageTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_msgIndex < _messages.length - 1) _msgIndex++;
        _jokeIndex = (_jokeIndex + 1) % _jokes.length;
      });
    });

    Timer(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => const MainShell(),
          transitionsBuilder: (_, animation, __, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _progress.dispose();
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
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 2),
                FadeTransition(
                  opacity: _fade,
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [V.goldLight, V.gold, V.bronze],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: V.gold.withOpacity(0.35),
                              blurRadius: 32,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.flight_takeoff_rounded,
                          size: 60,
                          color: V.bg,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const GoldGradientText('VANTAGE AIRLINES', size: 26),
                      const SizedBox(height: 10),
                      const Text(
                        'Elevando la experiencia de vuelo virtual',
                        style: TextStyle(color: V.muted, fontSize: 13, letterSpacing: 0.4),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 2),
                FadeTransition(
                  opacity: _fade,
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _progress,
                        builder: (context, _) => ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: _progress.value,
                            minHeight: 6,
                            backgroundColor: V.surface,
                            valueColor: const AlwaysStoppedAnimation(V.gold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        child: Text(
                          _messages[_msgIndex],
                          key: ValueKey(_msgIndex),
                          style: const TextStyle(
                            color: V.goldLight,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 1),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Row(
                    key: ValueKey(_jokeIndex),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.tips_and_updates_outlined, color: V.bronze, size: 15),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _jokes[_jokeIndex],
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: V.muted, fontSize: 11.5, fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final List<Widget> _pages = const [
    DashboardTab(),
    FlightsTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: V.bg,
      extendBody: true,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween(begin: const Offset(0, 0.02), end: Offset.zero).animate(animation),
                child: child,
              ),
            ),
            child: KeyedSubtree(key: ValueKey(_index), child: _pages[_index]),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _FloatingNavBar(
              index: _index,
              onChanged: (i) => setState(() => _index = i),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _FloatingNavBar({required this.index, required this.onChanged});

  static const _items = [
    (Icons.grid_view_rounded, 'Inicio'),
    (Icons.flight_rounded, 'Vuelos'),
    (Icons.person_rounded, 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: V.surface2.withOpacity(0.96),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: const Color(0x33D4AF37)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 24, offset: const Offset(0, 10)),
          ],
        ),
        child: Row(
          children: List.generate(_items.length, (i) {
            final selected = i == index;
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    gradient: selected
                        ? const LinearGradient(colors: [V.goldLight, V.gold])
                        : null,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _items[i].$1,
                        size: 22,
                        color: selected ? V.bg : V.muted,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _items[i].$2,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          color: selected ? V.bg : V.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [V.bg2, V.bg],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 130),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DashboardHeader(),
              const SizedBox(height: 22),
              const _PilotVipCard(),
              const SizedBox(height: 26),
              const _SectionTitle('ACCESOS RÁPIDOS'),
              const SizedBox(height: 14),
              const _QuickAccessGrid(),
              const SizedBox(height: 26),
              const _SectionTitle('ESTADÍSTICAS'),
              const SizedBox(height: 14),
              const _StatsGrid(),
              const SizedBox(height: 22),
              const _RankProgressCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Buenas tardes, CADETE',
                style: TextStyle(color: V.muted, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const GoldGradientText('sebrudo09', size: 24, spacing: 0.5),
                  const SizedBox(width: 8),
                  const Icon(Icons.verified, color: V.gold, size: 18),
                ],
              ),
            ],
          ),
        ),
        _CircleIcon(icon: Icons.notifications_none_rounded, badge: true, onTap: () {}),
        const SizedBox(width: 12),
        _CircleIcon(icon: Icons.headset_mic_outlined, onTap: () {}),
      ],
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final bool badge;
  final VoidCallback onTap;

  const _CircleIcon({required this.icon, this.badge = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: V.surface,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x33D4AF37)),
            ),
            child: Icon(icon, color: V.goldLight, size: 22),
          ),
          if (badge)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                height: 9,
                width: 9,
                decoration: BoxDecoration(
                  color: V.danger,
                  shape: BoxShape.circle,
                  border: Border.all(color: V.bg, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PilotVipCard extends StatelessWidget {
  const _PilotVipCard();

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      padding: const EdgeInsets.all(20),
      border: const Color(0x66D4AF37),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4A3B1E), Color(0xFF241C10), V.surface2],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 58,
                width: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [V.goldLight, V.gold, V.bronze]),
                  border: Border.all(color: V.goldLight, width: 2),
                ),
                child: const Center(
                  child: Text(
                    'S',
                    style: TextStyle(color: V.bg, fontWeight: FontWeight.w900, fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sebrudos Nine',
                      style: TextStyle(color: V.text, fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _Pill(label: 'CADETE', color: V.gold),
                        const SizedBox(width: 8),
                        _Pill(label: 'VTG030', color: V.goldLight),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.military_tech_rounded, color: V.gold, size: 34),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: const [
              _VipStat(value: '4 h', label: 'HORAS'),
              _VipDivider(),
              _VipStat(value: '6', label: 'VUELOS'),
              _VipDivider(),
              _VipStat(value: 'VTG030', label: 'CALLSIGN'),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: V.bg.withOpacity(0.35),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0x33D4AF37)),
            ),
            child: Row(
              children: const [
                Icon(Icons.workspace_premium_rounded, color: V.gold, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Insignia: Ala de Bronce — Piloto en formación',
                    style: TextStyle(color: V.goldLight, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VipStat extends StatelessWidget {
  final String value;
  final String label;

  const _VipStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(color: V.goldLight, fontSize: 17, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(color: V.muted, fontSize: 10, letterSpacing: 1)),
        ],
      ),
    );
  }
}

class _VipDivider extends StatelessWidget {
  const _VipDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 30, width: 1, color: const Color(0x33D4AF37));
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;

  const _Pill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 18, decoration: BoxDecoration(color: V.gold, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(color: V.text, fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 1.2),
        ),
      ],
    );
  }
}

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid();

  static const _items = [
    (Icons.route_rounded, 'Plan de Vuelo'),
    (Icons.list_alt_rounded, 'Mis Planes'),
    (Icons.emoji_events_rounded, 'Rankings'),
    (Icons.groups_rounded, 'Mi Equipo'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.78,
      children: List.generate(_items.length, (i) {
        final item = _items[i];
        return GestureDetector(
          onTap: () => _showSnack(context, item.$2),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [V.surface, V.surface2],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0x22D4AF37)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: V.gold.withOpacity(0.14),
                    border: Border.all(color: const Color(0x44D4AF37)),
                  ),
                  child: Icon(item.$1, color: V.goldLight, size: 20),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    item.$2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: V.muted, fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid();

  static const _stats = [
    (Icons.schedule_rounded, 'Horas voladas', '4 h'),
    (Icons.flight_takeoff_rounded, 'Vuelos completados', '6'),
    (Icons.public_rounded, 'Millas recorridas', '2,480'),
    (Icons.stars_rounded, 'Puntos de rango', '363 pts'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.75,
      children: List.generate(_stats.length, (i) {
        final s = _stats[i];
        return GradientCard(
          padding: const EdgeInsets.all(16),
          radius: 18,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(s.$1, color: V.gold, size: 22),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.$3,
                    style: const TextStyle(color: V.text, fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    s.$2,
                    style: const TextStyle(color: V.muted, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _RankProgressCard extends StatelessWidget {
  const _RankProgressCard();

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up_rounded, color: V.gold, size: 20),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Progreso de rango',
                  style: TextStyle(color: V.text, fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                '363 / 500 pts',
                style: TextStyle(color: V.goldLight.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: const [
              Text('CADETE', style: TextStyle(color: V.muted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
              Spacer(),
              Text('SEGUNDO OFICIAL', style: TextStyle(color: V.gold, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: 0.726,
              minHeight: 10,
              backgroundColor: V.bg,
              valueColor: const AlwaysStoppedAnimation(V.gold),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Te faltan 137 pts para ascender a SEGUNDO OFICIAL',
            style: TextStyle(color: V.muted, fontSize: 11.5),
          ),
        ],
      ),
    );
  }
}

class FlightsTab extends StatelessWidget {
  const FlightsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [V.bg2, V.bg],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 130),
          children: const [
            Text(
              'MIS VUELOS',
              style: TextStyle(color: V.text, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
            SizedBox(height: 4),
            Text(
              'Historial de operaciones',
              style: TextStyle(color: V.muted, fontSize: 13),
            ),
            SizedBox(height: 22),
            _FlightCard(
              origin: 'SKBO',
              destination: 'SKRG',
              aircraft: 'Airbus A320',
              date: '02 Oct 2026',
              duration: '48 min',
              points: '+25 pts',
              appeal: false,
            ),
            SizedBox(height: 16),
            _FlightCard(
              origin: 'KAVX',
              destination: 'KNUC',
              aircraft: 'Airbus A320',
              date: '28 Sep 2026',
              duration: '22 min',
              points: '+25 pts',
              appeal: true,
            ),
            SizedBox(height: 16),
            _FlightCard(
              origin: 'SKBO',
              destination: 'SKMD',
              aircraft: 'Cessna 172',
              date: '21 Sep 2026',
              duration: '35 min',
              points: '+18 pts',
              appeal: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _FlightCard extends StatelessWidget {
  final String origin;
  final String destination;
  final String aircraft;
  final String date;
  final String duration;
  final String points;
  final bool appeal;

  const _FlightCard({
    required this.origin,
    required this.destination,
    required this.aircraft,
    required this.date,
    required this.duration,
    required this.points,
    this.appeal = false,
  });

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                children: [
                  Text(origin, style: const TextStyle(color: V.text, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  const Text('Origen', style: TextStyle(color: V.muted, fontSize: 10)),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      const Icon(Icons.flight_rounded, color: V.gold, size: 18),
                      const SizedBox(height: 4),
                      Container(height: 1.5, color: const Color(0x44D4AF37)),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Text(destination, style: const TextStyle(color: V.text, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1)),
                  const Text('Destino', style: TextStyle(color: V.muted, fontSize: 10)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _MetaChip(icon: Icons.airplanemode_active_rounded, label: aircraft),
              const SizedBox(width: 8),
              _MetaChip(icon: Icons.timer_outlined, label: duration),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _MetaChip(icon: Icons.calendar_today_rounded, label: date),
              const Spacer(),
              _StatusBadge(label: appeal ? 'Apelación aceptada' : 'Aprobado', color: V.green),
            ],
          ),
          if (appeal) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: V.green.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: V.green.withOpacity(0.35)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.gavel_rounded, color: V.green, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Apelación aceptada: se restauraron los puntos del vuelo.',
                      style: TextStyle(color: V.green, fontSize: 11.5, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                points,
                style: const TextStyle(color: V.goldLight, fontSize: 15, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              _OutlineButton(
                label: 'Certificado',
                icon: Icons.description_outlined,
                onTap: () => _showSnack(context, 'Certificado de $origin → $destination'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: V.bg.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x22D4AF37)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: V.goldLight, size: 13),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: V.muted, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, color: color, size: 13),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _OutlineButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: V.gold),
          gradient: LinearGradient(colors: [V.gold.withOpacity(0.14), V.gold.withOpacity(0.04)]),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: V.goldLight, size: 15),
            const SizedBox(width: 7),
            Text(label, style: const TextStyle(color: V.goldLight, fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [V.bg2, V.bg],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 130),
          children: [
            const Text(
              'PERFIL',
              style: TextStyle(color: V.text, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
            const SizedBox(height: 4),
            const Text('Información del piloto y ajustes', style: TextStyle(color: V.muted, fontSize: 13)),
            const SizedBox(height: 22),
            const _ProfileCard(),
            const SizedBox(height: 24),
            _ProfileAction(
              icon: Icons.edit_rounded,
              title: 'Editar Perfil',
              subtitle: 'Nombre, callsign y contraseña',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              ),
            ),
            const SizedBox(height: 14),
            _ProfileAction(
              icon: Icons.settings_rounded,
              title: 'Configuración de la App',
              subtitle: 'Sonidos, reportes y marcos de avatar',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AppSettingsScreen()),
              ),
            ),
            const SizedBox(height: 26),
            _LogoutButton(
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      padding: const EdgeInsets.all(22),
      border: const Color(0x66D4AF37),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF3A2F1B), V.surface2],
      ),
      child: Column(
        children: [
          Container(
            height: 92,
            width: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [V.goldLight, V.gold, V.bronze]),
              border: Border.all(color: V.goldLight, width: 3),
              boxShadow: [
                BoxShadow(color: V.gold.withOpacity(0.35), blurRadius: 22, spreadRadius: 1),
              ],
            ),
            child: const Center(
              child: Text('S', style: TextStyle(color: V.bg, fontSize: 38, fontWeight: FontWeight.w900)),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sebrudos Nine',
            style: TextStyle(color: V.text, fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'seb****09@vantage.com',
            style: TextStyle(color: V.muted, fontSize: 13),
          ),
          const SizedBox(height: 18),
          Row(
            children: const [
              _ProfileStat(value: '363', label: 'PUNTOS'),
              _VipDivider(),
              _ProfileStat(value: 'VTG030', label: 'CALLSIGN'),
              _VipDivider(),
              _ProfileStat(value: '4 h', label: 'HORAS'),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: V.bg.withOpacity(0.35),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x33D4AF37)),
            ),
            child: Row(
              children: const [
                Icon(Icons.airlines_rounded, color: V.gold, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text('Vantage Airlines', style: TextStyle(color: V.text, fontSize: 13, fontWeight: FontWeight.w700)),
                ),
                _Pill(label: 'PILOTO', color: V.goldLight),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const _ProfileStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: V.goldLight, fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(color: V.muted, fontSize: 10, letterSpacing: 1)),
        ],
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GradientCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        radius: 18,
        child: Row(
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: V.gold.withOpacity(0.14),
                border: Border.all(color: const Color(0x44D4AF37)),
              ),
              child: Icon(icon, color: V.goldLight, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: V.text, fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: const TextStyle(color: V.muted, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: V.gold),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: V.danger.withOpacity(0.6)),
          gradient: LinearGradient(
            colors: [V.danger.withOpacity(0.16), V.danger.withOpacity(0.04)],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout_rounded, color: V.danger, size: 20),
            SizedBox(width: 10),
            Text(
              'CERRAR SESIÓN',
              style: TextStyle(color: V.danger, fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 1),
            ),
          ],
        ),
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _name = TextEditingController(text: 'Sebrudos Nine');
  final _callsign = TextEditingController(text: 'VTG030');
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _callsign.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: V.bg,
      appBar: AppBar(
        title: const Text('Editar Perfil', style: TextStyle(fontWeight: FontWeight.w700)),
        foregroundColor: V.text,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        children: [
          const _FieldLabel('Nombre completo'),
          const SizedBox(height: 8),
          _DarkField(controller: _name, hint: 'Ingresa tu nombre', icon: Icons.person_outline_rounded),
          const SizedBox(height: 20),
          const _FieldLabel('Callsign'),
          const SizedBox(height: 8),
          _DarkField(controller: _callsign, hint: 'VTG000', icon: Icons.badge_outlined),
          const SizedBox(height: 20),
          const _FieldLabel('Nueva contraseña'),
          const SizedBox(height: 8),
          _DarkField(
            controller: _password,
            hint: '••••••••',
            icon: Icons.lock_outline_rounded,
            obscure: true,
          ),
          const SizedBox(height: 34),
          GestureDetector(
            onTap: () {
              _showSnack(context, 'Cambios guardados correctamente');
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 17),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [V.goldLight, V.gold, V.bronze]),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(color: V.gold.withOpacity(0.35), blurRadius: 18, offset: const Offset(0, 8)),
                ],
              ),
              child: const Center(
                child: Text(
                  'GUARDAR CAMBIOS',
                  style: TextStyle(color: V.bg, fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: V.goldLight, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.5),
    );
  }
}

class _DarkField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;

  const _DarkField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: V.text, fontSize: 14),
      cursorColor: V.gold,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: V.muted, fontSize: 13),
        prefixIcon: Icon(icon, color: V.goldLight, size: 20),
        filled: true,
        fillColor: V.surface2,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0x33D4AF37)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: V.gold, width: 1.5),
        ),
      ),
    );
  }
}

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool _sounds = true;
  bool _errorReports = false;
  String _frame = 'Dorado';

  static const _frames = ['Dorado', 'Neón', 'Fuego'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: V.bg,
      appBar: AppBar(
        title: const Text('Configuración', style: TextStyle(fontWeight: FontWeight.w700)),
        foregroundColor: V.text,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        children: [
          GradientCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            radius: 18,
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: V.gold,
                  value: _sounds,
                  onChanged: (v) => setState(() => _sounds = v),
                  title: const Text('Sonidos de la app', style: TextStyle(color: V.text, fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Efectos y notificaciones', style: TextStyle(color: V.muted, fontSize: 12)),
                ),
                const Divider(color: Color(0x22D4AF37), height: 1),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  activeColor: V.gold,
                  value: _errorReports,
                  onChanged: (v) => setState(() => _errorReports = v),
                  title: const Text('Reportes de error', style: TextStyle(color: V.text, fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Enviar informes automáticos', style: TextStyle(color: V.muted, fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          const _FieldLabel('Marco de avatar'),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            children: _frames.map((f) {
              final selected = f == _frame;
              return GestureDetector(
                onTap: () => setState(() => _frame = f),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: selected ? V.gold.withOpacity(0.16) : V.surface2,
                    border: Border.all(color: selected ? V.gold : const Color(0x22D4AF37), width: selected ? 1.6 : 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                        color: selected ? V.gold : V.muted,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        f,
                        style: TextStyle(
                          color: selected ? V.goldLight : V.muted,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: V.surface,
        behavior: SnackBarBehavior.floating,
      ),
    );
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: V.surface2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Color(0x55E05A5A)),
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
                color: V.danger.withOpacity(0.14),
                border: Border.all(color: V.danger.withOpacity(0.6)),
              ),
              child: const Icon(Icons.logout_rounded, color: V.danger, size: 30),
            ),
            const SizedBox(height: 20),
            const Text(
              'Cerrar sesión',
              style: TextStyle(color: V.text, fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              '¿Estás seguro de que deseas salir de Vantage Airlines?',
              textAlign: TextAlign.center,
              style: TextStyle(color: V.muted, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(ctx).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0x33D4AF37)),
                      ),
                      child: const Center(
                        child: Text('CANCELAR', style: TextStyle(color: V.muted, fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 1)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(ctx).pop();
                      _showSnack(context, 'Sesión cerrada');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFE05A5A), Color(0xFFB23A3A)]),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text('CERRAR', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 1)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
