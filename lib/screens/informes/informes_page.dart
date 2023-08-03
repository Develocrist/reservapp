//CODIFICACION DE VISTA DONDE SE VERAN LAS OPCIONES DE INFORMES  PARA LOS USUARIOS CON ROL ADMINISTRADOR

//19/06: POR AHORA SOLO EL ESQUELETO

import 'package:flutter/material.dart';

class Informes extends StatefulWidget {
  const Informes({Key? key}) : super(key: key);

  @override
  State<Informes> createState() => InformesState();
}

class InformesState extends State<Informes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Informes'),
        ),
        body: Center(
          child: Text('Aquí va la pantalla para generar informes'),
        ));
  }
}
