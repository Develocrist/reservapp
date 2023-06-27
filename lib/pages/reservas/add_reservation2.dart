import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationScreen2 extends StatefulWidget {
  @override
  _ReservationScreen2State createState() => _ReservationScreen2State();
}

class _ReservationScreen2State extends State<ReservationScreen2> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _dateTime2Controller = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _userController = TextEditingController(text: '');
  final TextEditingController _fechaController = TextEditingController();

  Future<void> createReservation() async {
    try {
      final name = _nameController.text;
      final description = _descriptionController.text;
      final dateTime = DateTime.parse(_dateTimeController.text);
      final dateTime2 = DateTime.parse(_dateTime2Controller.text);
      final location = _locationController.text;
      final user = _userController.text;
      final fecha = DateTime.parse(_fechaController.text);

      final reservation = Reservation(
        name: name,
        description: description,
        dateTime: dateTime,
        dateTime2: dateTime2,
        location: location,
        user: user,
        fecha: fecha,
      );

      await FirebaseFirestore.instance
          .collection('reservations')
          .add(reservation.toMap());

      _nameController.clear();
      _descriptionController.clear();
      _dateTimeController.clear();
      _dateTime2Controller.clear();
      _locationController.clear();
      _userController.clear();
      _fechaController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reserva creada con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear la reserva')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //capturamos el uid del usuario actual y lo insertamos en el textformfield
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    _userController.text = arguments['uid'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Reserva'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: _dateTimeController,
              decoration: InputDecoration(
                  labelText: 'Fecha y hora de inicio (yyyy-MM-dd HH:mm)'),
            ),
            TextField(
              controller: _dateTime2Controller,
              decoration: InputDecoration(
                  labelText: 'Fecha y hora de fin (yyyy-MM-dd HH:mm)'),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Ubicación'),
            ),
            TextField(
              readOnly: true,
              controller: _userController,
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _fechaController,
              decoration:
                  InputDecoration(labelText: 'Fecha de reunión (yyyy-MM-dd)'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: createReservation,
              child: Text('Crear Reserva'),
            ),
          ],
        ),
      ),
    );
  }
}

class Reservation {
  final String name;
  final String description;
  final DateTime dateTime;
  final DateTime dateTime2;
  final String location;
  final String user;
  final DateTime fecha;

  Reservation({
    required this.name,
    required this.description,
    required this.dateTime,
    required this.dateTime2,
    required this.location,
    required this.user,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'dateTime': dateTime,
      'dateTime2': dateTime2,
      'location': location,
      'user': user,
      'fecha': fecha,
    };
  }
}
