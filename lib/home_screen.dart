import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menú principal')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
              ),
              child: const Text(
                'Ver salas',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Acción del segundo botón
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
              ),
              child: const Text(
                'Reservas',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Acción del tercer botón
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
              ),
              child: const Text(
                'Mis reservas',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Acción del cuarto botón
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
              ),
              child: const Text(
                'Informes',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/see');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
              ),
              child: const Text(
                'Gestionar salas',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
