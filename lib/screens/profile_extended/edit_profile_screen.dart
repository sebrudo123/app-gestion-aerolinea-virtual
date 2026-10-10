import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';
import '../../services/session_service.dart';
import '../../services/app_db.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _name = TextEditingController();
  final _license = TextEditingController();
  final _hours = TextEditingController();
  String _platform = 'Xbox';
  String? _email;
  bool _saving = false;

  static const _platforms = ['Xbox', 'Steam', 'PlayStation', 'Móvil (RFS)'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final name = await SessionService.name();
    final license = await SessionService.license();
    final hours = await SessionService.hours();
    final platform = await SessionService.platform();
    final email = await SessionService.savedEmail();
    if (!mounted) return;
    setState(() {
      _name.text = name;
      _license.text = license;
      _hours.text = hours;
      _platform = _platforms.contains(platform) ? platform : 'Xbox';
      _email = email;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await SessionService.setProfile(
      name: _name.text.trim(),
      platform: _platform,
      license: _license.text.trim(),
      hours: _hours.text.trim(),
    );
    if (AppDb.enabled) {
      await AppDb.saveProfile({
        'display_name': _name.text.trim(),
        'platform': _platform,
        'license': _license.text.trim(),
      });
    }
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF16A34A),
        content: Text('Perfil guardado'),
      ),
    );
    Navigator.of(context).pop(true);
  }

  @override
  void dispose() {
    _name.dispose();
    _license.dispose();
    _hours.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar perfil',
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
                  _label('Nombre de usuario'),
                  TextField(
                      controller: _name,
                      style: const TextStyle(fontSize: 13),
                      decoration: _dec('Tu nombre de piloto',
                          Icons.person_rounded)),
                  const SizedBox(height: 14),
                  _label('Correo'),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 13),
                    decoration: BoxDecoration(
                      color: V.surface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: V.borderNeon),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.mail_outline,
                            color: V.muted, size: 19),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(_email ?? 'No disponible',
                              style: const TextStyle(
                                  color: V.muted, fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  _label('Plataforma'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: V.surface2,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: V.borderNeon),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _platform,
                        isExpanded: true,
                        dropdownColor: V.surface2,
                        style: const TextStyle(fontSize: 13),
                        items: _platforms
                            .map((p) =>
                                DropdownMenuItem(value: p, child: Text(p)))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _platform = v ?? _platform),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _label('Licencia'),
                  TextField(
                      controller: _license,
                      style: const TextStyle(fontSize: 13),
                      decoration: _dec('Ej: Comercial (ATPL)',
                          Icons.card_membership_rounded)),
                  const SizedBox(height: 14),
                  _label('Horas de vuelo'),
                  TextField(
                      controller: _hours,
                      style: const TextStyle(fontSize: 13),
                      decoration:
                          _dec('Ej: 248h 32m', Icons.timer_rounded)),
                ],
              ),
            ),
            const SizedBox(height: 22),
            GestureDetector(
              onTap: _saving ? null : _save,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(colors: [V.neonLight, V.neon]),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: V.neon.withOpacity(_saving ? 0 : 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8)),
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
                      : const Text('GUARDAR CAMBIOS',
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

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.w700)),
      );

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