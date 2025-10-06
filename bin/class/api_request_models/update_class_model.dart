import '../../core/core.dart';
import '../dao/update_class_dao_model.dart';
import 'class_model.dart';

class UpdateClassModel extends BaseAdapterModel<UpdateClassDaoModel> {
  static const nameKey = ClassModel.nameKey;
  static const String schoolIdKey = ClassModel.schoolIdKey;

  //KEY_PLACE_HOLDER
  //Do not remove the line above

  final String? name;
  final int? schoolId;

  //FIELD_PLACE_HOLDER
  //Do not remove the line above

  UpdateClassModel(Map<String, dynamic> data, [String? classId]) : name = data[nameKey], schoolId = data[schoolIdKey]
  //CONSTRUCTOR_PLACE_HOLDER
  //Do not remove the line above
  ;

  static List<String> get requiredFields => [];

  static Map<String, Type> get fieldTypes => ClassModel.fieldTypes;

  static String? validateField(dynamic value, String key) => ClassModel.validateField(value, key);

  @override
  UpdateClassDaoModel toDao() => UpdateClassDaoModel(
    name: name,
    schoolId: schoolId,
    //TO_DAO_PLACE_HOLDER
    //Do not remove the line above
  );
}
