import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watchwiz/Screen/custom_app_bar.dart';
import 'package:watchwiz/Screen/custom_bottom_nav.dart';
import 'package:watchwiz/Screen/edit_event_screen.dart'; // Asegúrate de tener esta pantalla
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

                var trabajos = snapshot.data!.docs.where((doc) {
                  var clientName =
                      (doc['client_name'] ?? '').toString().toLowerCase();
                  return clientName.contains(searchText);
                }).toList();

                if (trabajos.isEmpty) {
                  return const Center(
                    child: Text(
                      'No se encontraron trabajos',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: trabajos.length,
                  itemBuilder: (context, index) {
                    var trabajo = trabajos[index];
                    String documentId = trabajo.id; // Obtén el ID del documento

                    return Card(
                      color: Colors.grey[900],
                      child: ListTile(
                        leading:
                            trabajo['photo'] != null && trabajo['photo'] != ''
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
                        trailing: IconButton(
                          icon:
                              const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            _deleteEvent(documentId); // Eliminar evento
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditEventScreen(eventId: documentId),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Eliminar un evento
  Future<void> _deleteEvent(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('trabajos')
          .doc(documentId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento eliminado con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el evento: $e')),
      );
    }
  }
}
