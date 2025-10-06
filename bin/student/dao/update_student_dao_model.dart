import '../../core/core.dart';
import 'student_dao_model.dart';

class UpdateStudentDaoModel extends BaseDaoModel {
  static const nameKey = StudentDaoModel.nameKey;
  static const surnameKey = StudentDaoModel.surnameKey;
  static const phoneNumberKey = StudentDaoModel.phoneNumberKey;

  String? name, surname, phoneNumber;

  UpdateStudentDaoModel({required this.name, required this.surname, required this.phoneNumber});
}
