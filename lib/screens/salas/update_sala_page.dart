import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:reservas_theo/servicios/firebase_service.dart';

import 'package:reservas_theo/servicios/upload_image.dart';

class UpdateRoomScreen extends StatefulWidget {
  const UpdateRoomScreen({Key? key}) : super(key: key);

  @override
  State<UpdateRoomScreen> createState() => _UpdateRoomScreenState();
}

class _UpdateRoomScreenState extends State<UpdateRoomScreen> {
  List<File?> imagesToUpload = []; //lista para añadir varias imagenes
  List<String> _selectedOptions = [];
  //se declaran las variables para cada uno de los valores a ingresar.
  TextEditingController roomNameController = TextEditingController(text: "");
  TextEditingController roomCapacityController = TextEditingController();
  TextEditingController roomDescriptionController = TextEditingController();
  TextEditingController roomUbicacion = TextEditingController();
  TextEditingController roomAlto = TextEditingController();
  TextEditingController roomAncho = TextEditingController();
  TextEditingController roomLargo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final String salaId = arguments['id_sala'];
    final String nameRoom = arguments['nombre'];
    final Future<List> salas = getSalas();

    // roomCapacityController = arguments['capacidad'];
    // roomDescriptionController.text = arguments['descripcion'];
    // roomUbicacion.text = arguments['ubicacion'];
    // roomAlto = arguments['alto_sala'];
    // roomAncho = arguments['ancho_sala'];
    // roomLargo = arguments['largo_sala'];

    return Scaffold(
        appBar: AppBar(
          title: Text('Actualizar sala :'),
          actions: [
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                print(salaId + " " + nameRoom);
              },
            )
          ],
        ),
        body: FutureBuilder(
            future: salas,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                /*se utiliza la variable roomData para almacenar los datos de todas las salas y despues realiza una busqueda
            con la instruccion firstWhere comparando las uid y con eso importar la informacion asociada unicamente
            a esa id*/
                final roomData = snapshot.data;
                final room = roomData?.firstWhere(
                    (room) => room['uid'] == salaId,
                    orElse: () => null);
                print(room);

                //si no se encuentra una uid, se muestra un mensaje de error

                if (room == null) {
                  return const Center(
                    child: Text('No se encontró la sala.'),
                  );
                }

                // roomCapacityController.text = room['capacidad'].toString();
                // roomDescriptionController.text = room['descripcion'];
                // roomUbicacion.text = room['ubicacion'];
                // roomAlto.text = room['alto_sala'].toString();
                // roomAncho.text = room['ancho_sala'].toString();
                // roomLargo.text = room['largo_sala'].toString();
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Información General: ',
                          style: TextStyle(fontSize: 18),
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
                            labelText: 'Nueva descripción',
                          ),
                        ),
                        TextField(
                          controller: roomUbicacion,
                          decoration: const InputDecoration(
                            hintText: 'Nueva ubicación',
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Text('Actualizar dimensiones',
                            style: TextStyle(fontSize: 18)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: roomLargo,
                                keyboardType: TextInputType.number,
                                decoration:
                                    const InputDecoration(hintText: 'Largo'),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: TextFormField(
                                controller: roomAncho,
                                keyboardType: TextInputType.number,
                                decoration:
                                    const InputDecoration(hintText: 'Ancho'),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: roomAlto,
                                keyboardType: TextInputType.number,
                                decoration:
                                    const InputDecoration(hintText: 'Alto'),
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
                          style: TextStyle(fontSize: 18),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: CheckboxListTile(
                                    title: const Text(
                                      'Capacitación',
                                    ),
                                    value: _selectedOptions
                                        .contains('Capacitación'),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value!) {
                                          _selectedOptions.add('Capacitación');
                                        } else {
                                          _selectedOptions
                                              .remove('Capacitación');
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: CheckboxListTile(
                                    title: const Text('Talleres'),
                                    value:
                                        _selectedOptions.contains('Talleres'),
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
                                    title: const Text('Asesorías'),
                                    value:
                                        _selectedOptions.contains('Asesoría'),
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
                                    title: const Text('Reuniones'),
                                    value:
                                        _selectedOptions.contains('Reuniones'),
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
                            String roomName =
                                roomNameController.text; //nombre de sala
                            int roomCapacity = int.parse(roomCapacityController
                                .text); //capacidad de sala
                            String roomDescription = roomDescriptionController
                                .text; //descripcion de sala
                            String roomLocation =
                                roomUbicacion.text; //ubicacion de la sala
                            int largoRoom =
                                int.parse(roomLargo.text); //alto de sala
                            int anchoRoom =
                                int.parse(roomAncho.text); //ancho de sala
                            int altoRoom =
                                int.parse(roomAlto.text); //alto de sala
                            List<String> actividades_admitidas =
                                _selectedOptions;
                            await updateSalas(
                              room['uid'],
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
                                setState(() {});
                              },
                            );
                            print('Nombre de la sala: $roomName');
                          },
                          child: const Text('Actualizar sala'),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              print(
                                  'opciones seleccionadas: $_selectedOptions');
                              print(room);
                            },
                            child: const Text('Ver opciones'))
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  @override
  void dispose() {
    roomNameController.dispose();
    roomCapacityController.dispose();
    roomDescriptionController.dispose();
    roomUbicacion.dispose();
    roomAlto.dispose();
    roomAncho.dispose();
    roomLargo.dispose();

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
}
