//CODIFICACION DE VISTA DONDE SE REALIZARAN TODAS LAS RESERVAS QUE EL USUARIO DESEE

//19/06: POR AHORA SOLO EL ESQUELETO

import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddReservation extends StatefulWidget {
  @override
  _AddReservationState createState() => _AddReservationState();
}

class _AddReservationState extends State<AddReservation> {
  String _asunto = '';
  String _description = '';
  DateTime? _selectedDateTime;
  String? _salaSeleccionada;
  List<String> _rooms =
      []; // Lista de salas disponibles, las cuales deben ser importadas desde firebase

  //bloques de horario predefinidos
  List<rangoTiempo> _rangoTiempo = [
    rangoTiempo(
      inicioBloque: TimeOfDay(hour: 8, minute: 15),
      finBloque: TimeOfDay(hour: 10, minute: 00),
    ),
    rangoTiempo(
      inicioBloque: TimeOfDay(hour: 10, minute: 15),
      finBloque: TimeOfDay(hour: 12, minute: 00),
    ),
  ]; //falta implementarlo en el formulario de reserva de salas

  //metodo para inicializar el otro metodo que realiza la solicitud de las salas
  @override
  void initState() {
    super.initState();
    getRoomsFromFirebase();
  }
//metodo para obtener las salas desde firebase

  Future<void> getRoomsFromFirebase() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('salas').get();
      setState(() {
        _rooms =
            snapshot.docs.map((doc) => doc.get('nombre') as String).toList();
      });
    } catch (e) {
      print('Error al obtener las salas $e');
    }
  }

//aqui necesito incorporar las salas creadas en la base de datos

  @override
  Widget build(BuildContext context) {
    print('Salas cargadas: $_rooms');
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservar Sala'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Asunto'),
              onChanged: (value) {
                setState(() {
                  _asunto = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(labelText: 'Descripción'),
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            // ElevatedButton(
            //   onPressed: () {
            //     showDatePicker(
            //       context: context,
            //       initialDate: DateTime.now(),
            //       firstDate: DateTime.now(),
            //       lastDate: DateTime(2100),
            //     ).then((selectedDate) {
            //       if (selectedDate != null) {
            //         showTimePicker(
            //           context: context,
            //           initialTime: TimeOfDay.now(),
            //         ).then((selectedTime) {
            //           if (selectedTime != null) {
            //             setState(() {
            //               _selectedDateTime = DateTime(
            //                 selectedDate.year,
            //                 selectedDate.month,
            //                 selectedDate.day,
            //                 selectedTime.hour,
            //                 selectedTime.minute,
            //               );
            //             });
            //           }
            //         });
            //       }
            //     });
            //   },
            //   child: Text('Seleccionar Fecha y Bloque Horario'),
            // ),
            // SizedBox(height: 16.0),

            DropdownButtonFormField<String>(
              value: _salaSeleccionada,
              decoration: InputDecoration(labelText: 'Sala'),
              items: _rooms.map((room) {
                return DropdownMenuItem<String>(
                  value: room,
                  child: Text(room),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _salaSeleccionada = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_selectedDateTime != null && _salaSeleccionada != null) {
                  // Acción al reservar la sala
                  print('Reservación realizada:');
                  print('Asunto: $_asunto');
                  print('Descripción: $_description');
                  print('Fecha y Bloque Horario: $_selectedDateTime');
                  print('Sala: $_salaSeleccionada');
                } else {
                  // Validación de campos
                  print('Por favor, complete todos los campos');
                }
              },
              child: Text('Reservar'),
            ),
          ],
        ),
      ),
    );
  }
}

class rangoTiempo {
  final TimeOfDay inicioBloque;
  final TimeOfDay finBloque;

  rangoTiempo({required this.inicioBloque, required this.finBloque});
}
