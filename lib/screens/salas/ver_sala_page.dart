import 'package:flutter/material.dart';
import 'package:reservas_theo/features/widgets/ui.dart';
import 'package:reservas_theo/servicios/firebase_service.dart';

class SeeRoomScreen extends StatefulWidget {
  const SeeRoomScreen({super.key});

  @override
  State<SeeRoomScreen> createState() => _SeeRoomScreenState();
}

class _SeeRoomScreenState extends State<SeeRoomScreen> {
  //recepcion de argumentos, en este caso de administrador,
  //para autorizar o no a realizar ciertas funciones

  List<String> dataList = [];
  List<String> filteredList = [];

  //--------------------- buscador de salas
  @override
  void initState() {
    super.initState();
    fetchRoomData();
  }

  Future<void> fetchRoomData() async {
    // Obtiene los datos de las salas
    List<Map<String, dynamic>> rooms =
        List<Map<String, dynamic>>.from(await getSalas());

    setState(() {
      dataList = rooms.map((room) => room['nombre'].toString()).toList();
      filteredList = dataList;
    });
  }

  void filterList(String query) {
    setState(() {
      filteredList = dataList
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  //----------------------
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    String? rol = arguments['rol'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salas'),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  if (rol == 'Administrador') {
                    Navigator.pushNamed(context, '/add');
                    //setState(() {});
                  } else {
                    SnackbarHelper.showSnackbar(context,
                        'Función disponible solo para usuarios administradores');
                  }
                },
                icon: const Icon(Icons.add_home_outlined),
                iconSize: 40,
              ),
              IconButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, '/reports');
                  setState(() {});
                },
                icon: const Icon(Icons.report_gmailerrorred),
                iconSize: 40,
              )
            ],
          ),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              filterList(value);
              //print(filteredList);
            },
            decoration: InputDecoration(
                labelText: 'Buscar sala', prefixIcon: Icon(Icons.search)),
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: getSalas(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: ((context, index) {
                    return Dismissible(
                      onDismissed: (direction) async {
                        await deleteSalas(snapshot.data?[index]['uid']);
                        //print('sala eliminada');
                        snapshot.data?.removeAt(index);
                      },
                      confirmDismiss: (direction) async {
                        bool result = false;
                        result = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                    'Desea eliminar a ${snapshot.data?[index]['nombre']} ?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      return Navigator.pop(context, false);
                                    },
                                    child: const Text(
                                      'Cancelar',
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      return Navigator.pop(context, true);
                                    },
                                    child: const Text('Si, eliminar',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              );
                            });
                        return result;
                      },
                      direction: DismissDirection.endToStart,
                      background: Container(
                          child: Icon(Icons.delete), color: Colors.red),
                      key: Key(snapshot.data?[index]['uid']),
                      child: ListTile(
                        title: Text(filteredList[index]),
                        subtitle:
                            Text('Estado: ${snapshot.data?[index]['estado']}'),
                        onTap: () {
                          //print(snapshot.data?[index]['capacidad']);
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.info_outline,
                                color: Colors.blue,
                              ),
                              onPressed: () async {
                                //obtiene el elemento en el indice 'index' solo si la lista no es nula
                                if (snapshot.data != null &&
                                    snapshot.data!.isNotEmpty) {
                                  final dataAtIndex = snapshot.data![index];
                                  if (dataAtIndex != null) {
                                    await Navigator.pushNamed(
                                      context,
                                      '/details_room',
                                      arguments: {
                                        "uid": snapshot.data?[index]['uid'],
                                        "name": snapshot.data?[index]['nombre']
                                      },
                                    );
                                  } else {
                                    SnackbarHelper.showSnackbar(context,
                                        'Ha ocurrido un error al enviar la información de la sala');
                                  }
                                } else {
                                  SnackbarHelper.showSnackbar(
                                      context, 'Ha ocurrido un error');
                                }
                              },
                            ),
                            IconButton(
                                onPressed: () async {
                                  await Navigator.pushNamed(
                                      context, '/addReport', arguments: {
                                    "uid": snapshot.data?[index]['uid'],
                                    "name": snapshot.data?[index]['nombre']
                                  });
                                },
                                icon: const Icon(
                                  Icons.report_gmailerrorred,
                                  color: Colors.red,
                                ))
                          ],
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
        ),
      ]),
    );
  }
}
