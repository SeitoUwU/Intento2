import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intento_dos/Opcion.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SelectedOption(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Banco de imagenes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  XFile? _image;
  opciones _opciones = opciones();

  Future<void> getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            mostrarTitulo(),
            Container(
              width: 250,
              height: 250,
              color: Colors.grey,
              child: Center(
                child: _image == null
                    ? Text('Aqui va la foto')
                    : Image.file(File(_image!.path)),
              ),
            ),
            const Text(
              'Opciones:',
              style: TextStyle(fontSize: 20),
            ),
            opciones(),
            botones(getImage),
            ElevatedButton(
              onPressed: () {
                int? id = Provider.of<SelectedOption>(context, listen: false)
                    .selectedOptionId;
                print("id: " + id.toString());
                print(_image.toString());
                if (id == null || _image == null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                            'Error no ha tomado una foto o no ha seleccionado una categoria'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Volver a intentar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  ElevatedButton(
                    onPressed: () {
                      _image = null;
                    },
                    child: Text("Limpiar"),
                  );
                  bool resp = uploadImage(_image!, id) as bool;
                  if (resp == false) {
                    AlertDialog(
                      title: const Text('Error al subir la imagen'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Volver a intentar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            reloadApp();
                          },
                        ),
                      ],
                    );
                  } else {
                    AlertDialog(
                      title: const Text('Imagen subida correctamente'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Volver a intentar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            reloadApp();
                          },
                        ),
                      ],
                    );
                  }
                }
              },
              child: Text("Enviar"),
            ),
            // Pasar getImage como argumento a botones
          ],
        ),
      ),
    );
  }
}

class botones extends StatelessWidget {
  final VoidCallback getImage; // Agregar un parámetro para getImage
  botones(this.getImage); // Inicializar getImage en el constructor

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: () async {
            // Hacer que onPressed sea una función asíncrona
            var image = getImage(); // Esperar el resultado de getImage
          },
          child: Text("Tomar foto"),
        ),
        SizedBox(width: 10), // Espacio entre los botones
      ],
    );
  }
}

class mostrarTitulo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      'Tome una fotografía',
      style: TextStyle(fontSize: 40),
    );
  }
}

class SelectedOption extends ChangeNotifier {
  int? _selectedOptionId;

  int? get selectedOptionId => _selectedOptionId;

  void setSelectedOptionId(int? id) {
    _selectedOptionId = id;
    notifyListeners();
  }
}

class opciones extends StatefulWidget {
  @override
  _opcionesState createState() => _opcionesState();
}

class _opcionesState extends State<opciones> {
  late Future<List<Opcion>> futureOpciones;

  @override
  void initState() {
    super.initState();
    futureOpciones = Opcion(0, '').getOpciones();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Opcion>>(
      future: futureOpciones,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DropdownButton<int>(
            value: Provider.of<SelectedOption>(context).selectedOptionId,
            items: snapshot.data!.map<DropdownMenuItem<int>>((Opcion opcion) {
              return DropdownMenuItem<int>(
                value: opcion.id,
                child: Text(opcion.op,
                    style: Theme.of(context).textTheme.bodyText1),
              );
            }).toList(),
            onChanged: (int? newId) {
              Provider.of<SelectedOption>(context, listen: false)
                  .setSelectedOptionId(newId);
              print("Opcion seleccionada: $newId");
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class tomarFoto extends StatefulWidget {
  @override
  _tomarFotoState createState() => _tomarFotoState();
}

class _tomarFotoState extends State<tomarFoto> {
  XFile? _image;

  Future<XFile?> getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tomar Foto'),
      ),
      body: Center(
        child: _image == null
            ? Text('No image selected.')
            : Container(
                width: 250,
                height: 250,
                child: Image.file(File(_image!.path), fit: BoxFit.cover),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage, // Llama a getImage cuando se presiona el botón
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

Future<bool> uploadImage(XFile image, int id) async {
  // Convertir la imagen en un MultipartFile
  var request = http.MultipartRequest(
      'POST', Uri.parse('http://172.27.27.209:8000/guardar_imagen'));
  request.files.add(await http.MultipartFile.fromPath(
    'image',
    image.path,
    contentType: MediaType('image', 'jpeg'),
  ));

  // Agregar la etiqueta de clase al cuerpo de la solicitud
  request.fields['class_label'] = id.toString();

  // Enviar la solicitud POST
  var response = await request.send();

  if (response.statusCode == 200) {
    return true;
  }
  return false;
}

Future<void> reloadApp() async {
  await Future.delayed(Duration(seconds: 2));
  runApp(MyApp());
}
