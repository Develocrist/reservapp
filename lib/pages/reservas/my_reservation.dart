//CODIFICACION DE VISTA DONDE SE GESTIONARAN TODAS LAS RESERVAS QUE EL USUARIO REALICE

//19/06: POR AHORA SOLO EL ESQUELETO

import 'package:flutter/material.dart';

class MyReservation extends StatefulWidget {
  const MyReservation({Key? key}) : super(key: key);

  @override
  State<MyReservation> createState() => _MyReservationState();
}

class _MyReservationState extends State<MyReservation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Mis reservas'),
        ),
        body: Center(
          child:
              Text('Aquí va la interfaz para gestionar las reservas propias'),
        ));
  }
}
