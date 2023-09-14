import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:reservas_theo/features/widgets/ui.dart';
import 'package:screenshot/screenshot.dart';

class ReservationScreen extends StatefulWidget {
  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  List<Reservation> _reservations = []; //lista completa de reservas
  List<Reservation> _filteredReservations = []; //lista filtrada de reservas
  ScreenshotController screenshotController =
      ScreenshotController(); //controlador que se encarga de la captura de pantalla

  bool _fechaFiltradaActiva = false;
  DateTime? _fechaSeleccionada; //variable para la fecha seleccionada

  @override
  void initState() {
    super.initState();
    loadReservations();
  }

  //metodo para cargar todas las reservas
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

      reservations.sort(
        (a, b) => b.fechaCreacion.compareTo(a.fechaCreacion),
      );

      setState(() {
        _reservations = reservations;
        _filteredReservations =
            _reservations; //al inicio ambas listas son iguales
      });
    } catch (e) {
      print('Error al cargar las reservas desde Firebase: $e');
    }
  }

//------------ Filtrar las reservas generadas por fecha

  Future<void> cargarReservas() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('reservations').get();
      List<Reservation> reservations = [];
      snapshot.docs.forEach((doc) {
        Reservation reservation = Reservation.fromFirestore(doc);
        reservations.add(reservation);
      });
      setState(() {
        _reservations = reservations;
        print(_reservations);
      });
    } catch (e) {
      print('Error al filtrar fecha: $e');
    }
  }

  List<Reservation> filtradoFecha(DateTime fechaFiltrada) {
    return _reservations.where((reservation) {
      return reservation.fecha.year == fechaFiltrada.year &&
          reservation.fecha.month == fechaFiltrada.month &&
          reservation.fecha.day == fechaFiltrada.day;
    }).toList();
  }

  //----------------------------

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;

    if (_filteredReservations.isNotEmpty) {
      bodyWidget = SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          child: ListView.builder(
            itemCount: _filteredReservations.length,
            itemBuilder: (context, index) {
              Reservation reservation = _filteredReservations[index];
              DateFormat dateFormat = DateFormat('dd/MM/yyyy');
              DateFormat timeFormat = DateFormat('HH:mm');
              // Personaliza el diseño de cada elemento de la lista con los datos de la reserva
              return ListTile(
                title: Text(
                    'Fecha: ${dateFormat.format(reservation.fecha)}'), //nombre de la reserva y la fecha cuando se va a realizar
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Asunto: ${reservation.asunto}'),
                    //Text('Descripción:\n ${reservation.descripcion}'), //descripción de la reserva
                    Text(
                        'Horario: ${timeFormat.format(reservation.horaInicio)} - ${timeFormat.format(reservation.horaFin)}'), // Muestra la fecha y hora de la reserva
                    Text(
                        'Sala: ${reservation.ubicacion}'), // Muestra la ubicación de la reserva
                    Text(
                        'Usuario que reservo: ${reservation.usuario}'), //mostrar al usuario que hizo la reserva

                    //Muestra al usuario que realizó la reserva
                    Divider()
                  ],
                ),
                trailing: TextButton(
                    onPressed: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => Screenshot(
                          controller: screenshotController,
                          child: Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Detalles de actividad:',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  //informacion asociada a la reserva

                                  Text(
                                      'Asunto: ${reservation.asunto}'), //asunto
                                  Text(
                                      'Descripción: ${reservation.descripcion}'), //descripción
                                  Text(
                                      'Fecha: ${dateFormat.format(reservation.fecha)}'),
                                  Text('Ubicación: ${reservation.ubicacion}'),
                                  Text(
                                      'Horario: ${timeFormat.format(reservation.horaInicio)} - ${timeFormat.format(reservation.horaFin)}'),
                                  Text(
                                      'Asistentes: ${reservation.asistentes.join(", ")}'),
                                  Text('ID: ${reservation.idReserva}'),
                                  TextButton(
                                      onPressed: () async {
                                        final Uint8List? image =
                                            await screenshotController
                                                .capture();
                                        if (image != null) {
                                          await ImageGallerySaver.saveImage(
                                              image);
                                          SnackbarHelper.showSnackbar(context,
                                              'Detalles de actividad guardada en Galería con Éxito');
                                        }
                                      },
                                      child: const Text('Guardar actividad')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cerrar'))
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text('Ver más')),
              );
            },
          ),
        ),
      );
    } else {
      bodyWidget = Container(
        height: 200,
        width: 200,
        child: const Center(
          child: Text('No hay reservas para la fecha Seleccionada'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (_fechaSeleccionada != null)
            Text(
                'Fecha Seleccionada: ${DateFormat('dd/MM/yyyy').format(_fechaSeleccionada!)}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final DateTime? seleccion = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100));
                  if (seleccion != null) {
                    setState(() {
                      _fechaSeleccionada = seleccion;
                      _filteredReservations = filtradoFecha(seleccion);
                      print('fechas capturadas $_filteredReservations');
                      _fechaFiltradaActiva = true;
                    });
                  }
                },
                child: const Text('Seleccionar Fecha'),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _fechaFiltradaActiva = false;
                    _fechaSeleccionada = null;
                    _filteredReservations = _reservations;
                  });
                },
                icon: const Icon(
                  Icons.search_off_outlined,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          bodyWidget
        ],
      ),
    );
  }
}

class Reservation {
  final String? asunto;
  final String? descripcion;
  final DateTime fecha;
  final DateTime horaInicio; // Nuevo campo para la hora de inicio
  final DateTime horaFin; //campo para almacenar la hora de termino
  final String? ubicacion; // Nuevo campo para la ubicación de la reserva
  final String? usuario;
  final String? idReserva;
  final List<String> asistentes;
  final DateTime fechaCreacion; //nuevo campo para la fecha de creacion

  Reservation(
      {required this.asunto,
      required this.descripcion,
      required this.horaInicio,
      required this.ubicacion,
      required this.usuario,
      required this.horaFin,
      required this.fecha,
      required this.idReserva,
      required this.asistentes,
      required this.fechaCreacion});

  factory Reservation.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<String> asistentes = (data['Asistentes'] as List<dynamic>)
        .map((dynamic asistente) => asistente.toString())
        .toList();
    print('asistentes obtenidos: $asistentes');
    return Reservation(
      asunto: data['Asunto'],
      descripcion: data['Descripción'],
      horaInicio: data['Hora_inicio'] != null
          ? (data['Hora_inicio'] as Timestamp).toDate()
          : DateTime.now(),
      horaFin: data['Hora_finalización'] != null
          ? (data['Hora_finalización'] as Timestamp).toDate()
          : DateTime.now(),
      ubicacion: data['Lugar'],
      usuario: data['Usuario'],
      fecha: data['Fecha'] != null
          ? (data['Fecha'] as Timestamp).toDate()
          : DateTime.now(),
      idReserva: data['uid'] ?? '',
      asistentes: asistentes, //asignar la lista de asistentes
      fechaCreacion: data['fechaCreacion'] != null //obtener fecha de creación
      ? (data['fechaCreacion'] as Timestamp).toDate()
      : DateTime.now(), //valor por defecto si no hay cfecha de creación
      
    );
  }
}
