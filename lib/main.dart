import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const VertexApp());
}

class VertexApp extends StatelessWidget {
  const VertexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vertex Airlines',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
