import '../base_dao_model.dart';

class UpdateUserDaoModel extends BaseDaoModel {
  String? firstName;
  String? lastName;

  UpdateUserDaoModel({this.firstName, this.lastName});
}
