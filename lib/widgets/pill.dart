import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Pill extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;

  const Pill({
    required this.label,
    super.key,
    this.color = V.gold,
    this.bg = const Color(0x30D4AF37),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
