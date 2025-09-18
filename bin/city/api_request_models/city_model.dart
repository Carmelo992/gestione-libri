import '../../core/core.dart';
import '../dao/city_dao_model.dart';

class CityModel extends BaseAdapterModel<CityDaoModel> {
  static const nameKey = "name";

  String name;

  CityModel(Map<String, dynamic> data, [String? clientId]) : name = data[nameKey];

  static List<String> get requiredFields => [nameKey];

  static Map<String, Type> get fieldTypes => {nameKey: String};

  static String? validateField(dynamic value, String key) {
    return switch (key) {
      nameKey => (value as String).trim().isEmpty ? StringsManager.emptyFields() : null,
      _ => null,
    };
  }

  @override
  CityDaoModel toDao() => CityDaoModel(name);
}
