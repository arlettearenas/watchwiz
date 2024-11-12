// add_event_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'add_event_controller.dart';
import 'add_event_styles.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final AddEventController _controller = AddEventController();

  @override
  void initState() {
    super.initState();
    _controller.requestStoragePermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_controller.clientNameController,
                  'Nombre del Cliente', Icons.person),
              const SizedBox(height: 15),
              _buildTextField(_controller.descriptionController, 'Descripción',
                  Icons.description),
              const SizedBox(height: 15),
              _buildTextField(_controller.phoneNumberController,
                  'Número de Teléfono', Icons.phone, TextInputType.phone),
              const SizedBox(height: 15),
              _buildTextField(
                  _controller.serviceCostController,
                  'Costo del Servicio',
                  Icons.monetization_on,
                  TextInputType.number),
              const SizedBox(height: 15),
              _buildTextField(_controller.advanceController, 'Adelanto',
                  Icons.payment, TextInputType.number),
              const SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await _controller.pickImage();
                      setState(() {}); // Actualiza la imagen seleccionada
                    },
                    style: elevatedButtonStyle,
                    child: const Icon(Icons.image, size: 50),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    _controller.selectedDate == null
                        ? ''
                        : DateFormat('yyyy-MM-dd')
                            .format(_controller.selectedDate!),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await _controller.selectDate(context);
                      setState(() {}); // Actualiza la fecha seleccionada
                    },
                    style: elevatedButtonStyle,
                    child: const Text('Seleccionar fecha'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => _controller.saveEvent(context),
                  style: elevatedButtonStyle,
                  child: const Text('Crear'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para construir campos de texto personalizados
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, [
    TextInputType keyboardType = TextInputType.text,
  ]) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: textFieldDecoration(label, icon),
    );
  }
}
