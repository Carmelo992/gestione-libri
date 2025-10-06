import '../../core/core.dart';
import '../dao/student_dao_model.dart';

class StudentModel extends BaseAdapterModel<StudentDaoModel> {
  static const String nameKey = "name";
  static const String surnameKey = "surname";
  static const String phoneNumberKey = "phoneNumber";

  String name, surname, phoneNumber;

  StudentModel(Map<String, dynamic> data, [String? studentId])
    : name = data[nameKey],
      surname = data[surnameKey],
      phoneNumber = data[phoneNumberKey];

  static List<String> get requiredFields => [nameKey, surnameKey, phoneNumberKey];

  static Map<String, Type> get fieldTypes => {nameKey: String, surnameKey: String, phoneNumberKey: String};

  static String? validateField(dynamic value, String key) {
    return switch (key) {
      nameKey || surnameKey || phoneNumberKey => (value as String).trim().isEmpty ? StringsManager.emptyFields() : null,
      _ => null,
    };
  }

  @override
  StudentDaoModel toDao() => StudentDaoModel(name: name, surname: surname, phoneNumber: phoneNumber);
}
