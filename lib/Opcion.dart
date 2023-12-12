import 'package:intento_dos/Conexion.dart';
import 'package:mysql1/mysql1.dart';

class Opcion{
  int id;
  String op;

  Opcion(this.id, this.op);

  Future<List<Opcion>> getOpciones() async{
    List<Opcion> opciones = [];
    final con = await getConnection();
    Results results = await con.query('SELECT id, tipo FROM tipo');

    for(var i in results){
      int id = i[0];
      String tipo = i[1];
      print("id: " + id.toString());
      print("tipo: "+ tipo);
      opciones.add(Opcion(id, tipo));
    }
    return opciones;
  }
}