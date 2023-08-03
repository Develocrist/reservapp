//codigo para el ingreso con firebase usando una cuenta de google

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//clase donde se ponen los campos necesarios para generar el registro, primero se prueba y despues se personaliza
class User with ChangeNotifier {
  late String id;
  late String nombre;
  late String photoURL;
  late String email;
  late String role;

  User(
      {required this.id,
      required this.nombre,
      required this.photoURL,
      required this.email,
      required this.role});
}
