import '../../strings.dart';

class AuthModel {
  static const emailKey = "email";
  static const passwordKey = "password";

  String email;
  String password;

  AuthModel(Map<String, dynamic> data, [String? clientId]) : email = data[emailKey], password = data[passwordKey];

  static List<String> get requiredFields => [emailKey, passwordKey];

  static Map<String, Type> get fieldTypes => {emailKey: String, passwordKey: String};

  static String? validateField(dynamic value, String key) {
    return switch (key) {
      emailKey || passwordKey => (value as String).trim().isEmpty ? StringsManager.emptyFields() : null,
      _ => null,
    };
  }
}
