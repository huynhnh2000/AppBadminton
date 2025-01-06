// import 'package:badminton_management_1/bbdata/local/database_helper.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseService{

//   final DatabaseHelper _dbHelper = DatabaseHelper();

//   Future<int> insert(String table, Map<String, dynamic> data) async {
//     final db = await _dbHelper.database;
//     return await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   Future<List<Map<String, dynamic>>> query(String table, {String? where, List<Object?>? whereArgs}) async {
//     final db = await _dbHelper.database;
//     return await db.query(table, where: where, whereArgs: whereArgs);
//   }

//   Future<int> update(String table, Map<String, dynamic> data, String where, List<Object?> whereArgs) async {
//     final db = await _dbHelper.database;
//     return await db.update(table, data, where: where, whereArgs: whereArgs);
//   }

//   Future<int> delete(String table, String where, List<Object?> whereArgs) async {
//     final db = await _dbHelper.database;
//     return await db.delete(table, where: where, whereArgs: whereArgs);
//   }

//   Future<void> clear(String table) async{
//     final db = await _dbHelper.database;
//     List<Map<String, dynamic>> result = await query(table);
//     if (result.isNotEmpty) {
//       await db.delete(table);
//     }
//   } 

// }