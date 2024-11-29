import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watchwiz/Widget/custom_app_bar.dart';
import 'package:watchwiz/Widget/custom_bottom_nav.dart';
import 'package:watchwiz/Widget/search_bar.dart';
import 'package:watchwiz/models/job.dart';

class TrabajosScreen extends StatefulWidget {
  const TrabajosScreen({super.key});

  @override
  _TrabajosScreenState createState() => _TrabajosScreenState();
}

class _TrabajosScreenState extends State<TrabajosScreen> {
  String searchText = '';
  List<Job> _trabajos = [];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  // Cargar los trabajos de Firebase y ordenarlos por review_date
  void _loadJobs() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('trabajos')
        .orderBy('review_date') // Ordenar por fecha de revisión
        .get();

    setState(() {
      _trabajos = snapshot.docs.map((doc) {
        return Job.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Filtrar los trabajos basados en el texto de búsqueda
  List<Job> getFilteredJobs() {
    return _trabajos.where((job) {
      return job.client_name.toLowerCase().contains(searchText) ||
          job.description.toLowerCase().contains(searchText);
    }).toList();
  }

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
            child: _trabajos.isEmpty
                ? const Center(
                    child:
                        CircularProgressIndicator(), // Indicador de carga mientras se obtienen los datos
                  )
                : ListView.builder(
                    itemCount: getFilteredJobs().length,
                    itemBuilder: (context, index) {
                      final trabajo = getFilteredJobs()[index];
                      return Card(
                        color: Colors.grey[900],
                        child: ListTile(
                          leading: trabajo.photo.isNotEmpty
                              ? Image.network(trabajo.photo,
                                  width: 100, height: 250, fit: BoxFit.cover)
                              : const Icon(Icons.image, color: Colors.white),
                          title: Text(
                            trabajo.client_name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            trabajo.description,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
