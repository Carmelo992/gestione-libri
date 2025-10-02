import '../../core/core.dart';
import 'student_dao_model.dart';

class UpdateStudentDaoModel extends BaseDaoModel {
  static const nameKey = StudentDaoModel.nameKey;

  String? name;

  UpdateStudentDaoModel(this.name);
}
