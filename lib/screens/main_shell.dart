import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/flights_tab.dart';
import 'tabs/social_map_tab.dart';
import 'tabs/profile_tab.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _i = 0;
  final _pages = const [
    DashboardTab(),
    FlightsTab(),
    SocialMapTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: KeyedSubtree(key: ValueKey(_i), child: _pages[_i]),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _Nav(
              index: _i,
              onChanged: (v) => setState(() => _i = v),
            ),
          ),
        ],
      ),
    );
  }
}

class _Nav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;
  const _Nav({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.grid_view_rounded, 'Inicio'),
      (Icons.flight_rounded, 'Vuelos'),
      (Icons.public_rounded, 'Mapa/Amigos'),
      (Icons.person_rounded, 'Perfil'),
    ];
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: V.surface2.withOpacity(0.98),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: V.borderGold),
        ),
        child: Row(
          children: List.generate(items.length, (i) {
            final sel = i == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: sel ? const LinearGradient(colors: [V.goldLight, V.gold]) : null,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(items[i].$1, color: sel ? V.bg : V.muted, size: 20),
                      const SizedBox(height: 2),
                      Text(items[i].$2,
                          style: TextStyle(
                            fontSize: 10,
                            color: sel ? V.bg : V.muted,
                            fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                          )),
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
