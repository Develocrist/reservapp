import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reservas_theo/services/firebase_service.dart';
import 'package:reservas_theo/services/select_image.dart';
import 'package:reservas_theo/services/upload_image.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({Key? key}) : super(key: key);

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  List<File?> imagesToUpload = [];

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
      body: SingleChildScrollView(
        child: Padding(
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
              Column(
                children: [
                  for (var i = 0; i < imagesToUpload.length; i++)
                    Container(
                      width: 200,
                      height: 300,
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 1.2,
                            child: Image.file(
                              imagesToUpload[i]!,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Positioned(
                            top: 3,
                            right: 3,
                            child: IconButton(
                              onPressed: () {
                                removeImage(i);
                              },
                              icon: Icon(
                                size: 30,
                                Icons.close,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              ElevatedButton(
                onPressed: selectImages,
                child: const Text('Agregar Imagen'),
              ),
              ElevatedButton(
                  onPressed: () {}, child: Text('Eliminar imagenes')),
              ElevatedButton(
                onPressed: () {},
                // onPressed: () async {
                //   if (imagesToUpload == null) {
                //     return;
                //   }
                //   final uploaded = await uploadImage(imagesToUpload!);
                //   if (uploaded) {
                //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //         content: Text('Imagen subida correctamente')));
                //   } else {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(content: Text('Error al subir imagen')));
                //   }
                // },
                child: const Text('Subir imagen a firebase'),
              ),
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

  Future<void> selectImages() async {
    final List<XFile>? selectedImages =
        await ImagePicker().pickMultiImage(imageQuality: 80);
    if (selectedImages != null) {
      setState(() {
        imagesToUpload =
            selectedImages.map((image) => File(image.path)).toList();
      });
    }
  }

  Future<void> uploadImages() async {
    for (final imageFile in imagesToUpload) {
      final uploaded = await uploadImage(imageFile!);
      if (uploaded) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Imágenes subidas correctamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al subir imágenes')),
        );
      }
    }
  }

  void removeImage(int index) {
    setState(() {
      imagesToUpload.removeAt(index);
    });
  }

  // Future<void> addRoom() async {
  //   String roomName = _roomNameController.text;
  //   int roomCapacity = int.parse(_roomCapacityController.text);
  //   String roomDescription = _roomDescriptionController.text;

  //   // Subir imágenes y obtener URLs
  //   List<String> imageUrls = [];
  //   for (final imageFile in imagesToUpload) {
  //     final imageUrl = await uploadImage(imageFile!); // Reemplazar con la función de subida de imágenes
  //     imageUrls.add(imageUrl);
  //   }

  //   // Guardar formulario en Firestore junto con las URLs de las imágenes
  //   await addSalas(roomName, roomCapacity, roomDescription, imageUrls);

  //   Navigator.pop(context);
  // }

}
