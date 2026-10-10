import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class MsfsProfileScreen extends StatelessWidget {
  const MsfsProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil (SkyPilot12)', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GradientCard(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: V.green.withOpacity(0.16), borderRadius: BorderRadius.circular(10), border: Border.all(color: V.green)),
                    child: const Text('PILOTO VERIFICADO', style: TextStyle(color: V.green, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
                  ),
                  const SizedBox(height: 18),
                  row(CrossAxisAlignment.center, const [
                    _Stat('248', 'Vuelos'),
                    _Stat('1,286', 'Horas'),
                    _Stat('3', 'Aerolíneas'),
                  ]),
                  const SizedBox(height: 18),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('SIMULADORES CONECTADOS', style: TextStyle(fontSize: 11, letterSpacing: 1, color: V.muted, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 10),
                  const _Sim('MSFS 2024', true),
                  const SizedBox(height: 8),
                  const _Sim('MSFS 2020', true),
                  const SizedBox(height: 18),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('AEROLÍNEA DEL PILOTO', style: TextStyle(fontSize: 11, letterSpacing: 1, color: V.muted, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 10),
                  const _Airline('SkyLink Virtual', '248 vuelos • 12 miembros'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget row(CrossAxisAlignment c, List<Widget> w) => Row(mainAxisAlignment: MainAxisAlignment.spaceAround, crossAxisAlignment: c, children: w);
}

class _Stat extends StatelessWidget {
  final String v, l;
  const _Stat(this.v, this.l);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(v, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: V.neon)),
      Text(l, style: const TextStyle(color: V.muted, fontSize: 11)),
    ]);
  }
}

class _Sim extends StatelessWidget {
  final String t;
  final bool on;
  const _Sim(this.t, this.on);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: V.surface2, borderRadius: BorderRadius.circular(12), border: Border.all(color: V.borderNeon)),
      child: Row(children: [
        Icon(Icons.flight_takeoff_rounded, color: on ? V.green : V.muted, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(t, style: const TextStyle(fontWeight: FontWeight.w700))),
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: V.green.withOpacity(0.16), borderRadius: BorderRadius.circular(8)), child: const Text('CONECTADO', style: TextStyle(color: V.green, fontSize: 9, fontWeight: FontWeight.w800))),
      ]),
    );
  }
}

class _Airline extends StatelessWidget {
  final String t, sub;
  const _Airline(this.t, this.sub);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: V.surface2, borderRadius: BorderRadius.circular(12), border: Border.all(color: V.borderGold)),
      child: Row(children: [
        Container(height: 36, width: 36, decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [V.goldLight, V.gold])), child: const Icon(Icons.flight, color: V.bg, size: 18)),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(fontWeight: FontWeight.w800)), Text(sub, style: const TextStyle(color: V.muted, fontSize: 11))])),
      ]),
    );
  }
}