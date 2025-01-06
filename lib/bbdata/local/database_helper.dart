// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// class DatabaseHelper{
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   factory DatabaseHelper() => _instance;
//   DatabaseHelper._internal();

//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     String databasePath = await getDatabasesPath();
//     String path = join(databasePath, 'sqlite_database.db');
    
//     // await deleteDatabase(path);
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {

//         await db.execute(
//           'CREATE TABLE IF NOT EXISTS rollcall('
//             'studentId TEXT PRIMARY KEY, '
//             'coachId TEXT, '
//             'isCheck TEXT, '
//             'statusId TEXT, '
//             'userCreated TEXT, '
//             'userUpdated TEXT, '
//             'dateCreated TEXT, '
//             'dateUpdated TEXT'
//           ')',
//         );

//         await db.execute(
//           'CREATE TABLE IF NOT EXISTS students('
//             'studentId TEXT PRIMARY KEY, '
//             'studentName TEXT, '
//             'phone TEXT, '
//             'password TEXT, '
//             'timeId TEXT, '
//             'images TEXT, '
//             'genderId TEXT, '
//             'birthday TEXT, '
//             'email TEXT, '
//             'statusId TEXT, '
//             'isCheck TEXT DEFAULT "0"'
//           ')',
//         );

//         await db.execute(
//           'CREATE TABLE IF NOT EXISTS times('
//             'timeId TEXT PRIMARY KEY, '
//             'timeName TEXT'
//           ')',
//         );

//       },
//     );
//   }

//   Future<void> close() async {
//     final db = await database;
//     db.close();
//   }
// }