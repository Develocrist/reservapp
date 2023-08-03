import 'package:flutter/material.dart';
import 'package:reservas_theo/servicios/firebase_service.dart';

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
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Nombre de sala: $nombre',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text('Capacidad: ${room['capacidad']} personas.'),
                          Text('Descripción: ${room['descripcion']}'),
                          Text('Ubicación: ${room['ubicacion']}'),
                          Text(
                              'Dimensiones (Metros): \nAlto: ${room['alto_sala']} MT , Ancho: ${room['ancho_sala']} MT, Largo: ${room['largo_sala']} MT'),
                          Text(
                              'Actividades admitidas: ${room['actividades_admitidas']}'),
                          Text('Estado actual: ${room['estado']}'),
                          Container(
                            width: 300,
                            height: 200,
                            //color: Colors.red,
                            child: Image.network(
                              'https://i.ibb.co/s36ySMD/sala1.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FloatingActionButton(
                            backgroundColor: Colors.green,
                            onPressed: () async {
                              String idSala = room['uid'];
                              print(idSala);
                              await Navigator.pushNamed(context, '/update_room',
                                  //se envian los argumentos para luego abrir la modificacion y que estos ya se encuentren reemplazados para su modificacion
                                  arguments: {
                                    "id_sala": idSala,
                                    "nombre": snapshot.data?[index]['nombre'],
                                    // "capacidad": snapshot.data?[index]
                                    //     ['capacidad'],
                                    // "descripcion": snapshot.data?[index]
                                    //     ['descripcion'],
                                    // "ubicacion": snapshot.data?[index]
                                    //     ['ubicacion'],
                                    // "alto": snapshot.data?[index]['alto_sala'],
                                    // "ancho": snapshot.data?[index]
                                    //     ['ancho_sala'],
                                    // "largo": snapshot.data?[index]
                                    //     ['largo_sala'],
                                  });

                              setState(() {});
                            },
                            child: const Icon(
                              Icons.edit,
                            ),
                          )
                        ],
                      ),
                    ),
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
