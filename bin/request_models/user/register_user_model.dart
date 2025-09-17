import './user_model.dart';

class RegisterUserModel {
  static const firstNameKey = UserModel.firstNameKey;
  static const lastNameKey = UserModel.lastNameKey;
  static const emailKey = UserModel.emailKey;

  String firstName;
  String lastName;
  String email;

  RegisterUserModel(Map<String, dynamic> data, [String? clientId])
    : firstName = data[firstNameKey],
      lastName = data[lastNameKey],
      email = data[emailKey];

  static List<String> get requiredFields => [firstNameKey, lastNameKey, emailKey];

  static Map<String, Type> get fieldTypes => UserModel.fieldTypes;

  static String? validateField(dynamic value, String key) => UserModel.validateField(value, key);
}
