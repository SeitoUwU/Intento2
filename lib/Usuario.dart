import 'Conexion.dart';
import 'package:mysql1/mysql1.dart';

class Usuario{
  String usuario;
  String contrasenia;
  int cantidad;

  Usuario(this.usuario, this.contrasenia, this.cantidad);

  Future<bool> getAutenticationUser(String usuario, String contrasenia) async{
    final con = await getConnection();

    try{
      await con.query(
          'call InicioSesion(?,?,@estado)',
          [usuario, contrasenia]
      );
      final estado = await con.query('select @estado');
      if (estado.elementAt(0).values?.elementAt(0) == 1){
        await con.close();
        return true;
      }else {
        await con.close();
        return false;
      }
    }catch(e){
      print(e);
      await con.close();
      return false;
    }
  }
}