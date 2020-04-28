import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyDatabase {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initialDatabase();
    return _db;
  }

  Future<Database> initialDatabase() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, "MyDatabse.db");
    Database _database =
        await openDatabase(dbPath, version: 1, onCreate: _onCreate);
    return _database;
  }

  void _onCreate(Database myDB, int version) {
    String sql1 =
        'create table mydata(data_id integer primary key autoincrement,'
        'ac_id text,ac_name text,ac_phone text,ac_password text,ac_address text,re text)';
    myDB.execute(sql1);
  }

  Future<int> insertData(String sql) async {
    try {
      Database d = await db;
      int data = await d.rawInsert(sql);
      return data;
    } catch (err) {
      throw err.toString();
    }
  }

  Future<List> selectData(String sql) async {
    try {
      Database d = await db;
      List data = await d.rawQuery(sql);
      return data;
    } catch (err) {
      throw err.toString();
    }
  }
  Future<int> updateData(String sql) async {
    try {
      Database d = await db;
      int data = await d.rawUpdate(sql);
      return data;
    } catch (err) {
      throw err.toString();
    }
  }
  Future<int> deleteData(String sql) async {
    try {
      Database d = await db;
      int data = await d.rawDelete(sql);
      return data;
    } catch (err) {
      throw err.toString();
    }
  }

}
