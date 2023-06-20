//CODIFICACION DE VISTA DONDE SE VERAN TODAS LAS RESERVAS QUE HAGAN LOS USUARIOS

//19/06: POR AHORA SOLO EL ESQUELETO

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  final String name;
  final String description;
  final String room;
  final String startTime;
  final String endTime;

  Event({
    required this.name,
    required this.description,
    required this.room,
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
  Map<DateTime, List<Event>> _events = {};

  String _eventName = '';
  String _eventDescription = '';
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  String _selectedRoom = '';
  List<String> _roomList = [
    'Sala UMD 1',
    'Sala UMD 2',
    'Sala UMD 3',
  ];

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
            eventLoader: (day) {
              return _events[day] ?? [];
            },
          ),
          SizedBox(height: 16),
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
                                Text(event.description),
                                Text('Sala: ${event.room}'),
                                Text('${event.startTime} - ${event.endTime}'),
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
                    onChanged: (value) {
                      () {};
                    },
                    value: _selectedRoom,
                    items: _roomList
                        .map((room) => DropdownMenuItem<String>(
                              value: room,
                              child: Text(room),
                            ))
                        .toList(),
                    decoration: InputDecoration(labelText: 'Sala'),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text('Hora de inicio: '),
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
                  onPressed: () {
                    setState(() {
                      final event = Event(
                        name: _eventName,
                        description: _eventDescription,
                        room: _selectedRoom,
                        startTime: _startTime.format(context),
                        endTime: _endTime.format(context),
                      );
                      _events[_selectedDay] ??= [];
                      _events[_selectedDay]!.add(event);
                    });
                    Navigator.pop(context);
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
