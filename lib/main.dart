import "dart:async";
import "package:flutter/material.dart";

void main() {
  runApp(const VertexApp());
}

class V {
  static const Color bg = Color(0xFF090E17);
  static const Color gold = Color(0xFFD4AF37);
  static const Color text = Color(0xFFFFFFFF);
}

class VertexApp extends StatelessWidget {
  const VertexApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Vertex Airlines",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: Center(child: Text("Vertex Airlines")),
      ),
    );
  }
}
