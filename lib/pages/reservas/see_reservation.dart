//CODIFICACION DE VISTA DONDE SE VERAN TODAS LAS RESERVAS QUE HAGAN LOS USUARIOS

//19/06: POR AHORA SOLO EL ESQUELETO

import 'package:flutter/material.dart';

class SeeReservation extends StatefulWidget {
  const SeeReservation({Key? key}) : super(key: key);

  @override
  State<SeeReservation> createState() => _SeeReservationState();
}

class _SeeReservationState extends State<SeeReservation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ver reservas'),
        ),
        body: Center(
          child: Text('Aquí va el calendario y los eventos de cada día'),
        ));
  }
}
