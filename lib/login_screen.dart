import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      // Realizar el inicio de sesión con Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Obtener las credenciales de acceso de Google
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Iniciar sesión con las credenciales de Google en Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Retornar las credenciales de usuario
      return userCredential;
    } catch (e) {
      // Manejar cualquier error durante el inicio de sesión
      print('Error en inicio de sesión con Google: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Inicio de sesión',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
              obscureText: true,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () async {
                // Iniciar sesión con el botón de inicio de sesión normal
                await Navigator.pushNamed(context, '/home');
              },
              child: Text('Iniciar sesión'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () async {
                // Iniciar sesión con Google
                _signInWithGoogle().then((UserCredential? userCredential) {
                  if (userCredential != null) {
                    // El inicio de sesión fue exitoso, puedes realizar acciones adicionales aquí
                    print(
                        'Inicio de sesión exitoso: ${userCredential.user!.displayName}');
                    Navigator.pushNamed(context, '/home');
                  } else {
                    // El inicio de sesión falló
                    print('Error en inicio de sesión con Google');
                  }
                });
              },
              child: Text('Iniciar sesión con Google'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/register');
              },
              child: Text('Crear cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}
