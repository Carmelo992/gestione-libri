import '../../core/core.dart';
import '../dao/update_student_dao_model.dart';
import 'student_model.dart';

class UpdateStudentModel extends BaseAdapterModel<UpdateStudentDaoModel> {
  static const nameKey = StudentModel.nameKey;

  String? name;

  UpdateStudentModel(Map<String, dynamic> data, [String? studentId]) : name = data[nameKey];

  static List<String> get requiredFields => [];

  static Map<String, Type> get fieldTypes => StudentModel.fieldTypes;

  static String? validateField(dynamic value, String key) => StudentModel.validateField(value, key);

  @override
  UpdateStudentDaoModel toDao() => UpdateStudentDaoModel(name);
}
