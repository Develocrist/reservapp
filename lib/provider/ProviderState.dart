import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reservas_theo/features/widgets/ui.dart';

//----- clase que almacena los metodos para crear los usuarios y su validación
class ProviderState extends ChangeNotifier {
  String? _uid, _email, _role;

  String? get getRole => _role;
  String? get getUID => _uid;
  String? get getEmail => _email;

  setUid(String? uid) {
    _uid = uid;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  setEmail(String? email) {
    _email = email;
    notifyListeners();
  }

  setRole(String? role) {
    _role = role;
    notifyListeners();
  }

//actualizar correo
  void updateEmail(String? email) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _email = email;
      notifyListeners();
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUserAccount(
      String nombre, String email, String password, String role) async {
    //metodo de firebase para crear el usuario, necesito incorporar el rol para despues recuperarlo
    bool success = false;
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      _uid = userCredential.user?.uid;
      _email = userCredential.user?.email;

      //asignar el rol de usuario al documento en firestore
      await FirebaseFirestore.instance.collection('users').doc(_uid).set({
        'nombre': nombre,
        'uid': _uid,
        'role': role,
      });

      return success = true;
    } catch (e) {
      success = false;

      //print('Error al crear usuario: $e');
    }
    return success;
  }

  //------------

  Future<bool> signInUserAccount(String email, String password) async {
    bool success = false;
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _uid = userCredential.user?.uid;
      _email = userCredential.user?.email;

      return success = true;
    } catch (e) {
      print('Error al iniciar sesión de usuario: $e');
    }
    return success;
  }

  void signOut() async {
    await _auth.signOut();    
    (print('salida exitosa'));
  }
}
