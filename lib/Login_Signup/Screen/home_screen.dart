import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watchwiz/Login_Signup/Screen/login.dart';
import 'package:watchwiz/Login_Signup/Services/authentication.dart';
import 'package:watchwiz/Login_Signup/Widget/button.dart';
import 'custom_app_bar.dart';
import 'custom_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(), // Llama al AppBar personalizado
      bottomNavigationBar:
          const CustomBottomNav(), // Barra de navegación inferior personalizada
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Bienvenido a WatchWiz",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('trabajos').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay trabajos disponibles',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                var trabajos = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: trabajos.length,
                  itemBuilder: (context, index) {
                    var trabajo = trabajos[index];
                    return Card(
                      color: Colors.grey[900],
                      child: ListTile(
                        leading: trabajo['photo'] != null
                            ? Image.network(trabajo['photo'],
                                width: 50, height: 50)
                            : const Icon(Icons.image, color: Colors.grey),
                        title: Text(
                          trabajo['client_name'] ?? 'Cliente desconocido',
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Costo del servicio: \$${trabajo['service_cost'] ?? 'N/A'}\nAdelanto: \$${trabajo['advance'] ?? 'N/A'}\nRestante: \$${trabajo['remaining'] ?? 'N/A'}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 20),
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
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
