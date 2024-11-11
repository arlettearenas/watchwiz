import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _clientNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _serviceCostController = TextEditingController();
  final TextEditingController _advanceController = TextEditingController();
  final TextEditingController _remainingController = TextEditingController();

  File? _selectedImage;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Método para seleccionar la fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Método para seleccionar la hora
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Método para seleccionar una imagen desde la galería
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    } else {
      // Opcional: Mostrar mensaje si no se seleccionó ninguna imagen
      print('No se seleccionó ninguna imagen');
    }
  }

  @override
  void initState() {
    super.initState();
    _requestStoragePermission();
  }

  Future<void> _requestStoragePermission() async {
    await Permission.photos.request();
    await Permission.storage.request();
  }

  // Método para guardar el evento en Firestore
  Future<void> _saveEvent() async {
    if (_clientNameController.text.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('El nombre del cliente y la fecha son obligatorios')),
      );
      return;
    }

    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    String formattedTime = _selectedTime != null
        ? _selectedTime!.format(context)
        : 'Hora no especificada';

    await FirebaseFirestore.instance.collection('trabajos').add({
      'client_name': _clientNameController.text,
      'description': _descriptionController.text,
      'phone_number': _phoneNumberController.text,
      'service_cost': int.tryParse(_serviceCostController.text) ?? 0,
      'advance': int.tryParse(_advanceController.text) ?? 0,
      'remaining': int.tryParse(_remainingController.text) ?? 0,
      'photo_path':
          _selectedImage?.path ?? '', // Ruta de la imagen en el dispositivo
      'date': formattedDate,
      'time': formattedTime,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Trabajo'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _clientNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Cliente',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Número de Teléfono',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _serviceCostController,
                decoration: const InputDecoration(
                  labelText: 'Costo del Servicio',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _advanceController,
                decoration: const InputDecoration(
                  labelText: 'Adelanto',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _remainingController,
                decoration: const InputDecoration(
                  labelText: 'Restante',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _selectedImage != null
                      ? Image.file(_selectedImage!, width: 100, height: 100)
                      : const Text(
                          'No se ha seleccionado',
                          style: TextStyle(color: Colors.white),
                        ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Galería'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    _selectedDate == null
                        ? 'Fecha no seleccionada'
                        : 'Fecha: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Seleccionar fecha'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    _selectedTime == null
                        ? 'Hora no seleccionada'
                        : 'Hora: ${_selectedTime!.format(context)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: const Text('Seleccionar hora'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveEvent,
                  child: const Text('Guardar trabajo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
