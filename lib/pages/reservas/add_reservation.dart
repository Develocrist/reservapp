//CODIFICACION DE VISTA DONDE SE REALIZARAN TODAS LAS RESERVAS QUE EL USUARIO DESEE

//19/06: POR AHORA SOLO EL ESQUELETO

import 'package:flutter/material.dart';

class AddReservation extends StatefulWidget {
  const AddReservation({Key? key}) : super(key: key);

  @override
  State<AddReservation> createState() => _AddReservationState();
}

class _AddReservationState extends State<AddReservation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Reserva'),
        ),
        body: Center(
          child: Text('Aquí va la interfaz para reservar'),
        ));
  }
}
