import 'package:sqlite3/sqlite3.dart';

import '../../city/city.dart';
import '../../core/core.dart';
import 'school_dao_model.dart';
import 'update_school_dao_model.dart';

class SchoolDao extends BaseDaoModel {
  static const String tableName = "schools";

  static const List<String> tableColumns = [
    "${SchoolDaoModel.nameKey} TEXT NOT NULL",
    "${SchoolDaoModel.externalIdKey} TEXT NOT NULL",
    "${SchoolDaoModel.cityIdKey} TEXT",
    "FOREIGN KEY(${SchoolDaoModel.cityIdKey}) REFERENCES ${CityDao.tableName}(${BaseDaoModel.idKey}) ON DELETE CASCADE",
  ];
  static const List<String> constraints = ["UNIQUE(${SchoolDaoModel.externalIdKey})"];

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

  SchoolDao(this.db);
}

extension SchoolDaoExt on SchoolDao {
  List<Row> getSchools({PaginationDaoModel? pagination}) =>
      CrudDao.getAll(db, SchoolDao.tableName, pagination: pagination, orderByField: [SchoolDaoModel.nameKey]);

  Row insertSchool(SchoolDaoModel school) =>
      CrudDao.insert(db, SchoolDao.tableName, [SchoolDaoModel.nameKey], [school.name]);

  Map<String, dynamic>? getSchool(String schoolId) => CrudDao.getById(db, SchoolDao.tableName, schoolId);

  Row? updateSchool(UpdateSchoolDaoModel school, String cityId) => CrudDao.update(
    db,
    SchoolDao.tableName,
    cityId,
    [
      if (school.name != null) UpdateSchoolDaoModel.nameKey,
      if (school.externalId != null) UpdateSchoolDaoModel.externalIdKey,
      if (school.cityId != null) UpdateSchoolDaoModel.cityIdKey,
    ],
    [
      if (school.name != null) school.name,
      if (school.externalId != null) school.externalId,
      if (school.cityId != null) school.cityId,
    ],
  );

  bool deleteSchool(String schoolId) => CrudDao.delete(db, SchoolDao.tableName, schoolId);
}
