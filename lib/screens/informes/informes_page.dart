//CODIFICACION DE VISTA DONDE SE VERAN LAS OPCIONES DE INFORMES  PARA LOS USUARIOS CON ROL ADMINISTRADOR

//19/06: POR AHORA SOLO EL ESQUELETO

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:VisalApp/features/widgets/ui.dart';

class Informes extends StatefulWidget {
  const Informes({Key? key}) : super(key: key);

  @override
  State<Informes> createState() => InformesState();
}

class InformesState extends State<Informes> {
  //----------------------------------------------------------------------
  //obtener las salas para el filtrado
  final TextEditingController _locationSalaController = TextEditingController();
  String? salaSeleccionada;
  List<String> nombreSalas = [];
  Future<List<String>> obtenerSalas() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('salas').get();
      querySnapshot.docs.forEach((doc) {
        String nameSalas = doc['nombre'];
        nombreSalas.add(nameSalas);
      });
    } catch (e) {
      print('hubo un error al obtener las salas: $e');
    }
    return nombreSalas;
  }

  //-----------------------------------------------------------------------
  //generar y guardar pdf version 2
  

  Future<void> generarGuardarPdf() async {
    //query para las reservaciones
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('reservations')
        .where('fechaCreacion', isGreaterThanOrEqualTo: fechaInicio)
        .where('fechaCreacion', isLessThanOrEqualTo: fechaFin)
        .where('Lugar', isEqualTo: salaSeleccionada)
        .get();

    List<QueryDocumentSnapshot> reservaciones = querySnapshot.docs;
    //ordenar las reservas por fecha
    reservaciones.sort((a, b) {
      DateTime fechaA = (a['Fecha'] as Timestamp).toDate().toLocal();
      DateTime fechaB = (b['Fecha'] as Timestamp).toDate().toLocal();
      return fechaA.compareTo(fechaB);
    });

    //-----------------------------------------------------------------
    

    //query para los reportes
    try {
      QuerySnapshot queryreport = await FirebaseFirestore.instance
        .collection('reportes')
        .where('fechaHoraReporte', isGreaterThanOrEqualTo: fechaInicio)
        .where('fechaHoraReporte', isLessThanOrEqualTo: fechaFin)
        .where('nombreSala', isEqualTo: salaSeleccionada)
        .get();
        List<QueryDocumentSnapshot> reportes = queryreport.docs;
        print('Reportes encontrados ${reportes.length}');
        //ordenar los reportes por fecha de incorporacion
        reportes.sort((a, b) {
          DateTime fechaA = (a['fechaHoraReporte'] as Timestamp).toDate().toLocal();
          DateTime fechaB = (b['fechaHoraReporte'] as Timestamp).toDate().toLocal();
          return fechaA.compareTo(fechaB);
        });
    } catch (e) {
          print('hubo un error con los reportes $e');
    }
    

    //--------------------------------------------
    try {      
      print('Reservaciones encontradas ${reservaciones.length}');
      String? path = await FilePicker.platform.getDirectoryPath();
      if (path != null) {
        final pdf = pw.Document();
        const reservasPorPagina = 4; // Estimación de reservas por pagina
        final periodo =
            '${DateFormat('dd/MM/yyyy').format(fechaInicio!)}-${DateFormat('dd/MM/yyyy').format(fechaFin!)}';
        final usabilidad = 'Reporte de usabilidad: $salaSeleccionada';

        for (var i = 0; i < reservaciones.length; i += reservasPorPagina) {
          final currentPage = pw.MultiPage(
            
            header: (pw.Context context) {
              return pw.Center(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                    //imagen aqui
                    pw.Text('Reporte VisalApp'),
                    pw.Text('Periodo seleccionado: $periodo'),
                    pw.Text(usabilidad),
                  ]));
            },
            build: (pw.Context context) {
              final List<pw.Widget> children = [];
              for (var j = i;
                  j < i + reservasPorPagina && j < reservaciones.length;
                  j++) {
                var reserva = reservaciones[j];
                DateTime? fecha =
                    (reserva['Fecha'] as Timestamp).toDate().toLocal();
                DateTime? horaInicio =
                    (reserva['Hora_inicio'] as Timestamp).toDate().toLocal();
                DateTime? horaFin = (reserva['Hora_finalización'] as Timestamp)
                    .toDate()
                    .toLocal();

                children.add(pw.Center(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(height: 10),
                      pw.Text('DETALLES DE ACTIVIDADES'),
                      pw.Text('Asunto: ${reserva['Asunto']}'),
                      pw.Text(
                          'Fecha de actividad: ${DateFormat('dd/MM/yyyy').format(fecha)}'),
                      pw.Text(
                          'Hora de actividad: ${DateFormat('HH:mm').format(horaInicio)} - ${DateFormat('HH:mm').format(horaFin)}'),
                      pw.Text('Descripción: ${reserva['Descripción']}'),
                      pw.Text('Organizador: ${reserva['Usuario']}'),
                      pw.SizedBox(height: 10),
                    ],
                  ),
                ));
              }
              return children;
            },
          );
          pdf.addPage(currentPage);
        }

        //GUARDAR PDF
        final bytes = await pdf.save();
        final directory = Directory(path);
        final file = File('${directory.path}/reporte${salaSeleccionada}.pdf');
        await file.writeAsBytes(bytes);

        print('Pdf generado en: ${file.path}');
        SnackbarHelper.showSnackbar(
            context, 'Informe generado y almacenado en ${file.path}');
      }
    } catch (e) {
      print('Error al generar o guardar pdf: $e');
    }
  }

  //-------------------------------------------------
  //metodos para seleccionar fechas de inicio y termino
  DateTime? fechaInicio;
  DateTime? fechaFin;
  Future<void> _fechaInicioSeleccionada(BuildContext context) async {
    final DateTime? fecha = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (fecha != null && fecha != fechaInicio) {
      setState(() {
        fechaInicio = fecha;
      });
    }
  }

  Future<void> _fechaFinSeleccionada(BuildContext context) async {
    final DateTime? fecha = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (fecha != null && fecha != fechaFin) {
      setState(() {
        fechaFin = fecha;
      });
    }
  }

  //----- falta implementar un filtro para establecer los rangos y esas cosas

  //----------------------------------

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obtenerSalas().then((nombres) {
      setState(() {
        nombreSalas = nombres;
      });
    }).catchError((error) {
      print('Error al obtener los nombres: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Informes'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Seleccione un rango de fechas y genere su informe de usabilidad\n',
                textAlign: TextAlign.center,
              ),

              //seleccion de fecha inicial

              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.black,
                  width: 1,
                )),
                child: Column(
                  children: [
                    Text(fechaInicio != null
                        ? 'Periodo seleccionado: ${DateFormat('dd/MM/yyyy').format(fechaInicio!)}'
                        : 'Fecha sin seleccionar'),
                    ElevatedButton(
                        onPressed: () => _fechaInicioSeleccionada(context),
                        child: const Text('Seleccionar Fecha inicial')),
                  ],
                ),
              ),

              //seleccion de fecha final
              const SizedBox(
                height: 16,
              ),
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.black,
                  width: 1,
                )),
                child: Column(
                  children: [
                    Text(fechaFin != null
                        ? 'Periodo seleccionado: ${DateFormat('dd/MM/yyyy').format(fechaFin!)}'
                        : 'Fecha sin seleccionar'),
                    ElevatedButton(
                        onPressed: () => _fechaFinSeleccionada(context),
                        child: const Text('Seleccionar Fecha final')),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Seleccionar Sala: '),
                  DropdownButton<String>(
                    value: salaSeleccionada,
                    onChanged: (String? newValue) {
                      setState(() {
                        salaSeleccionada = newValue;
                        _locationSalaController.text = salaSeleccionada!;
                      });
                    },
                    items: nombreSalas.map((String sala) {
                      return DropdownMenuItem<String>(
                        value: sala,
                        child: Text(sala),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    generarGuardarPdf();
                    //generateEmptyPDF;
                  },
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  label: const Text('Generar Informe'))
            ],
          ),
        ));
  }
}
