import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool useGoldBorder;

  const GradientCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(18),
    this.radius = 22,
    this.useGoldBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [V.surface, V.surface2],
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: useGoldBorder ? V.borderGold : Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
