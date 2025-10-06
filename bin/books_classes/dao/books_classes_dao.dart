import 'package:sqlite3/sqlite3.dart';

import '../../book/book.dart';
import '../../class/class.dart';
import '../../core/core.dart';
import 'books_classes_dao_model.dart';
import 'update_books_classes_dao_model.dart';

class BooksClassesDao extends BaseDaoModel {
  static const String tableName = "books_classes";

  static const List<String> tableColumns = [
    "${BooksClassesDaoModel.nameKey} TEXT NOT NULL",
    "${BooksClassesDaoModel.classIdKey} INTEGER NOT NULL",
    "${BooksClassesDaoModel.bookIdKey} INTEGER NOT NULL",
    //COLUMN_PLACE_HOLDER
    //Do not remove the line above
  ];

  static const List<String> tableConstraints = [
    "UNIQUE(${BooksClassesDaoModel.nameKey})",
    "FOREIGN KEY(${BooksClassesDaoModel.classIdKey}) REFERENCES ${ClassDao.tableName}(${BaseDaoModel.idKey}) ON DELETE CASCADE",
    "FOREIGN KEY(${BooksClassesDaoModel.bookIdKey}) REFERENCES ${BookDao.tableName}(${BaseDaoModel.idKey}) ON DELETE CASCADE",
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

  BooksClassesDao(this.db);
}

extension Books_classesDaoExt on BooksClassesDao {
  List<Row> getBooks_classess({PaginationDaoModel? pagination}) => CrudDao.getAll(
    db,
    BooksClassesDao.tableName,
    pagination: pagination,
    orderByField: [BooksClassesDaoModel.nameKey],
  );

  Row insertBooks_classes(BooksClassesDaoModel books_classes) => CrudDao.insert(
    db,
    BooksClassesDao.tableName,
    [
      BooksClassesDaoModel.nameKey,
      BooksClassesDaoModel.classIdKey,
      BooksClassesDaoModel.bookIdKey,

      //COLUMN_NAME_PLACE_HOLDER
      //Do not remove the line above
    ],
    [
      books_classes.name,
      books_classes.classId,
      books_classes.bookId,
      //COLUMN_VALUE_PLACE_HOLDER
      //Do not remove the line above
    ],
  );

  Map<String, dynamic>? getBooksClasses(String booksClassesId) =>
      CrudDao.getById(db, BooksClassesDao.tableName, booksClassesId);

  Row? updateBooksClasses(UpdateBooksClassesDaoModel booksClasses, String booksClassesId) => CrudDao.update(
    db,
    BooksClassesDao.tableName,
    booksClassesId,
    [
      if (booksClasses.name != null) UpdateBooksClassesDaoModel.nameKey,
      if (booksClasses.classId != null) UpdateBooksClassesDaoModel.classIdKey,
      if (booksClasses.bookId != null) UpdateBooksClassesDaoModel.bookIdKey,
      //COLUMN_UPDATE_PLACE_HOLDER
      //Do not remove the line above
    ],
    [
      if (booksClasses.name != null) booksClasses.name,
      if (booksClasses.classId != null) booksClasses.classId,
      if (booksClasses.bookId != null) booksClasses.bookId,
      //COLUMN_UPDATE_VALUE_PLACE_HOLDER
      //Do not remove the line above
    ],
  );

  bool deleteBooksClasses(String booksClasses) => CrudDao.delete(db, BooksClassesDao.tableName, booksClasses);
}
