//CODIFICACION DE VISTA DONDE SE VERAN LAS OPCIONES DE INFORMES  PARA LOS USUARIOS CON ROL ADMINISTRADOR

//19/06: POR AHORA SOLO EL ESQUELETO

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:reservas_theo/features/widgets/ui.dart';

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
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reservations')
          .where('fechaCreacion', isGreaterThanOrEqualTo: fechaInicio)
          .where('fechaCreacion', isLessThanOrEqualTo: fechaFin)
          .where('Lugar', isEqualTo: salaSeleccionada)
          .get();

      List<QueryDocumentSnapshot> reservaciones = querySnapshot.docs;
      print('Reservaciones encontradadas ${reservaciones.length}');
      String? path = await FilePicker.platform.getDirectoryPath();
      if (path != null) {
        final pdf = pw.Document();
        for (var reserva in reservaciones) {
          print('Datos de la reserva: ${reserva.data()}');
          DateTime? fecha = (reserva['Fecha'] as Timestamp).toDate().toLocal();
          DateTime? horaInicio =
              (reserva['Hora_inicio'] as Timestamp).toDate().toLocal();
          DateTime? horaFin =
              (reserva['Hora_finalización'] as Timestamp).toDate().toLocal();
          pdf.addPage(
            pw.MultiPage(
              build: (pw.Context context) {
                return [
                  pw.Text('Reporte de usabilidad: ${reserva['Lugar']}'),
                  pw.Text(
                    'Periodo: ${DateFormat('dd/MM/yyyy').format(fechaInicio!)} - ${DateFormat('dd/MM/yyyy').format(fechaFin!)}'),
                  pw.Text('DETALLES DE ACTIVIDADES'),
                  pw.Text('Asunto: ${reserva['Asunto']}'),
                  pw.Text(
                    'Fecha de actividad: ${DateFormat('dd/MM/yyyy').format(fecha)}'),
                  pw.Text(
                    'Hora de actividad: ${DateFormat('HH:mm').format(horaInicio)} - ${DateFormat('HH:mm').format(horaFin)}'),
                  pw.Text('Descripción: ${reserva['Descripción']}'),
                  pw.Text('Organizador: ${reserva['Usuario']}')
                ];
                // pw.Center(
                //     child: pw.Column(children: [
                //   pw.Text('Reporte de usabilidad: ${reserva['Lugar']}'),
                //   pw.Text(
                //       'Periodo: ${DateFormat('dd/MM/yyyy').format(fechaInicio!)} - ${DateFormat('dd/MM/yyyy').format(fechaFin!)}'),
                //   pw.Text('DETALLES DE ACTIVIDADES'),
                //   pw.Text('Asunto: ${reserva['Asunto']}'),
                //   pw.Text(
                //       'Fecha de actividad: ${DateFormat('dd/MM/yyyy').format(fecha)}'),
                //   pw.Text(
                //       'Hora de actividad: ${DateFormat('HH:mm').format(horaInicio)} - ${DateFormat('HH:mm').format(horaFin)}'),
                //   pw.Text('Descripción: ${reserva['Descripción']}'),
                //   pw.Text('Organizador: ${reserva['Usuario']}'),
                // ]));
              },
            ),
          );
        }
        final bytes = await pdf.save();
        final directory = Directory(path);
        final file = File('${directory.path}/pdf_test.pdf');
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Seleccionar Sala:   '),
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
              //seleccion de fecha inicial
              const SizedBox(
                height: 16,
              ),
              Text(fechaInicio != null
                  ? 'Periodo seleccionado: ${DateFormat('dd/MM/yyyy').format(fechaInicio!)}'
                  : 'Seleccione fecha inicial'),
              ElevatedButton(
                  onPressed: () => _fechaInicioSeleccionada(context),
                  child: const Text('Seleccionar Fecha inicial')),
              //seleccion de fecha final
              const SizedBox(
                height: 16,
              ),
              Text(fechaFin != null
                  ? 'Periodo seleccionado: ${DateFormat('dd/MM/yyyy').format(fechaFin!)}'
                  : 'Seleccione fecha final'),
              ElevatedButton(
                  onPressed: () => _fechaFinSeleccionada(context),
                  child: const Text('Seleccionar Fecha final')),

              ElevatedButton(
                  onPressed: () {
                    generarGuardarPdf();
                    //generateEmptyPDF;
                  },
                  child: const Text('Generar Informe'))
            ],
          ),
        ));
  }
}
