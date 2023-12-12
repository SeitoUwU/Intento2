import 'package:mysql1/mysql1.dart';
Future<MySqlConnection> getConnection() async {
  final conn = await MySqlConnection.connect(ConnectionSettings(
    host: 'bxmqyjq6uhblymsyi4jq-mysql.services.clever-cloud.com',
    port: 3306,
    user: 'uvin3ayjr9evhqzz',
    password: 'tWieHViS50yPqLJnDnv7',
    db: 'bxmqyjq6uhblymsyi4jq',
  ));
  return conn;
}