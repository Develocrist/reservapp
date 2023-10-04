import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:VisalApp/features/home/home_screen.dart';
import 'package:VisalApp/features/registro/registro_screen.dart';
import 'package:VisalApp/features/widgets/ui.dart';
import 'package:VisalApp/provider/ProviderState.dart';

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
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    Future<UserCredential?> signInWithGoogle() async {
      try {
        // Realizar el inicio de sesión con Google
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser!.authentication;

        // Obtener las credenciales de acceso de Google
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await googleSignIn.signOut();

        // Iniciar sesión con las credenciales de Google en Firebase
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        // Retornar las credenciales de usuario
        return userCredential;
      } catch (e) {
        // Manejar cualquier error durante el inicio de sesión
        print('Error en inicio de sesión con Google: $e');
        SnackbarHelper.showSnackbar(
            context, 'Hubo un error al iniciar sesión con Google');
        return null;
      }
    }

    return Scaffold(      
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 100,),
              SizedBox(
                width: 200,
                height: 170,              
                child: Image.asset('assets/logoapp.png', fit: BoxFit.fill,)
              ),
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),            
              TextFormField(
                controller: email,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: pass,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder()
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                height: 60,
                width: 250,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (email.text.isNotEmpty && pass.text.isNotEmpty) {
                      _login(email.text, pass.text);
                    } else {
                      AlertDialogHelper.showAlertDialog(
                          context,
                          'Error al ingresar',
                          'Rellene los campos y asegurese de que sean credenciales válidas');
                    }
                  },
                  label: const Text('Iniciar sesión'),
                  icon: Icon(Icons.person_2_outlined),
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: 60,
                width: 250,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      // Iniciar sesión con Google
                      signInWithGoogle().then((UserCredential? userCredential) {
                        if (userCredential != null) {
                          // El inicio de sesión fue exitoso, puedes realizar acciones adicionales aquí
                          print(
                              'Inicio de sesión exitoso: ${userCredential.user!.displayName}');
                          String? nombre_usuario = userCredential.user!.displayName;
                          Navigator.popAndPushNamed(context, '/home', arguments: {
                            'nombre_usuario': nombre_usuario,
                          });
                        } else {
                          SnackbarHelper.showSnackbar(
                              context, 'Hubo un problema al iniciar sesión');
                        }
                      });
                    } catch (e) {
                      print('hubo un error al iniciar con google');
                    }
                  },
                  label: const Text('Ingresar con Google'),
                  icon: Icon(Icons.g_mobiledata_outlined),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ProviderRegistration()));
                    },
                    child: const Text('Crear cuenta'),
                  ),
                  TextButton(
                      onPressed: () {
                        AlertDialogHelper.showAlertDialog(
                            context,
                            'Bienvenid@ a VisalApp',
                            'Esta aplicación te permitirá visualizar, reservar y obtener información en tiempo real y actualizada, respecto al estado actual de las salas y actividades de tu organización.');
                      },
                      child: const Text('¿Qué hace esta App?')),
                ],
              ),
          
              const Text('Versión 1.0.0'), //versión actual de la aplicación
            ],
          ),
        ),
      ),
    );
  }

  void _login(String email, String password) async {
    ProviderState providerState =
        Provider.of<ProviderState>(context, listen: false);

    try {
      if (await providerState.signInUserAccount(email, password)) {
        SnackbarHelper.showSnackbar(context, 'Inicio de sesión exitoso');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      } else {
        AlertDialogHelper.showAlertDialog(
            context, 'Error al ingresar', 'Credenciales invalidas');
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
    return const SnackBar(
      content: Text('Error al ingresar con Google'),
    );
  }
}
