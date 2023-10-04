import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:VisalApp/provider/ProviderState.dart';
import 'dart:async';
import 'package:VisalApp/features/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<String?> getUserRole(String? uid) async {
    //método para obtener el rol del usuario
    String? role;
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();
      //print(querySnapshot);
      if (querySnapshot.size > 0) {
        final userDoc = querySnapshot.docs[0];
        role = userDoc.get('role');
        //print('Role: $role');
      } else {
        role = 'Usuario Normal';
      }
    } catch (e) {
      //print('Error al obtener el rol del usuario: $e');
      role = 'Error al obtener el rol';
    }
    //print(role.toString());

    return role.toString();
  }

  //String? usuarioName;
  Future<String?> getUserName(String? uid) async {
    //metodo para capturar el nombre de usuario
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();
      //print(querySnapshot);
      if (querySnapshot.size > 0) {
        final userDoc = querySnapshot.docs[0];
        final nombre = userDoc.get('nombre');
        return nombre.toString();
      } else {
        return 'Por definir';
      }
    } catch (e) {
      return 'Error al obtener el nombre $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderState>(builder: (context, providerState, _) {
      //-------------------------------------- mensaje de bienvenida
      final Map<String, dynamic>? arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

      final String nombreUsuario = arguments?['nombre_usuario'] ??
          'UserVisalApp'; //se recibe el argumento nombre_usuario enviado desde providerlogin

      String welcomeMessage = ''; // mensaje de bienvenida

      final user = FirebaseAuth.instance.currentUser;
      final uid =
          user?.uid; //obtiene la uid del usuario para el builder del rol

      if (user != null) {
        final email = user.email;
        providerState.updateEmail(email);
      }
      if (providerState.getEmail != null &&
          providerState.getEmail!.isNotEmpty) {
        welcomeMessage = 'Bienvenido: ${providerState.getEmail!}';
      } else {
        welcomeMessage = 'Bienvenido: $nombreUsuario';
      }

      //---------------------------------------------------------------------------------- rol de usuario
      //print('valor username con provider: $nombreUsuario');
      String? userName = nombreUsuario; //asignacion de google a username
      //print('valor username con google: $userName');

      return Scaffold(
        appBar: AppBar(
          title: const Text('Menú principal'),
          actions: <Widget>[
            const Center(
              child: Text('Salir'),
            ),
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut(); //deslogeo con google
                  providerState.signOut(); //deslogeo sin google
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (Route<dynamic> route) => false,
                  );
                  SnackbarHelper.showSnackbar(context, 'Deslogueo exitoso!');
                },
                icon: const Icon(Icons.logout)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (welcomeMessage.isNotEmpty)
                FutureBuilder<String?>(
                  future: getUserRole(uid),
                  builder: (context, snapshot) {
                    final userRole = snapshot.data;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          //Text(nombreUsuario),
                          Text('$welcomeMessage\n$nombreUsuario'),
                          Text('Rol de usuario: $userRole'),
                          FutureBuilder(
                              future: getUserName(uid),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  String? usuarioName =
                                      snapshot.data ?? nombreUsuario;
                                  //print('valor usuarioName $usuarioName');
                                  if (usuarioName == 'Por definir') {
                                    //print('usuarioName1: $usuarioName');
                                    usuarioName = userName;
                                    //print('usuarioName: $usuarioName');
                                    return Text(
                                        'Nombre de usuarioooo: $usuarioName');
                                  } else {
                                    //aqui se muestra el nombre de usuario con provider
                                    //print('creo q siempre entra aca $usuarioName');
                                    userName = usuarioName;
                                    return Text(
                                        'Nombre de usuario: $usuarioName');
                                  }

                                  //userName = usuarioName; //aqui se reemplaza
                                  //aqui cambia porque fue reemplazado
                                } else if (snapshot.hasError) {
                                  return const Text(
                                      'Error al obtener el nombre');
                                } else {
                                  String usuarioNameProvider =
                                      snapshot.data ?? '';
                                  print(
                                      'nombre usuario provider: $usuarioNameProvider');
                                  return Text(
                                      'Nombre de usuario: $usuarioNameProvider');
                                }
                              }),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text('Reservas:'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await Navigator.pushNamed(
                                        context, '/myReservation',
                                        arguments: {
                                          "uid": user?.uid,
                                          "nombre": userName,
                                        });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(16.0),
                                  ),
                                  child: const Text(
                                    'Mis reservas',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // userName nombre de la variable con el nombre del usuario en ella, se debe enviar a la reserva
                                    await Navigator.pushNamed(
                                        context, '/addReservation2',
                                        arguments: {
                                          "uid": user?.uid,
                                          "nombre": userName
                                        });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(16.0),
                                  ),
                                  child: const Text(
                                    'Nueva reserva',
                                    style: TextStyle(fontSize: 14.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () async {
                              await Navigator.pushNamed(context,
                                  '/createReservation'); //antes era '/seeReservation'
                            },
                            child: const Text(
                              'Ver reservas',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          const Text('Salas:'),
                          ElevatedButton(
                            onPressed: () async {
                              await Navigator.pushNamed(
                                context,
                                '/see',
                                arguments: {
                                  "rol": userRole,
                                  "nombre": userName
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16.0),
                            ),
                            child: const Text(
                              'Ver salas',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          const Text('Administración:'),
                          ElevatedButton(
                            onPressed: () {
                              //verificar si el rol de usuario es admi o normal y en base eso ejecutar algo
                              if (userRole != 'Administrador') {
                                SnackbarHelper.showSnackbar(context,
                                    'Funcion solo disponible para usuarios con rol de Administrador');
                              } else {
                                Navigator.pushNamed(context, '/informes');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16.0),
                            ),
                            child: const Text(
                              'Informes',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                          'Error al obtener el rol del usuario: ${snapshot.error}');
                    } else {
                      return Text(
                          '$welcomeMessage\nid de usuario: ${user?.uid} \nRol de usuario: $userRole');
                    }
                  },
                ),
            ],
          ),
        ),
      );
    });
  }
}
