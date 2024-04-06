import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password1 = '';
  String _password2 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de usuario'),
      ),
      body: Center(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Ingrese su usuario'),
              onSaved: (value) {
                _username = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Ingrese la contraseña'),
              obscureText: true,
              onSaved: (value) {
                _password1 = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Confirme la contraseña'),
              obscureText: true,
              validator: (value) {
                if (value != _password1) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
              onSaved: (value) {
                _password2 = value!;
              },
            ),
            ElevatedButton(
              child: Text('Registrarse'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  print('Username: $_username');
                  print('Password: $_password1');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}