import 'package:sqlite3/sqlite3.dart';

import '../../core/core.dart';
import '../../school/school.dart';
import 'class_dao_model.dart';
import 'update_class_dao_model.dart';

class ClassDao extends BaseDaoModel {
  static const String tableName = "classs";

  static const List<String> tableColumns = [
    "${ClassDaoModel.nameKey} TEXT NOT NULL",
    "${ClassDaoModel.schoolIdKey} INTEGER NOT NULL",
    //COLUMN_PLACE_HOLDER
    //Do not remove the line above
  ];

  static const List<String> tableConstraints = [
    "UNIQUE(${ClassDaoModel.nameKey})",
    "FOREIGN KEY(${ClassDaoModel.schoolIdKey}) REFERENCES ${SchoolDao.tableName}(${BaseDaoModel.idKey}) ON DELETE CASCADE",
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

  ClassDao(this.db);
}

extension ClassDaoExt on ClassDao {
  List<Row> getClasss({PaginationDaoModel? pagination}) =>
      CrudDao.getAll(db, ClassDao.tableName, pagination: pagination, orderByField: [ClassDaoModel.nameKey]);

  Row insertClass(ClassDaoModel classModel) => CrudDao.insert(
    db,
    ClassDao.tableName,
    [
      ClassDaoModel.nameKey,
      ClassDaoModel.schoolIdKey,

      //COLUMN_NAME_PLACE_HOLDER
      //Do not remove the line above
    ],
    [
      classModel.name,
      classModel.schoolId,
      //COLUMN_VALUE_PLACE_HOLDER
      //Do not remove the line above
    ],
  );

  Map<String, dynamic>? getClass(String classId) => CrudDao.getById(db, ClassDao.tableName, classId);

  Row? updateClass(UpdateClassDaoModel classModel, String classId) => CrudDao.update(
    db,
    ClassDao.tableName,
    classId,
    [
      if (classModel.name != null) UpdateClassDaoModel.nameKey,
      if (classModel.schoolId != null) UpdateClassDaoModel.schoolIdKey,
      //COLUMN_UPDATE_PLACE_HOLDER
      //Do not remove the line above
    ],
    [
      if (classModel.name != null) classModel.name,
      if (classModel.schoolId != null) classModel.schoolId,
      //COLUMN_UPDATE_VALUE_PLACE_HOLDER
      //Do not remove the line above
    ],
  );

  bool deleteClass(String classModel) => CrudDao.delete(db, ClassDao.tableName, classModel);
}
