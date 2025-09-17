import 'dart:io';

import 'package:sqlite3/sqlite3.dart';

import 'dao/city/city_dao.dart';
import 'dao/user/user_dao.dart';
import 'logger.dart';

class DatabaseManager {
  static const idKey = "id";
  static int databaseVersion = 0;

  static const _dbName = "libri_stage.sqlite3";

  static late Database db;

  static CityDao cityDao = CityDao(db);
  static UserDao userDao = UserDao(db);

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

      db.userVersion = newDbVersion;
    }
  }

  static void createDatabaseTable() {
    db.execute(createTable(CityDao.tableName, CityDao.tableColumns));
    db.execute(createTable(UserDao.tableName, UserDao.tableColumns));
  }
}

String createTable(String tableName, List<String> columns, {List<String> constraints = const <String>[]}) =>
    '''
    CREATE TABLE IF NOT EXISTS $tableName (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
    ${columns.join(',\n')},
    createdAt TIMESTAMP DATETIME NOT NULL DEFAULT (STRFTIME('%Y-%m-%dT%H:%M:%f000Z', 'NOW')),
    updatedAt TIMESTAMP DATETIME NOT NULL DEFAULT (STRFTIME('%Y-%m-%dT%H:%M:%f000Z', 'NOW'))
    ${constraints.isNotEmpty ? ",\n${constraints.join(",\n")}" : ""}
    );
''';
