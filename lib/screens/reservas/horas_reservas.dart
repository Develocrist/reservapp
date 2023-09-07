import 'package:flutter/material.dart';

class Horas {
  final String id;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  Horas({required this.id, required this.startTime, required this.endTime});

  static List<Horas> horasPredefinidas = [
    Horas(
      id: 'Bloque 1',
      startTime: const TimeOfDay(hour: 8, minute: 15),
      endTime: const TimeOfDay(hour: 9, minute: 30),
    ),
    Horas(
      id: 'Bloque 2',
      startTime: const TimeOfDay(hour: 9, minute: 45),
      endTime: const TimeOfDay(hour: 11, minute: 0),
    ),
    Horas(
      id: 'Bloque 3',
      startTime: const TimeOfDay(hour: 11, minute: 15),
      endTime: const TimeOfDay(hour: 13, minute: 0),
    ),
    Horas(
      id: 'Bloque 4',
      startTime: const TimeOfDay(hour: 13, minute: 15),
      endTime: const TimeOfDay(hour: 14, minute: 30),
    ), 
    Horas(
      id: 'Bloque 5',
      startTime: const TimeOfDay(hour: 15, minute: 00),
      endTime: const TimeOfDay(hour: 16, minute: 15),
    ),
  ];
}
