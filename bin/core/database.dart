import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

import '../book/book.dart';
import '../books_classes/books_classes.dart';
import '../city/city.dart';
import '../class/class.dart';
import '../core/core.dart';
import '../order/order.dart';
import '../school/school.dart';
import '../student/student.dart';
import '../user/user.dart';
//NEW_MODULE_PATH_PLACE_HOLDER
//Do not remove the line above

class DatabaseManager {
  static const idKey = "id";
  static int databaseVersion = 0;

  static const _dbName = "libri_stage.sqlite3";

  static late Database db;

  static CityDao cityDao = CityDao(db);
  static UserDao userDao = UserDao(db);
  static SchoolDao schoolDao = SchoolDao(db);

	static BookDao bookDao = BookDao(db);
  static StudentDao studentDao = StudentDao(db);
  static OrderDao orderDao = OrderDao(db);
  static ClassDao classDao = ClassDao(db);
  static BooksClassesDao books_classesDao = BooksClassesDao(db);
  //NEW_MODULE_DAO_PLACE_HOLDER
  //Do not remove the line above

  static void openDatabase(String? dbName) {
    var dbFile = File("${Directory.current.path}/${dbName ?? _dbName}");
    bool overrideDefaultDbVersion = !dbFile.existsSync();
    Logger.log(dbFile.existsSync());
    Logger.log(dbFile);
    final db = sqlite3.open("${Directory.current.path}/${dbName ?? _dbName}");
    db.execute("PRAGMA foreign_keys = ON;");
    Logger.log('Using sqlite3 ${sqlite3.version}');
    Logger.log('Database version: ${db.userVersion}');
    if (overrideDefaultDbVersion) {
      db.userVersion = databaseVersion;
    }
    DatabaseManager.db = db;
  }

  static void handleMigration() {
    int oldDbVersion = db.userVersion;

    if (databaseVersion <= oldDbVersion) return;
    for (int i = oldDbVersion; i < databaseVersion; i++) {
      var newDbVersion = oldDbVersion + 1;
      Logger.log("Migration db from $i to $newDbVersion");

      CityDao.migrate(newDbVersion);
      UserDao.migrate(newDbVersion);
      SchoolDao.migrate(newDbVersion);
			BookDao.migrate(newDbVersion);
      StudentDao.migrate(newDbVersion);
      OrderDao.migrate(newDbVersion);
      ClassDao.migrate(newDbVersion);
      BooksClassesDao.migrate(newDbVersion);
      //NEW_MODULE_MIGRATION_PLACE_HOLDER
      //Do not remove the line above

      db.userVersion = newDbVersion;
    }
  }

  static void createDatabaseTable() {
    db.execute(createTable(CityDao.tableName, CityDao.tableColumns));
    db.execute(createTable(UserDao.tableName, UserDao.tableColumns));
    db.execute(createTable(SchoolDao.tableName, SchoolDao.tableColumns, constraints: SchoolDao.constraints));
    db.execute(createTable(BookDao.tableName, BookDao.tableColumns));
    db.execute(createTable(StudentDao.tableName, StudentDao.tableColumns));
    db.execute(createTable(OrderDao.tableName, OrderDao.tableColumns));
    db.execute(createTable(ClassDao.tableName, ClassDao.tableColumns));
    db.execute(createTable(BooksClassesDao.tableName, BooksClassesDao.tableColumns));
    //NEW_MODULE_CREATE_TABLE_PLACE_HOLDER
    //Do not remove the line above
  }
}

String createTable(String tableName, List<String> columns, {List<String> constraints = const <String>[]}) =>
    '''
    CREATE TABLE IF NOT EXISTS $tableName (
    ${[...BaseDaoModel.tableColumns, ...columns, ...constraints].join(',\n')} 
    );
''';
