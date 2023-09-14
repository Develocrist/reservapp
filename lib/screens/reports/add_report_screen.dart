import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddReport extends StatefulWidget {
  @override
  _AddReportState createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  //declaracion de variables
  TextEditingController nameController = TextEditingController(
      text: ""); //controlador para asignarle el nombre de la sala

  TextEditingController userName = TextEditingController(
      text: ''); //controlador de la vista del nombre de usuario

  String idSala = '';
  String nombreSala = '';
  String nombreUsuario = '';
  String asuntoReporte = '';
  String descripcionReporte = '';

//--------------------------------------------
//metodos que se utilizaran
  void _submitReport() async {
    try {
      //obtener fecha y hora actual
      Timestamp now = Timestamp.now();

      //instancia de firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      //añadir reporte a coleccion de reportes
      await firestore.collection('reportes').add({
        'nombreSala': nombreSala,
        'idsala': idSala,
        'usuario': nombreUsuario,
        'asunto': asuntoReporte,
        'descripcion': descripcionReporte,
        'reporteId': '',
        'fechaHoraReporte': now,
      }).then((docRef) {
        docRef.update(
            {'reporteId': docRef.id}); //añade la id generada del reporte
      });

      setState(() {
        asuntoReporte = '';
        descripcionReporte = '';
      });

      // Mostrar un mensaje de éxito o realizar alguna acción adicional
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte añadido correctamente')),
      );
    } catch (e) {
      print('Hubo un error al ingresar el reporte $e');
    }
  }

  //interfaz

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    nameController.text = arguments['name'];
    //------------- asignacion a variables
    nombreSala =
        nameController.text; //se asigna el nombre de la sala a la variable
    idSala = arguments['uid']; //asignamos la id de la sala a la variable
    nombreUsuario = arguments[
        'nombreusuario']; //asignamos el nombre de usuario obtenido de la ventana anterior a la nueva variable

    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Reporte'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('id sala: $idSala'),
            TextFormField(
              readOnly: true,
              initialValue: nombreSala,
              decoration: const InputDecoration(labelText: 'Sala'),
              onChanged: (value) {
                setState(() {
                  idSala = value;
                });
              },
            ),
            TextFormField(
              readOnly: true,
              initialValue: nombreUsuario,
              decoration: const InputDecoration(labelText: 'Usuario'),
              onChanged: (value) {
                setState(() {
                  nombreUsuario = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Asunto'),
              onChanged: (value) {
                setState(() {
                  asuntoReporte = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Descripción'),
              onChanged: (value) {
                setState(() {
                  descripcionReporte = value;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitReport,
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
