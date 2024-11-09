// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:watchwiz/Login_Signup/Screen/compras.dart';
import 'package:watchwiz/Login_Signup/Screen/perfil.dart';
import 'package:watchwiz/Login_Signup/Screen/trabajos.dart';

import 'home_screen.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomBottomNavState createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navega a la pantalla correspondiente según el índice seleccionado
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TrabajosScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ComprasScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PerfilScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType
          .fixed, // Asegura que el fondo negro se mantenga
      backgroundColor: Colors.black,
      selectedItemColor: Colors.blue, // Íconos seleccionados en color azul
      unselectedItemColor: Colors.grey, // Íconos no seleccionados en color gris
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Trabajos'),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart), label: 'Compras'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}
