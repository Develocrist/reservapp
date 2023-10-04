//CODIFICACION DE VISTA DONDE SE GESTIONARAN TODAS LAS RESERVAS QUE EL USUARIO REALICE

//19/06: POR AHORA SOLO EL ESQUELETO

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:VisalApp/features/widgets/ui.dart';

class MyReservation extends StatefulWidget {
  const MyReservation({Key? key}) : super(key: key);

  @override
  State<MyReservation> createState() => _MyReservationState();
}

class _MyReservationState extends State<MyReservation> {
  //---------------- sincronizacion con google

  //---------------------
  List<Reservation> _reservations = [];

  String? _userUid; //variable donde se recibe la uid
  String? _userName; //variable donde se recibe el nombre

  bool _userDataLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_userDataLoaded) {
      _loadUserData();
    }
  }

//---------------------
  Future<void> _loadUserData() async {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    setState(() {
      _userUid = arguments['uid'];
      _userName = arguments['nombre'];
      _userDataLoaded = true;
    });
    await loadReservations();
  }

  //cargar las reservas hechas por el usuario en firebase
  Future<void> loadReservations() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('reservations')
          .where('id_usuario',
              isEqualTo: _userUid) // Filtra por la UID del usuario
          .get();
      List<Reservation> reservations = [];
      snapshot.docs.forEach((doc) {
        Reservation reservation = Reservation.fromFirestore(doc);
        reservations.add(reservation);
      });

      setState(() {
        _reservations = reservations;
      });
    } catch (e) {
      print('Error al cargar las reservas desde Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis reservas'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: ListView.builder(
                shrinkWrap: true,                
                itemCount: _reservations.length,
                itemBuilder: (context, index) {
                  Reservation reservation = _reservations[index];
                  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
                  DateFormat timeFormat = DateFormat('HH:mm'); // Personaliza el diseño de cada elemento de la lista con los datos de la reserva
                  return Dismissible(
                    onDismissed: (direction) async {
                      await eliminarReserva(reservation.idreserva ?? '');
                      SnackbarHelper.showSnackbar(context, 'Reserva eliminada');
                    },
                    confirmDismiss: (direction) async {
                      bool result = false;
                      result = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('¿Desea eliminar esta reserva?'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    return Navigator.pop(context, false);
                                  },
                                  child: const Text('Cancelar')),
                              TextButton(
                                  onPressed: () {
                                    return Navigator.pop(context, true);
                                  },
                                  child: const Text(
                                    'Confirmar',
                                    style: TextStyle(color: Colors.red),
                                  ))
                            ],
                          );
                        },
                      );
                      return result;
                    },
                    key: Key(reservation.idusuario ?? ''),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      child: const Icon(Icons.delete),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ListTile(
                          title: Text(
                              'Asunto: ${reservation.asunto} \nFecha: ${dateFormat.format(reservation.fecha)}'), //nombre de la reserva y la fecha cuando se va a realizar
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //     'Descripción:\n  ${reservation.descripcion}'), //descripción de la reserva
                              Text(
                                  'Hora de inicio:\n ${timeFormat.format(reservation.horaInicio)} \nHora Termino: \n ${timeFormat.format(reservation.horaFin)}'), // Muestra la fecha y hora de la reserva
                              Text(
                                  'Sala: ${reservation.ubicacion}'), // Muestra la ubicación de la reserva
                              // Text(
                              //     'Usuario que reservo: ${reservation.usuario}'), //mostrar al usuario que hizo la reserva

                              //Muestra al usuario que realizó la reserva
                            ],
                          ),
                          trailing: Container(
                            width: 150,
                            height: 200,
                            color: Colors.blue[
                                100], //referencial para dar la opcion de scrollear
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                      //este boton deberia cambiar el estado de la sala
                                      onPressed: () async {
                                        final usuarioUso = reservation.usuario!;
                                        await actualizarEstadoSala(
                                            reservation.ubicacion!,
                                            'En uso por $usuarioUso');
                                        //----------------
                                        // await syncReservationWithGoogleCalendar(
                                        //     reservation);
                                        //-----------
                                        SnackbarHelper.showSnackbar(
                                            context, 'Estado actualizado');
                                      },
                                      child: const Text('Iniciar')),
                                  ElevatedButton(
                                      onPressed: () async {
                                        await actualizarEstadoSala(
                                            reservation.ubicacion!,
                                            'Disponible');
                                        SnackbarHelper.showSnackbar(
                                            context, 'Estado actualizado');
                                      },
                                      child: const Text('Terminar')),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/editMyReservation',
                                            arguments: {
                                              "idReserva": reservation.idreserva
                                            });
                                      },
                                      child: const Text('Modificar')),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          color: Colors.red,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Reservation {
  final String? asunto;
  final String? descripcion;
  final DateTime fecha;
  final DateTime horaInicio; // Nuevo campo para la hora de inicio
  final DateTime horaFin; //campo para almacenar la hora de termino
  final String? ubicacion; // Nuevo campo para la ubicación de la reserva
  final String? usuario;
  final String? idusuario;
  final String? idreserva;

  Reservation(
      {required this.asunto,
      required this.descripcion,
      required this.horaInicio,
      required this.ubicacion,
      required this.usuario,
      required this.horaFin,
      required this.fecha,
      required this.idusuario,
      required this.idreserva});

  factory Reservation.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Reservation(
        asunto: data['Asunto'],
        descripcion: data['Descripción'],
        //horaInicio: data['Hora_inicio'] != null ? (data['startDate'] as Timestamp).toDate() : DateTime.now(),
        horaInicio: data['Hora_inicio'] != null
            ? (data['Hora_inicio'] as Timestamp).toDate()
            : DateTime.now(),
        //horaFin: data['endDate'] != null    ? (data['endDate']   as Timestamp).toDate() : DateTime.now(), // Verifica si el valor es nulo antes de convertirlo
        horaFin: data['Hora_finalización'] != null
            ? (data['Hora_finalización'] as Timestamp).toDate()
            : DateTime.now(),
        ubicacion: data['Lugar'],
        usuario: data['Usuario'],
        //fecha: data['meetingDate'] != null ? (data['meetingDate'] as Timestamp).toDate() : DateTime.now(),
        fecha: data['Fecha'] != null
            ? (data['Fecha'] as Timestamp).toDate()
            : DateTime.now(),
        idusuario: data['id_usuario'],
        idreserva: data['uid']);
  }
}

//se requiere cambiar el estado de las salas de disponible a ocupada cuando se inicie una reserva hecha
Future<void> actualizarEstadoSala(String nombreSala, String nuevoEstado) async {
  try {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('salas')
        .where('nombre', isEqualTo: nombreSala)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final DocumentSnapshot salaDoc = snapshot.docs.first;
      final salaId = salaDoc.id;

      await FirebaseFirestore.instance
          .collection('salas')
          .doc(salaId)
          .update({'estado': nuevoEstado});

      print('Estado actualizado con éxito');
    } else {
      print('No se encontro la sala');
    }
  } catch (e) {
    print('Hubo un error al actualizar el estado: $e');
  }
}

//eliminar la reserva
Future<void> eliminarReserva(String idReserva) async {
  try {
    await FirebaseFirestore.instance
        .collection('reservations')
        .doc(idReserva)
        .delete();
    print(idReserva);
  } catch (e) {
    print('Error al eliminar $e');
  }
}

// Future<void> syncReservationWithGoogleCalendar(Reservation reservation) async {
//   User? user = FirebaseAuth.instance.currentUser;
//   if (user != null) {
//     String? accessToken = await user.getIdToken();
//     if (accessToken != null) {
//       final _googleSignIn = GoogleSignIn(
//           scopes: ['profile', 'email', calendar.CalendarApi.calendarScope]);
//       try {
//         final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//         if (googleUser == null) return; // El usuario canceló la autenticación
//         final GoogleSignInAuthentication googleAuth =
//             await googleUser.authentication;
//         final auth.AccessCredentials credentials = auth.AccessCredentials(
//           accessToken: googleAuth.accessToken,
//           refreshToken: googleAuth.refreshToken,
//           idToken: googleAuth.idToken,
//           scopes: ['profile', calendar.CalendarApi.calendarScope],
//         );
//         final calendarApi = calendar.CalendarApi(auth.ClientId('', ''),
//             authenticatedClient:
//                 auth.authenticatedClientFromCredentials(credentials));

//         final calendar.Event event = calendar.Event()
//           ..summary = reservation.asunto
//           ..description = reservation.descripcion ?? ''
//           ..start =
//               calendar.EventDateTime.dateTime(reservation.horaInicio.toUtc())
//           ..end = calendar.EventDateTime.dateTime(reservation.horaFin.toUtc());

//         // Asegúrate de proporcionar un ID único para el evento
//         event.id = reservation.idreserva;

//         await calendarApi.events.insert(event, 'primary');

//         print('Reserva sincronizada con Google Calendar');
//       } catch (e) {
//         print('Error al sincronizar la reserva con Google Calendar: $e');
//       }
//     } else {
//       print('No se pudo obtener el Access Token');
//     }
//   } else {
//     print('usuario no autenticado');
//   }
// }
