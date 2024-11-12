import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class AddEventController {
  final TextEditingController clientNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController serviceCostController = TextEditingController();
  final TextEditingController advanceController = TextEditingController();
  File? selectedImage;
  DateTime? selectedDate;

  // Selección de fecha
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      selectedDate = picked;
    }
  }

  // Selección de imagen desde galería
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
    }
  }

  // Solicitud de permisos
  Future<void> requestStoragePermission() async {
    await Permission.photos.request();
    await Permission.storage.request();
  }

  // Guardado de evento en Firestore
  Future<void> saveEvent(BuildContext context) async {
    if (clientNameController.text.isEmpty || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('El nombre del cliente y la fecha son obligatorios')),
      );
      return;
    }

    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
    int serviceCost = int.tryParse(serviceCostController.text) ?? 0;
    int advance = int.tryParse(advanceController.text) ?? 0;
    int remaining = serviceCost - advance;

    await FirebaseFirestore.instance.collection('trabajos').add({
      'client_name': clientNameController.text,
      'description': descriptionController.text,
      'phone_number': phoneNumberController.text,
      'service_cost': serviceCost,
      'advance': advance,
      'remaining': remaining,
      'photo': selectedImage?.path ?? '',
      'date': formattedDate,
    });

    Navigator.pop(context);
  }
}
