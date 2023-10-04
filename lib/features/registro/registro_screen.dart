import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:VisalApp/features/login/login_screen.dart';
import 'package:VisalApp/features/widgets/ui.dart';
import 'package:VisalApp/provider/ProviderState.dart';

class ProviderRegistration extends StatefulWidget {
  const ProviderRegistration({super.key});

  @override
  State<ProviderRegistration> createState() => _ProviderRegistrationState();
}

class _ProviderRegistrationState extends State<ProviderRegistration> {
  //variables para el registro

  final TextEditingController nombre = TextEditingController();
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Antes de comenzar... Registrate.',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nombre de usuario',
                      border: OutlineInputBorder(),
                    ),
                    controller: nombre,
                    maxLength: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      border: OutlineInputBorder(),
                    ),
                    maxLength: 30,
                    controller: correo,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingrese un correo electrónico válido';
                      }
                      return null;
                    },
                  ),
                  
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                    maxLength: 10,
                    obscureText: true,
                    controller: password,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingrese una contraseña válida';
                      }
                      return null;                      
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    maxLength: 15,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                        labelText: 'Organización',
                        suffixIcon: IconButton(
                          onPressed: () {
                            AlertDialogHelper.showAlertDialog(
                                context,
                                '¿Qué es esto?',
                                'El campo Organización corresponde a un identificador único entregado a la organización, con la finalidad de no permitir el registro de cualquier usuario, sino solo aquellos autorizados por la organización que haga uso de esta Aplicación.');
                          },
                          icon: const Icon(Icons.info_outline),
                        )),
                    controller: organizacion,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingrese una organización valida';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton.icon(
                    onPressed: () {
                      //validacion de la organización, se debe cambiar por algo mas profesional
                      final String organizacionText = organizacion.text;
                      //registro de usuario con rol de usuario
                      if (nombre.text.isNotEmpty &&
                          correo.text.isNotEmpty &&
                          password.text.isNotEmpty &&
                          organizacionText.toLowerCase().contains('umd')) {
                        String rol = 'Usuario común';
                        registerUser(nombre.text, correo.text, password.text,
                            rol, context);
                        SnackbarHelper.showSnackbar(
                            context, 'Registro de Usuario exitoso');
                      } //registro de usuario con rol de administrador
                      else if (nombre.text.isNotEmpty &&
                          correo.text.isNotEmpty &&
                          password.text.isNotEmpty &&
                          organizacionText
                              .toLowerCase()
                              .contains('admi_visalapp')) {
                        String rol = 'Administrador';
                        registerUser(nombre.text, correo.text, password.text,
                            rol, context);
                        SnackbarHelper.showSnackbar(
                            context, 'Registro de Administrador exitoso');
                      } else {
                        //si la organización no es valida entonces se muestra una alerta
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Error al registrar'),
                              content: const Text(
                                  'Porfavor, ingrese todos los campos y asegurese de que la organización ingresada sea una válida.'),
                              actions: <Widget>[
                                TextButton(
                                    child: const Text('Aceptar'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    }),
                              ],
                            );
                          },
                        );
                      }
                    },
                    label: const Text('Registrarse'),
                    icon: Icon(Icons.app_registration_outlined),
                  ),
                  const SizedBox(height:  16.0),
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
  void registerUser(
      String nombre, String email, String password, rol, context) async {
    ProviderState providerState =
        Provider.of<ProviderState>(context, listen: false);

    try {
      if (await providerState.createUserAccount(nombre, email, password, rol)) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ProviderLogin()));
      }
    } catch (e) {
      print('Hubo un error al registrar el usuario $e');

    }
  }
}
