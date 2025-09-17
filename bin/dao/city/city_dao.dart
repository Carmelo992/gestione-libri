import 'package:sqlite3/sqlite3.dart';

import '../base_dao_model.dart';
import '../crud_dao.dart';
import '../pagination_dao_model.dart';
import 'city_dao_model.dart';
import 'update_city_dao_model.dart';

class CityDao extends BaseDaoModel {
  static const String tableName = "cities";

  static const List<String> tableColumns = ["${CityDaoModel.nameKey} TEXT NOT NULL"];

  static const List<String> tableConstraints = ["UNIQUE(${CityDaoModel.nameKey})"];

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

  CityDao(this.db);
}

extension CityDaoExt on CityDao {
  List<Row> getCities({PaginationDaoModel? pagination}) =>
      CrudDao.getAll(db, CityDao.tableName, pagination: pagination, orderByField: [CityDaoModel.nameKey]);

  Row insertCity(CityDaoModel client) => CrudDao.insert(db, CityDao.tableName, [CityDaoModel.nameKey], [client.name]);

  Map<String, dynamic>? getCity(String clientId) => CrudDao.getById(db, CityDao.tableName, clientId);

  Row? updateCity(UpdateCityModel city, String cityId) => CrudDao.update(
    db,
    CityDao.tableName,
    cityId,
    [if (city.name != null) UpdateCityModel.nameKey],
    [if (city.name != null) city.name],
  );

  bool deleteCity(String city) => CrudDao.delete(db, CityDao.tableName, city);
}
