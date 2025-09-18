import '../../core/strings.dart';

class ChangePasswordModel {
  static const _oldPasswordKey = "oldPassword";
  static const _newPasswordKey = "newPassword";

  String oldPassword, newPassword;

  ChangePasswordModel.fromMap(Map<String, dynamic> map)
    : oldPassword = map[_oldPasswordKey],
      newPassword = map[_newPasswordKey];

  static List<String> get requiredFields => [_oldPasswordKey, _newPasswordKey];

  static Map<String, Type> get fieldTypes => {_oldPasswordKey: String, _newPasswordKey: String};

  static String? validateField(dynamic value, String key) {
    return switch (key) {
      _oldPasswordKey => (value as String).trim().isEmpty ? StringsManager.emptyFields() : null,
      _newPasswordKey =>
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
