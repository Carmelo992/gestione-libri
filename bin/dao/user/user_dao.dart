import 'package:bcrypt/bcrypt.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../database.dart';
import '../crud_dao.dart';
import '../pagination_dao_model.dart';
import 'update_user_dao_model.dart';
import 'user_dao_model.dart';

class UserDao {
  static const String tableName = "users";

  static const List<String> tableColumns = [
    "${UserDaoModel.firstNameKey} TEXT NOT NULL",
    "${UserDaoModel.lastNameKey} TEXT NOT NULL",
    "${UserDaoModel.emailKey} TEXT Unique NOT NULL",
    "${UserDaoModel.passwordKey} TEXT NOT NULL",
    "${UserDaoModel.isAdminKey} BOOLEAN NOT NULL DEFAULT false",
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

  UserDao(this.db);

  List<Row> getUsers({PaginationDaoModel? pagination}) => CrudDao.getAll(
    db,
    tableName,
    pagination: pagination,
    keys: [UserDaoModel.isAdminKey],
    values: [0],
    orderByField: [UserDaoModel.firstNameKey, UserDaoModel.lastNameKey],
  );

  Row insertUser(UserDaoModel resource) => CrudDao.insert(
    db,
    tableName,
    [UserDaoModel.firstNameKey, UserDaoModel.lastNameKey, UserDaoModel.emailKey, UserDaoModel.passwordKey],
    [resource.firstName, resource.lastName, resource.email, BCrypt.hashpw(resource.password, BCrypt.gensalt())],
  );

  Map<String, dynamic>? getUser(String resourceId) =>
      CrudDao.getBy(db, tableName, [DatabaseManager.idKey, UserDaoModel.isAdminKey], [resourceId, 0]);

  Row? updateUser(UpdateUserDaoModel resource, String resourceId) => CrudDao.update(
    db,
    tableName,
    resourceId,
    [
      if (resource.firstName != null) UserDaoModel.firstNameKey,
      if (resource.lastName != null) UserDaoModel.lastNameKey,
    ],
    [if (resource.firstName != null) resource.firstName, if (resource.lastName != null) resource.lastName],
  );

  bool deleteUser(String resource) => CrudDao.delete(db, tableName, resource);

  Map<String, dynamic>? login(String email) => CrudDao.getBy(db, tableName, [UserDaoModel.emailKey], [email]);

  void insertAdmin() => CrudDao.insert(
    db,
    tableName,
    [
      UserDaoModel.emailKey,
      UserDaoModel.passwordKey,
      UserDaoModel.firstNameKey,
      UserDaoModel.lastNameKey,
      UserDaoModel.isAdminKey,
    ],
    ["admin@admin.it", BCrypt.hashpw("B33@ppSrl!", BCrypt.gensalt()), "Admin", "Admin", true],
  );

  bool updatePassword(String userId, String password) {
    var hashpw = BCrypt.hashpw(password, BCrypt.gensalt());

    return CrudDao.update(db, tableName, userId, [UserDaoModel.passwordKey], [hashpw]) != null;
  }

  Map<String, dynamic>? getUserByEmail(String email) => CrudDao.getBy(db, tableName, [UserDaoModel.emailKey], [email]);
}
