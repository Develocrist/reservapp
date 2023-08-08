import 'package:flutter/material.dart';

class CurrentDateText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    String formattedDate =
        '${currentDate.day.toString().padLeft(2, '0')}/${currentDate.month.toString().padLeft(2, '0')}/${currentDate.year.toString()}';

    return Text(
      'Fecha actual: $formattedDate',
      style: const TextStyle(fontSize: 14),
    );
  }
}

class SnackbarHelper {
  static void showSnackbar(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensaje),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ));
  }
}

class AlertDialogHelper {
  static void showAlertDialog(
      BuildContext context, String titulo, String mensaje) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(titulo),
            content: Text(mensaje),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'))
            ],
          );
        });
  }
}
