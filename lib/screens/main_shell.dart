import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'map/live_map_screen.dart';
import 'hub/flights_hub_screen.dart';
import 'tickets/tickets_screen.dart';
import 'sync/sync_sim_screen.dart';
import 'profile_extended/profile_extended_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _i = 0;
  final _pages = const [
    LiveMapScreen(),
    FlightsHubScreen(),
    TicketsScreen(),
    SyncSimScreen(),
    ProfileExtendedScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
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

  static const _items = <(IconData, String)>[
    (Icons.map_rounded, 'Mapa'),
    (Icons.flight_rounded, 'Vuelos'),
    (Icons.confirmation_number_rounded, 'Tickets'),
    (Icons.sync_rounded, 'Sync'),
    (Icons.person_rounded, 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          color: V.surface2.withOpacity(0.98),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: V.borderNeon, width: 1.4),
          boxShadow: [
            BoxShadow(
              color: V.neon.withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 1,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: List.generate(_items.length, (i) {
            final sel = i == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    gradient: sel
                        ? const LinearGradient(colors: [V.neonLight, V.neon])
                        : null,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _items[i].$1,
                        color: sel ? V.bg : V.muted,
                        size: 20,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _items[i].$2,
                        style: TextStyle(
                          color: sel ? V.bg : V.muted,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
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