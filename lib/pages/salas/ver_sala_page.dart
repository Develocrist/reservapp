import 'package:flutter/material.dart';
import 'package:reservas_theo/services/firebase_service.dart';

class SeeRoomScreen extends StatefulWidget {
  const SeeRoomScreen({super.key});

  @override
  State<SeeRoomScreen> createState() => _SeeRoomScreenState();
}

class _SeeRoomScreenState extends State<SeeRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver salas'),
      ),
      body: FutureBuilder(
        future: getSalas(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
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
                  background:
                      Container(child: Icon(Icons.delete), color: Colors.red),
                  key: Key(snapshot.data?[index]['uid']),
                  child: ListTile(
                    title: Text(snapshot.data?[index]['nombre']),
                    subtitle: Text(
                        'Capacidad: ${snapshot.data?[index]['capacidad']} personas'),
                    // onTap: (() async {
                    //   await Navigator.pushNamed(context, '/edit');
                    //   setState(() {});
                    // }),
                    onTap: () {
                      print(snapshot.data?[index]['capacidad']);
                    },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
