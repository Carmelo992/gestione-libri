import '../../core/core.dart';
import '../dao/student_dao_model.dart';

class StudentModel extends BaseAdapterModel<StudentDaoModel> {
  static const nameKey = "name";

  String name;

  StudentModel(Map<String, dynamic> data, [String? studentId]) : name = data[nameKey];

  static List<String> get requiredFields => [nameKey];

  static Map<String, Type> get fieldTypes => {nameKey: String};

  static String? validateField(dynamic value, String key) {
    return switch (key) {
      nameKey => (value as String).trim().isEmpty ? StringsManager.emptyFields() : null,
      _ => null,
    };
  }

  @override
  StudentDaoModel toDao() => StudentDaoModel(name);
}
