import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

//funcion que nos trae la información de las salas que se crean en firebase

Future<List> getSalas() async {
  List salas = [];
  QuerySnapshot queryPersonas = await db
      .collection('salas')
      .get(); //esta linea trae toda la colección de salas contenidas en firebase

  for (var doc in queryPersonas.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final sala = {
      //se crea un objeto sala la cual puede tener mas propiedades y eso es lo que importa
      "nombre": data['nombre'],
      "uid": doc.id,
      "capacidad": data['capacidad'],
      "descripcion": data['descripcion']
    };
    salas.add(sala);
  }

  return salas;
}

//añadir salas a la base de datos
Future<void> addSalas(String name, int capacity, String description) async {
  await db
      .collection('salas')
      .add({"nombre": name, "capacidad": capacity, "descripcion": description});
}

//actualizar el nombre de la persona en la base de datos
Future<void> updateSalas(String uid, String newName) async {
  await db.collection('salas').doc(uid).set({'name': newName});
}

Future<void> deleteSalas(String uid) async {
  await db.collection('salas').doc(uid).delete();
}

//------------------------------------------------------------------

//funciones para los usuarios
// class Auth {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   User? get CurrentUser => _firebaseAuth.currentUser;
//   Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

//   Future<void> signInWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     await _firebaseAuth.signInWithEmailAndPassword(
//         email: email, password: password);
//   }

//   Future<void> createUserWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     await _firebaseAuth.createUserWithEmailAndPassword(
//         email: email, password: password);
//   }

//   Future<void> signOut() async {
//     await _firebaseAuth.signOut();
//   }
// }
