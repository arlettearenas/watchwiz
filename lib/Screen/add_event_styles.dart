import 'package:flutter/material.dart';

final darkBackground = Colors.grey[850]; // Fondo oscuro
final elevatedButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blue[800],
  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
);

final dateButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.blue[800],
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
);

InputDecoration textFieldDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.white),
    filled: true,
    fillColor: Colors.grey[850],
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 1.5),
    ),
  );
}
