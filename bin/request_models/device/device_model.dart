import '../../strings.dart';

class DeviceModel {
  static const nameKey = "name";
  static const addressKey = "address";
  static const clientIdKey = "clientId";

  String name;
  String address;
  int clientId;

  DeviceModel(Map<String, dynamic> data, [String? clientId])
    : name = data[nameKey],
      address = data[addressKey],
      clientId = data[clientIdKey];

  static List<String> get requiredFields => [nameKey, addressKey, clientIdKey];

  static Map<String, Type> get fieldTypes => {nameKey: String, addressKey: String, clientIdKey: int};

  static String? validateField(dynamic value, String key) {
    return switch (key) {
      nameKey || addressKey => (value as String).trim().isEmpty ? StringsManager.emptyFields() : null,
      clientIdKey => (value as int) <= 0 ? StringsManager.invalidId() : null,
      _ => null,
    };
  }
}
