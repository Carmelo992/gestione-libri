import '../../core/core.dart';

class SchoolDaoModel extends BaseDaoModel {
  static const nameKey = "name";
  static const cityIdKey = "cityId";

  String name;

  SchoolDaoModel(this.name);
}
