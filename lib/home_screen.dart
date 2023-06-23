import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:reservas_theo/login_test/ProviderState.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //---- testeando login con provider

    ProviderState? providerState = Provider.of<ProviderState>(context,
        listen: false); //obtiene una instancia del objeto ProviderState

    //------------ login con google
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final String nombreUsuario = arguments?['nombre_usuario'] ?? '';

    String welcomeMessage = ''; // mensaje de bienvenida

    if (providerState != null &&
        providerState.getEmail != null &&
        providerState.getEmail!.isNotEmpty) {
      welcomeMessage = 'Bienvenido: ${providerState.getEmail!}';
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Menú principal'), actions: <Widget>[
        IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); //deslogeo con google
              providerState.signOut(); //deslogeo sin google
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (Route<dynamic> route) => false,
              );
            },
            icon: const Icon(Icons.logout))
      ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (welcomeMessage.isNotEmpty) Text(welcomeMessage),
            // Visibility(
            //     visible: providerState.getEmail!.isNotEmpty,
            //     child: Text(
            //         'Bienvenido: ${providerState.getEmail}')), //saludo con provider
            // Visibility(
            //     visible: nombreUsuario.isNotEmpty,
            //     child: Text(
            //         'Bienvenido: $nombreUsuario')), //saludo con cuenta de google
            CurrentDateText(),
            const Text('Reservas:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await Navigator.pushNamed(context, '/myReservation');
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
                      await Navigator.pushNamed(context, '/addReservation');
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
                await Navigator.pushNamed(context, '/seeReservation');
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
                await Navigator.pushNamed(context, '/see');
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
                // Acción del cuarto botón
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
        ),
      ),
    );
  }
}

//generamos la fecha actual
class CurrentDateText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    String formattedDate =
        '${currentDate.day.toString().padLeft(2, '0')}/${currentDate.month.toString().padLeft(2, '0')}/${currentDate.year.toString()}';

    return Text(
      'Fecha actual: $formattedDate',
      style: const TextStyle(fontSize: 14),
    );
  }
}
