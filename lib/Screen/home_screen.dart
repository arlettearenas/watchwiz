import 'package:flutter/material.dart';

import 'custom_app_bar.dart';
import 'custom_bottom_nav.dart';
import 'search_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      bottomNavigationBar: CustomBottomNav(),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: 20),
          // Llamada al buscador personalizado
          CustomSearchBar(),
          SizedBox(height: 20),
          // Aquí puedes agregar más contenido si es necesario
        ],
      ),
    );
  }
}
