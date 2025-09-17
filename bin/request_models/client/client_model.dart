import '../../strings.dart';

class ClientModel {
  static const nameKey = "name";
  static const cityKey = "city";

  String name;
  String city;

  ClientModel(Map<String, dynamic> data, [String? clientId]) : name = data[nameKey], city = data[cityKey];

  static List<String> get requiredFields => [nameKey, cityKey];

  static Map<String, Type> get fieldTypes => {nameKey: String, cityKey: String};

  static String? validateField(dynamic value, String key) {
    return switch (key) {
      nameKey || cityKey => (value as String).trim().isEmpty ? StringsManager.emptyFields() : null,
      _ => null,
    };
  }
}
