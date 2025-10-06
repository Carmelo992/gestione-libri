import 'package:sqlite3/sqlite3.dart';

import '../../core/core.dart';
import 'update_website_dao_model.dart';
import 'website_dao_model.dart';

class WebsiteDao extends BaseDaoModel {
  static const String tableName = "websites";

  static const List<String> tableColumns = [
    "${WebsiteDaoModel.nameKey} TEXT NOT NULL",
    //COLUMN_PLACE_HOLDER
    //Do not remove the line above
  ];

  static const List<String> tableConstraints = [
    "UNIQUE(${WebsiteDaoModel.nameKey})",
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

  WebsiteDao(this.db);
}

extension WebsiteDaoExt on WebsiteDao {
  List<Row> getWebsites({PaginationDaoModel? pagination}) =>
      CrudDao.getAll(db, WebsiteDao.tableName, pagination: pagination, orderByField: [WebsiteDaoModel.nameKey]);

  Row insertWebsite(WebsiteDaoModel website) => CrudDao.insert(
    db,
    WebsiteDao.tableName,
    [
      WebsiteDaoModel.nameKey,

      //COLUMN_NAME_PLACE_HOLDER
      //Do not remove the line above
    ],
    [
      website.name,
      //COLUMN_VALUE_PLACE_HOLDER
      //Do not remove the line above
    ],
  );

  Map<String, dynamic>? getWebsite(String websiteId) => CrudDao.getById(db, WebsiteDao.tableName, websiteId);

  Row? updateWebsite(UpdateWebsiteDaoModel website, String websiteId) => CrudDao.update(
    db,
    WebsiteDao.tableName,
    websiteId,
    [
      if (website.name != null) UpdateWebsiteDaoModel.nameKey,
      //COLUMN_UPDATE_PLACE_HOLDER
      //Do not remove the line above
    ],
    [
      if (website.name != null) website.name,
      //COLUMN_UPDATE_VALUE_PLACE_HOLDER
      //Do not remove the line above
    ],
  );

  bool deleteWebsite(String website) => CrudDao.delete(db, WebsiteDao.tableName, website);
}
