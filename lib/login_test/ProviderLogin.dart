import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:reservas_theo/home_screen.dart';
import 'package:reservas_theo/login_test/ProviderRegistration.dart';
import 'package:reservas_theo/login_test/ProviderState.dart';

class ProviderLogin extends StatefulWidget {
  const ProviderLogin({super.key});

  @override
  State<ProviderLogin> createState() => _ProviderLoginState();
}

class _ProviderLoginState extends State<ProviderLogin> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //inicializamos la instancia de verificacion en firebase
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

        await _googleSignIn.signOut();

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

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Login a TheoApp',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: email,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: pass,
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
              obscureText: true,
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                if (email.text.isNotEmpty && pass.text.isNotEmpty) {
                  _login(email.text, pass.text);
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error al Ingresar'),
                          content: const Text(
                              'Rellene los campos y asegurese de que sean credenciales válidas.'),
                          actions: <Widget>[
                            TextButton(
                                child: const Text('Aceptar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                          ],
                        );
                      });
                }
              },
              // onPressed: () {
              //   Navigator.pushNamed(context,
              //       '/home'); // lo de arriba activa el ingreso con credenciales, con finalidades de prueba se habilita el ingreso directo
              // },
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
                    String? nombre_usuario = userCredential.user!.displayName;
                    Navigator.popAndPushNamed(context, '/home', arguments: {
                      'nombre_usuario': nombre_usuario,
                    });
                  } else {
                    ErrorIngreso();
                    print('Error en inicio de sesión con Google');
                  }
                });
              },
              child: Text('Iniciar sesión con Google'),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProviderRegistration()));
              },
              child: const Text('Crear cuenta'),
            ),
            const Text('V1.0.0') //versión actual de la aplicación
          ],
        ),
      ),
    );
  }

  void _login(String email, String password) async {
    ProviderState providerState =
        Provider.of<ProviderState>(context, listen: false);

    try {
      if (await providerState.signInUserAccount(email, password)) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ));
      }
    } catch (e) {
      print('error al iniciar con provider: $e');
    }
  }
}

class ErrorIngreso extends StatelessWidget {
  const ErrorIngreso({super.key});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text('Error al ingresar con Google'),
    );
  }
}
