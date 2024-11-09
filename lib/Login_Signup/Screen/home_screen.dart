import 'package:flutter/material.dart';

import 'custom_app_bar.dart';
import 'custom_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(), // Llama al AppBar personalizado
      bottomNavigationBar:
          CustomBottomNav(), // Barra de navegación inferior personalizada
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "Bienvenido a WatchWiz",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
