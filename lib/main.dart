import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reservas_theo/features/login/login_screen.dart';
import 'package:reservas_theo/features/registro/registro_screen.dart';
import 'package:reservas_theo/provider/ProviderState.dart';

import 'package:reservas_theo/screens/informes/informes_page.dart';
import 'package:reservas_theo/screens/reports/add_report_screen.dart';
import 'package:reservas_theo/screens/reports/report_screen.dart';
import 'package:reservas_theo/screens/reservas/add_reservation2.dart';

import 'package:reservas_theo/screens/reservas/reservas.dart'; //vistas respectivas a reservas
import 'package:reservas_theo/screens/reservas/see_reservation2.dart';

import 'package:reservas_theo/servicios/firebase_options.dart';
import 'package:reservas_theo/features/home/home_screen.dart';
import 'package:reservas_theo/screens/salas/salas.dart'; //vistas respectivas a salas

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //se asegura de que todas las dependencias necesitadas esten inicializadas antes de lanzar el programa
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      //inicializar providers
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
        //login y registro
        '/login': (context)     =>  const ProviderLogin(), //ruta a pantalla login2 <--- en uso actual        
        '/register': (context)  =>  const ProviderRegistration(), //ruta a pantalla de registro de usuario

        //pantalla principal
        '/home': (context)      =>   HomeScreen(), //ruta a menu principal        

        //reservas
        
        "/addReservation2": (context)   => ReservationScreen2(), //ruta a pantalla añadir reserva 2
        "/myReservation":   (context)   => const MyReservation(), //ruta a pantalla añadir reserva
        "/editMyReservation" :(context) => EditReservation(), //ruta a pantalla para editar la reserva y añadir asistentes

        //salas        
        "/details_room": (context)  =>   const DetailsRoomScreen(), //ruta a pantalla ver detalles de sala
        "/update_room": (context)   =>   const  UpdateRoomScreen(), //ruta a pantalla actualizar datos de sala      
        "/add": (context)           =>   const AddRoomScreen(), //ruta a pantalla añadir sala (solo administrador)
        "/edit": (context)          =>   const EditRoomScreen(), //ruta a pantalla modificar sala (solo administrador)
        "/see": (context)           =>   const SeeRoomScreen(), //ruta a pantalla visualizar salas (todos)

        //reportes
        "/createReservation": (context) =>  ReservationScreen(), //nueva interfaz para reservas (prueba)
        "/reports":           (context) =>  ReportScreen(), //interfaz para visualizar los reportes
        "/addReport":         (context) =>  AddReport(), //interfaz para añadir un reporte

        //informes
        "/informes":          (context) =>  const Informes(), //ruta a pantalla de informes (solo administrador)
      },
    );
  }
}
