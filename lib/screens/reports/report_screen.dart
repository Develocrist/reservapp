import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
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
      SnackBar(content: Text('Reporte enviado correctamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enviar Reporte'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Aqui se visualizaran los reportes hechos'),
          ],
        ),
      ),
    );
  }
}
