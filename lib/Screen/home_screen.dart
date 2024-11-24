import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:watchwiz/Widget/custom_app_bar.dart';
import 'package:watchwiz/Widget/custom_bottom_nav.dart';
import 'package:watchwiz/Widget/search_bar.dart';
import 'package:watchwiz/models/refacciones.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Refaccion> _refacciones = [];
  String searchText = ''; // Variable para almacenar el texto de búsqueda

  @override
  void initState() {
    super.initState();
    _loadRefacciones(); // Carga las refacciones al iniciar
  }

  void _loadRefacciones() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('refacciones').get();
    setState(() {
      _refacciones =
          snapshot.docs.map((doc) => Refaccion.fromFirestore(doc)).toList();
    });
  }

  void _addRefaccion() {
    _showRefaccionDialog(null);
  }

  void _editRefaccion(Refaccion refaccion) {
    _showRefaccionDialog(refaccion);
  }

  // ignore: unused_element
  void _deleteRefaccion(String refaccionId) async {
    await FirebaseFirestore.instance
        .collection('refacciones')
        .doc(refaccionId)
        .delete();
    _loadRefacciones();
    _showAlert('Refacción eliminada.');
  }

  void _showRefaccionDialog(Refaccion? refaccion) {
    final TextEditingController caracteristicasController =
        TextEditingController(text: refaccion?.caracteristicas);
    final TextEditingController categoriaController =
        TextEditingController(text: refaccion?.categoria);
    final TextEditingController colorController =
        TextEditingController(text: refaccion?.color);
    final TextEditingController existenciaController =
        TextEditingController(text: refaccion?.existencia.toString());
    final TextEditingController medidaController =
        TextEditingController(text: refaccion?.medida);
    final TextEditingController precioController =
        TextEditingController(text: refaccion?.precio.toString());

    File? _imageFile = refaccion != null && refaccion.imagen != null
        ? File(refaccion.imagen!)
        : null;

    Future<void> _pickImage(bool fromCamera) async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
          source: fromCamera ? ImageSource.camera : ImageSource.gallery);

      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
              refaccion == null ? 'Agregar Refacción' : 'Editar Refacción'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final result = await showModalBottomSheet<int>(
                      context: context,
                      builder: (BuildContext context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Tomar foto'),
                              onTap: () => Navigator.pop(context, 1),
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo),
                              title: const Text('Elegir de galería'),
                              onTap: () => Navigator.pop(context, 2),
                            ),
                          ],
                        );
                      },
                    );

                    if (result != null) {
                      _pickImage(result == 1);
                    }
                  },
                  child: _imageFile == null
                      ? const Icon(Icons.image, size: 100, color: Colors.grey)
                      : Image.file(_imageFile!, height: 100),
                ),
                const Text('Agrega la imagen'),
                TextField(
                  controller: caracteristicasController,
                  decoration:
                      const InputDecoration(labelText: 'Características'),
                ),
                TextField(
                  controller: categoriaController,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                ),
                TextField(
                  controller: colorController,
                  decoration: const InputDecoration(labelText: 'Color'),
                ),
                TextField(
                  controller: existenciaController,
                  decoration: const InputDecoration(labelText: 'Existencia'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: medidaController,
                  decoration: const InputDecoration(labelText: 'Medida'),
                ),
                TextField(
                  controller: precioController,
                  decoration: const InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Guardar'),
              onPressed: () async {
                if (caracteristicasController.text.isEmpty ||
                    categoriaController.text.isEmpty ||
                    colorController.text.isEmpty ||
                    existenciaController.text.isEmpty ||
                    medidaController.text.isEmpty ||
                    precioController.text.isEmpty) {
                  _showAlert(
                      'Por favor completa todos los campos antes de guardar.');
                  return;
                }

                double? existencia = double.tryParse(existenciaController.text);
                double? precio = double.tryParse(precioController.text);

                if (existencia == null || precio == null) {
                  _showAlert(
                      'Los campos de existencia y precio deben ser números.');
                  return;
                }

                String? imagePath = _imageFile?.path ?? refaccion?.imagen;

                if (refaccion == null) {
                  Refaccion newRefaccion = Refaccion(
                    caracteristicas: caracteristicasController.text,
                    categoria: categoriaController.text,
                    color: colorController.text,
                    existencia: existencia,
                    medida: medidaController.text,
                    precio: precio,
                    imagen: imagePath,
                  );
                  await FirebaseFirestore.instance
                      .collection('refacciones')
                      .add(newRefaccion.toMap());
                  Navigator.of(context).pop();
                  _showAlert('Refacción agregada correctamente.');
                } else {
                  await FirebaseFirestore.instance
                      .collection('refacciones')
                      .doc(refaccion.id)
                      .update({
                    'caracteristicas': caracteristicasController.text,
                    'categoria': categoriaController.text,
                    'color': colorController.text,
                    'existencia': existencia,
                    'medida': medidaController.text,
                    'precio': precio,
                    'imagen': imagePath,
                  });
                  Navigator.of(context).pop();
                  _showAlert('Refacción editada correctamente.');
                }

                _loadRefacciones();
              },
            ),
          ],
        );
      },
    );
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
          CustomSearchBar(
            onChanged: (value) {
              setState(() {
                searchText = value.toLowerCase();
              });
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _refacciones
                  .where((refaccion) =>
                      refaccion.caracteristicas
                          .toLowerCase()
                          .contains(searchText) ||
                      refaccion.categoria.toLowerCase().contains(searchText))
                  .length,
              itemBuilder: (context, index) {
                final refaccion = _refacciones
                    .where((refaccion) =>
                        refaccion.caracteristicas
                            .toLowerCase()
                            .contains(searchText) ||
                        refaccion.categoria.toLowerCase().contains(searchText))
                    .toList()[index];

                return Card(
                  color: const Color.fromARGB(255, 42, 42, 42),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () => _editRefaccion(refaccion),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        refaccion.imagen != null
                            ? Image.file(
                                File(refaccion.imagen!),
                                height: 120, // Limitar la altura
                                width: MediaQuery.of(context).size.width /
                                    2, // Ajustar al 50% del ancho
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.image, size: 100),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            refaccion.categoria,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '\$${refaccion.precio}',
                            style: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: _addRefaccion,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Aviso'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
