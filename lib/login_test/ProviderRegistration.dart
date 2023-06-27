import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:reservas_theo/login_test/ProviderLogin.dart';
import 'package:reservas_theo/login_test/ProviderState.dart';

class ProviderRegistration extends StatefulWidget {
  const ProviderRegistration({super.key});

  @override
  State<ProviderRegistration> createState() => _ProviderRegistrationState();
}

class _ProviderRegistrationState extends State<ProviderRegistration> {
  //variables para el registro
  final TextEditingController correo = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController organizacion = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Registrate en TheoApp',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // SizedBox(height: 16.0),
                  // TextFormField(
                  //   decoration: const InputDecoration(
                  //     labelText: 'Nombre',
                  //   ),
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return 'Ingrese un nombre válido';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                    ),
                    controller: correo,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingrese un correo electrónico válido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Organización',
                    ),
                    controller: organizacion,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingrese una organización valida';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                    ),
                    obscureText: true,
                    controller: password,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingrese una contraseña válida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () {
                      //validacion de la organización, se debe cambiar por algo mas profesional
                      final String organizacionText = organizacion.text;

                      if (correo.text.isNotEmpty &&
                          password.text.isNotEmpty &&
                          organizacionText.toLowerCase().contains('umd')) {
                        registerUser(correo.text, password.text, context);
                      } else {
                        //si la organización no es valida entonces se muestra una alerta
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error al registrar'),
                                content: const Text(
                                    'Porfavor, ingrese todos los campos y asegurese de que la organización sea válida.'),
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
                    child: const Text('Registrarse'),
                  ),
                  const SizedBox(height: 16.0),
                  //volver al login
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProviderLogin()));
                    },
                    child: const Text('Volver al inicio de sesión'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//metodo registro de usuario, el cual
  void registerUser(String email, String password, context) async {
    ProviderState providerState =
        Provider.of<ProviderState>(context, listen: false);

    try {
      if (await providerState.createUserAccount(email, password)) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ProviderLogin()));
      }
    } catch (e) {}
  }
}
