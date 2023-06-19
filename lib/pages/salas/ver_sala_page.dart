import 'package:flutter/material.dart';
import 'package:reservas_theo/services/firebase_service.dart';

class SeeRoomScreen extends StatefulWidget {
  const SeeRoomScreen({super.key});

  @override
  State<SeeRoomScreen> createState() => _SeeRoomScreenState();
}

class _SeeRoomScreenState extends State<SeeRoomScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salas'),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, '/add');
                  setState(() {});
                },
                icon: const Icon(Icons.add_home_outlined),
                iconSize: 40,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.report_gmailerrorred),
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
              print(filteredList);
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
                        print('sala eliminada');
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
                          subtitle: const Text('Estado actual: Disponible'),
                          //    'Ubicación: ${snapshot.data?[index]['ubicacion']}'),
                          // onTap: (() async {
                          //   await Navigator.pushNamed(context, '/edit');
                          //   setState(() {});
                          // }),
                          onTap: () {
                            print(snapshot.data?[index]['capacidad']);
                          },
                          trailing: IconButton(
                              icon: Icon(Icons.info),
                              onPressed: () async {
                                print(snapshot.data?[index]['uid']);
                                await Navigator.pushNamed(
                                    context, '/details_room', arguments: {
                                  "uid": snapshot.data?[index]['uid'],
                                  "name": snapshot.data?[index]['nombre']
                                });
                              })),
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
