import 'package:flutter/material.dart';
import 'package:VisalApp/servicios/firebase_service.dart';

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
            //variable que recibe la url de la imagen a cargar
            String? urlImagen = room['urlImagen'];

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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$nombre\n',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text('Capacidad: ${room['capacidad']} Personas.\n'),
                          Text('Descripción:${room['descripcion']}\n'),
                          Text('Ubicación: ${room['ubicacion']}\n'),
                          Text(
                              'Dimensiones (Metros):\nAlto: ${room['alto_sala']} MT\nAncho: ${room['ancho_sala']} MT\nLargo: ${room['largo_sala']} MT\n'),
                          Text(
                              'Actividades admitidas:\n${room['actividades_admitidas']}\n'),
                          Text('Estado actual: ${room['estado']}\n'),
                          const Text('Imagen referencial:\n'),
                          SizedBox(
                            width: 300,
                            height: 200,
                            //color: Colors.red,
                            child: urlImagen != null && urlImagen.isNotEmpty
                                ? Image.network(
                                    urlImagen,
                                    fit: BoxFit.fill,
                                  )
                                : FadeInImage.assetNetwork(
                                    placeholder: 'assets/carga.gif', image: ''),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // FloatingActionButton(
                          //   backgroundColor: Colors.green,
                          //   onPressed: () async {
                          //     String idSala = room['uid'];
                          //     print(idSala);
                          //     await Navigator.pushNamed(context, '/update_room',
                          //         //se envian los argumentos para luego abrir la modificacion y que estos ya se encuentren reemplazados para su modificacion
                          //         arguments: {
                          //           "id_sala": idSala,
                          //           "nombre": snapshot.data?[index]['nombre'],
                          //         });

                          //     setState(() {});
                          //   },
                          //   child: const Icon(
                          //     Icons.edit,
                          //   ),
                          // )
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
