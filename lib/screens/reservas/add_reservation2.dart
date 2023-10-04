import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:VisalApp/features/widgets/ui.dart';
import 'package:intl/intl.dart';
import 'package:VisalApp/screens/reservas/horas_reservas.dart';

class ReservationScreen2 extends StatefulWidget {
  @override
  _ReservationScreen2State createState() => _ReservationScreen2State();
}

class Reservation {
  final String name;
  final String description;
  final DateTime horaInicio;
  final DateTime horaFin;
  final String location;
  final String user;
  final String idUsuario;
  final DateTime? fechaReserva;
  final List<String> asistentes = [];

  Reservation({
    required this.name,
    required this.description,
    required this.horaInicio,
    required this.horaFin,
    required this.location,
    required this.user,
    required this.fechaReserva,
    required this.idUsuario,
    required List<String> asistentes, required Timestamp fechaCreacion,
  });

  Map<String, dynamic> toMap() {
    return {
      'Asunto': name,
      'Descripción': description,
      'Hora_inicio': horaInicio,
      'Hora_finalización': horaFin,
      'Lugar': location,
      'Usuario': user,
      'Fecha': fechaReserva,
      'uid': idUsuario,
      'Asistentes': asistentes,
    };
  }
}

class _ReservationScreen2State extends State<ReservationScreen2> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _userController = TextEditingController(text: '');
  final TextEditingController _userNameController =
      TextEditingController(text: '');

  //final TextEditingController _fechaReservaController = TextEditingController();

//metodo para crear la reserva
  Future<void> createReservation() async {
    try {
      final asunto = _nameController.text;
      final descripcion = _descriptionController.text;
      final horaInicio = tiempoInicio;
      final horaFin = tiempoFin;
      final location = _locationController.text;
      final user = _userNameController.text;
      final fechaReserva = fechaSeleccionada;
      final idUsuario = _userController.text;

      DateTime now = DateTime.now();
      DateTime dateTimeInicio = DateTime(
        now.year,
        now.month,
        now.day,
        horaInicio!.hour,
        horaInicio.minute,
      );

      DateTime now2 = DateTime.now();
      DateTime dateTimeFin = DateTime(
        now2.year,
        now2.month,
        now2.day,
        horaFin!.hour,
        horaFin.minute,
      );

      final List<String> asistentes = [];

      Timestamp now3 = Timestamp.now(); //obtener fecha y hora actual para el registro

      final reservation = Reservation(
          name: asunto,
          description: descripcion,
          horaInicio: dateTimeInicio,
          horaFin: dateTimeFin,
          location: location,
          user: user,
          fechaReserva: fechaReserva,
          idUsuario: idUsuario, // Agregar la ID del usuario
          asistentes: asistentes,
          fechaCreacion : now3, //agregar fecha y hora de creación
          );

      QuerySnapshot revisarReserva = await FirebaseFirestore.instance
          .collection('reservations')
          .where('Lugar', isEqualTo: location)
          .where('Hora_inicio', isEqualTo: dateTimeInicio)
          .where('Hora_finalización', isEqualTo: dateTimeFin)
          .get();

      if (revisarReserva.docs.isNotEmpty) {
        SnackbarHelper.showSnackbar(
            context, 'Ya existe una reserva para ese horario en esa sala');
      } else {
        final DocumentReference reservationRef = await FirebaseFirestore
            .instance
            .collection('reservations')
            .add(reservation.toMap());

        final String reservaId = reservationRef.id;

        // Actualiza la reserva con la ID del documento y la ID del usuario
        await FirebaseFirestore.instance
            .collection('reservations')
            .doc(reservaId)
            .update({
          'uid': reservaId,
          'id_usuario': idUsuario,
          'fechaCreacion' : now3
        });

        _nameController.clear();
        _descriptionController.clear();
        _locationController.clear();
        _userController.clear();

        SnackbarHelper.showSnackbar(context, 'Reserva creada con éxito');
      }
    } catch (e) {
      print(e);
      SnackbarHelper.showSnackbar(context, 'Error al crear la reserva');
    }
  }

//metodo para importar los nombres de las salas para el formulario de reserva
  List<String> nombresSalas = [];
  Future<List<String>> obtenerNombres() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('salas').get();
      querySnapshot.docs.forEach(
        (doc) {
          String nombreSala = doc['nombre'];
          nombresSalas.add(nombreSala);
        },
      );
    } catch (e) {
      print('Error al obtener las salas');
      SnackbarHelper.showSnackbar(
          context, 'Hubo un problema al recuperar salas');
    }
    return nombresSalas;
  }

//metodos para seleccionar fechas y horas
  DateTime? fechaSeleccionada;
  Future<void> _fechaSeleccionada(BuildContext context) async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (fecha != null && fecha != fechaSeleccionada) {
      setState(() {
        fechaSeleccionada = fecha;
      });
    }
  }

  TimeOfDay? tiempoInicio;
  TimeOfDay? tiempoFin;
  Future<void> _horaInicioSeleccionado(BuildContext context) async {
    final TimeOfDay? horainicio = await showTimePicker(
        context: context, initialTime: tiempoInicio ?? TimeOfDay.now());
    if (horainicio != null && horainicio != tiempoInicio) {
      setState(() {
        tiempoInicio = horainicio;
      });
    }
  }

  Future<void> _horaFinSeleccionado(BuildContext context) async {
    final TimeOfDay? horafin = await showTimePicker(
        context: context, initialTime: tiempoFin ?? TimeOfDay.now());
    if (horafin != null && horafin != tiempoFin) {
      setState(() {
        tiempoFin = horafin;
      });
    }
  }

  bool rangoValido(TimeOfDay? inicio, TimeOfDay? fin) {
    return fin!.hour < inicio!.hour ||
        (fin.hour == inicio.hour && fin.minute <= inicio.minute);
  }

  @override
  void initState() {
    super.initState();
    obtenerNombres().then((nombres) {
      setState(() {
        nombresSalas = nombres;
      });
    }).catchError((error) {
      print('Error al obtener los nombres: $error');
    });
  }

  String?
      selectedSala; //variable donde se almacenara la sala importada desde firebase

  String? actividadesSala =
      ""; //variable para almacenar las actividades que admite determinada sala
  int? personasAdmitidas;

  Horas? selectedHoras; //variable para los bloques de horas

  bool mostrarDetalles = false; //visibilidad de los detalles de la sala
  @override
  Widget build(BuildContext context) {
    //capturamos el uid del usuario actual y lo insertamos en el textformfield
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    _userController.text = arguments['uid'];
    _userNameController.text = arguments['nombre'] ?? arguments['nombreGoogle'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Reserva'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              readOnly: true,
              controller:
                  _userNameController, //controlador que tiene el nombre de usuario
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              maxLength: 30,
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Asunto:',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Detalles:', border: OutlineInputBorder(),),
              maxLength: 300,
              
            ),
            const SizedBox(height: 16),
            Text(fechaSeleccionada != null
                ? 'Fecha seleccionada: ${DateFormat('dd/MM/yyyy').format(fechaSeleccionada!)}'
                : 'Seleccione una fecha: '),
            ElevatedButton(
              onPressed: () => _fechaSeleccionada(context),
              child: const Text('Seleccionar Fecha'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Sala: '),
                DropdownButton<String>(
                  value: selectedSala,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSala = newValue;
                      _locationController.text = selectedSala!;
                      //se llama la funcion para cargar las actividades segun la sala
                      cargarActividades(selectedSala);
                      mostrarDetalles = true;
                    });
                  },
                  items: nombresSalas.map((String sala) {
                    return DropdownMenuItem<String>(
                      value: sala,
                      child: Text(sala),
                    );
                  }).toList(),
                ),
              ],
            ),
            Visibility(
              visible: mostrarDetalles,
              child: Text(
                "Esta sala es apta para las siguientes actividades: $actividadesSala y permite un máximo de $personasAdmitidas asistentes.",
                style: TextStyle(
                    fontStyle: FontStyle.italic, color: Colors.blue[800]),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Bloque Horario: '),
                DropdownButton<Horas>(
                  value:
                      selectedHoras, // La hora seleccionada en el DropdownButton
                  onChanged: (Horas? newValue) {
                    setState(() {
                      tiempoInicio = newValue?.startTime;
                      tiempoFin = newValue?.endTime;
                      selectedHoras = newValue;
                    });
                  },
                  items: Horas.horasPredefinidas
                      .map<DropdownMenuItem<Horas>>((Horas horas) {
                    return DropdownMenuItem<Horas>(
                      value: horas,
                      child: Text(
                        '${horas.startTime.format(context)} - ${horas.endTime.format(context)}',
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isEmpty ||
                    _descriptionController.text.isEmpty ||
                    tiempoInicio == null ||
                    tiempoFin == null ||
                    selectedSala == null ||
                    fechaSeleccionada == null) {
                  AlertDialogHelper.showAlertDialog(
                      context,
                      "Error al reservar",
                      "Asegurese de rellenar correctamente todos los campos");
                } else {
                  showDialog(
                      context: context,
                      builder: ((BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirmar Reserva"),
                          content: const Text(
                              '¿Estas seguro que desea crear esta reserva?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                                onPressed: () {
                                  createReservation();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Confirmar')),
                          ],
                        );
                      }));
                }
              },
              child: const Text('Crear Reserva'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> cargarActividades(String? selectedSala) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('salas')
          .where('nombre', isEqualTo: selectedSala)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final sala = snapshot.docs.first;
        final actividades = sala['actividades_admitidas'] as List<dynamic>;
        final cantidadPersonas = sala['capacidad'] as int;
        //ahora se convierte en cadena de texto
        final actividadesTexto = actividades.map((dynamic actividad) {
          return actividad.toString();
        }).join(', ');
        setState(() {
          actividadesSala = actividadesTexto;
          personasAdmitidas = cantidadPersonas;
        });
      } else {
        setState(() {
          actividadesSala = "Selecciona una sala";
          personasAdmitidas = 0;
        });
      }
    } catch (e) {
      setState(() {
        actividadesSala = "Error al cargar los detalles de las actividades $e";
        personasAdmitidas = 0;
      });
      print('Hubo un error: $e');
    }
  }
}
