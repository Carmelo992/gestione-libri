import '../base_dao_model.dart';

class UserDaoModel extends BaseDaoModel {
  static const firstNameKey = "first_name";
  static const lastNameKey = "last_name";
  static const emailKey = "email";
  static const passwordKey = "password";
  static const isAdminKey = "is_admin";

  final String firstName;
  final String lastName;
  final String email;
  final String password;

  UserDaoModel(this.firstName, this.lastName, this.email, this.password);
}
