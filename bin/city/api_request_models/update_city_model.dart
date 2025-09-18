import '../../core/core.dart';
import '../dao/update_city_dao_model.dart';
import 'city_model.dart';

class UpdateCityModel extends BaseAdapterModel<UpdateCityDaoModel> {
  static const nameKey = CityModel.nameKey;

  String? name;

  UpdateCityModel(Map<String, dynamic> data, [String? clientId]) : name = data[nameKey];

  static List<String> get requiredFields => [];

  static Map<String, Type> get fieldTypes => CityModel.fieldTypes;

  static String? validateField(dynamic value, String key) => CityModel.validateField(value, key);

  @override
  UpdateCityDaoModel toDao() => UpdateCityDaoModel(name);
}
