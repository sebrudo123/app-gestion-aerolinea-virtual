import 'package:flutter/material.dart';

class V {
  static const Color bg = Color(0xFF040914);
  static const Color bg2 = Color(0xFF0A1224);
  static const Color surface = Color(0xFF101A2F);
  static const Color surface2 = Color(0xFF0C1527);
  static const Color neon = Color(0xFF007AFF);
  static const Color neonLight = Color(0xFF0A84FF);
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFFFC077);
  static const Color bronze = Color(0xFF8C6D2F);
  static const Color text = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFF9AA3B2);
  static const Color green = Color(0xFF3DDC84);
  static const Color danger = Color(0xFFE05A5A);
  static const Color borderNeon = Color(0x33007AFF);
  static const Color borderGold = Color(0x33D4AF37);
}

class AppTheme {
  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: V.bg,
      colorScheme: ColorScheme.dark(
        primary: V.neon,
        secondary: V.neonLight,
        surface: V.surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: V.text,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: V.text,
        displayColor: V.text,
      ),
    );
  }
}
