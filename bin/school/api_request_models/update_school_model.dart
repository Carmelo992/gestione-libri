import '../../core/core.dart';
import '../dao/update_school_dao_model.dart';
import 'school_model.dart';

class UpdateSchoolModel extends BaseAdapterModel<UpdateSchoolDaoModel> {
  static const nameKey = SchoolModel.nameKey;
  static const externalIdKey = SchoolModel.externalIdKey;
  static const cityIdKey = SchoolModel.cityIdKey;

  String? name, externalId;
  int? cityId;

  UpdateSchoolModel(Map<String, dynamic> data)
    : name = data[nameKey],
      externalId = data[externalIdKey],
      cityId = data[cityIdKey];

  static List<String> get requiredFields => [];

  static Map<String, Type> get fieldTypes => SchoolModel.fieldTypes;

  static String? validateField(dynamic value, String key) => SchoolModel.validateField(value, key);

  @override
  UpdateSchoolDaoModel toDao() => UpdateSchoolDaoModel(name: name, externalId: externalId, cityId: cityId);
}
