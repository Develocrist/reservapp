import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menú principal'), actions: <Widget>[
        IconButton(onPressed: () {}, icon: const Icon(Icons.logout))
      ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                SizedBox(
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
      'Fecha actual: ' + formattedDate,
      style: TextStyle(fontSize: 18),
    );
  }
}
