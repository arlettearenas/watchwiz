import 'package:cloud_firestore/cloud_firestore.dart';

class Refaccion {
  final String? id;
  final String nombre;
  final String caracteristicas;
  final String categoria;
  final String color;
  final int existencia;
  final int medida;
  final int aceptable;
  final int precio;
  final String? imagen;

  Refaccion({
    this.id,
    required this.nombre,
    required this.caracteristicas,
    required this.categoria,
    required this.color,
    required this.existencia,
    required this.medida,
    required this.aceptable,
    required this.precio,
    this.imagen,
  });

  // Método para convertir un documento de Firestore en un objeto Refaccion
  factory Refaccion.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Refaccion(
      id: doc.id,
      nombre: data['nombre'] ?? 'Sin nombre',
      caracteristicas: data['caracteristicas'] ?? '',
      categoria: data['categoria'] ?? '',
      color: data['color'] ?? '',
      existencia: (data['existencia'] is double)
          ? (data['existencia'] as double).toInt()
          : data['existencia'] as int,
      medida: (data['medida'] is double)
          ? (data['medida'] as double).toInt()
          : int.tryParse(data['medida'].toString()) ?? 0,
      aceptable: (data['aceptable'] is double)
          ? (data['aceptable'] as double).toInt()
          : data['aceptable'] as int,
      precio: (data['precio'] is double)
          ? (data['precio'] as double).toInt() // Convertir de double a int
          : data['precio'] as int,
      imagen: data['imagen'],
    );
  }

  // Método para convertir un objeto Refaccion a un mapa para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'caracteristicas': caracteristicas,
      'categoria': categoria,
      'color': color,
      'existencia': existencia,
      'medida': medida,
      'aceptable': aceptable,
      'precio': precio,
      'imagen': imagen,
    };
  }
}
