
// import 'package:badminton_management_1/bbdata/aamodel/my_time.dart';
// import 'package:badminton_management_1/bbdata/local/database_service.dart';

// class TimeDatabaseRepository{
  
//   final DatabaseService _dbService = DatabaseService();

//   String tableName = 'times';
//   String timeIdCol = 'timeId';

//   // SQLite
//   Future<int> addItem(MyTime time) async {
//     return await _dbService.insert(tableName, time.toMapSqlite());
//   }

//   Future<List<MyTime>> getItems() async {
//     final itemsData = await _dbService.query(tableName);
//     return itemsData.map((item) => MyTime.fromJson(item)).toList();
//   }

//   Future<int> updateItem(MyTime item) async {
//     return await _dbService.update(
//       tableName,
//       item.toMapSqlite(),
//       '$timeIdCol = ?',
//       [item.id],
//     );
//   }

//   Future<int> deleteItem(String timeId) async {
//     return await _dbService.delete(tableName, '$timeIdCol = ?', [timeId]);
//   }

//   Future<void> clearItem() async {
//     return await _dbService.clear(tableName);
//   }
//   //
// }