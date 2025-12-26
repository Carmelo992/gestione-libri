import 'package:sqlite3/sqlite3.dart';

import '../../core/core.dart';
import 'update_year_dao_model.dart';
import 'year_dao_model.dart';

class YearDao extends BaseDaoModel {
  static const String tableName = "years";

  static const List<String> tableColumns = [
    "${YearDaoModel.nameKey} TEXT NOT NULL",
    //COLUMN_PLACE_HOLDER
    //Do not remove the line above
  ];

  static const List<String> tableConstraints = [
    "UNIQUE(${YearDaoModel.nameKey})",
    //CONSTRAINT_PLACE_HOLDER
    //Do not remove the line above
  ];

  static void migrate(int newDbVersion) {
    switch (newDbVersion) {
      case 1:
      //db.execute('''
      //BEGIN TRANSACTION;
      //
      //  ALTER TABLE tasks
      //  RENAME COLUMN date TO startDate;
      //
      //  ALTER TABLE tasks
      //  ADD COLUMN endDate DATETIME;
      //
      //  UPDATE tasks SET endDate = startDate WHERE endDate IS NULL;
      //
      //COMMIT;
      //''');
      //break;
    }
  }

  Database db;

  YearDao(this.db);
}

extension YearDaoExt on YearDao {
  List<Row> getYears({PaginationDaoModel? pagination}) =>
      CrudDao.getAll(db, YearDao.tableName, pagination: pagination, orderByField: [YearDaoModel.nameKey], isDesc: true);

  Row insertYear(YearDaoModel year) => CrudDao.insert(
    db,
    YearDao.tableName,
    [
      YearDaoModel.nameKey,

      //COLUMN_NAME_PLACE_HOLDER
      //Do not remove the line above
    ],
    [
      year.name,
      //COLUMN_VALUE_PLACE_HOLDER
      //Do not remove the line above
    ],
  );

  Map<String, dynamic>? getYear(String yearId) => CrudDao.getById(db, YearDao.tableName, yearId);

  Row? updateYear(UpdateYearDaoModel year, String yearId) => CrudDao.update(
    db,
    YearDao.tableName,
    yearId,
    [
      if (year.name != null) UpdateYearDaoModel.nameKey,
      //COLUMN_UPDATE_PLACE_HOLDER
      //Do not remove the line above
    ],
    [
      if (year.name != null) year.name,
      //COLUMN_UPDATE_VALUE_PLACE_HOLDER
      //Do not remove the line above
    ],
  );

  bool deleteYear(String year) => CrudDao.delete(db, YearDao.tableName, year);
}
