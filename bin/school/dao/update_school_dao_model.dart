import '../../core/core.dart';
import 'school_dao_model.dart';

class UpdateSchoolDaoModel extends BaseDaoModel {
  static const nameKey = SchoolDaoModel.nameKey;
  static const externalIdKey = SchoolDaoModel.externalIdKey;
  static const cityIdKey = SchoolDaoModel.cityIdKey;

  String? name, externalId;
  int? cityId;

  UpdateSchoolDaoModel({required this.name, required this.externalId, required this.cityId});
}
