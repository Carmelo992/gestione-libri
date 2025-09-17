import '../../dao/user/user_dao_model.dart';
import '../../strings.dart';
import '../base_adapter_model.dart';

class UserModel implements BaseAdapterModel<UserDaoModel> {
  static const firstNameKey = "firstName";
  static const lastNameKey = "lastName";
  static const emailKey = "email";
  static const passwordKey = "password";
  static const isAdminKey = "isAdmin";

  String firstName;
  String lastName;
  String email;
  String password;

  String get fullName => [firstName, lastName].join(" ");

  UserModel(Map<String, dynamic> data, [String? clientId])
    : firstName = data[firstNameKey],
      lastName = data[lastNameKey],
      email = data[emailKey],
      password = data[passwordKey];

  static List<String> get requiredFields => [firstNameKey, lastNameKey, emailKey, passwordKey];

  static Map<String, Type> get fieldTypes => {
    firstNameKey: String,
    lastNameKey: String,
    emailKey: String,
    passwordKey: String,
  };

  static String? validateField(dynamic value, String key) {
    return switch (key) {
      firstNameKey || lastNameKey => (value as String).trim().isEmpty ? StringsManager.emptyFields() : null,
      emailKey => () {
        if ((value as String).trim().isEmpty) {
          return StringsManager.emptyFields();
        }

        String pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regExp = RegExp(pattern);
        if (!regExp.hasMatch(value)) {
          return StringsManager.invalidEmail();
        }

        return null;
      }.call(),
      passwordKey => () {
        if ((value as String).trim().isEmpty) {
          return StringsManager.emptyFields();
        }
        if (value.length < 8) return StringsManager.passwordNotSecure();

        return null;
      }.call(),
      _ => null,
    };
  }

  @override
  UserDaoModel toDao() => UserDaoModel(firstName, lastName, email, password);
}
