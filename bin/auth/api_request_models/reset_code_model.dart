import '../../core/strings.dart';

class ResetCodeModel {
  static const _emailKey = "email";

  String email;

  ResetCodeModel.fromMap(Map<String, dynamic> map) : email = map[_emailKey];

  static List<String> get requiredFields => [_emailKey];

  static Map<String, Type> get fieldTypes => {_emailKey: String};

  static String? validateField(dynamic value, String key) {
    return switch (key) {
      _emailKey =>
        () {
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
      _ => null,
    };
  }
}
