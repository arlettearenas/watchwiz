// add_event_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Services/event_controller.dart';
import 'add_event_styles.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final EventController _controller = EventController();

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
              _buildTextLabel('Nombre del Cliente'),
              _buildTextField(_controller.clientNameController),
              const SizedBox(height: 15),
              _buildTextLabel('Descripción'),
              _buildTextField(_controller.descriptionController),
              const SizedBox(height: 15),
              _buildTextLabel('Número de Teléfono'),
              _buildTextField(
                  _controller.phoneNumberController, TextInputType.phone),
              const SizedBox(height: 15),
              _buildTextLabel('Costo del Servicio'),
              _buildTextField(
                  _controller.serviceCostController, TextInputType.number),
              const SizedBox(height: 15),
              _buildTextLabel('Adelanto'),
              _buildTextField(
                  _controller.advanceController, TextInputType.number),
              const SizedBox(height: 20),
              const Text(
                "Foto de la reparación:",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _controller.pickImage();
                    setState(() {}); // Actualiza la imagen seleccionada
                  },
                  style: elevatedButtonStyle,
                  child: const Icon(Icons.image, color: Colors.white, size: 50),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
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
                      child: const Text('Fecha',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => _controller.saveEvent(context),
                  style: elevatedButtonStyle,
                  child: const Text('Crear',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para construir etiquetas de texto con estilo uniforme
  Widget _buildTextLabel(String label) {
    return Text(
      label,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    );
  }

  // Widget para construir campos de texto personalizados
  Widget _buildTextField(
    TextEditingController controller, [
    TextInputType keyboardType = TextInputType.text,
  ]) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: textFieldDecoration(''), // Elimina label en el decorador
    );
  }
}
