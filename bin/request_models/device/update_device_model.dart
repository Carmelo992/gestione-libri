import 'device_model.dart';

class UpdateDeviceModel {
  static const nameKey = DeviceModel.nameKey;
  static const addressKey = DeviceModel.addressKey;
  static const clientIdKey = DeviceModel.clientIdKey;

  String? name;
  String? city;
  int? clientId;

  UpdateDeviceModel(Map<String, dynamic> data, [String? clientId]) : name = data[nameKey], city = data[addressKey], clientId = data[clientIdKey];

  static List<String> get requiredFields => [];

  static Map<String, Type> get fieldTypes => DeviceModel.fieldTypes;

  static String? validateField(dynamic value, String key) => DeviceModel.validateField(value, key);
}
