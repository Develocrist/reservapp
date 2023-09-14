import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:reservas_theo/features/widgets/widgets.dart';
import 'package:reservas_theo/servicios/firebase_service.dart';

//import 'package:reservas_theo/servicios/upload_image.dart';

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
  TextEditingController roomNameController = TextEditingController();
  TextEditingController roomCapacityController = TextEditingController();
  TextEditingController roomDescriptionController = TextEditingController();
  TextEditingController roomUbicacion = TextEditingController();
  TextEditingController roomAlto = TextEditingController();
  TextEditingController roomAncho = TextEditingController();
  TextEditingController roomLargo = TextEditingController();

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
                      controller: roomNameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      controller: roomCapacityController,
                      decoration: const InputDecoration(
                        labelText: 'Capacidad',
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: roomDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción de la sala',
                ),
              ),
              TextField(
                controller: roomUbicacion,
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
                      controller: roomLargo,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Largo'),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextFormField(
                      controller: roomAncho,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Ancho'),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: roomAlto,
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
                          value: _selectedOptions.contains('Asesorías'),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                _selectedOptions.add('Asesorías');
                              } else {
                                _selectedOptions.remove('Asesorías');
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

              ElevatedButton(
                onPressed: () async {
                  // Asignación de los campos en el form a variables con determinado tipo de variable para luego enviarlos a firebase_service.dart
                  String roomName = roomNameController.text; //nombre de sala
                  int roomCapacity = int.parse(
                      roomCapacityController.text); //capacidad de sala
                  String roomDescription =
                      roomDescriptionController.text; //descripcion de sala
                  String roomLocation =
                      roomUbicacion.text; //ubicacion de la sala
                  int largoRoom = int.parse(roomLargo.text); //alto de sala
                  int anchoRoom = int.parse(roomAncho.text); //ancho de sala
                  int altoRoom = int.parse(roomAlto.text); //alto de sala
                  List<String> actividades_admitidas = _selectedOptions;

                  String estado = 'Disponible';
                  

                  String imageurl = await uploadImages();

                  addSalas(
                          roomName,
                          roomCapacity,
                          roomDescription,
                          roomLocation,
                          largoRoom,
                          anchoRoom,
                          altoRoom,
                          actividades_admitidas,
                          estado,
                          imageurl)
                      .then(
                    (_) {
                      Navigator.pop(context);
                    },
                  );
                },
                child: const Text('Añadir sala a firebase'),
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    roomNameController.dispose();
    roomCapacityController.dispose();
    roomDescriptionController.dispose();
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

  Future<String> uploadImages() async {
    String imageUrl = '';
    for (final imageFile in imagesToUpload) {
      final uploaded = await uploadImage(imageFile!);
      // ignore: unnecessary_null_comparison
      if (uploaded != null) {
        SnackbarHelper.showSnackbar(context, 'Sala incorporada con Éxito!');
        imageUrl = uploaded;
      } else {
        SnackbarHelper.showSnackbar(context, 'Ha ocurrido un problema');
      }
    }
    return imageUrl;
  }

  void removeImage(int index) {
    setState(() {
      imagesToUpload.removeAt(index);
    });
  }
}

//--------------------------

FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;

//funcion que sube la imagen y genera la url
Future<String> uploadImage(File image) async {
  print(image.path);
  final String namefile = image.path.split("/").last;
  Reference ref = storage.ref().child('imagenes').child(namefile);
  final UploadTask uploadTask = ref.putFile(image);
  print(uploadTask);
  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
  print(snapshot);
  final String url = await snapshot.ref.getDownloadURL();

  print(url);
  return url;
}
