
// import 'package:badminton_management_1/bbdata/aamodel/my_roll_call.dart';
// import 'package:badminton_management_1/bbdata/local/database_service.dart';

// class RollCallDatabaseRepository{
  
//   final DatabaseService _dbService = DatabaseService();

//   String tableName = 'rollcall';
//   String studentIdCol = 'studentId';

//   // SQLite
//   Future<int> addItem(MyRollCall rc) async {
//     return await _dbService.insert(tableName, rc.toMapSqlite());
//   }

//   Future<List<MyRollCall>> getItems() async {
//     final itemsData = await _dbService.query(tableName);
//     return itemsData.map((item) => MyRollCall.fromJson(item)).toList();
//   }

//   Future<int> updateItem(MyRollCall item) async {
//     return await _dbService.update(
//       tableName,
//       item.toMapSqlite(),
//       '$studentIdCol = ?',
//       [item.studentId],
//     );
//   }

//   Future<int> deleteItem(String studentId) async {
//     return await _dbService.delete(tableName, '$studentIdCol = ?', [studentId]);
//   }
//   //
// }