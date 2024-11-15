import 'package:flutter/material.dart';
import 'package:watchwiz/Screen/custom_app_bar.dart';
import 'package:watchwiz/Screen/custom_bottom_nav.dart';
import 'package:watchwiz/Screen/search_bar.dart';

class TrabajosScreen extends StatefulWidget {
  const TrabajosScreen({super.key});

  @override
  _TrabajosScreenState createState() => _TrabajosScreenState();
}

class _TrabajosScreenState extends State<TrabajosScreen> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(), // Llama al AppBar personalizado
      bottomNavigationBar:
          const CustomBottomNav(), // Barra de navegación inferior personalizada
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Añadimos el buscador al inicio de la columna
          CustomSearchBar(
            onChanged: (value) {
              setState(() {
                searchText = value.toLowerCase();
              });
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
