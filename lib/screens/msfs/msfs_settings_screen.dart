import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';
import '../../services/session_service.dart';
import '../auth/sim_selector_screen.dart';

class MsfsSettingsScreen extends StatefulWidget {
  final String edition;
  final String userLabel;
  const MsfsSettingsScreen({
    required this.edition,
    required this.userLabel,
    super.key,
  });

  @override
  State<MsfsSettingsScreen> createState() => _MsfsSettingsScreenState();
}

class _MsfsSettingsScreenState extends State<MsfsSettingsScreen> {
  bool _notif = true;
  bool _live = true;
  bool _imperial = true;
  String _platform = 'Xbox';
  String _user = 'SkyPilot12';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final acc = await SessionService.msfsAccount(widget.edition);
    if (acc != null && mounted) {
      setState(() {
        _platform = acc['platform'] == 'steam' ? 'Steam' : 'Xbox';
        _user = acc['user'] ?? _user;
      });
    }
  }

  Future<void> _unlink() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        backgroundColor: V.surface2,
        title: const Text('Desconectar cuenta'),
        content: Text(
            'Se quitará la vinculación de $_platform y volverás al selector de simulador.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(d, false),
              child: const Text('CANCELAR')),
          TextButton(
              onPressed: () => Navigator.pop(d, true),
              child: const Text('DESCONECTAR',
                  style: TextStyle(color: V.danger))),
        ],
      ),
    );
    if (ok != true) return;
    await SessionService.clearMsfsAccount(widget.edition);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SimSelectorScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final edition =
        widget.edition == '2024' ? 'Microsoft Flight Simulator 2024' : 'Microsoft Flight Simulator 2020';
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Ajustes',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GradientCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                    _platform == 'Steam'
                        ? Icons.games_rounded
                        : Icons.sports_esports_rounded,
                    color: V.green,
                    size: 30),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$_platform vinculada',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text('$_user • $edition',
                          style: const TextStyle(
                              color: V.muted, fontSize: 11)),
                    ],
                  ),
                ),
                const Icon(Icons.verified_rounded, color: V.green, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('PREFERENCIAS',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                  color: V.muted)),
          const SizedBox(height: 10),
          GradientCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Column(
              children: [
                _Sw('Notificaciones de vuelo', _notif,
                    (v) => setState(() => _notif = v)),
                const Divider(color: V.borderNeon),
                _Sw('Seguimiento en vivo', _live,
                    (v) => setState(() => _live = v)),
                const Divider(color: V.borderNeon),
                _Sw('Unidades imperiales (ft / kts)', _imperial,
                    (v) => setState(() => _imperial = v)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('CUENTA',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                  color: V.muted)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _unlink,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: V.surface2,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: V.danger.withOpacity(0.6)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.link_off_rounded, color: V.danger),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text('Desconectar cuenta',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, color: V.danger)),
                  ),
                  Icon(Icons.chevron_right_rounded, color: V.danger),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text('Vertex Airlines • SkyConnect',
                style: TextStyle(color: V.muted, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

class _Sw extends StatelessWidget {
  final String t;
  final bool v;
  final ValueChanged<bool> onChanged;
  const _Sw(this.t, this.v, this.onChanged);
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      activeColor: V.neon,
      title: Text(t, style: const TextStyle(fontSize: 13)),
      value: v,
      onChanged: onChanged,
    );
  }
}