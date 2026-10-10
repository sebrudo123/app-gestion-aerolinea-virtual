import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/flights_tab.dart';
import 'tabs/profile_tab.dart';

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
      extendBody: true,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.01),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: KeyedSubtree(key: ValueKey(_index), child: _pages[_index]),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _FloatingNav(
              index: _index,
              onChanged: (i) => setState(() => _index = i),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _FloatingNav({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.grid_view_rounded, 'Inicio'),
      (Icons.flight_rounded, 'Vuelos'),
      (Icons.person_rounded, 'Perfil y Ajustes'),
    ];

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: V.surface2.withOpacity(0.98),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: V.borderGold),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: List.generate(items.length, (i) {
            final selected = i == index;
            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(vertical: 9),
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
                        items[i].$1,
                        size: 22,
                        color: selected ? V.bg : V.muted,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        items[i].$2,
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
