import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class ConnectAccountScreen extends StatelessWidget {
  const ConnectAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conectar Cuenta', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            GradientCard(
              padding: const EdgeInsets.all(18),
              child: const Column(
                children: [
                  Icon(Icons.sports_esports_rounded, color: V.green, size: 42),
                  SizedBox(height: 8),
                  Text('Xbox Live', style: TextStyle(fontWeight: FontWeight.w800)),
                  SizedBox(height: 2),
                  Text('Vincula tu ID único de Xbox', style: TextStyle(color: V.muted, fontSize: 11)),
                  SizedBox(height: 12),
                  _LinkChip('VINCULAR CUENTA XBOX', V.green),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GradientCard(
              padding: const EdgeInsets.all(18),
              child: const Column(
                children: [
                  Icon(Icons.games_rounded, color: V.neon, size: 42),
                  SizedBox(height: 8),
                  Text('Steam', style: TextStyle(fontWeight: FontWeight.w800)),
                  SizedBox(height: 2),
                  Text('Vincula tu cuenta de Steam', style: TextStyle(color: V.muted, fontSize: 11)),
                  SizedBox(height: 12),
                  _LinkChip('VINCULAR CUENTA STEAM', V.neon),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('La cuenta se asocia al ID único del usuario en la base de datos.',
                style: TextStyle(color: V.muted, fontSize: 11, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}

class _LinkChip extends StatelessWidget {
  final String t;
  final Color c;
  const _LinkChip(this.t, this.c);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [c.withOpacity(0.9), c.withOpacity(0.7)]), borderRadius: BorderRadius.circular(12)),
      child: Text(t, style: const TextStyle(color: V.bg, fontWeight: FontWeight.w900, letterSpacing: 0.6)),
    );
  }
}