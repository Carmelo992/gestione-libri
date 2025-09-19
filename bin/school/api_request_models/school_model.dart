import '../../core/core.dart';
import '../dao/school_dao_model.dart';

class SchoolModel extends BaseAdapterModel<SchoolDaoModel> {
  static const nameKey = "name";

  String name;

  SchoolModel(Map<String, dynamic> data) : name = data[nameKey];

  static List<String> get requiredFields => [nameKey];

  static Map<String, Type> get fieldTypes => {nameKey: String};

  static String? validateField(dynamic value, String key) {
    return switch (key) {
      nameKey => (value as String).trim().isEmpty ? StringsManager.emptyFields() : null,
      _ => null,
    };
  }

  @override
  SchoolDaoModel toDao() => SchoolDaoModel(name);
}
