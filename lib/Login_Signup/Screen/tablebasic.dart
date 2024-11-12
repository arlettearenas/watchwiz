import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:watchwiz/Login_Signup/Screen/add_event.dart';
import 'package:watchwiz/Login_Signup/Screen/custom_app_bar.dart';
import 'package:watchwiz/Login_Signup/Screen/custom_bottom_nav.dart';

class TableBasicsExample extends StatefulWidget {
  const TableBasicsExample({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TableBasicsExampleState createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  List _trabajos = [];

  @override
  void initState() {
    super.initState();
    _loadEvents(_selectedDay); // Carga los eventos del día actual
  }

  void _showAddEventModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Bordes redondeados
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8, // Ajusta el ancho
            height:
                MediaQuery.of(context).size.height * 0.7, // Ajusta la altura
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.grey[900], // Color de fondo
              borderRadius: BorderRadius.circular(20),
            ),
            child: const AddEventScreen(), // Tu contenido
          ),
        );
      },
    );
  }

  void _loadEvents(DateTime date) async {
    // Formatea la fecha para Firestore
    String dateKey = "${date.year}-${date.month}-${date.day}";

    // Obtiene los eventos de Firestore para la fecha seleccionada
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('trabajos')
        .where('date', isEqualTo: dateKey)
        .get();

    setState(() {
      _trabajos = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(), // Llama al AppBar personalizado
      bottomNavigationBar:
          const CustomBottomNav(), // Barra de navegación inferior personalizada
      backgroundColor: Colors.black,
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
              _loadEvents(
                  selectedDay); // Carga eventos para el día seleccionado
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarStyle: const CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
              weekendTextStyle: TextStyle(color: Colors.red),
              defaultTextStyle: TextStyle(color: Colors.white),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleTextStyle: TextStyle(color: Colors.white),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _trabajos.isEmpty
                ? const Center(
                    child: Text(
                      "No hay trabajos para este día",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : ListView.builder(
                    itemCount: _trabajos.length,
                    itemBuilder: (context, index) {
                      var event = _trabajos[index];
                      return Card(
                        color: Colors.grey[800],
                        child: ListTile(
                          title: Text(
                            event['client_name'] ?? 'Nombre no especificado',
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            event['description'] ?? 'Sin descripción',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: Text(
                            event['phone_number'] ?? 'Número no especificado',
                            style: const TextStyle(color: Colors.white54),
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Abre AddEventScreen como un modal en lugar de una nueva pantalla
          _showAddEventModal(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
