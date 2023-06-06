import 'package:flutter/material.dart';
import 'package:reservas_theo/services/firebase_service.dart';

class DetailsRoomScreen extends StatefulWidget {
  const DetailsRoomScreen({Key? key}) : super(key: key);

  @override
  State<DetailsRoomScreen> createState() => _DetailsRoomScreenState();
}

class _DetailsRoomScreenState extends State<DetailsRoomScreen> {
  TextEditingController nameController = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    //se transforman los argumentos recibidos de la vista de salas para mostrarlos
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    nameController.text = arguments['name'];
    String nombre = nameController.text;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de sala'),
      ),
      body: FutureBuilder(
        future: getSalas(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            /*se utiliza la variable roomData para almacenar los datos de todas las salas y despues realiza una busqueda
            con la instruccion firstWhere comparando las uid y con eso importar la informacion asociada unicamente
            a esa id*/
            final roomData = snapshot.data;
            final room = roomData?.firstWhere(
                (room) => room['uid'] == arguments['uid'],
                orElse: () => null);

            //si no se encuentra una uid, se muestra un mensaje de error

            if (room == null) {
              return const Center(
                child: Text('No se encontró la sala.'),
              );
            }
            return ListView.builder(
              itemCount: 1,
              itemBuilder: ((context, index) {
                return Card(
                  child: Column(
                    children: [
                      Text(
                        'Nombre de sala: $nombre',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text('Capacidad: ${room['capacidad']} personas.'),
                      Text('Descripción: ${room['descripcion']}')
                    ],
                  ),
                );
              }),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
