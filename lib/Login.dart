import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intento_dos/Usuario.dart';
import 'Register.dart';
import 'main.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    ),
  );
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  Usuario usuario = Usuario('', '', 0);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('Images/Amazonia.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
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
                                  _password = value!;
                                },
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  ElevatedButton(
                                    child: Text('Login'),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        usuario
                                            .getAutenticationUser(
                                                _username, _password)
                                            .then((value) {
                                          if (value) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => MyHomePage(
                                                    title: 'Banco de imagenes'),
                                              ),
                                            );
                                          } else {
                                            AlertDialog(
                                              title: Text('Error'),
                                              content: Text(
                                                  'Usuario o contraseña incorrectos'),
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
                                        });
                                      }
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text('Registrarse'),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RegisterPage(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              )
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
        ),
      ),
    );
  }
}
