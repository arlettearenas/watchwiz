// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:watchwiz/Screen/custom_app_bar.dart';
import 'package:watchwiz/Screen/custom_bottom_nav.dart';

class ComprasScreen extends StatelessWidget {
  const ComprasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(), // Llama al AppBar personalizado
      bottomNavigationBar:
          CustomBottomNav(), // Barra de navegación inferior personalizada
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Página de compras',
          style: TextStyle(
            color: Colors.white, // Establece el color del texto a blanco
          ),
        ),
      ),
    );
  }
}
