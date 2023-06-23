import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

//----- clase que almacena los metodos para crear los usuarios y su validación
class ProviderState extends ChangeNotifier {
  String? _Uid, _Email;

  String? get getUID => _Uid;
  String? get getEmail => _Email;

  setUid(String? uid) {
    _Uid = uid;
    notifyListeners();
  }

  setEmail(String? email) {
    _Email = email;
    notifyListeners();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> CreateUserAccount(String email, String password) async {
    bool success = false;
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential != null) {
        _Uid = userCredential.user?.uid;
        _Email = userCredential.user?.email;

        return success = true;
      }
    } catch (e) {
      print('Error al crear usuario: $e');
    }
    return success;
  }

  //------------

  Future<bool> SignInUserAccount(String email, String password) async {
    bool success = false;
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential != null) {
        _Uid = userCredential.user?.uid;
        _Email = userCredential.user?.email;

        return success = true;
      }
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
