import 'package:flutter/material.dart';

class V {
  static const Color bg = Color(0xFF090E17);
  static const Color bg2 = Color(0xFF0B132B);
  static const Color surface = Color(0xFF1C2541);
  static const Color surface2 = Color(0xFF141B2E);
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldLight = Color(0xFFFFC077);
  static const Color bronze = Color(0xFF8C6D2F);
  static const Color text = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFF9AA3B2);
  static const Color green = Color(0xFF3DDC84);
  static const Color danger = Color(0xFFE05A5A);
  static const Color borderGold = Color(0x33D4AF37);
}

class AppTheme {
  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: V.bg,
      colorScheme: ColorScheme.dark(
        primary: V.gold,
        secondary: V.goldLight,
        surface: V.surface,
        background: V.bg,
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
