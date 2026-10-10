import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_card.dart';
import '../widgets/gold_gradient_text.dart';
import 'main_shell.dart';

class Auth {
  static const String adminEmail = 'vertexairlanes@gmail.com';
  static const String adminPass = 'vertexadmin123';
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _obscure = true;
  bool _error = false;
  bool _remember = false;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _login() {
    if (_email.text.trim() == Auth.adminEmail &&
        _pass.text == Auth.adminPass) {
      setState(() => _error = false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    } else {
      setState(() => _error = true);
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
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'Iniciar sesión',
                  style: TextStyle(color: V.muted, fontSize: 13, letterSpacing: 0.6),
                ),
              ),
              const SizedBox(height: 60),
              GradientCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ACCESO PROFESIONAL',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.8,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text('Correo electrónico',
                        style: TextStyle(color: V.muted, fontSize: 12)),
                    const SizedBox(height: 8),
                    _DarkField(
                      controller: _email,
                      hint: 'vertexairlanes@gmail.com',
                      icon: Icons.mail_outline_rounded,
                    ),
                    const SizedBox(height: 20),
                    const Text('Contraseña',
                        style: TextStyle(color: V.muted, fontSize: 12)),
                    const SizedBox(height: 8),
                    _DarkField(
                      controller: _pass,
                      hint: '••••••••',
                      icon: Icons.lock_outline_rounded,
                      obscure: _obscure,
                      suffix: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                          color: V.muted,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _remember,
                          onChanged: (v) => setState(() => _remember = v ?? false),
                        ),
                        const Text('Recordar sesión',
                            style: TextStyle(color: V.muted, fontSize: 12)),
                      ],
                    ),
                    if (_error) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Correo o contraseña incorrectos',
                        style: TextStyle(
                          color: V.danger,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: _login,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [V.goldLight, V.gold, V.bronze],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: V.gold.withOpacity(0.35),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'INGRESAR',
                            style: TextStyle(
                              color: V.bg,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
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

class _DarkField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;

  const _DarkField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: V.text, fontSize: 14),
      cursorColor: V.gold,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: V.muted, fontSize: 13),
        prefixIcon: Icon(icon, color: V.goldLight, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: V.surface2,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: V.borderGold),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: V.gold, width: 1.6),
        ),
      ),
    );
  }
}
