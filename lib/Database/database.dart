import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todolist/Models/task.dart';

class DatabaseTask {
  Database _database;
  final String kTableTask = 'table_task';
  final String kId = 'id';
  final String kName = 'name';
  final String kDescription = 'description';

  //Tạo Database và table để lưu dữ liệu openDatabase(path, onCreate, version)
  Future _openDB() async {

    _database = await openDatabase(
      join(await getDatabasesPath(), 'taskDB.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $kTableTask($kId INTEGER PRIMARY KEY AUTOINCREMENT,$kName TEXT,$kDescription TEXT)');
      },
      version: 1,
    );
  }

  //insert vào Database
  Future insertDB(Task task) async {
    await _openDB();
    await _database.insert(kTableTask, task.toMap());
  }

  //update dữ liệu Task database
  Future updateDB(Task task) async {
    await _openDB();
    await _database.update(
      kTableTask,
      task.toMap(),
      where: '$kId = ?',
      whereArgs: [task.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //delete dữ liệu database theo id
  Future deleteDB(int id) async {
    await _openDB();
    await _database.delete(kTableTask, where: '$kId = ?', whereArgs: [id]);
  }

  Future<List<Task>> getDB() async {
    await _openDB();
    List<Map<String, dynamic>> maps = await _database.query(kTableTask);
    return List.generate(
        maps.length,
        (index) => Task(
            id: maps[index][kId],
            name: maps[index][kName],
            description: maps[index][kDescription]
        ));
  }
}
