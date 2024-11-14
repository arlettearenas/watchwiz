import 'package:flutter/material.dart';

final darkBackground = Colors.grey[900];
final elevatedButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: const Color.fromARGB(255, 162, 204, 247),
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
      borderSide: const BorderSide(color: Color.fromARGB(255, 74, 78, 195), width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
