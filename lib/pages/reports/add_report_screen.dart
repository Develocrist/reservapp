import 'package:flutter/material.dart';

class AddReport extends StatefulWidget {
  @override
  _AddReportState createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  TextEditingController nameController = TextEditingController(
      text: ""); //controlador para asignarle el nombre de la sala

  TextEditingController idController = TextEditingController(
      text: ''); //controlador para asignarle la id de la sala
  String _subject = '';
  String _description = '';

  void _submitReport() {
    // Aquí puedes implementar la lógica para enviar el reporte a donde corresponda
    // Por ejemplo, puedes enviarlo a través de una solicitud HTTP o guardarlo en una base de datos

    // Resetear los campos después del envío
    setState(() {
      _subject = '';
      _description = '';
    });

    // Mostrar un mensaje de éxito o realizar alguna acción adicional
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reporte añadido correctamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    nameController.text = arguments['name'];
    idController.text = arguments['uid'];
    String nombreSala =
        nameController.text; //se asigna el nombre de la sala a la variable

    String idSala =
        idController.text; //asignamos la id de la sala a la variable

    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Reporte'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('id sala: ${idSala}'),
            TextFormField(
              readOnly: true,
              initialValue: nombreSala,
              decoration: InputDecoration(labelText: 'Sala'),
              onChanged: (value) {
                setState(() {
                  _subject = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Asunto'),
              onChanged: (value) {
                setState(() {
                  _subject = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(labelText: 'Descripción'),
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
            ),
            SizedBox(height: 16.0),
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
