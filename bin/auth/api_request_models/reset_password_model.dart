import '../../core/strings.dart';

class ResetPasswordModel {
  static const _codeKey = "code";
  static const _passwordKey = "password";

  String code, password;

  ResetPasswordModel.fromMap(Map<String, dynamic> map) : code = map[_codeKey], password = map[_passwordKey];

  static List<String> get requiredFields => [_codeKey, _passwordKey];

  static Map<String, Type> get fieldTypes => {_codeKey: String, _passwordKey: String};

  static String? validateField(dynamic value, String key) {
    return switch (key) {
      _codeKey => (value as String).trim().isEmpty ? StringsManager.emptyFields() : null,
      _passwordKey =>
        () {
          if ((value as String).trim().isEmpty) {
            return StringsManager.emptyFields();
          }
          if (value.length < 8) return StringsManager.passwordNotSecure();
        }.call(),
      _ => null,
    };
  }
}
