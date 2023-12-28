import 'package:contact/db_helper/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  late DatabaseConnection _databaseConnection;
  Repository() {
    _databaseConnection = DatabaseConnection();
  }
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _databaseConnection.setDatabase();
      return _database!;
    }
  }

  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  readData(table, {String? orderBy}) async {
    var connection = await database;
    return await connection.query(table, orderBy: orderBy);
  }

  //read single data
  readDataById(table, itemId) async {
    var connection = await database;
    return await connection.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  //update data
  updateData(table, data) async {
    var connection = await database;
    return await connection
        .update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  //delete data
  deleteData(table, itemId) async {
    var connection = await database;
    return await connection.rawDelete('DELETE FROM $table WHERE id = $itemId');
  }

  //search data
  dataSearch(table, search) async {
    var connection = await database;
    return await connection.rawQuery(
        "SELECT * FROM $table WHERE name LIKE '%$search%' OR phone LIKE '%$search%'");
  }
}
