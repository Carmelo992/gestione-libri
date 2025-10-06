import 'package:sqlite3/sqlite3.dart';

import '../../core/core.dart';
import 'transaction_dao_model.dart';
import 'update_transaction_dao_model.dart';

class TransactionDao extends BaseDaoModel {
  static const String tableName = "transactions";

  static const List<String> tableColumns = [
    "${TransactionDaoModel.studentIdKey} INTEGER NOT NULL",
    "${TransactionDaoModel.amountKey} INTEGER NOT NULL",
    //COLUMN_PLACE_HOLDER
    //Do not remove the line above
  ];

  static const List<String> tableConstraints = [
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

  TransactionDao(this.db);
}

extension TransactionDaoExt on TransactionDao {
  List<Row> getTransactions({PaginationDaoModel? pagination}) =>
      CrudDao.getAll(db, TransactionDao.tableName, pagination: pagination);

  Row insertTransaction(TransactionDaoModel transaction) => CrudDao.insert(
    db,
    TransactionDao.tableName,
    [
      TransactionDaoModel.studentIdKey,
      TransactionDaoModel.amountKey,

      //COLUMN_NAME_PLACE_HOLDER
      //Do not remove the line above
    ],
    [
      transaction.studentId,
      transaction.amount,
      //COLUMN_VALUE_PLACE_HOLDER
      //Do not remove the line above
    ],
  );

  Map<String, dynamic>? getTransaction(String transactionId) =>
      CrudDao.getById(db, TransactionDao.tableName, transactionId);

  Row? updateTransaction(UpdateTransactionDaoModel transaction, String transactionId) => CrudDao.update(
    db,
    TransactionDao.tableName,
    transactionId,
    [
      if (transaction.studentId != null) UpdateTransactionDaoModel.studentIdKey,
      if (transaction.amount != null) UpdateTransactionDaoModel.amountKey,
      //COLUMN_UPDATE_PLACE_HOLDER
      //Do not remove the line above
    ],
    [
      if (transaction.studentId != null) transaction.studentId,
      if (transaction.amount != null) transaction.amount,
      //COLUMN_UPDATE_VALUE_PLACE_HOLDER
      //Do not remove the line above
    ],
  );

  bool deleteTransaction(String transaction) => CrudDao.delete(db, TransactionDao.tableName, transaction);
}
