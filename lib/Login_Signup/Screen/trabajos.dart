import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watchwiz/Login_Signup/Screen/custom_app_bar.dart';
import 'package:watchwiz/Login_Signup/Screen/custom_bottom_nav.dart';

class TrabajosScreen extends StatelessWidget {
  const TrabajosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(), // Llama al AppBar personalizado
      bottomNavigationBar:
          const CustomBottomNav(), // Barra de navegación inferior personalizada
      backgroundColor: Colors.black,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('trabajos').snapshots(),
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
                  leading: trabajo['photo'] != null && trabajo['photo'] != ''
                      ? Image.file(
                          File(trabajo['photo']),
                          width: 100,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image, color: Colors.grey),
                  title: Text(
                    trabajo['client_name'] ?? 'Cliente desconocido',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Costo del servicio: \$${trabajo['service_cost'] ?? 'N/A'}\n'
                    'Adelanto: \$${trabajo['advance'] ?? 'N/A'}\n'
                    'Restante: \$${trabajo['remaining'] ?? 'N/A'}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
