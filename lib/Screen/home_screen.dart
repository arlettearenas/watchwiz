import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  String searchText = '';

  @override
  void initState() {
    super.initState();
    _loadRefacciones();
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

  void _deleteRefaccion(String? refaccionId, String? imageUrl) async {
    try {
      // Asegúrate de que refaccionId no sea nulo antes de proceder
      if (refaccionId == null) {
        _showAlert('El ID de la refacción es nulo y no se puede eliminar.');
        return;
      }

      // Si hay una imagen asociada, eliminarla de Firebase Storage
      if (imageUrl != null) {
        try {
          Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
          await imageRef.delete();
          print('Imagen eliminada de Firebase Storage');
        } catch (e) {
          print("Error al eliminar la imagen: $e");
        }
      }

      // Eliminar el documento de Firestore
      await FirebaseFirestore.instance
          .collection('refacciones')
          .doc(refaccionId)
          .delete();
      _loadRefacciones();
      _showAlert('Refacción eliminada.');
    } catch (e) {
      _showAlert('Error al eliminar la refacción: $e');
    }
  }

  Future<String?> uploadImage(XFile imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = storageRef.putFile(File(imageFile.path));

      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  void _showRefaccionDialog(Refaccion? refaccion) {
    final TextEditingController nombreController =
        TextEditingController(text: refaccion?.nombre);
    final TextEditingController caracteristicasController =
        TextEditingController(text: refaccion?.caracteristicas);
    final TextEditingController categoriaController =
        TextEditingController(text: refaccion?.categoria);
    final TextEditingController colorController =
        TextEditingController(text: refaccion?.color);
    final TextEditingController existenciaController =
        TextEditingController(text: refaccion?.existencia.toString());
    final TextEditingController medidaController =
        TextEditingController(text: refaccion?.medida.toString());
    final TextEditingController aceptableController =
        TextEditingController(text: refaccion?.aceptable.toString());
    final TextEditingController precioController =
        TextEditingController(text: refaccion?.precio.toString());

    String? imageUrl = refaccion?.imagen;

    Future<void> pickImage(bool fromCamera) async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
          source: fromCamera ? ImageSource.camera : ImageSource.gallery);

      if (image != null) {
        // Sube la imagen a Firebase Storage
        final uploadedUrl = await uploadImage(image);
        if (uploadedUrl != null) {
          setState(() {
            imageUrl = uploadedUrl; // Actualiza la URL con la imagen subida
          });
        } else {
          _showAlert('Error al subir la imagen.');
        }
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
                      pickImage(result == 1);
                    }
                  },
                  child: imageUrl == null
                      ? const Text('Selecciona una imagen')
                      : Image.network(imageUrl!, height: 100),
                ),
                TextField(
                  controller: nombreController,
                  decoration:
                      const InputDecoration(labelText: 'Nombre de la pieza'),
                ),
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
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: aceptableController,
                  decoration: const InputDecoration(labelText: 'Aceptable'),
                  keyboardType: TextInputType.number,
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
                if (nombreController.text.isEmpty ||
                    caracteristicasController.text.isEmpty ||
                    categoriaController.text.isEmpty ||
                    colorController.text.isEmpty ||
                    existenciaController.text.isEmpty ||
                    medidaController.text.isEmpty ||
                    aceptableController.text.isEmpty ||
                    precioController.text.isEmpty) {
                  _showAlert(
                      'Por favor completa todos los campos antes de guardar.');
                  return;
                }

                int? existencia = int.tryParse(existenciaController.text);
                int? precio = int.tryParse(precioController.text);
                int? medida = int.tryParse(medidaController.text);
                int? aceptable = int.tryParse(aceptableController.text);

                if (existencia == null ||
                    precio == null ||
                    medida == null ||
                    aceptable == null) {
                  _showAlert(
                      'Los campos de existencia, medida y precio deben ser números.');
                  return;
                }

                if (refaccion == null) {
                  // Nueva refacción
                  await FirebaseFirestore.instance
                      .collection('refacciones')
                      .add({
                    'nombre': nombreController.text,
                    'caracteristicas': caracteristicasController.text,
                    'categoria': categoriaController.text,
                    'color': colorController.text,
                    'existencia': existencia,
                    'medida': medida,
                    'aceptable': aceptable,
                    'precio': precio,
                    'imagen': imageUrl, // URL de la imagen subida
                  });
                  Navigator.of(context).pop();
                  _showAlert('Refacción agregada correctamente.');
                } else {
                  // Editar refacción existente
                  await FirebaseFirestore.instance
                      .collection('refacciones')
                      .doc(refaccion.id)
                      .update({
                    'nombre': nombreController.text,
                    'caracteristicas': caracteristicasController.text,
                    'categoria': categoriaController.text,
                    'color': colorController.text,
                    'existencia': existencia,
                    'medida': medida,
                    'aceptable': aceptable,
                    'precio': precio,
                    'imagen': imageUrl, // URL de la imagen subida
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio:
                      3 / 4, // Ajusta la proporción para más espacio vertical
                ),
                itemCount: _refacciones
                    .where((refaccion) =>
                        refaccion.categoria
                            .toLowerCase()
                            .contains(searchText) ||
                        refaccion.nombre.toLowerCase().contains(searchText))
                    .length,
                itemBuilder: (context, index) {
                  final refaccion = _refacciones
                      .where((refaccion) =>
                          refaccion.categoria
                              .toLowerCase()
                              .contains(searchText) ||
                          refaccion.nombre.toLowerCase().contains(searchText))
                      .toList()[index];

                  return Card(
                    elevation: 5, // Sombra para destacar la tarjeta
                    color: const Color.fromARGB(255, 50, 50, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () => _editRefaccion(refaccion),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              child: refaccion.imagen != null
                                  ? Image.network(
                                      refaccion.imagen!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )
                                  : const Icon(
                                      Icons.image,
                                      size: 100,
                                      color: Colors.grey,
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  refaccion.nombre,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.fade,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  refaccion.categoria,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteRefaccion(
                                refaccion.id, refaccion.imagen),
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
        ));
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Información'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
