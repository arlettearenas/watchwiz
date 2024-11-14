import 'package:flutter/material.dart';

final darkBackground = Colors.grey[900];
final elevatedButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: const Color.fromARGB(255, 18, 17, 17),
  backgroundColor: const Color.fromARGB(255, 22, 114, 207),
  padding: const EdgeInsets.symmetric(horizontal: 16),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
);

InputDecoration textFieldDecoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.white),
    prefixIcon: Icon(icon, color: Colors.blueAccent),
    filled: true,
    fillColor: Colors.grey[800],
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.lightBlue, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
