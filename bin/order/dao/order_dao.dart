import 'package:sqlite3/sqlite3.dart';

import '../../core/core.dart';
import 'order_dao_model.dart';
import 'update_order_dao_model.dart';

class OrderDao extends BaseDaoModel {
  static const String tableName = "orders";

  static const List<String> tableColumns = ["${OrderDaoModel.nameKey} TEXT NOT NULL"];

  static const List<String> tableConstraints = ["UNIQUE(${OrderDaoModel.nameKey})"];

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

  OrderDao(this.db);
}

extension OrderDaoExt on OrderDao {
  List<Row> getOrders({PaginationDaoModel? pagination}) =>
      CrudDao.getAll(db, OrderDao.tableName, pagination: pagination, orderByField: [OrderDaoModel.nameKey]);

  Row insertOrder(OrderDaoModel order) => CrudDao.insert(db, OrderDao.tableName, [OrderDaoModel.nameKey], [order.name]);

  Map<String, dynamic>? getOrder(String orderId) => CrudDao.getById(db, OrderDao.tableName, orderId);

  Row? updateOrder(UpdateOrderDaoModel order, String orderId) => CrudDao.update(
    db,
    OrderDao.tableName,
    orderId,
    [if (order.name != null) UpdateOrderDaoModel.nameKey],
    [if (order.name != null) order.name],
  );

  bool deleteOrder(String order) => CrudDao.delete(db, OrderDao.tableName, order);
}
