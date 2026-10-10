import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class SocialMapTab extends StatelessWidget {
  const SocialMapTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 130),
          children: [
            const Text('LIVE MAP Y RED SOCIAL', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
            const SizedBox(height: 16),
            GradientCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [Icon(Icons.map_rounded, color: V.gold), SizedBox(width: 8), Text('Mapa en tiempo real', style: TextStyle(fontWeight: FontWeight.w700))]),
                  const SizedBox(height: 12),
                  Container(
                    height: 180,
                    decoration: BoxDecoration(color: V.surface2, borderRadius: BorderRadius.circular(14), border: Border.all(color: V.borderGold)),
                    child: const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.flight_takeoff_rounded, color: V.goldLight), SizedBox(height: 6), Text('Tu posición y amigos en RFS', style: TextStyle(color: V.muted, fontSize: 12))])),
                  ),
                  const SizedBox(height: 12),
                  const Row(children: [_Dot(V.gold), SizedBox(width: 6), Text('Tú (VTG030)'), Spacer(), _Dot(V.green), SizedBox(width: 6), Text('Amigos conectados')]),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GradientCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [Icon(Icons.group_add_rounded, color: V.gold), SizedBox(width: 8), Text('Buscador de amigos por Callsign', style: TextStyle(fontWeight: FontWeight.w700))]),
                  const SizedBox(height: 12),
                  Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: V.surface2, borderRadius: BorderRadius.circular(12), border: Border.all(color: V.borderGold)), child: const Row(children: [Icon(Icons.search_rounded, color: V.muted), SizedBox(width: 8), Text('Buscar VTG030 / Callsign...', style: TextStyle(color: V.muted, fontSize: 12)), Spacer()])),
                  const SizedBox(height: 12),
                  const Text('Vuelos en grupo (Formación): Convoyes para despegar y volar juntos.', style: TextStyle(color: V.muted, fontSize: 11.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color c;
  const _Dot(this.c);
  @override
  Widget build(BuildContext context) {
    return Container(height: 8, width: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: c));
  }
}
