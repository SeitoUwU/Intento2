import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:intento_dos/Usuario.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password1 = '';
  String _password2 = '';
  Usuario usuario = Usuario('', '', 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de usuario'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Card(
              color: Colors.white70,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Ingrese su usuario'),
                            onSaved: (value) {
                              _username = value!;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Ingrese la contraseña'),
                            obscureText: true,
                            onSaved: (value) {
                              _password1 = value!;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Confirme la contraseña'),
                            obscureText: true,
                            onSaved: (value) {
                              _password2 = value!;
                            },
                          ),
                          ElevatedButton(
                            child: Text('Registrarse'),
                            onPressed: () {
                              print("object");
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                print("object");
                                if (_password1 != _password2) {
                                  print("object error");
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Error'),
                                        content: Text(
                                            'Las contraseñas no coinciden'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  print("object Ingreso");
                                  Future<bool> result = usuario.register(_username, _password1);
                                  if(result == true){
                                    print("object exitoso");
                                    AlertDialog(
                                      title: Text('Registro exitoso'),
                                      content: Text('Usuario registrado correctamente'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Aceptar'),
                                        ),
                                      ],
                                    );
                                  }else{
                                    AlertDialog(
                                      title: Text('Error'),
                                      content: Text('Error al registrar el usuario'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Aceptar'),
                                        ),
                                      ],
                                    );
                                  }
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
