import '../strings.dart';

class ValidationModelsManager {
  static ValidationError? validate(
    Map<String, dynamic>? data,
    List<String> requiredFields,
    Map<String, Type> types,
    String? Function(dynamic field, String key) checkField,
  ) {
    if (data == null) return MissingData();
    List<String> keys = [];
    for (String key in requiredFields) {
      var element = data[key];
      if (element == null) {
        keys.add(key);
      }
    }

    if (keys.isNotEmpty) {
      return MissingRequiredFields(keys);
    }

    Map<String, Type> invalidTypes = {};
    Map<String, String> checkFieldErrors = {};

    for (String key in data.keys) {
      Type? type = types[key];
      if (type == null) continue;
      if (data[key].runtimeType != type) {
        invalidTypes.putIfAbsent(key, () => type);
      } else {
        String? error = checkField(data[key], key);
        if (error != null) {
          checkFieldErrors.putIfAbsent(key, () => error);
        }
      }
    }

    if (invalidTypes.isNotEmpty) {
      return WrongFieldFormat(invalidTypes);
    }

    if (checkFieldErrors.isNotEmpty) {
      return WrongFieldValue(checkFieldErrors);
    }

    return null;
  }
}

sealed class ValidationError {
  Map<String, dynamic> get bodyJson;
}

class MissingData extends ValidationError {
  @override
  Map<String, dynamic> get bodyJson => {StringsManager.error(): StringsManager.missingDataError()};
}

class MissingRequiredFields extends ValidationError {
  List<String> keys;

  MissingRequiredFields(this.keys);

  @override
  Map<String, dynamic> get bodyJson =>
      Map.fromEntries(keys.map((e) => MapEntry(e, StringsManager.missingFieldError())));
}

class WrongFieldFormat extends ValidationError {
  Map<String, Type> types;

  WrongFieldFormat(this.types);

  @override
  Map<String, dynamic> get bodyJson => types.map((key, value) => MapEntry(key, StringsManager.invalidType()));
}

class WrongFieldValue extends ValidationError {
  Map<String, String> errors;

  WrongFieldValue(this.errors);

  @override
  Map<String, dynamic> get bodyJson => errors;
}
