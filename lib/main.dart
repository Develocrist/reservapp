import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:reservas_theo/register_screen.dart';
import 'package:reservas_theo/firebase_options.dart';
import 'package:reservas_theo/login_screen.dart';
import 'package:reservas_theo/home_screen.dart';
import 'package:reservas_theo/pages/salas/salas.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //se asegura de que todas las dependencias necesitadas esten inicializadas antes de lanzar el programa
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Theo App',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => const HomeScreen(),
        "/add": (context) => const AddRoomScreen(),
        "/edit": (context) => const EditRoomScreen(),
        "/see": (context) => const SeeRoomScreen(),
        "/register": (context) => const RegisterScreen(),
      },
    );
  }
}
