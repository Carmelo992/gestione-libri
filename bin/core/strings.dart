class StringsManager {
  static const Map<StringKey, Map<String, String>> _strings = {
    StringKey.emptyFieldError: {"en": "Must be not empty"},
    StringKey.invalidTypeError: {"en": "Invalid type"},
    StringKey.invalidEmailError: {"en": "Invalid email"},
    StringKey.passwordNotSecureError: {"en": "Must have at least 8 character"},
    StringKey.invalidHexColor: {"en": "Invalid hex color"},
    StringKey.mustBeGreaterThanZeroError: {"en": "Must be greater than 0"},
    StringKey.mustBePositiveNumberError: {"en": "Must be positive number"},
    StringKey.missingField: {"en": "Missing"},
    StringKey.missingData: {"en": "Missing data"},
    StringKey.wrongCredentialsError: {"en": "Wrong credentials"},
    StringKey.invalidIdError: {"en": "Invalid id"},
    StringKey.invalidDateError: {"en": "Invalid date"},
    StringKey.invalidTimeIntervalError: {"en": "Invalid time range, start date is after than end date"},
    StringKey.missingTruckIdWhenKmIsSetError: {"en": "TruckId is mandatory when km is set"},
    StringKey.missingKmWhenTruckIdIsSetError: {"en": "km is mandatory when truckId is set"},
    StringKey.resetCodePasswordError: {"en": "An error occurred while sending the reset code via mail"},
    StringKey.resetPasswordTitle: {"en": "You have requested a password reset"},
    StringKey.resetPasswordMessage: {
      "en": "To complete the password reset procedure, here is the code to enter into the app",
    },
    StringKey.newResourceEmailTitle: {"en": "Login credentials"},
    StringKey.newResourceEmailMessage: {
      "en": "A user has been created to access the app. Please use the credentials in this email to log in.",
    },
    StringKey.timeIntervalAlreadyTakenError: {"en": "time range already taken"},
    StringKey.wrongUserPermission: {"en": "A wrong user permission has been insert"},
    StringKey.clientNotFound: {"en": "Client not found"},
    StringKey.invalidPrice: {"en": "Invalid price, it must be greater than zero"},
    StringKey.invalidTransactionType: {"en": "Invalid transaction type, it must be 0 = payed or 1 = toPay"},
    //STRING_MAP_KEY
    //WARNING: DO NOT CANCEL THE LINE ABOVE
  };

  static const String _defaultLang = "en";

  static String _get(StringKey key, [String? lang]) =>
      _strings[key]?[lang ?? _defaultLang] ?? _strings[key]?[_defaultLang] ?? "${key.name} - ${lang ?? _defaultLang}";

  static String emptyFields([String? lang]) => _get(StringKey.emptyFieldError, lang);

  static String invalidType([String? lang]) => _get(StringKey.invalidTypeError, lang);

  static String invalidEmail([String? lang]) => _get(StringKey.invalidEmailError, lang);

  static String passwordNotSecure([String? lang]) => _get(StringKey.passwordNotSecureError, lang);

  static String invalidHexColor([String? lang]) => _get(StringKey.invalidHexColor, lang);

  static String mustBeGreaterThanZero([String? lang]) => _get(StringKey.mustBeGreaterThanZeroError, lang);

  static String mustBePositiveNumber([String? lang]) => _get(StringKey.mustBePositiveNumberError, lang);

  static String missingFieldError([String? lang]) => _get(StringKey.missingField, lang);

  static String missingDataError([String? lang]) => _get(StringKey.missingData, lang);

  static String wrongCredentials([String? lang]) => _get(StringKey.wrongCredentialsError, lang);

  static String error() => "error";

  static String invalidId([String? lang]) => _get(StringKey.invalidIdError, lang);

  static String invalidDate([String? lang]) => _get(StringKey.invalidDateError, lang);

  static String invalidTimeInterval([String? lang]) => _get(StringKey.invalidTimeIntervalError, lang);

  static String missingTruckIdWhenKmIsSet([String? lang]) => _get(StringKey.missingTruckIdWhenKmIsSetError, lang);

  static String missingKmWhenTruckIdIsSet([String? lang]) => _get(StringKey.missingKmWhenTruckIdIsSetError, lang);

  static String resetCodePasswordError([String? lang]) => _get(StringKey.resetCodePasswordError, lang);

  static String resetPasswordTitle([String? lang]) => _get(StringKey.resetPasswordTitle, lang);

  static String resetPasswordMessage([String? lang]) => _get(StringKey.resetPasswordMessage, lang);

  static String newResourceTitle([String? lang]) => _get(StringKey.newResourceEmailTitle, lang);

  static String newResourceMessage([String? lang]) => _get(StringKey.newResourceEmailMessage, lang);

  static String timeIntervalAlreadyTakenError([String? lang]) => _get(StringKey.timeIntervalAlreadyTakenError, lang);

  static String wrongUserPermission([String? lang]) => _get(StringKey.wrongUserPermission, lang);

  static String clientNotFound([String? lang]) => _get(StringKey.clientNotFound, lang);

  static String invalidPrice([String? lang]) => _get(StringKey.invalidPrice, lang);

  static String invalidTransactionType([String? lang]) => _get(StringKey.invalidTransactionType, lang);
  //STRING_METHOD
  //WARNING: DO NOT CANCEL THE LINE ABOVE
}

enum StringKey {
  emptyFieldError,
  invalidTypeError,
  invalidEmailError,
  passwordNotSecureError,
  invalidHexColor,
  mustBeGreaterThanZeroError,
  mustBePositiveNumberError,
  missingField,
  missingData,
  wrongCredentialsError,
  invalidIdError,
  invalidDateError,
  invalidTimeIntervalError,
  missingTruckIdWhenKmIsSetError,
  missingKmWhenTruckIdIsSetError,
  resetCodePasswordError,
  resetPasswordTitle,
  resetPasswordMessage,
  newResourceEmailTitle,
  newResourceEmailMessage,
  timeIntervalAlreadyTakenError,
  wrongUserPermission,
  clientNotFound,
  invalidPrice,
  invalidTransactionType,
  //STRING_KEY
  //WARNING: DO NOT CANCEL THE LINE ABOVE
}
