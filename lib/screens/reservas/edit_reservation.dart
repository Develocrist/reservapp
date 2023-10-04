import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:VisalApp/features/widgets/ui.dart';

//28-08 se necesita importar la id de la reserva, para despues cargar la información de esta en los campos de texto
//se necesitan 2 botones igual para cambiar el estado de la reserva el cual debe actualizarse en firebase y que sea visible para todos
//se necesita importar ademas los usuarios registrados para añadirlos en formato de asistentes, en forma de lista.

class EditReservation extends StatefulWidget {
  const EditReservation({super.key});

  @override
  State<EditReservation> createState() => _EditReservationState();
}

class _EditReservationState extends State<EditReservation> {
  String? idReservacion;
  String? asunto = "";
  String? descripcion = "";
  TextEditingController _asuntoController = TextEditingController(text: '');
  TextEditingController _descripcionController = TextEditingController(text: '');
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    idReservacion = arguments['idReserva'];
    cargarDatosReserva();
  }

  List<String> usuariosRegistrados =
      []; //lista para almacenar a los usuarios capturados

  //método para cargar los usuarios ya registrados en firebase, incluyendo a los admis
  Future<void> cargarUsuariosRegistrados() async {
    try {
      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      usuariosRegistrados = [];

      for (QueryDocumentSnapshot doc in userSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('nombre')) {
          String nombre = data['nombre'] as String;
          usuariosRegistrados.add(nombre);
        }
      }
      setState(() {
        print(
            'los usuarios cargados fueron los siguientes: $usuariosRegistrados');
      });
    } catch (e) {
      print('Ocurrio un error al cargar los usuarios $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarUsuariosRegistrados();
  }

  List<String> asistentesSeleccionados = []; //inicialmente vacio
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modificar reserva'),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'ID de Reserva:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                idReservacion ?? 'N/A', // Mostrar "N/A" si la ID está vacía
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16), // Separación entre elementos
              const Text(
                'Asunto:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: _asuntoController, // Valor inicial del TextFormField
                decoration: const InputDecoration(
                  border: OutlineInputBorder(), // Borde alrededor del campo
                ),
                maxLength: 30,
                onChanged: (value) {
                  setState(() {
                    asunto = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              const Text(
                'Descripción:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: _descripcionController, // Valor inicial del TextFormField
                maxLines: 3, // Varias líneas para la descripción
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                maxLength: 100,
                onChanged: (value) {
                  setState(() {
                    descripcion = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Añadir asistentes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: usuariosRegistrados.length,
                  itemBuilder: (BuildContext context, int index) {
                    final nombreUsuario = usuariosRegistrados[index];
                    return CheckboxListTile(
                      title: Text(nombreUsuario),
                      value: asistentesSeleccionados.contains(nombreUsuario),
                      onChanged: (bool? isChecked) {
                        setState(() {
                          if (isChecked!) {
                            asistentesSeleccionados.add(nombreUsuario);
                          } else {
                            asistentesSeleccionados.remove(nombreUsuario);
                          }
                          print(
                              'asistentes seleccionados: $asistentesSeleccionados');
                        });
                      },
                    );
                  }),

              ElevatedButton(
                onPressed: () {
                  actualizarReserva();
                },
                child: const Text('Guardar Cambios'),
              ),
            ],
          )),
    );
  }

  Future<void> cargarDatosReserva() async {
    try {
      final DocumentSnapshot reservaSnapshot = await FirebaseFirestore.instance
          .collection('reservations')
          .doc(idReservacion)
          .get();

      if (reservaSnapshot.exists) {
        setState(() {
          asunto = reservaSnapshot['Asunto'];
          descripcion = reservaSnapshot['Descripción'];
        });
      } else {
        setState(() {
          asunto = "";
          descripcion = "";
        });
      }
    } catch (e) {
      print('Hubo un error con los datos de reserva : $e');
    }
  }

  Future<void> actualizarReserva() async {
    try {
      final DocumentReference reservaRef = FirebaseFirestore.instance
          .collection('reservations')
          .doc(idReservacion);
      Map<String, dynamic> datosActualizados = {
        'Asunto': asunto,
        'Descripción': descripcion,
        'Asistentes': asistentesSeleccionados.toList(),
      };

      await reservaRef.update(datosActualizados);
      SnackbarHelper.showSnackbar(context, 'Reserva actualizada con éxito');
    } catch (e) {
      print('Hubo un error al actualizar la reserva: $e');
    }
  }
}
