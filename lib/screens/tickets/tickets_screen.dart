import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';
import '../../services/app_db.dart';
import 'create_ticket_screen.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  int _t = 0;
  bool _loading = true;
  List<_TicketData> _tickets = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final remote = await AppDb.tickets();
    final local = await AppDb.localTickets();
    final list = <_TicketData>[
      for (final l in local)
        _TicketData(
          id: '${l['id']}',
          text: '${l['title']}',
          desc: '${l['description'] ?? ''}',
          st: 'Abierto',
          c: const Color(0xFFB8944F),
        ),
      for (final r in remote)
        _TicketData(
          id: '${r['id']}',
          text: '${r['title']}',
          desc: '${r['description'] ?? ''}',
          st: '${r['status']}',
          c: '${r['status']}' == 'abierto'
              ? const Color(0xFFB8944F)
              : '${r['status']}' == 'resuelto'
                  ? V.green
                  : const Color(0xFFB8944F),
        ),
    ];
    if (list.isEmpty) {
      list.addAll(const [
        _TicketData(
            id: '#TK-0034',
            text: 'Problema con SimBrief',
            desc: 'El plan de vuelo no exporta la ruta completa.',
            st: 'En proceso',
            c: Color(0xFFB8944F)),
        _TicketData(
            id: '#TK-0033',
            text: 'No se sincroniza el vuelo (RFS)',
            desc: 'La posición no avanza en el mapa en vivo.',
            st: 'Abierto',
            c: V.danger),
        _TicketData(
            id: '#TK-0032',
            text: 'Solicitud de ruta nueva',
            desc: 'Pedido de rutas transatlánticas entre Europa y US.',
            st: 'Resuelto',
            c: V.green),
        _TicketData(
            id: '#TK-0031',
            text: 'Error en el plan de vuelo',
            desc: 'El explotador no aparece en el FPL.',
            st: 'Cerrado',
            c: V.muted),
      ]);
    }
    if (!mounted) return;
    setState(() {
      _tickets = list;
      _loading = false;
    });
  }

  Future<void> _create() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const CreateTicketScreen()),
    );
    if (created == true) _load();
  }

  List<_TicketData> get _visible =>
      _t == 0 ? _tickets : _tickets;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de tickets',
            style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          GestureDetector(
            onTap: _create,
            child: Container(
              margin: const EdgeInsets.only(right: 14),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [V.neonLight, V.neon]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('Crear ticket',
                  style: TextStyle(
                      color: V.bg, fontWeight: FontWeight.w800, fontSize: 11)),
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [V.bg2, V.bg]),
        ),
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
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: CircularProgressIndicator(color: V.neon),
                ),
              )
            else
              GradientCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    for (var i = 0; i < _visible.length; i++) ...[
                      if (i > 0) const Divider(color: V.borderNeon),
                      _Tic(t: _visible[i]),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: 12),
            const Text(
              'Tu ticket se envía a soporte y queda registrado en la base de datos.',
              style: TextStyle(color: V.muted, fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketData {
  final String id, text, desc, st;
  final Color c;
  const _TicketData(
      {required this.id,
      required this.text,
      required this.desc,
      required this.st,
      required this.c});
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
            gradient:
                sel ? const LinearGradient(colors: [V.neonLight, V.neon]) : null,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: V.borderNeon),
          ),
          child: Center(
            child: Text(t,
                style: TextStyle(
                    color: sel ? V.bg : V.muted,
                    fontWeight: FontWeight.w700,
                    fontSize: 12)),
          ),
        ),
      ),
    );
  }
}

class _Tic extends StatelessWidget {
  final _TicketData t;
  const _Tic({required this.t});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.id,
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(t.text,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 12.5)),
                const SizedBox(height: 2),
                Text(t.desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: V.muted, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: t.c.withOpacity(0.16),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: t.c.withOpacity(0.6)),
            ),
            child: Text(t.st,
                style: TextStyle(
                    color: t.c, fontSize: 10, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}