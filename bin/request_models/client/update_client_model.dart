import 'client_model.dart';

class UpdateClientModel {
  static const nameKey = ClientModel.nameKey;
  static const cityKey = ClientModel.cityKey;

  String? name;
  String? city;

  UpdateClientModel(Map<String, dynamic> data, [String? clientId]) : name = data[nameKey], city = data[cityKey];

  static List<String> get requiredFields => [];

  static Map<String, Type> get fieldTypes => ClientModel.fieldTypes;

  static String? validateField(dynamic value, String key) => ClientModel.validateField(value, key);
}
