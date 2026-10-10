import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/gradient_card.dart';

class SimBriefScreen extends StatelessWidget {
  const SimBriefScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SimBrief / ACARS Dispatch', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [V.bg2, V.bg])),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            GradientCard(child: Text('Importación de OFP (ZFW, Block Fuel, Cost Index, ruta)', style: TextStyle(color: V.muted))),
          ],
        ),
      ),
    );
  }
}
