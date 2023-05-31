import 'package:flutter/material.dart';
import 'package:reservas_theo/services/firebase_service.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({Key? key}) : super(key: key);

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  TextEditingController _roomNameController = TextEditingController();
  TextEditingController _roomCapacityController = TextEditingController();
  TextEditingController _roomDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir sala'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _roomNameController,
              decoration: const InputDecoration(
                labelText: 'Nombre de la sala',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              keyboardType: TextInputType.phone,
              controller: _roomCapacityController,
              decoration: const InputDecoration(
                labelText: 'Capacidad de la sala',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _roomDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción de la sala',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                // Acción del botón
                String roomName = _roomNameController.text;
                int roomCapacity = int.parse(_roomCapacityController.text);
                String roomDescription = _roomDescriptionController.text;
                await addSalas(roomName, roomCapacity, roomDescription).then(
                  (_) {
                    Navigator.pop(context);
                  },
                );
                print('Nombre de la sala: $roomName');
              },
              child: const Text('Añadir sala'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    _roomCapacityController.dispose();
    _roomDescriptionController.dispose();
    super.dispose();
  }
}
