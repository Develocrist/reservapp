import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservas_theo/features/widgets/ui.dart';
import 'package:intl/intl.dart';

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
  final DateTime fechaReserva;

  Reservation({
    required this.name,
    required this.description,
    required this.horaInicio,
    required this.horaFin,
    required this.location,
    required this.user,
    required this.fechaReserva,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'dateTime': horaInicio,
      'dateTime2': horaFin,
      'location': location,
      'user': user,
      'fecha': fechaReserva,
    };
  }
}

class _ReservationScreen2State extends State<ReservationScreen2> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _horaInicioController = TextEditingController();
  final TextEditingController _horaFinController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _userController = TextEditingController(text: '');
  final TextEditingController _fechaReservaController = TextEditingController();

//metodo para crear la reserva
  Future<void> createReservation() async {
    try {
      final name = _nameController.text;
      final description = _descriptionController.text;
      final horaInicio = DateTime.parse(_horaInicioController.text);
      final horaFin = DateTime.parse(_horaFinController.text);
      final location = _locationController.text;
      final user = _userController.text;
      final fechaReserva = DateTime.parse(_fechaReservaController.text);

      final reservation = Reservation(
        name: name,
        description: description,
        horaInicio: horaInicio,
        horaFin: horaFin,
        location: location,
        user: user,
        fechaReserva: fechaReserva,
      );

      await FirebaseFirestore.instance
          .collection('reservations')
          .add(reservation.toMap());

      _nameController.clear();
      _descriptionController.clear();
      _horaInicioController.clear();
      _horaFinController.clear();
      _locationController.clear();
      _userController.clear();
      _fechaReservaController.clear();

      SnackbarHelper.showSnackbar(context, 'Reserva creada con éxito');
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    bool datosValidos = false;
    //capturamos el uid del usuario actual y lo insertamos en el textformfield
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    _userController.text = arguments['uid'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Reserva'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              readOnly: true,
              controller: _userController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Asunto reserva:'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Detalles:'),
            ),
            // TextField(
            //   controller: _fechaReservaController,
            //   decoration: const InputDecoration(
            //       labelText: 'Fecha de reunión (yyyy-MM-dd)'),
            // ),
            Text(fechaSeleccionada != null
                ? 'Fecha seleccionada: ${DateFormat('dd/MM/yyyy').format(fechaSeleccionada!)}'
                : 'Seleccione una fecha: '),
            ElevatedButton(
              onPressed: () => _fechaSeleccionada(context),
              child: const Text('Seleccionar Fecha'),
            ),
            Text(
              tiempoInicio != null
                  ? 'Hora de inicio seleccionada: ${tiempoInicio!.format(context)}'
                  : 'Hora de inicio no seleccionada',
            ),
            ElevatedButton(
              onPressed: () => _horaInicioSeleccionado(context),
              child: const Text('Seleccionar Hora de inicio'),
            ),
            Text(
              tiempoFin != null
                  ? 'Hora de fin seleccionado: ${tiempoFin!.format(context)}'
                  : 'Hora de inicio no seleccionada',
            ),
            ElevatedButton(
              onPressed: () => _horaFinSeleccionado(context),
              child: const Text('Seleccionar hora de finalización'),
            ),
            if (tiempoInicio != null &&
                tiempoFin != null &&
                rangoValido(tiempoInicio, tiempoFin))
              const Text(
                'El rango de horas seleccionado no es valido!',
                style: TextStyle(color: Colors.red),
              ),

            // TextField(
            //   controller: _horaInicioController,
            //   decoration: const InputDecoration(
            //       labelText: 'Hora de inicio (yyyy-MM-dd HH:mm)'),
            // ),
            // TextField(
            //   controller: _horaFinController,
            //   decoration: const InputDecoration(
            //       labelText: 'Hora de termino (yyyy-MM-dd HH:mm)'),
            // ),
            // TextField(
            //   controller: _locationController,
            //   decoration: const InputDecoration(labelText: 'Sala:'),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Sala:     '),
                DropdownButton<String>(
                  value: selectedSala,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSala = newValue;
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

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (datosValidos = true) {
                  createReservation();
                } else {
                  AlertDialogHelper.showAlertDialog(
                      context,
                      "Error al reservar",
                      "Asegurese de ingresar correctamente los campos");
                }
              },
              child: const Text('Crear Reserva'),
            ),
          ],
        ),
      ),
    );
  }
}
