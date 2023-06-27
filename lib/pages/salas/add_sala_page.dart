import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:reservas_theo/services/firebase_service.dart';

import 'package:reservas_theo/services/upload_image.dart';

class AddRoomScreen extends StatefulWidget {
  const AddRoomScreen({Key? key}) : super(key: key);

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  List<File?> imagesToUpload = []; //lista para añadir varias imagenes
  final List<String> _selectedOptions =
      []; //lista para añadir los tipos de actividades admitidas

  //se declaran las variables para cada uno de los valores a ingresar.
  TextEditingController _roomNameController = TextEditingController();
  TextEditingController _roomCapacityController = TextEditingController();
  TextEditingController _roomDescriptionController = TextEditingController();
  TextEditingController _roomUbicacion = TextEditingController();
  TextEditingController _roomAlto = TextEditingController();
  TextEditingController _roomAncho = TextEditingController();
  TextEditingController _roomLargo = TextEditingController();

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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Información General: ',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _roomNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      controller: _roomCapacityController,
                      decoration: const InputDecoration(
                        labelText: 'Capacidad',
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _roomDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción de la sala',
                ),
              ),
              TextField(
                controller: _roomUbicacion,
                decoration: const InputDecoration(
                  labelText: 'Ubicación de la sala',
                ),
              ),
              const SizedBox(height: 16.0),
              const Text('Dimensiones (Metros)',
                  style: TextStyle(fontSize: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _roomLargo,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Largo'),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: _roomAncho,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Ancho'),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _roomAlto,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Alto'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              //radio buttons para los tipos de actividades que se admiten
              const Text(
                'Actividades admitidas',
                style: TextStyle(fontSize: 16),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          contentPadding:
                              const EdgeInsets.fromLTRB(0.5, 0.5, 0.5, 0.5),
                          title: const Text(
                            'Capacitación',
                          ),
                          value: _selectedOptions.contains('Capacitación'),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                _selectedOptions.add('Capacitación');
                              } else {
                                _selectedOptions.remove('Capacitación');
                              }
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          contentPadding:
                              const EdgeInsets.fromLTRB(0.5, 0.5, 0.5, 0.5),
                          title: const Text('Talleres'),
                          value: _selectedOptions.contains('Talleres'),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                _selectedOptions.add('Talleres');
                              } else {
                                _selectedOptions.remove('Talleres');
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          contentPadding:
                              const EdgeInsets.fromLTRB(0.5, 0.5, 0.5, 0.5),
                          title: const Text('Asesorías'),
                          value: _selectedOptions.contains('Asesoría'),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                _selectedOptions.add('Asesoría');
                              } else {
                                _selectedOptions.remove('Asesoría');
                              }
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          contentPadding:
                              const EdgeInsets.fromLTRB(0.5, 0.5, 0.5, 0.5),
                          title: const Text('Reuniones'),
                          value: _selectedOptions.contains('Reuniones'),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                _selectedOptions.add('Reuniones');
                              } else {
                                _selectedOptions.remove('Reuniones');
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16.0),
              Column(
                children: [
                  for (var i = 0; i < imagesToUpload.length; i++)
                    Container(
                      width: 200,
                      height: 200,
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
                              icon: const Icon(
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
              // ElevatedButton(
              //   onPressed: () async {
              //     if (imagesToUpload == null) {
              //       return;
              //     }
              //     final uploaded = await uploadImage(imagesToUpload!);
              //     if (uploaded) {
              //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              //           content: Text('Imagen subida correctamente')));
              //     } else {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //           const SnackBar(content: Text('Error al subir imagen')));
              //     }
              //   },
              //   child: const Text('Subir imagen a firebase'),
              // ),
              ElevatedButton(
                onPressed: () async {
                  // Asignación de los campos en el form a variables con determinado tipo de variable para luego enviarlos a firebase_service.dart
                  String roomName = _roomNameController.text; //nombre de sala
                  int roomCapacity = int.parse(
                      _roomCapacityController.text); //capacidad de sala
                  String roomDescription =
                      _roomDescriptionController.text; //descripcion de sala
                  String roomLocation =
                      _roomUbicacion.text; //ubicacion de la sala
                  int largoRoom = int.parse(_roomLargo.text); //alto de sala
                  int anchoRoom = int.parse(_roomAncho.text); //ancho de sala
                  int altoRoom = int.parse(_roomAlto.text); //alto de sala
                  List<String> actividades_admitidas = _selectedOptions;
                  await uploadImages();
                  addSalas(
                    roomName,
                    roomCapacity,
                    roomDescription,
                    roomLocation,
                    largoRoom,
                    anchoRoom,
                    altoRoom,
                    actividades_admitidas,
                    //imagesToUpload
                  ).then(
                    (_) {
                      Navigator.pop(context);
                    },
                  );
                  print('Nombre de la sala: $roomName');
                },
                child: const Text('Añadir sala a firebase'),
              ),
              // ElevatedButton(
              //     onPressed: () {
              //       print('opciones seleccionadas: $_selectedOptions');
              //     },
              //     child: const Text('Ver opciones')),
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
