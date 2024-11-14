import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditEventScreen extends StatefulWidget {
  final String eventId;
  EditEventScreen({required this.eventId});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController serviceCostController = TextEditingController();
  final TextEditingController advanceController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _loadEventData();
  }

  // Cargar los datos del evento desde Firestore
  Future<void> _loadEventData() async {
    DocumentSnapshot eventDoc = await FirebaseFirestore.instance
        .collection('trabajos')
        .doc(widget.eventId)
        .get();

    setState(() {
      clientNameController.text = eventDoc['client_name'];
      descriptionController.text = eventDoc['description'];
      phoneNumberController.text = eventDoc['phone_number'];
      serviceCostController.text = eventDoc['service_cost'].toString();
      advanceController.text = eventDoc['advance'].toString();
      selectedDate = DateTime.parse(eventDoc['date']);
    });
  }

  // Guardar los cambios en Firestore
  Future<void> _updateEvent() async {
    try {
      await FirebaseFirestore.instance
          .collection('trabajos')
          .doc(widget.eventId)
          .update({
        'client_name': clientNameController.text,
        'description': descriptionController.text,
        'phone_number': phoneNumberController.text,
        'service_cost': int.tryParse(serviceCostController.text) ?? 0,
        'advance': int.tryParse(advanceController.text) ?? 0,
        'remaining': (int.tryParse(serviceCostController.text) ?? 0) -
            (int.tryParse(advanceController.text) ?? 0),
        'date': selectedDate?.toIso8601String() ?? '',
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento actualizado con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el evento: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Evento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: clientNameController,
              decoration:
                  const InputDecoration(labelText: 'Nombre del Cliente'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: phoneNumberController,
              decoration:
                  const InputDecoration(labelText: 'Número de Teléfono'),
            ),
            TextField(
              controller: serviceCostController,
              decoration:
                  const InputDecoration(labelText: 'Costo del Servicio'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: advanceController,
              decoration: const InputDecoration(labelText: 'Anticipo'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateEvent,
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
