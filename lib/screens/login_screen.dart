import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_card.dart';
import '../widgets/gold_gradient_text.dart';
import '../services/session_service.dart';
import 'main_shell.dart';

class Auth {
  static const String email = 'vertexairlanes@gmail.com';
  static const String pass = 'vertexadmin123';
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _e = TextEditingController();
  final _p = TextEditingController();
  bool _ob = true;
  bool _err = false;
  bool _rem = false;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final saved = await SessionService.savedEmail();
    final rem = await SessionService.rememberFlag();
    if (!mounted) return;
    setState(() {
      if (saved != null && saved.isNotEmpty) _e.text = saved;
      _rem = rem;
    });
  }

  @override
  void dispose() {
    _e.dispose();
    _p.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_e.text.trim() == Auth.email && _p.text == Auth.pass) {
      await SessionService.saveSession(_e.text.trim(), remember: _rem);
      if (!mounted) return;
      setState(() => _err = false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    } else {
      setState(() => _err = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [V.bg2, V.bg],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 60),
              const Center(child: GoldGradientText('VERTEX AIRLINES', size: 26)),
              const SizedBox(height: 8),
              const Center(child: Text('Iniciar sesión', style: TextStyle(color: V.muted))),
              const SizedBox(height: 50),
              GradientCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ACCESO', style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.6)),
                    const SizedBox(height: 22),
                    const Text('Correo electrónico', style: TextStyle(color: V.muted, fontSize: 12)),
                    const SizedBox(height: 8),
                    _F(controller: _e, hint: 'vertexairlanes@gmail.com', icon: Icons.mail_outline),
                    const SizedBox(height: 16),
                    const Text('Contraseña', style: TextStyle(color: V.muted, fontSize: 12)),
                    const SizedBox(height: 8),
                    _F(controller: _p, hint: '••••••••', icon: Icons.lock_outline, obscure: _ob, suffix: IconButton(icon: Icon(_ob ? Icons.visibility_off : Icons.visibility, color: V.muted), onPressed: () => setState(() => _ob = !_ob))),
                    const SizedBox(height: 12),
                    Row(children: [Checkbox(value: _rem, onChanged: (v) => setState(() => _rem = v ?? false)), const Text('Recordar sesión', style: TextStyle(color: V.muted, fontSize: 12))]),
                    if (_err) ...[const SizedBox(height: 8), const Text('Credenciales incorrectas', style: TextStyle(color: V.danger, fontSize: 12))],
                    const SizedBox(height: 18),
                    GestureDetector(
                      onTap: _login,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [V.goldLight, V.gold, V.bronze]),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: V.gold.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 8))],
                        ),
                        child: const Center(child: Text('INGRESAR', style: TextStyle(color: V.bg, fontWeight: FontWeight.w900, letterSpacing: 1.8))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _F extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  const _F({required this.controller, required this.hint, required this.icon, this.obscure = false, this.suffix});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: V.text),
      cursorColor: V.gold,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: V.muted),
        prefixIcon: Icon(icon, color: V.goldLight),
        suffixIcon: suffix,
        filled: true,
        fillColor: V.surface2,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: V.borderGold)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: V.gold, width: 1.4)),
      ),
    );
  }
}
