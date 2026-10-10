import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/app_db.dart';
import '../../services/session_service.dart';
import '../../widgets/gradient_card.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  bool _saving = false;
  String _cat = 'Soporte técnico';
  String? _email;

  static const _cats = [
    'Soporte técnico',
    'Sincronización del simulador',
    'Problema con planes de vuelo',
    'Mi aerolínea / perfil',
    'Sugerencia / otro',
  ];

  @override
  void initState() {
    super.initState();
    Future(() async {
      final e = await SessionService.savedEmail();
      if (mounted) setState(() => _email = e);
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final t = _title.text.trim();
    final d = _desc.text.trim();
    if (t.isEmpty) {
      _bar('Escribe un asunto para tu ticket');
      return;
    }
    if (d.length < 10) {
      _bar('Describe el problema con al menos 10 caracteres');
      return;
    }
    setState(() => _saving = true);
    final ok = await AppDb.createTicket(
      title: t,
      description: d,
      category: _cat,
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF16A34A),
          content: Text('Ticket creado y guardado en la base de datos'),
        ),
      );
      Navigator.of(context).pop(true);
      return;
    }
    if (!AppDb.enabled) {
      await AppDb.saveLocalTicket({
        'id': '#TK-${DateTime.now().millisecondsSinceEpoch ~/ 1000}',
        'title': t,
        'description': d,
        'category': _cat,
        'status': 'abierto',
        'created_at': DateTime.now().toIso8601String(),
      });
      _bar('Ticket registrado y guardado en el dispositivo.');
      Navigator.of(context).pop(true);
      return;
    }
    _bar('No se pudo guardar en el servidor. Intenta de nuevo.');
    Navigator.of(context).pop(true);
  }

  void _bar(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear ticket',
            style: TextStyle(fontWeight: FontWeight.w800)),
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
            GradientCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nuevo ticket',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  const Text(
                    'Cuéntanos el problema con el simulador, la sincronización o tu cuenta y lo resolvemos.',
                    style: TextStyle(color: V.muted, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  const Text('Categoría',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: V.surface2,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: V.borderNeon),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _cat,
                        isExpanded: true,
                        dropdownColor: V.surface2,
                        style: const TextStyle(fontSize: 13),
                        items: _cats
                            .map((c) => DropdownMenuItem(
                                value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) => setState(() => _cat = v ?? _cat),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Asunto',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _title,
                    style: const TextStyle(fontSize: 13),
                    decoration: _dec('Ej: No sincroniza el vuelo en RFS',
                        Icons.title_rounded),
                  ),
                  const SizedBox(height: 14),
                  const Text('Descripción',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _desc,
                    maxLines: 5,
                    style: const TextStyle(fontSize: 13),
                    decoration: _dec(
                        'Describe qué ocurre, cuándo ocurrió y qué simulador estabas usando…',
                        Icons.description_rounded),
                  ),
                  if (_email != null) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(Icons.mail_outline,
                            color: V.muted, size: 15),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text('Se notificará a $_email',
                              style: const TextStyle(
                                  color: V.muted, fontSize: 11)),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _saving ? null : _submit,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [V.neonLight, V.neon]),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: V.neon.withOpacity(_saving ? 0 : 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _saving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: V.bg, strokeWidth: 2.5),
                              )
                            : const Text('ENVIAR TICKET',
                                style: TextStyle(
                                    color: V.bg,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.4)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _dec(String hint, IconData ic) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: V.muted, fontSize: 12),
      prefixIcon: Icon(ic, color: V.neon, size: 19),
      filled: true,
      fillColor: V.surface2,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: V.borderNeon),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: V.borderNeon),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: V.neon, width: 1.3),
      ),
    );
  }
}