import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  int _t = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de tickets', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [V.neonLight, V.neon]), borderRadius: BorderRadius.circular(10)),
            child: const Text('Crear ticket', style: TextStyle(color: V.bg, fontWeight: FontWeight.w800, fontSize: 11)),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                _Tab('Mis tickets', 0, _t, () => setState(() => _t = 0)),
                const SizedBox(width: 8),
                _Tab('Todos', 1, _t, () => setState(() => _t = 1)),
              ],
            ),
            const SizedBox(height: 16),
            GradientCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: const [
                  _Tic(id: '#TK-0034', text: 'Problema con SimBrief', st: 'En proceso', c: Color(0xFFB8944F)),
                  Divider(color: V.borderNeon),
                  _Tic(id: '#TK-0033', text: 'No se sincroniza el vuelo (RFS)', st: 'Abierto', c: V.danger),
                  Divider(color: V.borderNeon),
                  _Tic(id: '#TK-0032', text: 'Solicitud de ruta nueva', st: 'Resuelto', c: V.green),
                  Divider(color: V.borderNeon),
                  _Tic(id: '#TK-0031', text: 'Error en el plan de vuelo', st: 'Cerrado', c: V.muted),
                  Divider(color: V.borderNeon),
                  _Tic(id: '#TK-0030', text: 'Problema con la aerolínea', st: 'Resuelto', c: V.green),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String t;
  final int i, s;
  final VoidCallback onTap;
  const _Tab(this.t, this.i, this.s, this.onTap);

  @override
  Widget build(BuildContext context) {
    final sel = i == s;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: sel ? const LinearGradient(colors: [V.neonLight, V.neon]) : null,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: V.borderNeon),
          ),
          child: Center(child: Text(t, style: TextStyle(color: sel ? V.bg : V.muted, fontWeight: FontWeight.w700, fontSize: 12))),
        ),
      ),
    );
  }
}

class _Tic extends StatelessWidget {
  final String id, text, st;
  final Color c;
  const _Tic({required this.id, required this.text, required this.st, required this.c});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(id, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(height: 2), Text(text, style: const TextStyle(color: V.muted, fontSize: 11))])),
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: c.withOpacity(0.16), borderRadius: BorderRadius.circular(10), border: Border.all(color: c.withOpacity(0.6))), child: Text(st, style: TextStyle(color: c, fontSize: 10, fontWeight: FontWeight.w700))),
      ],
    );
  }
}
