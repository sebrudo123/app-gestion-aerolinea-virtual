import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../services/discord_presence_service.dart';

class DiscordPresenceTab extends StatefulWidget {
  const DiscordPresenceTab({super.key});

  @override
  State<DiscordPresenceTab> createState() => _DiscordPresenceTabState();
}

class _DiscordPresenceTabState extends State<DiscordPresenceTab> {
  final _service = DiscordRichPresenceService();
  final _stateCtrl = TextEditingController(text: 'En Vertex Airlines');
  final _detailsCtrl = TextEditingController(text: 'Preparado para volar');
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    _init();
    _service.connectedStream.listen((v) {
      if (mounted) setState(() => _connected = v);
    });
  }

  Future<void> _init() async {
    await _service.initialize('1558647821907922974');
    if (mounted) setState(() => _connected = _service.isConnected);
  }

  Future<void> _update() async {
    await _service.updatePresence(
      state: _stateCtrl.text,
      details: _detailsCtrl.text,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rich Presence actualizado (simulado)'),
          backgroundColor: V.green,
        ),
      );
    }
  }

  Future<void> _clear() async {
    await _service.clearPresence();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rich Presence limpiado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discord Rich Presence',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [V.bg2, V.bg],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: V.surface2,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: V.borderNeon),
              ),
              child: Row(
                children: [
                  Icon(
                    _connected ? Icons.discord : Icons.sync,
                    color: _connected ? V.neon : V.muted,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _connected ? 'Conectado (simulado)' : 'Conectando...',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Cliente: Vertex Airlines',
                        style: TextStyle(color: V.muted, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('ESTADO',
                style: TextStyle(
                    fontWeight: FontWeight.w800, letterSpacing: 1, fontSize: 12)),
            const SizedBox(height: 8),
            TextField(
              controller: _stateCtrl,
              decoration: InputDecoration(
                filled: true,
                fillColor: V.surface2,
                hintText: 'Estado (ej. En Vertex Airlines)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: V.borderNeon),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('DETALLES',
                style: TextStyle(
                    fontWeight: FontWeight.w800, letterSpacing: 1, fontSize: 12)),
            const SizedBox(height: 8),
            TextField(
              controller: _detailsCtrl,
              decoration: InputDecoration(
                filled: true,
                fillColor: V.surface2,
                hintText: 'Detalles (ej. Vuelo activo)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: V.borderNeon),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _update,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [V.neonLight, V.neon]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('ACTUALIZAR PRESENCE',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                                fontSize: 12)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: _clear,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: V.surface2,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: V.borderNeon),
                      ),
                      child: const Center(
                        child: Text('LIMPIAR',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                                fontSize: 12)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Implementación simulada (sin binarios nativos) para mantener estable el build en CI. ID: 1558647821907922974',
              style: TextStyle(color: V.muted, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
