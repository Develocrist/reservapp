import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  List<Reservation> _reservations = [];

  @override
  void initState() {
    super.initState();
    loadReservations();
  }

  Future<void> loadReservations() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('reservations').get();
      List<Reservation> reservations = [];
      snapshot.docs.forEach((doc) {
        // Parsear los datos de Firestore y crear objetos Reservation
        Reservation reservation = Reservation.fromFirestore(doc);
        reservations.add(reservation);
      });

      setState(() {
        _reservations = reservations;
      });
    } catch (e) {
      print('Error al cargar las reservas desde Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservas'),
      ),
      body: ListView.builder(
        itemCount: _reservations.length,
        itemBuilder: (context, index) {
          Reservation reservation = _reservations[index];
          DateFormat dateFormat = DateFormat('dd/MM/yyyy');
          DateFormat timeFormat = DateFormat('HH:mm');
          // Personaliza el diseño de cada elemento de la lista con los datos de la reserva
          return ListTile(
            title: Text(
                'Asunto: ${reservation.name} \nFecha: ${dateFormat.format(reservation.fecha)}'), //nombre de la reserva y la fecha cuando se va a realizar
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Descripción:\n  ${reservation.description}'), //descripción de la reserva
                Text(
                    'Hora de inicio:\n  ${timeFormat.format(reservation.dateTime)} \nHora de finalización: \n  ${timeFormat.format(reservation.dateTime2)}'), // Muestra la fecha y hora de la reserva
                Text(
                    'Sala: ${reservation.location}'), // Muestra la ubicación de la reserva
                Text(
                    'Usuario que reservo: ${reservation.user}'), //mostrar al usuario que hizo la reserva

                //Muestra al usuario que realizó la reserva
              ],
            ),
          );
        },
      ),
    );
  }
}

class Reservation {
  final String name;
  final String description;
  final DateTime fecha;
  final DateTime dateTime; // Nuevo campo para la hora de inicio
  final DateTime dateTime2; //campo para almacenar la hora de termino
  final String location; // Nuevo campo para la ubicación de la reserva
  final String user;

  Reservation(
      {required this.name,
      required this.description,
      required this.dateTime,
      required this.location,
      required this.user,
      required this.dateTime2,
      required this.fecha});

  factory Reservation.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Reservation(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      dateTime: data['startDate'] != null
          ? (data['startDate'] as Timestamp).toDate()
          : DateTime.now(),
      dateTime2: data['endDate'] != null
          ? (data['endDate'] as Timestamp).toDate()
          : DateTime.now(), // Verifica si el valor es nulo antes de convertirlo
      location: data['location'] ?? '',
      user: data['userID'] ?? '',
      fecha: data['meetingDate'] != null
          ? (data['meetingDate'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
