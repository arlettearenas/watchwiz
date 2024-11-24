import 'package:cloud_firestore/cloud_firestore.dart';

class Refaccion {
  String? id;
  String caracteristicas;
  String categoria;
  String color;
  double existencia;
  String medida;
  double precio;
  String? imagen;

  Refaccion({
    this.id,
    required this.caracteristicas,
    required this.categoria,
    required this.color,
    required this.existencia,
    required this.medida,
    required this.precio,
    this.imagen,
  });

  // Método para convertir un documento de Firestore en un objeto Refaccion
  factory Refaccion.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Refaccion(
      id: doc.id,
      caracteristicas: data['caracteristicas'],
      categoria: data['categoria'],
      color: data['color'],
      existencia: data['existencia'],
      medida: data['medida'],
      precio: data['precio'],
      imagen: data['imagen'],
    );
  }

  // Método para convertir un objeto Refaccion a un mapa para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'caracteristicas': caracteristicas,
      'categoria': categoria,
      'color': color,
      'existencia': existencia,
      'medida': medida,
      'precio': precio,
      'imagen': imagen,
    };
  }
}
