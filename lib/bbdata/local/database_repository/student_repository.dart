// import 'package:badminton_management_1/bbdata/aamodel/my_student.dart';
// import 'package:badminton_management_1/bbdata/local/database_service.dart';

// class StudentDatabaseRepository{
  
//   final DatabaseService _dbService = DatabaseService();

//   String tableName = 'students';
//   String studentIdCol = 'id';
//   String isCheckCol = 'isCheck';

//   // SQLite
//   Future<int> addItem(MyStudent std) async {
//     return await _dbService.insert(tableName, std.toMapSqlite());
//   }

//   Future<List<MyStudent>> getItems() async {
//     final itemsData = await _dbService.query(tableName);
//     return itemsData.map((item) => MyStudent.fromJson(item)).toList();
//   }

//   Future<int> updateItem(MyStudent item) async {
//     return await _dbService.update(
//       tableName,
//       item.toMapSqlite(),
//       '$studentIdCol = ?',
//       [item.id],
//     );
//   }

//   Future<int> deleteItem(String studentId) async {
//     return await _dbService.delete(tableName, '$studentIdCol = ?', [studentId]);
//   }

//   Future<void> clearItem() async {
//     return await _dbService.clear(tableName);
//   }
//   //
// }