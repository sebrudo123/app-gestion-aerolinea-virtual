import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';
import '../../services/session_service.dart';

class ChangeAvatarScreen extends StatefulWidget {
  const ChangeAvatarScreen({super.key});

  @override
  State<ChangeAvatarScreen> createState() => _ChangeAvatarScreenState();
}

class _ChangeAvatarScreenState extends State<ChangeAvatarScreen> {
  String _sel = 'S';

  static const _options = ['S', 'V', 'A', 'C', 'M', 'K', 'D', 'P', 'R', 'T'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final a = await SessionService.avatar();
    if (mounted) setState(() => _sel = a);
  }

  Future<void> _save() async {
    await SessionService.setAvatar(_sel);
    if (mounted) Navigator.of(context).pop(true);
  }

  Color _color(String s) {
    final colors = [
      V.neon,
      V.gold,
      V.green,
      const Color(0xFFB06AB3),
      const Color(0xFFFF7A7A),
      const Color(0xFF00C2D1),
    ];
    return colors[s.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambiar avatar',
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
            Center(
              child: Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [
                    _color(_sel).withOpacity(0.95),
                    _color(_sel).withOpacity(0.6),
                  ]),
                  border: Border.all(color: V.neon, width: 3),
                  boxShadow: [
                    BoxShadow(color: V.neon.withOpacity(0.25), blurRadius: 26),
                  ],
                ),
                child: Center(
                  child: Text(_sel,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 44,
                          fontWeight: FontWeight.w900)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('ELIGE TU AVATAR',
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    color: V.muted)),
            const SizedBox(height: 12),
            GradientCard(
              padding: const EdgeInsets.all(14),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 14,
                runSpacing: 14,
                children: _options.map((s) {
                  final selected = s == _sel;
                  return GestureDetector(
                    onTap: () => setState(() => _sel = s),
                    child: Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [
                          _color(s).withOpacity(0.95),
                          _color(s).withOpacity(0.6),
                        ]),
                        border: Border.all(
                            color: selected ? V.neon : V.borderNeon,
                            width: selected ? 3 : 1),
                      ),
                      child: Center(
                        child: Text(s,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 20)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 22),
            GestureDetector(
              onTap: _save,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(colors: [V.neonLight, V.neon]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: V.neon.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8)),
                  ],
                ),
                child: const Center(
                  child: Text('GUARDAR AVATAR',
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
    );
  }
}