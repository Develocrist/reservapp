//CODIFICACION DE VISTA DONDE SE REALIZARAN TODAS LAS RESERVAS QUE EL USUARIO DESEE

// POR AHORA SOLO EL ESQUELETO, 23/06, falta incorporar la seleccion de una fecha

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  rangoTiempo?
      _selectedTimeRange; //variable para almacenar el bloque horario seleccionado
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
    rangoTiempo(
      inicioBloque: TimeOfDay(hour: 12, minute: 15),
      finBloque: TimeOfDay(hour: 14, minute: 00),
    ),
    rangoTiempo(
      inicioBloque: TimeOfDay(hour: 14, minute: 15),
      finBloque: TimeOfDay(hour: 16, minute: 00),
    ),
    rangoTiempo(
      inicioBloque: TimeOfDay(hour: 16, minute: 15),
      finBloque: TimeOfDay(hour: 18, minute: 00),
    ),
  ]; //falta implementarlo en el formulario de reserva de salas

  DateTime? _selectedDate; //variable que almacenara la fecha

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

  //metodo para seleccionar una fecha
  Future<void> selectedDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

//aqui necesito incorporar las salas creadas en la base de datos

  @override
  Widget build(BuildContext context) {
    print(
        'Salas cargadas: $_rooms'); //verifica e imprime si se cargaron las salas
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservar Sala'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //campo para seleccionar fecha
            TextButton(
              onPressed: () {
                selectedDate(context);
              },
              child: Text(
                _selectedDate != null
                    ? 'Fecha seleccionada: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}'
                    : 'Seleccionar fecha',
              ),
            ),

            //campo para ingresar el asunto
            TextField(
              decoration: InputDecoration(labelText: 'Asunto'),
              onChanged: (value) {
                setState(() {
                  _asunto = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(labelText: 'Descripción'),
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<rangoTiempo>(
              value: _selectedTimeRange,
              decoration: const InputDecoration(
                  labelText: 'Seleccionar bloque horario'),
              items: _rangoTiempo.map((rango) {
                return DropdownMenuItem<rangoTiempo>(
                  value: rango,
                  child: Text(
                    '${rango.inicioBloque.format(context)} - ${rango.finBloque.format(context)}',
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTimeRange = value;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: _salaSeleccionada,
              decoration: const InputDecoration(labelText: 'Seleccionar sala'),
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
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_selectedDate != null &&
                    _salaSeleccionada != null &&
                    _selectedTimeRange != null) {
                  // Acción al reservar la sala
                  print('exito en la reserva?');
                  print('Reservación realizada:');
                  print('Fecha seleccionada: $_selectedDate');
                  print('Asunto: $_asunto');
                  print('Descripción: $_description');
                  print(
                      'Bloque Horario seleccionado: ${_selectedTimeRange?.inicioBloque.format(context)} - ${_selectedTimeRange?.finBloque.format(context)}');
                  print('Sala: $_salaSeleccionada');
                } else {
                  // Validación de campos
                  print('Reservación realizada:');
                  print('Fecha seleccionada: $_selectedDate');
                  print('Asunto: $_asunto');
                  print('Descripción: $_description');
                  print(
                      'Bloque Horario seleccionado: ${_selectedTimeRange?.inicioBloque.format(context)} - ${_selectedTimeRange?.finBloque.format(context)}');
                  print('Sala: $_salaSeleccionada');
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
