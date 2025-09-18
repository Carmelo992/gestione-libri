import '../../core/core.dart';
import 'city_dao_model.dart';

class UpdateCityDaoModel extends BaseDaoModel {
  static const nameKey = CityDaoModel.nameKey;

  String? name;

  UpdateCityDaoModel(this.name);
}
