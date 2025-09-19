import '../../core/core.dart';
import 'school_dao_model.dart';

class UpdateSchoolDaoModel extends BaseDaoModel {
  static const nameKey = SchoolDaoModel.nameKey;

  String? name;

  UpdateSchoolDaoModel(this.name);
}
