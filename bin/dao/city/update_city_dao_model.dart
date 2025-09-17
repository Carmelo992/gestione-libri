import 'city_dao_model.dart';

class UpdateCityModel {
  static const nameKey = CityDaoModel.nameKey;

  String? name;

  UpdateCityModel(this.name);
}
