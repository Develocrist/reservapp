import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:reservas_theo/login_test/ProviderLogin.dart';
import 'package:reservas_theo/login_test/ProviderState.dart';

class ProviderRegistration extends StatefulWidget {
  const ProviderRegistration({super.key});

  @override
  State<ProviderRegistration> createState() => _ProviderRegistrationState();
}

class _ProviderRegistrationState extends State<ProviderRegistration> {
  //variables para el registro
  final TextEditingController correo = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Registro de usuario',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nombre',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingrese un nombre válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                ),
                controller: correo,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingrese un correo electrónico válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              // TextFormField(
              //   decoration: InputDecoration(
              //     labelText: 'Organización',
              //   ),
              //   controller: _organizationController,
              //   validator: (value) {
              //     if (value!.isEmpty) {
              //       return 'La organización no puede estar vacía';
              //     }
              //     return null;
              //   },
              // ),
              // SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                ),
                obscureText: true,
                controller: password,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Ingrese una contraseña válida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  RegisterUser(correo.text, password.text, context);
                },
                child: const Text('Registrarse'),
              ),

              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  return Navigator.pop(context);
                },
                child: const Text('Volver al inicio de sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void RegisterUser(String email, String password, context) async {
    ProviderState providerState =
        Provider.of<ProviderState>(context, listen: false);

    try {
      if (await providerState.CreateUserAccount(email, password)) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ProviderLogin()));
      }
    } catch (e) {}
  }
}
