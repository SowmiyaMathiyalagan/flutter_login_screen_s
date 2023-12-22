import 'package:flutter_login_screen_s/user_details_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "LoginScreenDB.db";
  static const _databaseVersion = 4;

  // Register table
  static const loginDetailsTable = 'login_details_table';

  // colum Register table
  static const columnId = '_id';
  static const colUserName = 'user_name';
  static const colDOB = '_dob';
  static const colPassword = '_password';
  static const colMobileNo = '_mobileNo';
  static const colEmailID = '_emailID';

  late Database _db;

  Future<void> initialization() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    print(documentsDirectory);
    print(path);

    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database database, int version) async {
    await database.execute('''
    CREATE TABLE $loginDetailsTable(
    $columnId INTEGER PRIMARY KEY,
    $colUserName TEXT,
    $colDOB TEXT,
    $colPassword TEXT,
    $colMobileNo TEXT,
    $colEmailID TEXT
    )
    ''');
  }

  _onUpgrade(Database database, int oldVersion, int newVersion) async {
    await database.execute('drop table $loginDetailsTable');
    _onCreate(database, newVersion);
  }

  Future<int> insertDirectorDetails(Map<String, dynamic> row,
      String tableName) async {
    return await _db.insert(tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    // select * from login_details_table;
    return await _db.query(tableName);
  }

  Future<int> update(Map<String, dynamic> row, String tableName) async{
    int id =row [columnId];
    return await _db.update(
      tableName,
      row,
      where: '$columnId = ?',
      whereArgs: [id],

    );
  }
  Future<int> delete(int id, String tableName) async {
    return await _db.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<bool> checkLoginCredentials(String username, String password) async {
    final List<Map<String, dynamic>> result = await _db.query(
      loginDetailsTable,
      where: '$colUserName = ? AND $colPassword = ?',
      whereArgs: [username, password],
    );

    return result.isNotEmpty;
  }


}