import '../../core/core.dart';
import '../dao/school_dao_model.dart';

class SchoolModel extends BaseAdapterModel<SchoolDaoModel> {
  static const nameKey = "name";
  static const externalIdKey = "externalId";
  static const cityIdKey = "cityId";

  String name, externalId;
  int cityId;

  SchoolModel(Map<String, dynamic> data)
    : name = data[nameKey],
      externalId = data[externalIdKey],
      cityId = data[cityIdKey];

  static List<String> get requiredFields => [nameKey];

  static Map<String, Type> get fieldTypes => {nameKey: String};

  static String? validateField(dynamic value, String key) {
    return switch (key) {
      nameKey => (value as String).trim().isEmpty ? StringsManager.emptyFields() : null,
      _ => null,
    };
  }

  @override
  SchoolDaoModel toDao() => SchoolDaoModel(name: name, externalId: externalId, cityId: cityId);
}
