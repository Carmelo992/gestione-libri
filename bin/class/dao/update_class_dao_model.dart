import '../../core/core.dart';
import 'class_dao_model.dart';

class UpdateClassDaoModel extends BaseDaoModel {
  static const nameKey = ClassDaoModel.nameKey;
  static const String schoolIdKey = ClassDaoModel.schoolIdKey;

  //KEY_PLACE_HOLDER
  //Do not remove the line above

  String? name;
  final int? schoolId;

  //FIELD_PLACE_HOLDER
  //Do not remove the line above

  UpdateClassDaoModel({
    required this.name,
    required this.schoolId,
    //CONSTRUCTOR_PLACE_HOLDER
    //Do not remove the line above
  });
}
