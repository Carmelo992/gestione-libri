import 'package:sqlite3/sqlite3.dart';

import '../../core/core.dart';
import 'student_dao_model.dart';
import 'update_student_dao_model.dart';

class StudentDao extends BaseDaoModel {
  static const String tableName = "students";

  static const List<String> tableColumns = [
    "${StudentDaoModel.nameKey} TEXT NOT NULL",
    "${StudentDaoModel.surnameKey} TEXT NOT NULL",
    "${StudentDaoModel.phoneNumberKey} TEXT NOT NULL",
  ];

  static const List<String> tableConstraints = ["UNIQUE(${StudentDaoModel.nameKey})"];

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

  StudentDao(this.db);
}

extension StudentDaoExt on StudentDao {
  List<Row> getStudents({PaginationDaoModel? pagination}) =>
      CrudDao.getAll(db, StudentDao.tableName, pagination: pagination, orderByField: [StudentDaoModel.nameKey]);

  Row insertStudent(StudentDaoModel student) =>
      CrudDao.insert(db, StudentDao.tableName, [StudentDaoModel.nameKey], [student.name]);

  Map<String, dynamic>? getStudent(String studentId) => CrudDao.getById(db, StudentDao.tableName, studentId);

  Row? updateStudent(UpdateStudentDaoModel student, String studentId) => CrudDao.update(
    db,
    StudentDao.tableName,
    studentId,
    [
      if (student.name != null) UpdateStudentDaoModel.nameKey,
      if (student.surname != null) UpdateStudentDaoModel.surnameKey,
      if (student.phoneNumber != null) UpdateStudentDaoModel.phoneNumberKey,
    ],
    [
      if (student.name != null) student.name,
      if (student.surname != null) student.surname,
      if (student.phoneNumber != null) student.phoneNumber,
    ],
  );

  bool deleteStudent(String student) => CrudDao.delete(db, StudentDao.tableName, student);
}
