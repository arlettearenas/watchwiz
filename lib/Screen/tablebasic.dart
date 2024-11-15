import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:watchwiz/Screen/custom_app_bar.dart';
import 'package:watchwiz/Screen/custom_bottom_nav.dart';

class TableBasicsExample extends StatefulWidget {
  const TableBasicsExample({super.key});

  @override
  _TableBasicsExampleState createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  List<Map<String, dynamic>> _trabajos = [];

  @override
  void initState() {
    super.initState();
    _loadEvents(_selectedDay); // Carga los eventos del día actual
  }

  void _loadEvents(DateTime date) async {
    String dateKey = "${date.year}-${date.month}-${date.day}";
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('trabajos')
        .where('date', isEqualTo: dateKey)
        .get();

    setState(() {
      _trabajos = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Agrega el ID del documento para editar/borrar
        return data;
      }).toList();
    });
  }

  Future<void> _showAlert(String message) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Información'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _addJob() {
    _showJobDialog(null);
  }

  void _editJob(Map<String, dynamic> job) {
    _showJobDialog(job);
  }

  void _showJobDialog(Map<String, dynamic>? job) {
    final TextEditingController clientNameController =
        TextEditingController(text: job?['client_name']);
    final TextEditingController descriptionController =
        TextEditingController(text: job?['description']);
    final TextEditingController phoneNumberController =
        TextEditingController(text: job?['phone_number']);
    final TextEditingController advanceController =
        TextEditingController(text: job?['advance']?.toString());
    final TextEditingController serviceCostController =
        TextEditingController(text: job?['service_cost']?.toString());

    // Inicializar _imageFile con la imagen previa si existe
    File? _imageFile =
        job != null && job['photo'] != null ? File(job['photo']) : null;

    Future<void> _pickImage(bool fromCamera) async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(job == null ? 'Agregar Trabajo' : 'Editar Trabajo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final result = await showModalBottomSheet<int>(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Tomar foto'),
                              onTap: () => Navigator.pop(context, 1),
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo),
                              title: const Text('Elegir de galería'),
                              onTap: () => Navigator.pop(context, 2),
                            ),
                          ],
                        );
                      },
                    );

                    if (result != null) {
                      _pickImage(result == 1);
                    }
                  },
                  child: _imageFile == null
                      ? const Icon(Icons.image, size: 100, color: Colors.grey)
                      : Image.file(_imageFile!, height: 100),
                ),
                const Text('Agrega la imagen'),
                TextField(
                  controller: clientNameController,
                  decoration:
                      const InputDecoration(labelText: 'Nombre del cliente'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                TextField(
                  controller: phoneNumberController,
                  decoration:
                      const InputDecoration(labelText: 'Número de teléfono'),
                ),
                TextField(
                  controller: serviceCostController,
                  decoration:
                      const InputDecoration(labelText: 'Costo del servicio'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: advanceController,
                  decoration: const InputDecoration(labelText: 'Anticipo'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Guardar'),
              onPressed: () async {
                if (clientNameController.text.isEmpty ||
                    descriptionController.text.isEmpty ||
                    phoneNumberController.text.isEmpty ||
                    advanceController.text.isEmpty ||
                    serviceCostController.text.isEmpty) {
                  _showAlert(
                      'Por favor completa todos los campos antes de guardar.');
                  return;
                }

                double? advance = double.tryParse(advanceController.text);
                double? serviceCost =
                    double.tryParse(serviceCostController.text);

                if (advance == null || serviceCost == null) {
                  _showAlert(
                      'Los campos de anticipo y costo deben ser números.');
                  return;
                }

                double remaining = serviceCost - advance;
                final dateKey =
                    "${_selectedDay.year}-${_selectedDay.month}-${_selectedDay.day}";

                // Usar la ruta de la imagen anterior si no se selecciona una nueva imagen
                String? imagePath = _imageFile?.path ?? job?['photo'];

                if (job == null) {
                  await FirebaseFirestore.instance.collection('trabajos').add({
                    'client_name': clientNameController.text,
                    'description': descriptionController.text,
                    'phone_number': phoneNumberController.text,
                    'advance': advance,
                    'service_cost': serviceCost,
                    'remaining': remaining,
                    'date': dateKey,
                    'photo': imagePath,
                  });

                  Navigator.of(context).pop();
                  _showAlert('Trabajo agregado correctamente.');
                } else {
                  await FirebaseFirestore.instance
                      .collection('trabajos')
                      .doc(job['id'])
                      .update({
                    'client_name': clientNameController.text,
                    'description': descriptionController.text,
                    'phone_number': phoneNumberController.text,
                    'advance': advance,
                    'service_cost': serviceCost,
                    'remaining': remaining,
                    'photo': imagePath,
                  });

                  Navigator.of(context).pop();
                  _showAlert('Trabajo editado correctamente.');
                }

                _loadEvents(_selectedDay);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteJob(String jobId) async {
    await FirebaseFirestore.instance.collection('trabajos').doc(jobId).delete();
    _loadEvents(_selectedDay);
    _showAlert('Trabajo eliminado.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      bottomNavigationBar: const CustomBottomNav(),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
              _loadEvents(selectedDay);
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
              weekendTextStyle: TextStyle(color: Colors.red),
              defaultTextStyle: TextStyle(color: Colors.white),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleTextStyle: TextStyle(color: Colors.white),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _trabajos.isEmpty
                ? const Center(
                    child: Text(
                      "No hay trabajos para este día",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: _trabajos.length,
                    itemBuilder: (context, index) {
                      final trabajo = _trabajos[index];
                      return Card(
                        color: Colors.grey[900],
                        child: ListTile(
                          leading: trabajo['photo'] != null
                              ? Image.file(File(trabajo['photo']),
                                  width: 50, height: 50, fit: BoxFit.cover)
                              : const Icon(Icons.image, color: Colors.grey),
                          title: Text(trabajo['client_name'],
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text(trabajo['description'],
                              style: const TextStyle(color: Colors.white)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editJob(trabajo),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteJob(trabajo['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addJob,
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
