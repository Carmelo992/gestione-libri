import '../../core/core.dart';
import '../dao/update_year_dao_model.dart';
import 'year_model.dart';

class UpdateYearModel extends BaseAdapterModel<UpdateYearDaoModel> {
  static const nameKey = YearModel.nameKey;

  //KEY_PLACE_HOLDER
  //Do not remove the line above

  final String? name;

  //FIELD_PLACE_HOLDER
  //Do not remove the line above

  UpdateYearModel(Map<String, dynamic> data, [String? yearId]) : name = data[nameKey]
  //CONSTRUCTOR_PLACE_HOLDER
  //Do not remove the line above
  ;

  static List<String> get requiredFields => [];

  static Map<String, Type> get fieldTypes => YearModel.fieldTypes;

  static String? validateField(dynamic value, String key) => YearModel.validateField(value, key);

  @override
  UpdateYearDaoModel toDao() => UpdateYearDaoModel(
    name: name,
    //TO_DAO_PLACE_HOLDER
    //Do not remove the line above
  );
}
