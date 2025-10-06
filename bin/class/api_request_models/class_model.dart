import '../../core/core.dart';
import '../dao/class_dao_model.dart';

class ClassModel extends BaseAdapterModel<ClassDaoModel> {
  static const nameKey = "name";
  static const String schoolIdKey = "schoolId";

  //KEY_PLACE_HOLDER
  //Do not remove the line above

  final String name;
  final int schoolId;

  //FIELD_PLACE_HOLDER
  //Do not remove the line above

  ClassModel(Map<String, dynamic> data, [String? classId]) : name = data[nameKey], schoolId = data[schoolIdKey]
  //CONSTRUCTOR_PLACE_HOLDER
  //Do not remove the line above
  ;

  static List<String> get requiredFields => [
    nameKey,
    schoolIdKey,
    //REQUIRED_FIELD_PLACE_HOLDER
    //Do not remove the line above
  ];

  static Map<String, Type> get fieldTypes => {
    nameKey: String,
    schoolIdKey: int,
    //FIELD_TYPE_PLACE_HOLDER
    //Do not remove the line above
  };

  static String? validateField(dynamic value, String key) {
    return switch (key) {
      nameKey => (value as String).trim().isEmpty ? StringsManager.emptyFields() : null,
      //TODO add custom validation rule here
      _ => null,
    };
  }

  @override
  ClassDaoModel toDao() => ClassDaoModel(
    name: name,
    schoolId: schoolId,
    //TO_DAO_PLACE_HOLDER
    //Do not remove the line above
  );
}
