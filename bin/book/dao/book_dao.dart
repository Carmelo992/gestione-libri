import 'package:sqlite3/sqlite3.dart';

import '../../core/core.dart';
import 'book_dao_model.dart';
import 'update_book_dao_model.dart';

class BookDao extends BaseDaoModel {
  static const String tableName = "cities";

  static const List<String> tableColumns = ["${BookDaoModel.nameKey} TEXT NOT NULL"];

  static const List<String> tableConstraints = ["UNIQUE(${BookDaoModel.nameKey})"];

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

  BookDao(this.db);
}

extension BookDaoExt on BookDao {
  List<Row> getBooks({PaginationDaoModel? pagination}) =>
      CrudDao.getAll(db, BookDao.tableName, pagination: pagination, orderByField: [BookDaoModel.nameKey]);

  Row insertBook(BookDaoModel book) => CrudDao.insert(db, BookDao.tableName, [BookDaoModel.nameKey], [book.name]);

  Map<String, dynamic>? getBook(String bookId) => CrudDao.getById(db, BookDao.tableName, bookId);

  Row? updateBook(UpdateBookDaoModel book, String bookId) => CrudDao.update(
    db,
    BookDao.tableName,
    bookId,
    [if (book.name != null) UpdateBookDaoModel.nameKey],
    [if (book.name != null) book.name],
  );

  bool deleteBook(String book) => CrudDao.delete(db, BookDao.tableName, book);
}
