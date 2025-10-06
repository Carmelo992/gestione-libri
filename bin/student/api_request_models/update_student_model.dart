import '../../core/core.dart';
import '../dao/update_student_dao_model.dart';
import 'student_model.dart';

class UpdateStudentModel extends BaseAdapterModel<UpdateStudentDaoModel> {
  static const nameKey = StudentModel.nameKey;
  static const surnameKey = StudentModel.surnameKey;
  static const phoneNumberKey = StudentModel.phoneNumberKey;

  String? name, surname, phoneNumber;

  UpdateStudentModel(Map<String, dynamic> data, [String? studentId])
    : name = data[nameKey],
      surname = data[surnameKey],
      phoneNumber = data[phoneNumberKey];

  static List<String> get requiredFields => [];

  static Map<String, Type> get fieldTypes => StudentModel.fieldTypes;

  static String? validateField(dynamic value, String key) => StudentModel.validateField(value, key);

  @override
  UpdateStudentDaoModel toDao() => UpdateStudentDaoModel(name: name, surname: surname, phoneNumber: phoneNumber);
}
