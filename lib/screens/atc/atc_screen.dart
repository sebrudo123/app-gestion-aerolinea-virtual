import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class AtcScreen extends StatelessWidget {
  const AtcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ATC Virtual Integrado', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            GradientCard(child: Text('Frecuencias: GND • TWR • APP • CTR • COMMS texto/voz', style: TextStyle(color: V.muted))),
          ],
        ),
      ),
    );
  }
}
