import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para manejar la fecha fácilmente
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

  // Formato de fecha para la comparación
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

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

  // Función para asegurarse de que la fecha siempre tenga dos dígitos para el día y el mes
  String formatDateString(String date) {
    final parts = date.split('-');
    if (parts.length == 3) {
      String day = parts[2];
      String month = parts[1];
      String year = parts[0];

      // Asegurarse de que el día y el mes tengan dos dígitos
      if (day.length == 1) {
        day = '0$day';
      }
      if (month.length == 1) {
        month = '0$month';
      }

      return '$year-$month-$day'; // Devuelve la fecha con formato 'yyyy-MM-dd'
    }
    return date;
  }

  // Función para obtener la fecha de hoy en formato 'yyyy-MM-dd'
  String getTodayDate() {
    return _dateFormat.format(DateTime.now());
  }

  // Función para obtener la fecha de mañana en formato 'yyyy-MM-dd'
  String getTomorrowDate() {
    return _dateFormat.format(DateTime.now().add(Duration(days: 1)));
  }

  // Función para obtener el estado del trabajo según su fecha
  String getJobStatus(String reviewDate) {
    final today = getTodayDate();
    final tomorrow = getTomorrowDate();

    final formattedReviewDate =
        formatDateString(reviewDate); // Formatear la fecha de revisión

    if (formattedReviewDate == today) {
      return 'Para hoy';
    } else if (formattedReviewDate == tomorrow) {
      return 'Para mañana';
    } else if (DateTime.parse(formattedReviewDate).isAfter(DateTime.now())) {
      return 'Para los siguientes días';
    } else {
      return 'Pasado';
    }
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
                : ListView(
                    children: [
                      _buildJobSection(
                          'Hoy',
                          getFilteredJobs()
                              .where((job) =>
                                  getJobStatus(job.review_date) == 'Para hoy')
                              .toList()),
                      _buildJobSection(
                          'Mañana',
                          getFilteredJobs()
                              .where((job) =>
                                  getJobStatus(job.review_date) ==
                                  'Para mañana')
                              .toList()),
                      _buildJobSection(
                          'Para los siguientes días',
                          getFilteredJobs()
                              .where((job) =>
                                  getJobStatus(job.review_date) ==
                                  'Para los siguientes días')
                              .toList()),
                      _buildJobSection(
                          'Pasado',
                          getFilteredJobs()
                              .where((job) =>
                                  getJobStatus(job.review_date) == 'Pasado')
                              .toList()),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // Método para construir cada sección de trabajos por estado
  Widget _buildJobSection(String status, List<Job> jobs) {
    return jobs.isEmpty
        ? const SizedBox() // Si no hay trabajos para ese estado, no se muestra nada
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  status, // Muestra el título de la sección (estado del trabajo)
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final trabajo = jobs[index];
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trabajo.description,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
  }
}
