import '../../core/core.dart';

class SchoolDaoModel extends BaseDaoModel {
  static const nameKey = "name";
  static const externalIdKey = "external_id";
  static const cityIdKey = "city_id";

  String name, externalId;
  int cityId;

  SchoolDaoModel({required this.name, required this.externalId, required this.cityId});
}
