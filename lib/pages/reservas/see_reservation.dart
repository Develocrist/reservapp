import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class Event {
  final String name;
  final String description;
  final String room;
  final DateTime fecha;
  final String startTime;
  final String endTime;

  Event({
    required this.name,
    required this.description,
    required this.room,
    required this.fecha,
    required this.startTime,
    required this.endTime,
  });
}

class SeeReservation extends StatefulWidget {
  @override
  _SeeReservationState createState() => _SeeReservationState();
}

class _SeeReservationState extends State<SeeReservation> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final Map<DateTime, List<Event>> _events = {};

  String _eventName = '';
  String _eventDescription = '';
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  String _salaSeleccionada = '';
  List<String> _rooms =
      []; //lista que almacena las salas que se obtendran desde firebase

  final scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>(); //notificacion en caso de haber error

  @override
  void initState() {
    super.initState();
    getRoomsFromFirebase();
    loadEventsFromFirebase();
  }

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
      scaffoldMessengerKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Hubo un error al cargar las salas'),
        ),
      );
    }
  }

  String _formatTimestampToTime(Timestamp? timestamp) {
    final dateTime = timestamp?.toDate() ?? DateTime.now();
    final formattedTime = DateFormat.Hm().format(dateTime);
    return formattedTime;
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    final formattedTime = DateFormat.Hm().format(dateTime);
    return formattedTime;
  }

  Future<void> loadEventsFromFirebase() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('reservas').get();

      setState(() {
        _events.clear();

        for (var doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final event = Event(
            name: data['nombre'] as String? ?? '',
            description: data['descripcion'] as String? ?? '',
            room: data['sala'] as String? ?? '',
            fecha: (data['fecha'] as Timestamp?)?.toDate() ?? DateTime.now(),
            startTime: _formatTimestampToTime(data['horainicio']),
            endTime: _formatTimestampToTime(data['horafin']),
          );

          final eventDate = DateTime(
            event.fecha.year,
            event.fecha.month,
            event.fecha.day,
            int.parse(event.startTime.split(':')[0]),
            int.parse(event.startTime.split(':')[1]),
          );

          _events[eventDate] ??= [];
          _events[eventDate]!.add(event);
        }
      });
    } catch (e) {
      print('Error al cargar los eventos desde Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2022, 1, 1),
            lastDay: DateTime.utc(2023, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: (day) => _events[day] ?? [],
          ),
          const SizedBox(height: 16),
          Text(
            'Eventos para el $_selectedDay:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: _events[_selectedDay]
                      ?.map((event) => ListTile(
                            title: Text(event.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Descripción: ${event.description}'),
                                Text('Sala: ${event.room}'),
                                Text(
                                    'Hora de inicio: ${event.startTime} - Hora de termino: ${event.endTime}'),
                                Text('Fecha: ${event.fecha}'),
                              ],
                            ),
                          ))
                      .toList() ??
                  [],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Agregar Evento'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nombre del Evento'),
                    onChanged: (value1) {
                      setState(() {
                        _eventName = value1;
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration:
                        InputDecoration(labelText: 'Descripción del Evento'),
                    onChanged: (value2) {
                      setState(() {
                        _eventDescription = value2;
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _salaSeleccionada.isNotEmpty &&
                            _rooms.contains(_salaSeleccionada)
                        ? _salaSeleccionada
                        : null,
                    decoration:
                        const InputDecoration(labelText: 'Seleccionar sala'),
                    items: _rooms.map((room) {
                      return DropdownMenuItem<String>(
                        value: room,
                        child: Text(room),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _salaSeleccionada = value!;
                      });
                    },
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Hora de inicio: '),
                      ElevatedButton(
                        onPressed: () async {
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: _startTime,
                          );
                          if (selectedTime != null) {
                            setState(() {
                              _startTime = selectedTime;
                            });
                          }
                        },
                        child: Text(_startTime.format(context)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text('Hora de fin: '),
                      ElevatedButton(
                        onPressed: () async {
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: _endTime,
                          );
                          if (selectedTime != null) {
                            setState(() {
                              _endTime = selectedTime;
                            });
                          }
                        },
                        child: Text(_endTime.format(context)),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    try {
                      final event = Event(
                        fecha: DateTime(
                            _selectedDay.year,
                            _selectedDay.month,
                            _selectedDay.day,
                            _startTime.hour,
                            _startTime.minute),
                        name: _eventName,
                        description: _eventDescription,
                        room: _salaSeleccionada,
                        startTime: _startTime.format(context),
                        endTime: _endTime.format(context),
                      );

                      await FirebaseFirestore.instance
                          .collection('reservas')
                          .add({
                        'nombre': event.name,
                        'descripcion': event.description,
                        'sala': event.room,
                        'fecha': event.fecha,
                        'horaInicio': event.startTime,
                        'horaFinal': event.endTime,
                      });

                      setState(() {
                        _events[_selectedDay] ??= [];
                        _events[_selectedDay]!.add(event);
                      });

                      Navigator.pop(context);
                    } catch (e) {
                      print('Error al guardar el evento en Firebase: $e');
                    }
                  },
                  child: Text('Agregar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar'),
                ),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
