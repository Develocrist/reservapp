import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:VisalApp/features/widgets/ui.dart';
import 'package:screenshot/screenshot.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  // ScreenshotController capturaReporte =
  //     ScreenshotController(); //controlador para la captura del reporte

  List<ScreenshotController> capturaReporteList =
      []; //controlador para varios reportes

  String formattedDate = '';
  String formattedTime = '';
  Future<List<Reporte>> getReportes() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      //obtener la coleccion reportes y consultar documentos

      QuerySnapshot querySnapshot =
          await firestore.collection('reportes').get();
      //convertir documentos en una lista de reporte
      List<Reporte> reportes = querySnapshot.docs.map((doc) {
        Timestamp timestamp = doc['fechaHoraReporte'];
        DateTime dateTime = timestamp.toDate();

        // formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
        // formattedTime = DateFormat('HH:mm').format(dateTime);

        return Reporte(
          doc['asunto'],
          doc['descripcion'],
          doc['usuario'],
          dateTime,
          doc['nombreSala'],
          doc['reporteId'],
        );
      }).toList();
      return reportes;
    } catch (e) {
      print('Hubo un error al recuperar los informes $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver Reportes'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Reporte>>(
            future: getReportes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    ScreenshotController capturaReporte =  ScreenshotController();
                    DateTime? dateTime = snapshot.data?[index].hora;
                    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime!);
                    String formattedTime = DateFormat('HH:mm').format(dateTime);


                    capturaReporteList.add(capturaReporte);
                    return Screenshot(
                      controller: capturaReporte,
                      child: Card(
                        child: ListTile(
                          title: Text('Sala: ${snapshot.data?[index].sala}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Fecha y hora del reporte:\n$formattedDate - $formattedTime'),
                              Text(
                                  'Reportado por: ${snapshot.data?[index].usuario}'),
                              Text('Asunto: ${snapshot.data?[index].asunto}'),
                              Text(
                                  'Descripción: ${snapshot.data?[index].descripcion}'),
                              ElevatedButton.icon(
                                  onPressed: () async {
                                    final Uint8List? image =
                                        await capturaReporte.capture();
                                    if (image != null) {
                                      await ImageGallerySaver.saveImage(image);
                                      SnackbarHelper.showSnackbar(context,
                                          'Reporte de actividad guardado en Galería');
                                    }
                                  },
                                  icon: const Icon(Icons.save_alt_outlined),
                                  label: const Text('Guardar reporte')),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                Text('Error al cargr los reportes: ${snapshot.error}');
              }
              return Text('No hay reportes');
            },
          )),
    );
  }
}

class Reporte {
  final String usuario;
  final String asunto;
  final String descripcion;
  final DateTime hora;
  final String sala;
  final String reporteId;

  Reporte(this.asunto, this.descripcion, this.usuario, this.hora, this.sala,
      this.reporteId);
}
