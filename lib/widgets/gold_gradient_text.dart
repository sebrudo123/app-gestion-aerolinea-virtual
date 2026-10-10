import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GoldGradientText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final double spacing;

  const GoldGradientText(
    this.text, {
    super.key,
    this.size = 22,
    this.weight = FontWeight.w800,
    this.spacing = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => const LinearGradient(
        colors: [V.goldLight, V.gold, V.bronze],
      ).createShader(rect),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: size,
          fontWeight: weight,
          letterSpacing: spacing,
        ),
      ),
    );
  }
}
