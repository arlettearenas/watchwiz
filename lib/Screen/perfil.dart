import 'package:flutter/material.dart';
import 'package:watchwiz/Services/authentication.dart';
import 'package:watchwiz/Widget/button.dart';
import 'package:watchwiz/Screen/custom_app_bar.dart';
import 'package:watchwiz/Screen/custom_bottom_nav.dart';
import 'package:watchwiz/Screen/login.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(), // Llama al AppBar personalizado
      bottomNavigationBar:
          const CustomBottomNav(), // Barra de navegación inferior personalizada
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Página de perfil',
              style: TextStyle(
                color: Colors.white, // Establece el color del texto a blanco
              ),
            ),
            const SizedBox(height: 20), // Espacio entre el texto y el botón
            MyButton(
              onTab: () async {
                await AuthServices().signOut();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              text: "Cerrar Sesión",
            ),
          ],
        ),
      ),
    );
  }
}
