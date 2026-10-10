import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/session_service.dart';
import 'msfs_dashboard_screen.dart';

class OwnershipScreen extends StatefulWidget {
  final String edition;
  const OwnershipScreen({required this.edition, super.key});

  @override
  State<OwnershipScreen> createState() => _OwnershipScreenState();
}

class _OwnershipScreenState extends State<OwnershipScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  int _step = 0;
  bool _owned = false;
  bool _checking = false;
  String _user = 'SkyPilot12';
  String _platform = 'Xbox';

  static const _steps = [
    'Conectando con la tienda de la plataforma…',
    'Consultando tu biblioteca de juegos…',
    'Verificando licencia de MSFS',
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
    _prepare();
  }

  Future<void> _prepare() async {
    final acc = await SessionService.msfsAccount(widget.edition);
    if (acc != null) {
      _user = acc['user'] ?? _user;
      _platform = acc['platform'] == 'steam' ? 'Steam' : 'Xbox';
    }
    final owned = await SessionService.msfsOwned(widget.edition);
    if (mounted) {
      setState(() => _owned = owned);
      _startScan();
    }
  }

  void _startScan() {
    setState(() => _checking = true);
    Timer.periodic(const Duration(milliseconds: 950), (t) async {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_step < _steps.length - 1) {
        setState(() => _step++);
      } else {
        t.cancel();
        _finish();
      }
    });
  }

  Future<void> _finish() async {
    final owned = await SessionService.msfsOwned(widget.edition);
    if (!mounted) return;
    setState(() {
      _owned = owned;
      _checking = false;
    });
    _ctrl.stop();
  }

  Future<void> _continue() async {
    await SessionService.setMsfsOwned(widget.edition, _owned);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => MsfsDashboardScreen(edition: widget.edition),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title =
        widget.edition == '2024' ? 'MSFS 2024' : 'MSFS 2020';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificación de licencia',
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
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 12),
            Center(
              child: FadeTransition(
                opacity: _ctrl,
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: _owned
                        ? const LinearGradient(
                            colors: [V.goldLight, V.gold, V.bronze])
                        : const LinearGradient(
                            colors: [V.neonLight, V.neon]),
                    boxShadow: [
                      BoxShadow(
                          color: (_owned ? V.gold : V.neon)
                              .withOpacity(0.35),
                          blurRadius: 34),
                    ],
                  ),
                  child: Icon(
                    _owned
                        ? Icons.verified_rounded
                        : Icons.lock_rounded,
                    color: V.bg,
                    size: 52,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            if (_checking) ...[
              for (var i = 0; i < _steps.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Icon(
                        i < _step
                            ? Icons.check_circle_rounded
                            : i == _step
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_unchecked_rounded,
                        color: i <= _step ? V.neon : V.muted,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(_steps[i],
                            style: TextStyle(
                                color:
                                    i <= _step ? V.text : V.muted,
                                fontSize: 12.5)),
                      ),
                    ],
                  ),
                ),
            ] else ...[
              Center(
                child: Text(
                  _owned
                      ? '¡Licencia verificada!'
                      : 'Licencia no detectada',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: _owned ? V.gold : V.danger),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _owned
                    ? '$title confirmado en tu biblioteca de $_platform.'
                    : 'No encontramos $title en tu biblioteca de $_platform.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: V.muted, fontSize: 12),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$_platform vinculada: $_user',
                      style: const TextStyle(
                          color: V.muted, fontSize: 11.5)),
                ],
              ),
              const SizedBox(height: 24),
              if (!_owned) ...[
                GestureDetector(
                  onTap: () => setState(() => _owned = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: V.surface2,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: V.borderNeon),
                    ),
                    child: const Center(
                      child: Text('YA TENGO EL JUEGO (OTRA CUENTA)',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                              letterSpacing: 0.6)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              GestureDetector(
                onTap: _owned
                    ? _continue
                    : () {
                        setState(() {
                          _step = 0;
                          _checking = true;
                        });
                        _startScan();
                      },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: _owned
                        ? const LinearGradient(colors: [V.neonLight, V.neon])
                        : null,
                    color: _owned ? null : V.surface2,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: _owned ? V.neon : V.borderNeon),
                  ),
                  child: Center(
                    child: Text(
                      _owned ? 'ENTRAR AL DASHBOARD' : 'REINTENTAR VERIFICACIÓN',
                      style: TextStyle(
                        color: _owned ? V.bg : V.muted,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}