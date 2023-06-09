import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reservas_theo/login_test/ProviderLogin.dart';
import 'package:reservas_theo/login_test/ProviderRegistration.dart';
import 'package:reservas_theo/login_test/ProviderState.dart';

import 'package:reservas_theo/pages/informes/informes_page.dart';
import 'package:reservas_theo/pages/reports/add_report_screen.dart';
import 'package:reservas_theo/pages/reports/report_screen.dart';
import 'package:reservas_theo/pages/reservas/add_reservation2.dart';

import 'package:reservas_theo/pages/reservas/reservas.dart'; //vistas respectivas a reservas
import 'package:reservas_theo/pages/reservas/see_reservation2.dart';

import 'package:reservas_theo/register_screen.dart';
import 'package:reservas_theo/firebase_options.dart';
import 'package:reservas_theo/login_screen.dart';
import 'package:reservas_theo/home_screen.dart';
import 'package:reservas_theo/pages/salas/salas.dart'; //vistas respectivas a salas

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //se asegura de que todas las dependencias necesitadas esten inicializadas antes de lanzar el programa
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProviderState()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TheoApp',
      initialRoute: '/login',
      routes: {
        '/login2': (context) => LoginScreen(), //ruta a pantalla login (antigua)
        '/login': (context) =>
            ProviderLogin(), //ruta a pantalla login2 <--- en uso actual
        '/home': (context) => const HomeScreen(), //ruta a menu principal
        "/add": (context) =>
            const AddRoomScreen(), //ruta a pantalla añadir sala (solo administrador)
        "/edit": (context) =>
            const EditRoomScreen(), //ruta a pantalla modificar sala (solo administrador)
        "/see": (context) =>
            const SeeRoomScreen(), //ruta a pantalla visualizar salas (todos)
        "/register2": (context) =>
            const RegisterScreen(), //ruta a pantalla de registro de usuariov(antigua)
        "/register": (context) =>
            const ProviderRegistration(), //ruta a pantalla de registro de usuario
        "/details_room": (context) =>
            const DetailsRoomScreen(), //ruta a pantalla ver detalles de sala
        "/update_room": (context) =>
            const UpdateRoomScreen(), //ruta a pantalla actualizar datos de sala
        "/seeReservation": (context) =>
            SeeReservation(), //ruta a pantalla ver reservas
        "/addReservation": (context) =>
            AddReservation(), //ruta a pantalla añadir reserva

        "/addReservation2": (context) =>
            ReservationScreen2(), //ruta a pantalla añadir reserva 2
        "/myReservation": (context) =>
            const MyReservation(), //ruta a pantalla añadir reserva
        "/informes": (context) =>
            const Informes(), //ruta a pantalla de informes (solo administrador)

        "/createReservation": (context) =>
            ReservationScreen(), //nueva interfaz para reservas (prueba)

        "/reports": (context) =>
            ReportScreen(), //interfaz para visualizar los reportes
        "/addReport": (context) =>
            AddReport(), //interfaz para añadir un reporte
      },
    );
  }
}
