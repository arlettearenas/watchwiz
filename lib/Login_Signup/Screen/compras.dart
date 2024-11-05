import 'package:flutter/material.dart';

class ComprasScreen extends StatelessWidget {
  const ComprasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trabajos'),
      ),
      body: const Center(
        child: Text('Página de Trabajos'),
      ),
    );
  }
}
