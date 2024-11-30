import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:watchwiz/Widget/custom_app_bar.dart';
import 'package:watchwiz/Widget/custom_bottom_nav.dart';
import 'package:watchwiz/models/refacciones.dart';

class ComprasScreen extends StatefulWidget {
  const ComprasScreen({super.key});

  @override
  _ComprasScreenState createState() => _ComprasScreenState();
}

class _ComprasScreenState extends State<ComprasScreen> {
  List<Refaccion> _refaccionesParaComprar = [];
  Map<String, bool> _seleccionados = {};

  @override
  void initState() {
    super.initState();
    _loadRefacciones();
  }

  void _loadRefacciones() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('refacciones').get();
    setState(() {
      _refaccionesParaComprar = snapshot.docs
          .map((doc) => Refaccion.fromFirestore(doc))
          .where((refaccion) =>
              refaccion.existencia < refaccion.aceptable) // Condición
          .toList();
      // Inicializar el mapa de seleccionados
      _seleccionados = {
        for (var refaccion in _refaccionesParaComprar) refaccion.id!: false
      };
    });
  }

  void _onChanged(bool? value, String id) {
    setState(() {
      _seleccionados[id] = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      bottomNavigationBar: const CustomBottomNav(),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Refacciones para comprar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _refaccionesParaComprar.length,
              itemBuilder: (context, index) {
                final refaccion = _refaccionesParaComprar[index];
                return Card(
                  color: const Color.fromARGB(255, 42, 42, 42),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    leading: Icon(
                      _seleccionados[refaccion.id] == true
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: Colors.white,
                    ),
                    title: Text(
                      refaccion.categoria,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Existencia: ${refaccion.existencia}\nAceptable: ${refaccion.aceptable}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      _onChanged(!_seleccionados[refaccion.id]!, refaccion.id!);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
